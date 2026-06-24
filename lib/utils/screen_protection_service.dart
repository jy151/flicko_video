import 'dart:io';

import 'package:flutter/services.dart';

class ScreenProtectionService {
  static const MethodChannel _channel = MethodChannel(
    'flicko_video/native_screen_protection',
  );

  static bool? _enabled;

  static Future<void> setEnabled(bool enabled) async {
    if (!Platform.isIOS || _enabled == enabled) {
      return;
    }

    _enabled = enabled;
    await _channel.invokeMethod<void>('setEnabled', {'enabled': enabled});
  }
}
