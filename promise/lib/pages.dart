import 'package:promise/const/text.dart';
import 'package:promise/settings.dart';
import 'package:flutter/material.dart';
import 'package:promise/util/localize.ext.dart';

const tourPageKey = Key("tour_page");
const settingsPageKey = Key("settings_page");
const dynamicMenuPageKey = Key("dynamic_menu_page");

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: settingsPageKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.translate("settings_page.title"),
              style: const TextStyle(fontSize: textFontSize),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.translate("settings_page.description"),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: textFontSize, color: Colors.black87),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicMenuPage extends StatelessWidget {
  final MenuItemInfo menuItem;

  const DynamicMenuPage({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: dynamicMenuPageKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              menuItem.title,
              style: const TextStyle(fontSize: textFontSize),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
