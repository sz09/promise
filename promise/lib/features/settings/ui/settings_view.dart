import 'package:flutter/material.dart';
import 'package:promise/features/settings/preferences_helper.dart';
import 'package:promise/features/settings/ui/widget/settings_language_widget.dart';
import 'package:promise/features/settings/ui/widget/settings_theme_switch_widget.dart';

import 'package:promise/di/service_locator.dart';
import 'package:promise/util/localize.ext.dart';
import 'widget/settings_header_widget.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsHeader(header: context.translate('theme')),
        const SettingsThemeSwitch(),
        Container(color: Colors.grey, height: 1),
        SettingsHeader(header: context.translate('language')),
        SettingsLanguageWidget(
            selectedLanguage:
                serviceLocator.get<PreferencesHelper>().languagePreferred)
      ],
    );
  }
}
