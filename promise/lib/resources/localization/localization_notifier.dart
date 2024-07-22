import 'package:flutter/material.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/settings/preferences_helper.dart';
import 'package:promise/resources/localization/l10n.dart';

class LocalizationNotifier extends ChangeNotifier {
  late Locale _locale;

  Locale get locale => _locale;

  LocalizationNotifier(String storedLanguageCode) {
    _locale = L10n.getLocale(storedLanguageCode);
  }

  Future<void> setLocale(String languageCode) async {
    _locale = L10n.getLocale(languageCode);
    await serviceLocator
        .get<PreferencesHelper>()
        .setPreferredLanguage(_locale.languageCode);
    notifyListeners();
  }

  Future<void> clearLocale() async {
    _locale = L10n.getLocale('en');
    await serviceLocator
        .get<PreferencesHelper>()
        .setPreferredLanguage(_locale.languageCode);
    notifyListeners();
  }
}
