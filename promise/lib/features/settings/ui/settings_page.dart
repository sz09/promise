import 'package:flutter/material.dart';
import 'package:promise/features/page.deletegate.dart';
import 'package:promise/features/settings/ui/settings_view.dart';
import 'package:promise/util/localize.ext.dart';

class SettingsPage extends Page {
  const SettingsPage({super.key});

  @override
  Route createRoute(BuildContext context) {
    return onCreateRoute(
      settings: this,
      builder: (context) => 
        Scaffold(
          appBar: AppBar(
            title: Text(context.translate('settings')),
          ),
          body: const Center(
            child: SettingsView(),
          )
        )
    );
  }
}


class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(context.translate('settings')),
      ),
      body: const Center(
        child: SettingsView(),
      )
    );
  }
}
