import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/hive/auth/auth_box.dart';
import 'package:flutter/foundation.dart';

class AttributionReporter {
  const AttributionReporter._();

  static const int _adjustLookupTimeoutMs = 30000;

  static Future<void> reportAdjustClient() async {
    if (!AuthBox.isLoggedIn) {
      return;
    }

    try {
      await _requestTrackingAuthorizationIfNeeded();

      final adid = await _readAdid();
      final attribution = await _readAttribution();
      final gpsAdid = await _readGoogleAdId();

      await Api.reportAttribution({ 
        'adid': _valueOrEmpty(adid),
        'network': _networkOrEmpty(attribution),
        'gps_adid': _valueOrEmpty(gpsAdid),
      });
    } catch (_) {
      // Attribution reporting must not block or break app startup.
    }
  }

  static Future<void> _requestTrackingAuthorizationIfNeeded() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }

    try {
      // ATTrackingManagerAuthorizationStatus.notDetermined.
      const notDetermined = 0;
      final status = await Adjust.getAppTrackingAuthorizationStatus();
      if (status == notDetermined) {
        await Adjust.requestAppTrackingAuthorization();
      }
    } catch (_) {
      // Keep attribution reporting best-effort.
    }
  }

  static Future<String?> _readAdid() async {
    try {
      return Adjust.getAdidWithTimeout(_adjustLookupTimeoutMs);
    } catch (_) {
      return null;
    }
  }

  static Future<AdjustAttribution?> _readAttribution() async {
    try {
      return Adjust.getAttributionWithTimeout(_adjustLookupTimeoutMs);
    } catch (_) {
      return null;
    }
  }

  static Future<String?> _readGoogleAdId() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return null;
    }

    try {
      return Adjust.getGoogleAdId();
    } catch (_) {
      return null;
    }
  }

  static String _networkOrEmpty(AdjustAttribution? attribution) {
    final network = _valueOrEmpty(attribution?.network);
    if (network.toLowerCase() == 'no user consent') {
      return '';
    }
    return network;
  }

  static String _valueOrEmpty(String? value) => value?.trim() ?? '';
}
