import 'package:flicko_video/i18n/i18n.dart';
import 'package:flicko_video/i18n/locale_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'state.dart';

class SettingController extends StateNotifier<SettingState> {
  SettingController(String languageCode)
    : super(SettingState.initial(languageCode));

  Future<void> updateLanguage(String languageCode) async {
    final locale = AppLocale.fromCode(languageCode);
    final updatedItems = state.items
        .map(
          (item) => item.type == SettingItemType.language
              ? SettingItem(
                  type: item.type,
                  title: item.title,
                  subtitle: locale.nativeName,
                  isDestructive: item.isDestructive,
                )
              : item,
        )
        .toList(growable: false);

    state = state.copyWith(
      currentLanguageCode: locale.code,
      items: updatedItems,
    );
  }
}

final settingControllerProvider =
    StateNotifierProvider<SettingController, SettingState>((ref) {
      final languageCode = ref.watch(appLocaleControllerProvider).languageCode;
      return SettingController(languageCode);
    });
