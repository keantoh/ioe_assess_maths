import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ColorSeed {
  blue(1, Colors.blue),
  teal(2, Colors.teal),
  green(3, Colors.green),
  red(4, Colors.red),
  pink(5, Colors.pink),
  purple(6, Colors.deepPurple);

  final int id;
  final Color color;

  const ColorSeed(this.id, this.color);

  static ColorSeed fromId(int id) {
    return ColorSeed.values
        .firstWhere((colorSeed) => colorSeed.id == id, orElse: () => blue);
  }

  String getColorName(BuildContext context) {
    switch (this) {
      case ColorSeed.blue:
        return AppLocalizations.of(context)!.color_blue;
      case ColorSeed.teal:
        return AppLocalizations.of(context)!.color_teal;
      case ColorSeed.green:
        return AppLocalizations.of(context)!.color_green;
      case ColorSeed.red:
        return AppLocalizations.of(context)!.color_red;
      case ColorSeed.pink:
        return AppLocalizations.of(context)!.color_pink;
      default:
        return AppLocalizations.of(context)!.color_purple;
    }
  }
}
