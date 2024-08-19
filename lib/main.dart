import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/theme_settings.dart';
import 'package:math_assessment/src/notifiers/theme_state_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app.dart';

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

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((value) => runApp(ProviderScope(overrides: [
            themeNotifierProvider
                .overrideWith((ref) => ThemeStateNotifier(initialSettings))
          ], child: const MyApp())));
}
