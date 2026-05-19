import 'package:flutter/widgets.dart';

class AppLocale {
  const AppLocale._({
    required this.code,
    required this.languageTag,
    required this.locale,
    required this.nativeName,
    required this.englishName,
    this.isCommon = false,
  });

  final String code;
  final String languageTag;
  final Locale locale;
  final String nativeName;
  final String englishName;
  final bool isCommon;

  static const english = AppLocale._(
    code: 'en',
    languageTag: 'en',
    locale: Locale('en'),
    nativeName: 'English',
    englishName: 'English',
    isCommon: true,
  );

  static const simplifiedChinese = AppLocale._(
    code: 'zh-Hans',
    languageTag: 'zh-Hans',
    locale: Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    nativeName: '简体中文',
    englishName: 'Chinese (Simplified)',
    isCommon: true,
  );

  static const traditionalChinese = AppLocale._(
    code: 'zh-Hant',
    languageTag: 'zh-Hant',
    locale: Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    nativeName: '繁體中文',
    englishName: 'Chinese (Traditional)',
    isCommon: true,
  );

  static const japanese = AppLocale._(
    code: 'ja',
    languageTag: 'ja',
    locale: Locale('ja'),
    nativeName: '日本語',
    englishName: 'Japanese',
    isCommon: true,
  );

  static const korean = AppLocale._(
    code: 'ko',
    languageTag: 'ko',
    locale: Locale('ko'),
    nativeName: '한국어',
    englishName: 'Korean',
    isCommon: true,
  );

  static const french = AppLocale._(
    code: 'fr',
    languageTag: 'fr',
    locale: Locale('fr'),
    nativeName: 'Français',
    englishName: 'French',
    isCommon: true,
  );

  static const russian = AppLocale._(
    code: 'ru',
    languageTag: 'ru',
    locale: Locale('ru'),
    nativeName: 'Русский',
    englishName: 'Russian',
    isCommon: true,
  );

  static const german = AppLocale._(
    code: 'de',
    languageTag: 'de',
    locale: Locale('de'),
    nativeName: 'Deutsch',
    englishName: 'German',
    isCommon: true,
  );

  static const spanish = AppLocale._(
    code: 'es',
    languageTag: 'es',
    locale: Locale('es'),
    nativeName: 'Español',
    englishName: 'Spanish',
    isCommon: true,
  );

  static const portuguese = AppLocale._(
    code: 'pt',
    languageTag: 'pt',
    locale: Locale('pt'),
    nativeName: 'Português',
    englishName: 'Portuguese',
    isCommon: true,
  );

  static const italian = AppLocale._(
    code: 'it',
    languageTag: 'it',
    locale: Locale('it'),
    nativeName: 'Italiano',
    englishName: 'Italian',
    isCommon: true,
  );

  static const arabic = AppLocale._(
    code: 'ar',
    languageTag: 'ar',
    locale: Locale('ar'),
    nativeName: 'العربية',
    englishName: 'Arabic',
    isCommon: true,
  );

  static const hindi = AppLocale._(
    code: 'hi',
    languageTag: 'hi',
    locale: Locale('hi'),
    nativeName: 'हिन्दी',
    englishName: 'Hindi',
    isCommon: true,
  );

  static const thai = AppLocale._(
    code: 'th',
    languageTag: 'th',
    locale: Locale('th'),
    nativeName: 'ไทย',
    englishName: 'Thai',
  );

  static const vietnamese = AppLocale._(
    code: 'vi',
    languageTag: 'vi',
    locale: Locale('vi'),
    nativeName: 'Tiếng Việt',
    englishName: 'Vietnamese',
    isCommon: true,
  );

  static const indonesian = AppLocale._(
    code: 'id',
    languageTag: 'id',
    locale: Locale('id'),
    nativeName: 'Bahasa Indonesia',
    englishName: 'Indonesian',
    isCommon: true,
  );

  static const turkish = AppLocale._(
    code: 'tr',
    languageTag: 'tr',
    locale: Locale('tr'),
    nativeName: 'Türkçe',
    englishName: 'Turkish',
  );

  static const supported = <AppLocale>[
    english,
    simplifiedChinese,
    traditionalChinese,
    japanese,
    korean,
    french,
    russian,
    german,
    spanish,
    portuguese,
    italian,
    arabic,
    hindi,
    thai,
    vietnamese,
    indonesian,
    turkish,
  ];

  static AppLocale fromCode(String? code) {
    if (code == null || code.isEmpty) {
      return english;
    }

    final normalized = code.toLowerCase().replaceAll('_', '-');

    for (final locale in supported) {
      if (locale.code.toLowerCase() == normalized ||
          locale.languageTag.toLowerCase() == normalized) {
        return locale;
      }
    }

    if (normalized.startsWith('zh-hant') ||
        normalized.contains('tw') ||
        normalized.contains('hk') ||
        normalized.contains('mo')) {
      return traditionalChinese;
    }

    if (normalized.startsWith('zh')) {
      return simplifiedChinese;
    }

    for (final locale in supported) {
      if (normalized == locale.locale.languageCode.toLowerCase()) {
        return locale;
      }
    }

    return english;
  }

  static AppLocale resolve(Locale? locale) {
    if (locale == null) {
      return english;
    }

    final scriptCode = locale.scriptCode;
    final countryCode = locale.countryCode;
    final segments = <String>[locale.languageCode];
    if (scriptCode != null && scriptCode.isNotEmpty) {
      segments.add(scriptCode);
    }
    if (countryCode != null && countryCode.isNotEmpty) {
      segments.add(countryCode);
    }

    return fromCode(segments.join('-'));
  }

  static List<AppLocale> prioritized({
    required String currentLanguageCode,
    String? systemLanguageCode,
  }) {
    final current = fromCode(currentLanguageCode);
    final system = fromCode(systemLanguageCode);

    final prioritized = <AppLocale>[];
    void addIfMissing(AppLocale locale) {
      if (!prioritized.any((item) => item.code == locale.code)) {
        prioritized.add(locale);
      }
    }

    addIfMissing(current);
    addIfMissing(system);

    for (final locale in supported.where((item) => item.isCommon)) {
      addIfMissing(locale);
    }

    for (final locale in supported) {
      addIfMissing(locale);
    }

    return prioritized;
  }
}
