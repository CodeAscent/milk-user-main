import 'dart:ui';

class Language {
  final String? languageCode;
  final String? countryCode;
  final String? name;
  Language({this.languageCode, this.countryCode, this.name});

  Locale toLocale() {
    return Locale(languageCode!, countryCode);
  }
}
