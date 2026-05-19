import 'dart:io';

import 'package:flicko_video/i18n/i18n.dart';
import 'package:hive/hive.dart';

class AppBox { 
  static const String name = 'app';
  static const String _languageKey = 'language';

  static Box<dynamic> get box => Hive.box<dynamic>(name);

  static Future<void> init() async {
    await Hive.openBox<dynamic>(name);
  }

  static Future<void> close() async {
    await Hive.close();
  }

  static Future<void> setLanguage(String languageCode) async {
    await box.put(_languageKey, AppLocale.fromCode(languageCode).code);
  }

  static String getLanguage() {
    final savedLanguage = box.get(_languageKey) as String?;
    if (savedLanguage != null && savedLanguage.isNotEmpty) {
      return AppLocale.fromCode(savedLanguage).code;
    } 

    return getSystemLanguage();
  }

  static String getSystemLanguage() {
    return AppLocale.fromCode(Platform.localeName).code;
  }
}
