import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:flicko_video/core/http.dart';
import 'package:flicko_video/hive/app/app_box.dart';
import 'package:flicko_video/hive/auth/auth_box.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'app_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  await initBoxes();

  initAdjust();
  await initUserAgentClient();

  runApp(const ProviderScope(child: AppView()));
}

void initAdjust() {
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
      debugPrint('[Adjust]: Click label: ${attributionChangedData.clickLabel}');
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
      setUserAgentClient(sessionSuccessData.adid);
    }
    if (sessionSuccessData.jsonResponse != null) {
      debugPrint('[Adjust]: JSON response: ${sessionSuccessData.jsonResponse}');
    }
  };
  Adjust.initSdk(config);
}

Future<void> initUserAgentClient() async {
  final adid = await Adjust.getAdid();
  await setUserAgentClient(adid);
}

Future<void> setUserAgentClient(String? guid) async {
  final packageInfo = await PackageInfo.fromPlatform();
  final normalizedGuid = guid?.trim();
  if (normalizedGuid == null || normalizedGuid.isEmpty) {
    return;
  }

  Http().setUserAgentClient('$normalizedGuid/app/${packageInfo.version}');
}

Future<void> initBoxes() async {
  await AppBox.init();
  await AuthBox.init();
  await UserBox.init();
}
