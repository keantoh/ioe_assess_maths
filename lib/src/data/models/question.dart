import 'package:flutter/material.dart';
import 'package:math_assessment/src/data/models/dot_paint.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class Question {
  final int id;
  final int category;
  final int correctOption;

  Question(this.id, this.category, this.correctOption);

  void parseOptions(List<dynamic> options);

  factory Question.fromJson(Map<String, dynamic> json) {
    switch (json['category']) {
      case 1:
        return NonSymbolicQuestion(
          json['id'],
          json['category'],
          json['correct_option'],
          json['options'] as List<dynamic>,
        );
      case 5:
        return SubitisingQuestion(
          json['id'],
          json['category'],
          json['correct_option'],
          json['options'] as List<dynamic>,
        );
      default:
        throw ArgumentError('Unknown category: ${json['category']}');
    }
  }

  String getQuestionInstruction(BuildContext context) {
    switch (id) {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        return AppLocalizations.of(context)!.question1;
      case 26:
        return AppLocalizations.of(context)!.question26;
      case 27:
        return AppLocalizations.of(context)!.question27;
      case 28:
        return AppLocalizations.of(context)!.question28;
      case 29:
        return AppLocalizations.of(context)!.question29;
      case 30:
        return AppLocalizations.of(context)!.question30;
      default:
        return AppLocalizations.of(context)!.question26;
    }
  }
}

class NonSymbolicQuestion extends Question {
  List<List<DotPaint>> options = [];

  NonSymbolicQuestion(
      super.id, super.category, super.correctOption, List<dynamic> options) {
    parseOptions(options);
  }

  @override
  void parseOptions(List<dynamic> options) {
    this.options = options.map((optionList) {
      if (optionList is List<dynamic>) {
        return optionList.map((dot) {
          if (dot is Map<String, dynamic>) {
            return DotPaint.fromJson(dot);
          } else {
            throw const FormatException('Invalid dot format');
          }
        }).toList();
      } else {
        throw const FormatException('Invalid option list format');
      }
    }).toList();
  }
}

class SubitisingQuestion extends Question {
  List<List<DotPaint>> options = [];

  SubitisingQuestion(
      super.id, super.category, super.correctOption, List<dynamic> options) {
    parseOptions(options);
  }

  @override
  void parseOptions(List<dynamic> options) {
    this.options = options.map((optionList) {
      if (optionList is List<dynamic>) {
        return optionList.map((dot) {
          if (dot is Map<String, dynamic>) {
            return DotPaint.fromJson(dot);
          } else {
            throw const FormatException('Invalid dot format');
          }
        }).toList();
      } else {
        throw const FormatException('Invalid option list format');
      }
    }).toList();
  }
}
