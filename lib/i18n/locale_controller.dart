import 'package:flicko_video/hive/app/app_box.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/legacy.dart';

class AppLocaleState {
  const AppLocaleState({required this.locale});

  final Locale locale;

  String get languageCode => AppLocale.resolve(locale).code;
  String get systemLanguageCode => AppBox.getSystemLanguage();
}

class AppLocaleController extends StateNotifier<AppLocaleState> {
  AppLocaleController()
    : super(
        AppLocaleState(
          locale: AppLocale.fromCode(AppBox.getLanguage()).locale,
        ),
      );

  Future<void> updateLocale(String languageCode) async {
    final appLocale = AppLocale.fromCode(languageCode);
    if (state.languageCode == appLocale.code) {
      return;
    }

    await AppBox.setLanguage(appLocale.code);
    state = AppLocaleState(locale: appLocale.locale);
  }

  void init() {}
}

final appLocaleControllerProvider =
    StateNotifierProvider<AppLocaleController, AppLocaleState>((ref) {
      final controller = AppLocaleController();
      ref.onDispose(controller.dispose);
      return controller;
    });
