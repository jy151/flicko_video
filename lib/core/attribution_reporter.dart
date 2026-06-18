import 'dart:async';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/core/http.dart';
import 'package:flicko_video/hive/auth/auth_box.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AttributionReporter {
  const AttributionReporter._();

  static const int _adjustLookupTimeoutMs = 30000;
  static bool _isAdjustInitialized = false;

  static Future<void> reportAdjustClient() async {
    if (!AuthBox.isLoggedIn) {
      return;
    }

    try {
      _initAdjust();
      await _requestTrackingAuthorizationIfNeeded();

      final adid = await _initUserAgentClient();
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

  static void _initAdjust() {
    if (_isAdjustInitialized) {
      return;
    }

    final config = AdjustConfig('ca2d9vldhfcw', AdjustEnvironment.sandbox);
    config.isAppTrackingTransparencyUsageEnabled = true;
    config.attConsentWaitingInterval = 30;

    config.attributionCallback = (AdjustAttribution attributionChangedData) {
      debugPrint('[Adjust]: Attribution changed!');

      if (attributionChangedData.trackerToken != null) {
        debugPrint(
          '[Adjust]: Tracker token: ${attributionChangedData.trackerToken}',
        );
      }
      if (attributionChangedData.trackerName != null) {
        debugPrint(
          '[Adjust]: Tracker name: ${attributionChangedData.trackerName}',
        );
      }
      if (attributionChangedData.campaign != null) {
        debugPrint('[Adjust]: Campaign: ${attributionChangedData.campaign}');
      }
      if (attributionChangedData.network != null) {
        debugPrint('[Adjust]: Network: ${attributionChangedData.network}');
      }
      if (attributionChangedData.creative != null) {
        debugPrint('[Adjust]: Creative: ${attributionChangedData.creative}');
      }
      if (attributionChangedData.adgroup != null) {
        debugPrint('[Adjust]: Adgroup: ${attributionChangedData.adgroup}');
      }
      if (attributionChangedData.clickLabel != null) {
        debugPrint(
          '[Adjust]: Click label: ${attributionChangedData.clickLabel}',
        );
      }
      if (attributionChangedData.fbInstallReferrer != null) {
        debugPrint(
          '[Adjust]: facebook install referrer: ${attributionChangedData.fbInstallReferrer}',
        );
      }
      if (attributionChangedData.jsonResponse != null) {
        debugPrint(
          '[Adjust]: JSON Response: ${attributionChangedData.jsonResponse}',
        );
      }
    };

    config.sessionSuccessCallback = (AdjustSessionSuccess sessionSuccessData) {
      debugPrint('[Adjust]: Session recording success!');

      if (sessionSuccessData.message != null) {
        debugPrint('[Adjust]: Message: ${sessionSuccessData.message}');
      }
      if (sessionSuccessData.timestamp != null) {
        debugPrint('[Adjust]: Timestamp: ${sessionSuccessData.timestamp}');
      }
      if (sessionSuccessData.adid != null) {
        debugPrint('[Adjust]: Adid: ${sessionSuccessData.adid}');
        unawaited(_setUserAgentClient(sessionSuccessData.adid));
      }
      if (sessionSuccessData.jsonResponse != null) {
        debugPrint(
          '[Adjust]: JSON response: ${sessionSuccessData.jsonResponse}',
        );
      }
    };
    Adjust.initSdk(config);
    _isAdjustInitialized = true;
  }

  static Future<String?> _initUserAgentClient() async {
    final adid = await _readAdid();
    await _setUserAgentClient(adid);
    return adid;
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

  static Future<void> _setUserAgentClient(String? guid) async {
    final normalizedGuid = guid?.trim();
    if (normalizedGuid == null || normalizedGuid.isEmpty) {
      return;
    }

    final packageInfo = await PackageInfo.fromPlatform();
    Http().setUserAgentClient('$normalizedGuid/app/${packageInfo.version}');
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
