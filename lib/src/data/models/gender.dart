import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Gender {
  male,
  female,
  other;

  String getGenderName(BuildContext context) {
    switch (this) {
      case Gender.male:
        return AppLocalizations.of(context)!.male;
      case Gender.female:
        return AppLocalizations.of(context)!.female;
      default:
        return AppLocalizations.of(context)!.other;
    }
  }
}
