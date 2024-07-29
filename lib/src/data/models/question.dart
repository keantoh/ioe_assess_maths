import 'package:flutter/material.dart';
import 'package:math_assessment/src/data/models/dot_paint.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class Question {
  final int id;
  final int category;
  final int correctOption;

  Question(this.id, this.category, this.correctOption);

  // Abstract method for parsing options
  void parseOptions(List<dynamic> options);

  // Factory method to create questions based on category
  factory Question.fromJson(Map<String, dynamic> json) {
    switch (json['category']) {
      case 1:
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
        return AppLocalizations.of(context)!.question1;
      case 2:
        return AppLocalizations.of(context)!.question2;
      default:
        return AppLocalizations.of(context)!.question1;
    }
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

  // Method to display question or handle specific logic
  void displayQuestion() {
    // Custom display logic for multiple choice questions
  }
}
