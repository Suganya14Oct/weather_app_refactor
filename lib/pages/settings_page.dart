
import 'package:flutter/material.dart';
import 'package:open_weather_provider_refactor/provider/temp_settings/temp_settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Text('Temperature Unit'),
          subtitle: Text('Celsius/Fahrenheit (Default: celsius)'),
          trailing: Switch(
              value: context.watch<TempSettingProvider>().state.tempUnit == TempUnit.celsius,
              onChanged: (_) {
                context.read<TempSettingProvider>().toggleTempUnit();
              }),
        ),
      )
    );
  }
}

