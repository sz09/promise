import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:promise/const/text.dart';
import 'package:promise/pre_app_config.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';

class SettingsThemeSwitch extends StatefulWidget {
  const SettingsThemeSwitch({super.key});

  @override
  _SettingsThemeSwitchState createState() => _SettingsThemeSwitchState();
}

class _SettingsThemeSwitchState extends State<SettingsThemeSwitch> {
  bool isDarkTheme = Get.isDarkMode;
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: InkWell(
        onTap: () async => await toggleBrightness(context, !isDarkTheme),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(
                Icons.palette_outlined,
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                context.translate('dark_theme'),
                style: const TextStyle(fontSize: textFontSize),
              ),
            ),
            Switch.adaptive(
              activeColor: context.textColor,
              value: isDarkTheme,
              onChanged: (val) async => await toggleBrightness(context, val),
            ),
          ],
        ),
      ),
    );
  }

  Future toggleBrightness(BuildContext context, bool val) async {
    setState(() {
      isDarkTheme = val;
    });

    Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
    await storage.write(themeModeKey, val);
  }
}
