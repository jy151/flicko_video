import 'dart:async';

import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/core/http.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flicko_video/utils/in_app_purchase_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'state.dart';

class RechargeResult {
  const RechargeResult._({required this.success, this.message});

  const RechargeResult.success([String? message])
    : this._(success: true, message: message);

  const RechargeResult.failure(String message)
    : this._(success: false, message: message);

  final bool success;
  final String? message;
}

class RechargeController extends StateNotifier<RechargeState> {
  RechargeController() : super(RechargeState.initial()) {
    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        if (!mounted) return;
        if (isPendingStoreKitPurchaseError(error)) {
          unawaited(_recoverPendingStoreKitTransactions());
        }
        debugPrint('Recharge purchase stream failed: $error');
        state = state.copyWith(
          isLoading: false,
          errorMessage: inAppPurchaseFailedMessage,
          successMessage: null,
        );
      },
    );
  }

  static const List<String> _productIds = [
    'flicko1000Points',
    'filcko12000Points',
    'filcko_2600Points',
    'filcko27000Points',
    'filcko300Points',
    'filcko7500Points',
  ];

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  Future<void>? _initRequest;

  Future<void> init() async {
    _initRequest ??= _loadProducts();
    return _initRequest;
  }

  void selectPackage(String packageId) {
    final selectedPackage = _findPackage(packageId) ?? state.selectedPackage;
    if (selectedPackage == null) {
      return;
    }

    state = state.copyWith(
      selectedPackageId: selectedPackage.id,
      errorMessage: null,
      successMessage: null,
    );
  }

  Future<RechargeResult> recharge() async {
    final selectedPackage = state.selectedPackage;
    final productDetails = selectedPackage?.productDetails;
    if (selectedPackage == null || productDetails == null) {
      const message = '充值套餐暂不可购买，请稍后重试';
      state = state.copyWith(errorMessage: message, successMessage: null);
      return const RechargeResult.failure(message);
    }

    if (state.isLoading) {
      const message = '正在处理购买，请稍候';
      state = state.copyWith(errorMessage: message, successMessage: null);
      return const RechargeResult.failure(message);
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );
    try {
      final purchaseParam = PurchaseParam(productDetails: productDetails);
      final started = await _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam,
      );
      if (!started) {
        const message = inAppPurchaseFailedMessage;
        state = state.copyWith(isLoading: false, errorMessage: message);
        return const RechargeResult.failure(message);
      }
      return const RechargeResult.success();
    } catch (error) {
      debugPrint('Recharge purchase start failed: $error');
      if (isPendingStoreKitPurchaseError(error)) {
        unawaited(_recoverPendingStoreKitTransactions());
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: inAppPurchaseFailedMessage,
      );
      return const RechargeResult.failure(inAppPurchaseFailedMessage);
    }
  }

  Future<void> _loadProducts() async {
    state = state.copyWith(
      currentCredits: UserBox.credit,
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

      final packages = _buildPackages(response.productDetails);
      final nextSelectedPackage = _resolveSelectedPackage(packages);
      final errorMessage = _productLoadMessage(response);

      state = state.copyWith(
        packages: packages,
        selectedPackageId: nextSelectedPackage?.id,
        isProductLoading: false,
        isStoreAvailable: true,
        errorMessage: errorMessage,
        successMessage: null,
      );
    } catch (error) {
      if (!mounted) return;
      state = state.copyWith(
        isProductLoading: false,
        errorMessage: '充值套餐加载失败：$error',
      );
    }
  }

  List<RechargePackage> _buildPackages(List<ProductDetails> products) {
    if (products.isEmpty) {
      return state.packages;
    }

    final productsById = {for (final product in products) product.id: product};
    final packages = <RechargePackage>[];

    for (final productId in _productIds) {
      final product = productsById[productId];
      if (product == null) {
        continue;
      }

      final fallbackPackage = _fallbackPackageForProduct(productId);
      packages.add(
        _packageFromProduct(product: product, fallbackPackage: fallbackPackage),
      );
    }

    for (final product in products) {
      if (_productIds.contains(product.id)) {
        continue;
      }

      final fallbackPackage = _fallbackPackageForProduct(product.id);
      packages.add(
        _packageFromProduct(product: product, fallbackPackage: fallbackPackage),
      );
    }

    packages.sort((a, b) => a.diamonds.compareTo(b.diamonds));
    return packages.isEmpty ? state.packages : packages;
  }

  RechargePackage _packageFromProduct({
    required ProductDetails product,
    required RechargePackage fallbackPackage,
  }) {
    final totalPoints =
        _pointsFromText(product.id) ??
        _pointsFromText(product.description) ??
        fallbackPackage.diamonds;
    final baseAmount = _baseAmountForPoints(totalPoints, fallbackPackage);
    final giftAmount = totalPoints - baseAmount;

    return RechargePackage(
      id: product.id,
      diamonds: totalPoints,
      baseAmount: baseAmount,
      giftAmount: giftAmount > 0 ? giftAmount : 0,
      price: product.price,
      badge: _resolveBadge(product.id, fallbackPackage),
      productDetails: product,
    );
  }

  int _baseAmountForPoints(int totalPoints, RechargePackage fallbackPackage) {
    if (fallbackPackage.diamonds == totalPoints) {
      return fallbackPackage.baseAmount;
    }
    return totalPoints;
  }

  String? _resolveBadge(String productId, RechargePackage fallbackPackage) {
    final normalizedId = productId.toLowerCase();
    if (normalizedId.contains('27000')) {
      return 'ultimate';
    }
    if (normalizedId.contains('7500')) {
      return 'bestPopular';
    }
    return fallbackPackage.badge;
  }

  RechargePackage? _resolveSelectedPackage(List<RechargePackage> packages) {
    if (packages.isEmpty) {
      return null;
    }

    for (final package in packages) {
      if (package.id == state.selectedPackageId) {
        return package;
      }
    }

    for (final package in packages) {
      if (package.diamonds == 2600) {
        return package;
      }
    }
    return packages.first;
  }

  String? _productLoadMessage(ProductDetailsResponse response) {
    if (response.error != null) {
      return response.error!.message;
    }
    if (response.productDetails.isEmpty) {
      return '暂未获取到可购买充值套餐';
    }
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint(
        'Recharge products not found: ${response.notFoundIDs.join(', ')}',
      );
    }
    return null;
  }

  RechargePackage _fallbackPackageForProduct(String productId) {
    final points = _pointsFromText(productId);
    if (points != null) {
      for (final package in state.packages) {
        if (package.diamonds == points) {
          return package;
        }
      }
    }

    return state.packages.first;
  }

  int? _pointsFromText(String value) {
    final match = RegExp(r'(\d+)').firstMatch(value);
    if (match == null) {
      return null;
    }
    return int.tryParse(match.group(1) ?? '');
  }

  RechargePackage? _findPackage(String packageId) {
    for (final package in state.packages) {
      if (package.id == packageId) {
        return package;
      }
    }
    return null;
  }

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchaseDetails in purchaseDetailsList) {
      await _handlePurchase(purchaseDetails);
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
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
        final message = inAppPurchaseErrorMessage(purchaseDetails.error);
        if (isPendingStoreKitPurchaseError(purchaseDetails.error)) {
          unawaited(_recoverPendingStoreKitTransactions());
        }
        debugPrint('Recharge purchase failed: ${purchaseDetails.error}');
        if (!mounted) return;
        state = state.copyWith(
          isLoading: false,
          errorMessage: message,
          successMessage: null,
        );
      case PurchaseStatus.canceled:
        if (!mounted) return;
        state = state.copyWith(
          isLoading: false,
          errorMessage: '购买已取消',
          successMessage: null,
        );
    }
  }

  Future<void> _deliverPurchase(PurchaseDetails purchaseDetails) async {
    try {
      final response = await _submitPurchaseToBackend(purchaseDetails);
      if (!response.isSuccess) {
        if (!mounted) return;
        debugPrint(
          'Recharge purchase receipt submit failed: ${response.message}',
        );
        state = state.copyWith(
          isLoading: false,
          errorMessage: inAppPurchaseFailedMessage,
          successMessage: null,
        );
        return;
      }

      await _completePurchaseIfNeeded(purchaseDetails);

      final latestCredits = await _syncUserDataAfterRecharge();

      if (!mounted) return;
      state = state.copyWith(
        currentCredits: latestCredits,
        isLoading: false,
        errorMessage: null,
        successMessage: '充值成功',
      );
    } catch (error) {
      if (!mounted) return;
      debugPrint('Recharge purchase receipt submit exception: $error');
      state = state.copyWith(
        isLoading: false,
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
      return ApiResponse(code: 400, message: '未知充值商品');
    }

    return Api.applePay(
      receipt: purchaseDetails.verificationData.serverVerificationData,
      productId: productId,
    );
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
      debugPrint('Recharge complete purchase failed: $error');
    }
  }

  Future<int> _syncUserDataAfterRecharge() async {
    try {
      final member = await UserBox.syncUserInfo();
      return member?.credit ?? UserBox.credit;
    } catch (error) {
      debugPrint('Recharge user info sync failed: $error');
    }

    try {
      final balance = await UserBox.syncBalance();
      return balance?.credit ?? UserBox.credit;
    } catch (error) {
      debugPrint('Recharge balance sync failed: $error');
      return UserBox.credit;
    }
  }

  Future<void> _recoverPendingStoreKitTransactions() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (error) {
      debugPrint('Recharge restore pending purchases failed: $error');
    }
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}

final rechargeControllerProvider =
    StateNotifierProvider<RechargeController, RechargeState>((ref) {
      return RechargeController();
    });
