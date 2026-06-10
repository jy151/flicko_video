import 'package:in_app_purchase/in_app_purchase.dart';

class RechargePackage {
  final String id;
  final int diamonds;
  final int baseAmount;
  final int giftAmount;
  final String price;
  final String? badge;
  final ProductDetails? productDetails;

  const RechargePackage({
    required this.id,
    required this.diamonds,
    required this.baseAmount,
    required this.giftAmount,
    required this.price,
    this.badge,
    this.productDetails,
  });
}

class RechargeState {
  final int currentCredits;
  final List<RechargePackage> packages;
  final String? selectedPackageId;
  final bool isLoading;
  final bool isProductLoading;
  final bool isStoreAvailable;
  final String? errorMessage;
  final String? successMessage;

  const RechargeState({
    required this.currentCredits,
    required this.packages,
    this.selectedPackageId,
    this.isLoading = false,
    this.isProductLoading = false,
    this.isStoreAvailable = true,
    this.errorMessage,
    this.successMessage,
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
          price: 'US\$ 5.99',
        ),
        RechargePackage(
          id: '2',
          diamonds: 1000,
          baseAmount: 800,
          giftAmount: 200,
          price: 'US\$ 14.99',
        ),
        RechargePackage(
          id: '3',
          diamonds: 2600,
          baseAmount: 2000,
          giftAmount: 600,
          price: 'US\$ 35.99',
        ),
        RechargePackage(
          id: '4',
          diamonds: 7500,
          baseAmount: 5000,
          giftAmount: 2500,
          price: 'US\$ 89.99',
          badge: 'bestPopular',
        ),
        RechargePackage(
          id: '5',
          diamonds: 12000,
          baseAmount: 7500,
          giftAmount: 4500,
          price: 'US\$ 138.99',
        ),
        RechargePackage(
          id: '6',
          diamonds: 27000,
          baseAmount: 15000,
          giftAmount: 12000,
          price: 'US\$ 269.99',
          badge: 'ultimate',
        ),
      ],
      selectedPackageId: '3',
    );
  }

  RechargePackage? get selectedPackage {
    for (final package in packages) {
      if (package.id == selectedPackageId) {
        return package;
      }
    }
    return packages.isEmpty ? null : packages.first;
  }

  RechargeState copyWith({
    int? currentCredits,
    List<RechargePackage>? packages,
    String? selectedPackageId,
    bool? isLoading,
    bool? isProductLoading,
    bool? isStoreAvailable,
    Object? errorMessage = _unset,
    Object? successMessage = _unset,
  }) {
    return RechargeState(
      currentCredits: currentCredits ?? this.currentCredits,
      packages: packages ?? this.packages,
      selectedPackageId: selectedPackageId ?? this.selectedPackageId,
      isLoading: isLoading ?? this.isLoading,
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
