import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/theme_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeSettings>(
  (ref) {
    return ThemeNotifier(ThemeSettings(
      themeMode: ThemeMode.system,
      themeColor: Colors.blue,
      fontScale: 1.0,
    ));
  },
);

class ThemeNotifier extends StateNotifier<ThemeSettings> {
  ThemeNotifier(super.state);

  static const String _themeModeKey = 'themeMode';
  static const String _themeColorKey = 'themeColor';
  static const String _fontScaleKey = 'fontScale';

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_themeModeKey, state.themeMode.index);
    await prefs.setInt(_themeColorKey, state.themeColor.value);
    await prefs.setDouble(_fontScaleKey, state.fontScale);
  }

  void updateThemeMode(ThemeMode? newThemeMode) {
    if (newThemeMode != null) {
      state = state.copyWith(themeMode: newThemeMode);
      _saveSettings();
    }
  }

  void updateThemeColor(Color newThemeColor) {
    state = state.copyWith(themeColor: newThemeColor);
    // _saveSettings();
  }

  void updateFontScale(double? newFontScale) {
    if (newFontScale != null) {
      state = state.copyWith(fontScale: newFontScale);
      _saveSettings();
    }
  }
}
