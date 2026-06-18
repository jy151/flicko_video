import 'dart:io';

import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';

class ScreenProtectionService {
  static bool? _enabled;

  static Future<void> setEnabled(bool enabled) async {
    if (!Platform.isIOS || _enabled == enabled) {
      return;
    }

    _enabled = enabled;
    if (enabled) {
      await ScreenProtector.preventScreenshotOn();
      await ScreenProtector.protectDataLeakageWithColor(Colors.black);
    } else {
      await ScreenProtector.preventScreenshotOff();
      await ScreenProtector.protectDataLeakageWithColorOff();
      await ScreenProtector.protectDataLeakageOff();
    }
  }
}
