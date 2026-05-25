class MemberPlan {
  final String id;
  final String title;
  final String price;
  final String unit;
  final String diamonds;
  final String saveLabel;

  const MemberPlan({
    required this.id,
    required this.title,
    required this.price,
    required this.unit,
    required this.diamonds,
    required this.saveLabel,
  });
}

class MemberState {
  final List<MemberPlan> plans;
  final String selectedPlanId;
  final String countdown;
  final String paymentAmount;
  final String bonusDiamonds;
  final bool isLoading;

  const MemberState({
    required this.plans,
    required this.selectedPlanId,
    required this.countdown,
    required this.paymentAmount,
    required this.bonusDiamonds,
    required this.isLoading,
  });

  factory MemberState.initial() {
    return const MemberState(
      plans: [
        MemberPlan(
          id: 'quarterly',
          title: 'quarterlyPlan',
          price: 'US\$0.50',
          unit: '/day',
          diamonds: '700',
          saveLabel: 'SAVE 55%',
        ),
        MemberPlan(
          id: 'annual',
          title: 'annualPlan',
          price: 'US\$0.27',
          unit: '/day',
          diamonds: '1600',
          saveLabel: 'SAVE 70%',
        ),
        MemberPlan(
          id: 'lifetime',
          title: 'lifetimePlan',
          price: 'US\$0.08',
          unit: '/day',
          diamonds: '3000',
          saveLabel: 'SAVE 91%',
        ),
      ],
      selectedPlanId: 'annual',
      countdown: '09:52',
      paymentAmount: 'US\$99.99',
      bonusDiamonds: '1,600',
      isLoading: false,
    );
  }

  MemberState copyWith({
    List<MemberPlan>? plans,
    String? selectedPlanId,
    String? countdown,
    String? paymentAmount,
    String? bonusDiamonds,
    bool? isLoading,
  }) {
    return MemberState(
      plans: plans ?? this.plans,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      countdown: countdown ?? this.countdown,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      bonusDiamonds: bonusDiamonds ?? this.bonusDiamonds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
