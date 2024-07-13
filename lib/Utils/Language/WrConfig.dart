import 'language_model.dart';

class WrConfig{
  WrConfig._();

  static final Language defaultLanguage =
  Language(languageCode: 'en', countryCode: 'US', name: 'English');

  static final List<Language> wrSupportedLanguageList = <Language>[
    Language(languageCode: 'en', countryCode: 'US', name: 'English'),
    Language(languageCode: 'ar', countryCode: 'AE', name: 'Arabic'),
  ];
}