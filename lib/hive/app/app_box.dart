import 'dart:io';

import 'package:flicko_video/i18n/i18n.dart';
import 'package:hive/hive.dart';

class AppBox {
  static const String name = 'app';
  static const String _languageKey = 'language';
  // 是否初次启动·
  static const String _isFirstLaunchKey = 'isFirstLaunch';

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


  static Future<void> setIsFirstLaunch(bool isFirstLaunch) async {
    await box.put(_isFirstLaunchKey, isFirstLaunch);
  }

  static bool get isFirstLaunch {
    return box.get(_isFirstLaunchKey) as bool? ?? true; 
  }

  // 监听初次启动
  static Stream<bool> watchIsFirstLaunch() {
    return box.watch(key: _isFirstLaunchKey).map((event) => event.value as bool);
  }

}
