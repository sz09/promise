import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Utils class for app localization with delegate
class AppLocalization {
  late final Locale _locale;

  AppLocalization(this._locale);

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  late Map<String, String> _localizedValues;

  /// This function will load requested language `.json` file and will assign it to the `_localizedValues` map
  Future loadLanguage() async {

    // https://stackoverflow.com/questions/60079645/flutter-how-to-mock-a-call-to-rootbundle-loadstring-then-reset-the-mocked
    String jsonStringValues = await rootBundle.loadString('assets/i18n/${_locale.languageCode}.json', cache: false);

    Map<String, dynamic> mappedValues = json.decode(jsonStringValues);

    // converting `dynamic` value to `String`, because `_localizedValues` is of type Map<String,String>
    _localizedValues = mappedValues.map((key, value) => MapEntry(key, value.toString()));
  }

  String? getTranslatedValue(String key) {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<AppLocalization> delegate = _AppLocalizationDelegate();
}

/// Private overriden delegate class
class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  // It will check if the user's locale is supported by our App or not
  @override
  bool isSupported(Locale locale) {
    return ["en", "vi"].contains(locale.languageCode);
  }

  // It will load the equivalent json file requested by the user
  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization appLocalization = AppLocalization(locale);
    await appLocalization.loadLanguage();
    return appLocalization;
  }

  // coverage:ignore-start
  @override
  bool shouldReload(_AppLocalizationDelegate old) => false;
  // coverage:ignore-end
}


const EN = Locale('en', "US");
const VN = Locale('vi', "VN");

class L10n {
  static Locale getLocale(String code) {
    switch (code) {
      case 'vi':
        return VN;
      case 'en':
      default:
        return EN;
    }
  }
}

Map<String, Map<String, String>> _localizedValues = {};


class LocalizationService extends Translations {
// locale sẽ được get mỗi khi mới mở app (phụ thuộc vào locale hệ thống hoặc bạn có thể cache lại locale mà người dùng đã setting và set nó ở đây)
  static final locale = _getLocaleFromLanguage();

// fallbackLocale là locale default nếu locale được set không nằm trong những Locale support
  static const fallbackLocale = EN;

// language code của những locale được support
  static final langCodes = [
    'en',
    'vi',
  ];

// các Locale được support
  static final locales = [
    EN,
    VN,
  ];

// cái này là Map các language được support đi kèm với mã code của lang đó: cái này dùng để đổ data vào Dropdownbutton và set language mà không cần quan tâm tới language của hệ thống
  static final langs = LinkedHashMap.from({
    'en': 'English',
    'vi': 'Tiếng Việt',
  });

  static void changeLocale(String langCode) {
    final locale = _getLocaleFromLanguage(langCode: langCode);
    Get.updateLocale(locale);
  }
  static Future loadLanguage({required String languageCode}) async {
    if(!_localizedValues.containsKey(languageCode)){
      // https://stackoverflow.com/questions/60079645/flutter-how-to-mock-a-call-to-rootbundle-loadstring-then-reset-the-mocked
      String jsonStringValues = await rootBundle.loadString(
          'assets/i18n/$languageCode.json',
          cache: false);

      Map<String, dynamic> mappedValues = json.decode(jsonStringValues);

      // converting `dynamic` value to `String`, because `_localizedValues` is of type Map<String,String>
      _localizedValues[languageCode] = mappedValues.map((key, value) => MapEntry(key, value.toString()));
    }
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': _localizedValues["en"] ?? {},
        'vi_VN': _localizedValues["vi"] ?? {},
      };

  static Locale _getLocaleFromLanguage({String? langCode}) {
    var lang = langCode ?? Get.locale?.languageCode ?? Get.deviceLocale!.languageCode;
    for (int i = 0; i < langCodes.length; i++) {
      if (lang == langCodes[i]) return locales[i];
    }
    return Get.locale!;
  }
}
