import 'package:in_app_purchase/in_app_purchase.dart';

class MemberPlan {
  final String id;
  final String title;
  final String price;
  final String unit;
  final String diamonds;
  final String saveLabel;
  final ProductDetails? productDetails;

  const MemberPlan({
    required this.id,
    required this.title,
    required this.price,
    required this.unit,
    required this.diamonds,
    required this.saveLabel,
    this.productDetails,
  });
}

class MemberState {
  final List<MemberPlan> plans;
  final String selectedPlanId;
  final String paymentAmount;
  final String bonusDiamonds;
  final int currentCredits;
  final bool isLoading;
  final bool isRestoring;
  final bool isProductLoading;
  final bool isStoreAvailable;
  final String? errorMessage;
  final String? successMessage;

  const MemberState({
    required this.plans,
    required this.selectedPlanId,
    required this.paymentAmount,
    required this.bonusDiamonds,
    required this.currentCredits,
    required this.isLoading,
    required this.isRestoring,
    required this.isProductLoading,
    required this.isStoreAvailable,
    this.errorMessage,
    this.successMessage,
  });

  factory MemberState.initial({int currentCredits = 0}) {
    return MemberState(
      plans: [
        MemberPlan(
          id: 'monthly',
          title: 'monthlyPlan',
          price: 'US\$0.50',
          unit: '/day',
          diamonds: '700',
          saveLabel: 'SAVE 55%',
        ),
        MemberPlan(
          id: 'quarterly',
          title: 'quarterlyPlan',
          price: 'US\$0.27',
          unit: '/day',
          diamonds: '1600',
          saveLabel: 'SAVE 70%',
        ),
        MemberPlan(
          id: 'annual',
          title: 'annualPlan',
          price: 'US\$0.08',
          unit: '/day',
          diamonds: '3000',
          saveLabel: 'SAVE 91%',
        ),
      ],
      selectedPlanId: 'quarterly',
      paymentAmount: 'US\$99.99',
      bonusDiamonds: '1,600',
      currentCredits: currentCredits,
      isLoading: false,
      isRestoring: false,
      isProductLoading: false,
      isStoreAvailable: true,
    );
  }

  MemberPlan? get selectedPlan {
    for (final plan in plans) {
      if (plan.id == selectedPlanId) {
        return plan;
      }
    }
    return plans.isEmpty ? null : plans.first;
  }

  MemberState copyWith({
    List<MemberPlan>? plans,
    String? selectedPlanId,
    String? paymentAmount,
    String? bonusDiamonds,
    int? currentCredits,
    bool? isLoading,
    bool? isRestoring,
    bool? isProductLoading,
    bool? isStoreAvailable,
    Object? errorMessage = _unset,
    Object? successMessage = _unset,
  }) {
    return MemberState(
      plans: plans ?? this.plans,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      bonusDiamonds: bonusDiamonds ?? this.bonusDiamonds,
      currentCredits: currentCredits ?? this.currentCredits,
      isLoading: isLoading ?? this.isLoading,
      isRestoring: isRestoring ?? this.isRestoring,
      isProductLoading: isProductLoading ?? this.isProductLoading,
      isStoreAvailable: isStoreAvailable ?? this.isStoreAvailable,
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : errorMessage as String?,
      successMessage: successMessage == _unset
          ? this.successMessage
          : successMessage as String?,
    );
  }
}

const Object _unset = Object();
