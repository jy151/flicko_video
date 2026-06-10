import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

const inAppPurchaseFailedMessage = '网络异常请稍后再试';

bool isPendingStoreKitPurchaseError(Object? error) {
  if (error == null) {
    return false;
  }

  if (error is PlatformException) {
    return _containsPendingStoreKitMarker(error.code) ||
        _containsPendingStoreKitMarker(error.message) ||
        _containsPendingStoreKitMarker(error.details?.toString());
  }

  if (error is IAPError) {
    return _containsPendingStoreKitMarker(error.code) ||
        _containsPendingStoreKitMarker(error.message) ||
        _containsPendingStoreKitMarker(error.details?.toString());
  }

  return _containsPendingStoreKitMarker(error.toString());
}

String inAppPurchaseErrorMessage(IAPError? error) => inAppPurchaseFailedMessage;

bool _containsPendingStoreKitMarker(String? value) {
  if (value == null || value.isEmpty) {
    return false;
  }

  final normalized = value.toLowerCase();
  return normalized.contains('storekit_duplicate_product_object') ||
      normalized.contains('duplicate_product') ||
      normalized.contains('pending transaction');
}
