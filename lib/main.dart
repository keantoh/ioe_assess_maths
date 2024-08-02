import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/theme_settings.dart';
import 'package:math_assessment/src/notifiers/theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // debugPaintSizeEnabled = true; // Enable debug paint size
  WidgetsFlutterBinding.ensureInitialized();

  final initialSettings = await SharedPreferences.getInstance().then((prefs) {
    final themeModeIndex = prefs.getInt('themeMode') ?? ThemeMode.system.index;
    final themeColorValue = prefs.getInt('themeColor') ?? Colors.blue.value;
    final fontScale = prefs.getDouble('fontScale') ?? 1.0;

    return ThemeSettings(
      themeMode: ThemeMode.values[themeModeIndex],
      themeColor: Color(themeColorValue),
      fontScale: fontScale,
    );
  });

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((value) => runApp(ProviderScope(overrides: [
            themeNotifierProvider
                .overrideWith((ref) => ThemeNotifier(initialSettings))
          ], child: const MyApp())));
}
