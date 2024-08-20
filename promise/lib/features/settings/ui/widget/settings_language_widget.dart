import 'package:flutter/material.dart';
import 'package:promise/const/text.dart';
import 'package:promise/resources/localization/l10n.dart';
import 'package:promise/resources/localization/localization_notifier.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:provider/provider.dart';

import 'settings_language_icon_widget.dart';

class SettingsLanguageWidget extends StatefulWidget {
  final String selectedLanguage;

  const SettingsLanguageWidget({super.key, required this.selectedLanguage});

  @override
  _SettingsLanguageWidgetState createState() => _SettingsLanguageWidgetState();
}

class _SettingsLanguageWidgetState extends State<SettingsLanguageWidget>
    with WidgetsBindingObserver {
  late String selectedLanguage;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this); // Subscribe to changes
    super.initState();
    selectedLanguage = widget.selectedLanguage;
  }

  @override
  void didChangeLocales(List<Locale>? locales) async {
    await setUpSelectedLanguage(context, WidgetsBinding.instance.platformDispatcher.locales.first.languageCode);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
          child: InkWell(
            onTap: () => setUpSelectedLanguage(context, EN.languageCode),
            child: IgnorePointer(
              child: Row(
                children: [
                  SettingsLanguageIcon(languageCode: EN.languageCode),
                  Expanded(
                    child: Text(
                      context.translate('language.english'),
                      style: const TextStyle(fontSize: textFontSize),
                    ),
                  ),
                  Radio<String>(
                    activeColor: context.textColor,
                    value: EN.languageCode,
                    groupValue: selectedLanguage,
                    onChanged: (value) =>
                        setState(() => selectedLanguage = value!),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
          child: InkWell(
            onTap: () => setUpSelectedLanguage(context, VN.languageCode),
            child: IgnorePointer(
              child: Row(
                children: [
                  SettingsLanguageIcon(languageCode: VN.languageCode),
                  Expanded(
                    child: Text(
                      context.translate('language.vietnamese'),
                      style: const TextStyle(fontSize: textFontSize),
                    ),
                  ),
                  Radio<String>(
                    activeColor: context.textColor,
                    value: VN.languageCode,
                    groupValue: selectedLanguage,
                    onChanged: (value) =>
                        setState(() => selectedLanguage = value!),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future setUpSelectedLanguage(BuildContext context, String? currentLanguage) async {
    currentLanguage ??= EN.languageCode;

    setState(() {
      selectedLanguage = currentLanguage!;
    });

    final localizationNotifier =
        Provider.of<LocalizationNotifier>(context, listen: false);
    await localizationNotifier.setLocale(currentLanguage);
  }
}
