import 'dart:async';

import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/core/http.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flicko_video/utils/in_app_purchase_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'state.dart';

class MemberPurchaseResult {
  const MemberPurchaseResult._({required this.success, this.message});

  const MemberPurchaseResult.success([String? message])
    : this._(success: true, message: message);

  const MemberPurchaseResult.failure(String message)
    : this._(success: false, message: message);

  final bool success;
  final String? message;
}

class MemberController extends StateNotifier<MemberState> {
  MemberController()
    : super(MemberState.initial(currentCredits: UserBox.credit)) {
    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        if (!mounted) return;
        _isRestoringPurchases = false;
        _cancelRestoreFallbackTimer();
        if (isPendingStoreKitPurchaseError(error)) {
          unawaited(_recoverPendingStoreKitTransactions());
        }
        debugPrint('VIP purchase stream failed: $error');
        state = state.copyWith(
          isLoading: false,
          isRestoring: false,
          errorMessage: inAppPurchaseFailedMessage,
          successMessage: null,
        );
      },
    );
  }

  static const List<String> _productIds = [
    'FlickMonthVip',
    'FilckoQuarterlyVip',
    'FlickoAnnualPlan',
  ];

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  StreamSubscription<dynamic>? _userBoxSubscription;
  Future<void>? _initRequest;
  Timer? _restoreFallbackTimer;
  var _isRestoringPurchases = false;

  void watchUserCredits() {
    _applyUserCredits();
    _userBoxSubscription ??= UserBox.box.watch().listen((_) {
      _applyUserCredits();
    });
  }

  void selectPlan(String planId) {
    final selectedPlan = _findPlan(planId) ?? state.selectedPlan;
    if (selectedPlan == null) {
      return;
    }

    state = state.copyWith(
      selectedPlanId: selectedPlan.id,
      paymentAmount: _paymentAmountForPlan(selectedPlan),
      bonusDiamonds: selectedPlan.diamonds,
      errorMessage: null,
      successMessage: null,
    );
  }

  Future<MemberPurchaseResult> unlockVipService() async {
    final selectedPlan = state.selectedPlan;
    final productDetails = selectedPlan?.productDetails;
    if (selectedPlan == null || productDetails == null) {
      const message = '套餐暂不可购买，请稍后重试';
      state = state.copyWith(errorMessage: message, successMessage: null);
      return const MemberPurchaseResult.failure(message);
    }

    if (state.isLoading || state.isRestoring) {
      const message = '正在处理购买，请稍候';
      state = state.copyWith(errorMessage: message, successMessage: null);
      return const MemberPurchaseResult.failure(message);
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );
    try {
      final purchaseParam = PurchaseParam(productDetails: productDetails);
      final started = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
      if (!started) {
        const message = inAppPurchaseFailedMessage;
        state = state.copyWith(isLoading: false, errorMessage: message);
        return const MemberPurchaseResult.failure(message);
      }
      return const MemberPurchaseResult.success();
    } catch (error) {
      debugPrint('VIP purchase start failed: $error');
      if (isPendingStoreKitPurchaseError(error)) {
        unawaited(_recoverPendingStoreKitTransactions());
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: inAppPurchaseFailedMessage,
      );
      return const MemberPurchaseResult.failure(inAppPurchaseFailedMessage);
    }
  }

  Future<MemberPurchaseResult> restorePurchases() async {
    if (state.isLoading || state.isRestoring) {
      const message = '正在处理购买，请稍候';
      state = state.copyWith(errorMessage: message, successMessage: null);
      return const MemberPurchaseResult.failure(message);
    }

    state = state.copyWith(
      isRestoring: true,
      errorMessage: null,
      successMessage: null,
    );
    try {
      _isRestoringPurchases = true;
      await _inAppPurchase.restorePurchases();
      _startRestoreFallbackTimer();
      return const MemberPurchaseResult.success();
    } catch (error) {
      debugPrint('VIP restore purchases failed: $error');
      _isRestoringPurchases = false;
      _cancelRestoreFallbackTimer();
      if (!mounted) {
        return const MemberPurchaseResult.failure(inAppPurchaseFailedMessage);
      }
      state = state.copyWith(
        isRestoring: false,
        errorMessage: inAppPurchaseFailedMessage,
      );
      return const MemberPurchaseResult.failure(inAppPurchaseFailedMessage);
    }
  }

  Future<void> init() async {
    watchUserCredits();
    _initRequest ??= _loadProducts();
    return _initRequest;
  }

  Future<void> _loadProducts() async {
    state = state.copyWith(
      isProductLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final storeAvailable = await _inAppPurchase.isAvailable();
      if (!storeAvailable) {
        if (!mounted) return;
        state = state.copyWith(
          isProductLoading: false,
          isStoreAvailable: false,
          errorMessage: '当前设备无法连接应用商店',
        );
        return;
      }

      final response = await _inAppPurchase.queryProductDetails(
        _productIds.toSet(),
      );
      if (!mounted) return;

      final plans = _buildPlans(response.productDetails);
      final nextSelectedPlan = _resolveSelectedPlan(plans);
      final errorMessage = _productLoadMessage(response);

      state = state.copyWith(
        plans: plans,
        selectedPlanId: nextSelectedPlan?.id,
        paymentAmount: nextSelectedPlan == null
            ? state.paymentAmount
            : _paymentAmountForPlan(nextSelectedPlan),
        bonusDiamonds: nextSelectedPlan?.diamonds,
        isProductLoading: false,
        isStoreAvailable: true,
        errorMessage: errorMessage,
        successMessage: null,
      );
    } catch (error) {
      if (!mounted) return;
      state = state.copyWith(
        isProductLoading: false,
        errorMessage: '套餐加载失败：$error',
      );
    }
  }

  List<MemberPlan> _buildPlans(List<ProductDetails> products) {
    if (products.isEmpty) {
      return state.plans;
    }

    final productsById = {for (final product in products) product.id: product};
    final plans = <MemberPlan>[];

    for (final productId in _productIds) {
      final product = productsById[productId];
      if (product == null) {
        continue;
      }

      final fallbackPlan = _fallbackPlanForProduct(productId);
      plans.add(_planFromProduct(product: product, fallbackPlan: fallbackPlan));
    }

    for (final product in products) {
      if (_productIds.contains(product.id)) {
        continue;
      }

      final fallbackPlan = _fallbackPlanForProduct(product.id);
      plans.add(_planFromProduct(product: product, fallbackPlan: fallbackPlan));
    }

    return plans.isEmpty ? state.plans : plans;
  }

  MemberPlan _planFromProduct({
    required ProductDetails product,
    required MemberPlan fallbackPlan,
  }) {
    final durationDays = _durationDaysForProduct(product.id);
    final pricePerDay = _formatDailyPrice(product, durationDays);
    final diamonds = _resolvePlanDiamonds(product, fallbackPlan);

    return MemberPlan(
      id: product.id,
      title: _resolvePlanTitle(product, fallbackPlan),
      price: pricePerDay,
      unit: fallbackPlan.unit,
      diamonds: diamonds,
      saveLabel: _resolveSaveLabel(product.id, fallbackPlan),
      productDetails: product,
    );
  }

  String _resolvePlanTitle(ProductDetails product, MemberPlan fallbackPlan) {
    final productTitle = product.title.trim();
    if (productTitle.isNotEmpty) {
      return productTitle;
    }
    return fallbackPlan.title;
  }

  String _resolvePlanDiamonds(ProductDetails product, MemberPlan fallbackPlan) {
    final descriptionValue = RegExp(
      r'(\d[\d,]*)\s*(?:diamonds?|credits?|💎)',
      caseSensitive: false,
    ).firstMatch(product.description);
    if (descriptionValue != null) {
      return descriptionValue.group(1) ?? fallbackPlan.diamonds;
    }

    return fallbackPlan.diamonds;
  }

  String _resolveSaveLabel(String productId, MemberPlan fallbackPlan) {
    final normalizedId = productId.toLowerCase();
    if (normalizedId.contains('annual') || normalizedId.contains('year')) {
      return 'SAVE 91%';
    }
    if (normalizedId.contains('quarter')) {
      return 'SAVE 70%';
    }
    if (normalizedId.contains('month')) {
      return 'SAVE 55%';
    }
    return fallbackPlan.saveLabel;
  }

  MemberPlan? _resolveSelectedPlan(List<MemberPlan> plans) {
    if (plans.isEmpty) {
      return null;
    }

    for (final plan in plans) {
      if (plan.id == state.selectedPlanId) {
        return plan;
      }
    }

    for (final plan in plans) {
      if (plan.id.toLowerCase().contains('quarter')) {
        return plan;
      }
    }
    return plans.first;
  }

  String? _productLoadMessage(ProductDetailsResponse response) {
    if (response.error != null) {
      return response.error!.message;
    }
    if (response.productDetails.isEmpty) {
      return '暂未获取到可购买套餐';
    }
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('VIP products not found: ${response.notFoundIDs.join(', ')}');
    }
    return null;
  }

  int _durationDaysForProduct(String productId) {
    final normalizedId = productId.toLowerCase();
    if (normalizedId.contains('annual') ||
        normalizedId.contains('year') ||
        normalizedId.contains('yearly')) {
      return 365;
    }
    if (normalizedId.contains('quarter')) {
      return 90;
    }
    if (normalizedId.contains('week')) {
      return 7;
    }
    return 30;
  }

  String _formatDailyPrice(ProductDetails product, int durationDays) {
    if (durationDays <= 0 || product.rawPrice <= 0) {
      return product.price;
    }

    final amount = product.rawPrice / durationDays;
    return '${product.currencySymbol}${amount.toStringAsFixed(2)}';
  }

  String _paymentAmountForPlan(MemberPlan plan) {
    return plan.productDetails?.price ?? _fallbackPaymentAmount(plan.id);
  }

  String _fallbackPaymentAmount(String planId) {
    final normalizedId = planId.toLowerCase();
    if (normalizedId.contains('month')) {
      return 'US\$49.99';
    }
    if (normalizedId.contains('annual') || normalizedId.contains('year')) {
      return 'US\$199.99';
    }
    return 'US\$99.99';
  }

  MemberPlan _fallbackPlanForProduct(String productId) {
    final normalizedId = productId.toLowerCase();
    for (final plan in state.plans) {
      final normalizedPlanId = plan.id.toLowerCase();
      if (normalizedId.contains(normalizedPlanId) ||
          normalizedPlanId.contains(normalizedId)) {
        return plan;
      }
    }

    if (normalizedId.contains('month')) {
      return state.plans.first;
    }
    if (normalizedId.contains('annual') ||
        normalizedId.contains('year') ||
        normalizedId.contains('yearly')) {
      return state.plans.last;
    }
    if (state.plans.length > 1) {
      return state.plans[1];
    }
    return state.plans.first;
  }

  MemberPlan? _findPlan(String planId) {
    for (final plan in state.plans) {
      if (plan.id == planId) {
        return plan;
      }
    }
    return null;
  }

  void _applyUserCredits() {
    final credits = UserBox.credit;
    if (mounted && credits != state.currentCredits) {
      state = state.copyWith(currentCredits: credits);
    }
  }

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchaseDetails in purchaseDetailsList) {
      await _handlePurchase(purchaseDetails);
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    if (!_productIds.contains(purchaseDetails.productID)) {
      return;
    }

    _cancelRestoreFallbackTimer();

    switch (purchaseDetails.status) {
      case PurchaseStatus.pending:
        if (!mounted) return;
        state = state.copyWith(isLoading: true, errorMessage: null);
      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        await _deliverPurchase(purchaseDetails);
      case PurchaseStatus.error:
        if (purchaseDetails.pendingCompletePurchase) {
          await _completePurchaseIfNeeded(purchaseDetails);
        }
        _isRestoringPurchases = false;
        final message = inAppPurchaseErrorMessage(purchaseDetails.error);
        if (isPendingStoreKitPurchaseError(purchaseDetails.error)) {
          unawaited(_recoverPendingStoreKitTransactions());
        }
        debugPrint('VIP purchase failed: ${purchaseDetails.error}');
        if (!mounted) return;
        state = state.copyWith(
          isLoading: false,
          isRestoring: false,
          errorMessage: message,
          successMessage: null,
        );
      case PurchaseStatus.canceled:
        _isRestoringPurchases = false;
        if (!mounted) return;
        state = state.copyWith(
          isLoading: false,
          isRestoring: false,
          errorMessage: '购买已取消',
          successMessage: null,
        );
    }
  }

  Future<void> _deliverPurchase(PurchaseDetails purchaseDetails) async {
    try {
      final response = await _submitPurchaseToBackend(purchaseDetails);
      if (!response.isSuccess) {
        _isRestoringPurchases = false;
        if (!mounted) return;
        debugPrint('VIP purchase receipt submit failed: ${response.message}');
        state = state.copyWith(
          isLoading: false,
          isRestoring: false,
          errorMessage: inAppPurchaseFailedMessage,
          successMessage: null,
        );
        return;
      }

      await _completePurchaseIfNeeded(purchaseDetails);

      await _syncUserInfoAfterPurchase();

      final successMessage = _isRestoringPurchases ? '购买恢复成功' : 'VIP 套餐购买成功';
      _isRestoringPurchases = false;
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        isRestoring: false,
        errorMessage: null,
        successMessage: successMessage,
      );
    } catch (error) {
      _isRestoringPurchases = false;
      if (!mounted) return;
      debugPrint('VIP purchase receipt submit exception: $error');
      state = state.copyWith(
        isLoading: false,
        isRestoring: false,
        errorMessage: inAppPurchaseFailedMessage,
        successMessage: null,
      );
    }
  }

  Future<ApiResponse> _submitPurchaseToBackend(
    PurchaseDetails purchaseDetails,
  ) async {
    final productId = purchaseDetails.productID;
    if (!_productIds.contains(productId)) {
      return ApiResponse(code: 400, message: '未知会员商品');
    }

    return Api.applePay(
      receipt: purchaseDetails.verificationData.serverVerificationData,
      productId: productId,
    );
  }

  Future<void> _syncUserInfoAfterPurchase() async {
    try {
      await UserBox.syncUserInfo();
    } catch (error) {
      debugPrint('VIP user info sync failed: $error');
    }
  }

  Future<void> _completePurchaseIfNeeded(
    PurchaseDetails purchaseDetails,
  ) async {
    if (!purchaseDetails.pendingCompletePurchase) {
      return;
    }

    try {
      await _inAppPurchase.completePurchase(purchaseDetails);
    } catch (error) {
      debugPrint('VIP complete purchase failed: $error');
    }
  }

  void _startRestoreFallbackTimer() {
    _restoreFallbackTimer?.cancel();
    _restoreFallbackTimer = Timer(const Duration(seconds: 4), () {
      _isRestoringPurchases = false;
      if (!mounted || !state.isRestoring) {
        return;
      }

      state = state.copyWith(
        isRestoring: false,
        successMessage: '暂无可恢复购买',
        errorMessage: null,
      );
    });
  }

  void _cancelRestoreFallbackTimer() {
    _restoreFallbackTimer?.cancel();
    _restoreFallbackTimer = null;
  }

  Future<void> _recoverPendingStoreKitTransactions() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (error) {
      debugPrint('VIP restore pending purchases failed: $error');
    }
  }

  @override
  void dispose() {
    _restoreFallbackTimer?.cancel();
    _userBoxSubscription?.cancel();
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}

final memberControllerProvider =
    StateNotifierProvider<MemberController, MemberState>((ref) {
      return MemberController();
    });
