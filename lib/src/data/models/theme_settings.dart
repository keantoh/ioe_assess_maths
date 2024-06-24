import 'package:flutter/material.dart';

class ThemeSettings {
  final ThemeMode themeMode;
  final Color themeColor;
  final double fontScale;

  ThemeSettings({
    required this.themeMode,
    required this.themeColor,
    required this.fontScale,
  });

  ThemeSettings copyWith({
    ThemeMode? themeMode,
    Color? themeColor,
    double? fontScale,
  }) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      themeColor: themeColor ?? this.themeColor,
      fontScale: fontScale ?? this.fontScale,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.index,
      'themeColor': themeColor.value,
      'fontScale': fontScale,
    };
  }

  factory ThemeSettings.fromMap(Map<String, dynamic> map) {
    return ThemeSettings(
      themeMode: ThemeMode.values[map['themeMode']],
      themeColor: Color(map['themeColor']),
      fontScale: map['fontScale'],
    );
  }
}
