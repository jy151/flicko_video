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

  config.attributionCallback = (AdjustAttribution attributionChangedData) {
    print('[Adjust]: Attribution changed!');

    if (attributionChangedData.trackerToken != null) {
      print('[Adjust]: Tracker token: ${attributionChangedData.trackerToken}');
    }
    if (attributionChangedData.trackerName != null) {
      print('[Adjust]: Tracker name: ${attributionChangedData.trackerName}');
    }
    if (attributionChangedData.campaign != null) {
      print('[Adjust]: Campaign: ${attributionChangedData.campaign}');
    }
    if (attributionChangedData.network != null) {
      print('[Adjust]: Network: ${attributionChangedData.network}');
    }
    if (attributionChangedData.creative != null) {
      print('[Adjust]: Creative: ${attributionChangedData.creative}');
    }
    if (attributionChangedData.adgroup != null) {
      print('[Adjust]: Adgroup: ${attributionChangedData.adgroup}');
    }
    if (attributionChangedData.clickLabel != null) {
      print('[Adjust]: Click label: ${attributionChangedData.clickLabel}');
    }
    if (attributionChangedData.fbInstallReferrer != null) {
      print(
        '[Adjust]: facebook install referrer: ${attributionChangedData.fbInstallReferrer}',
      );
    }
    if (attributionChangedData.jsonResponse != null) {
      print('[Adjust]: JSON Response: ${attributionChangedData.jsonResponse}');
    }
  };

  config.sessionSuccessCallback = (AdjustSessionSuccess sessionSuccessData) {
    print('[Adjust]: Session recording success!');

    if (sessionSuccessData.message != null) {
      print('[Adjust]: Message: ${sessionSuccessData.message}');
    }
    if (sessionSuccessData.timestamp != null) {
      print('[Adjust]: Timestamp: ${sessionSuccessData.timestamp}');
    }
    if (sessionSuccessData.adid != null) {
      print('[Adjust]: Adid: ${sessionSuccessData.adid}');
      setUserAgentClient(sessionSuccessData.adid);
    }
    if (sessionSuccessData.jsonResponse != null) {
      print('[Adjust]: JSON response: ${sessionSuccessData.jsonResponse}');
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
