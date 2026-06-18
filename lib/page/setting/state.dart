import 'package:flicko_video/i18n/i18n.dart';

enum SettingItemType {
  language,
  termsOfService,
  privacyPolicy,
  aboutApp,
  deleteAccount,
  logout,
}

class SettingItem {
  final SettingItemType type;
  final String title;
  final String? subtitle;
  final bool isDestructive;

  const SettingItem({
    required this.type,
    required this.title,
    this.subtitle,
    this.isDestructive = false,
  });
}

class SettingState {
  final String currentLanguageCode;
  final List<SettingItem> items;

  const SettingState({required this.currentLanguageCode, required this.items});

  factory SettingState.initial(String languageCode) {
    final locale = AppLocale.fromCode(languageCode);
    return SettingState(
      currentLanguageCode: locale.code,
      items: _buildItems(locale),
    );
  }

  SettingState copyWith({
    String? currentLanguageCode,
    List<SettingItem>? items,
  }) {
    return SettingState(
      currentLanguageCode: currentLanguageCode ?? this.currentLanguageCode,
      items: items ?? this.items,
    );
  }

  static List<SettingItem> _buildItems(AppLocale locale) {
    return [
      SettingItem(
        type: SettingItemType.language,
        title: 'Language',
        subtitle: locale.nativeName,
      ),
      const SettingItem(
        type: SettingItemType.termsOfService,
        title: 'Terms of Service',
      ),
      const SettingItem(
        type: SettingItemType.privacyPolicy,
        title: 'Privacy Policy',
      ),
      const SettingItem(type: SettingItemType.aboutApp, title: 'About App'),
      const SettingItem(
        type: SettingItemType.deleteAccount,
        title: 'Delete Account',
        isDestructive: true,
      ),
      const SettingItem(
        type: SettingItemType.logout,
        title: 'Log Out',
        isDestructive: true,
      ),
    ];
  }
}
