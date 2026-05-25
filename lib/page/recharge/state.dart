class RechargePackage {
  final String id;
  final int diamonds;
  final int baseAmount;
  final int giftAmount;
  final String price;
  final String? badge;

  const RechargePackage({
    required this.id,
    required this.diamonds,
    required this.baseAmount,
    required this.giftAmount,
    required this.price,
    this.badge,
  });
}

class RechargeState {
  final int currentCredits;
  final List<RechargePackage> packages;
  final String? selectedPackageId;
  final bool isLoading;

  const RechargeState({
    required this.currentCredits,
    required this.packages,
    this.selectedPackageId,
    this.isLoading = false,
  });

  factory RechargeState.initial() {
    return const RechargeState(
      currentCredits: 0,
      packages: [
        RechargePackage(
          id: '1',
          diamonds: 300,
          baseAmount: 300,
          giftAmount: 0,
          price: 'US\$ 5.40',
        ),
        RechargePackage(
          id: '2',
          diamonds: 1000,
          baseAmount: 800,
          giftAmount: 200,
          price: 'US\$ 14.40',
        ),
        RechargePackage(
          id: '3',
          diamonds: 2600,
          baseAmount: 2000,
          giftAmount: 600,
          price: 'US\$ 36.00',
        ),
        RechargePackage(
          id: '4',
          diamonds: 7500,
          baseAmount: 5000,
          giftAmount: 2500,
          price: 'US\$ 90.00',
          badge: 'bestPopular',
        ),
        RechargePackage(
          id: '5',
          diamonds: 12000,
          baseAmount: 7500,
          giftAmount: 4500,
          price: 'US\$ 139.00',
        ),
        RechargePackage(
          id: '6',
          diamonds: 27000,
          baseAmount: 15000,
          giftAmount: 12000,
          price: 'US\$ 270.00',
          badge: 'ultimate',
        ),
      ],
      selectedPackageId: '3',
    );
  }

  RechargeState copyWith({
    int? currentCredits,
    List<RechargePackage>? packages,
    String? selectedPackageId,
    bool? isLoading,
  }) {
    return RechargeState(
      currentCredits: currentCredits ?? this.currentCredits,
      packages: packages ?? this.packages,
      selectedPackageId: selectedPackageId ?? this.selectedPackageId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
