import 'package:flutter/material.dart';
import 'package:promise/features/settings/ui/settings_view.dart';
import 'package:promise/util/localize.ext.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.translate('settings')),
        ),
        body: const Center(
          child: SettingsView(),
        ))
        ;
  }
}
