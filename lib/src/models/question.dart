import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:math_assessment/src/models/dot_paint_option.dart';
import 'package:math_assessment/src/models/image_paint_option.dart';
import 'package:math_assessment/src/config.dart';

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
      case 2:
        return SymbolicQuestion(
          json['id'],
          json['category'],
          json['correct_option'],
          json['options'] as List<dynamic>,
        );
      case 3:
        return ClassificationQuestion(
          json['id'],
          json['category'],
          (json['options'] as List<dynamic>)
              .where((option) => option['isCorrect'] == true)
              .length,
          json['options'] as List<dynamic>,
        );
      case 4:
        return PatterningQuestion(
            json['id'],
            json['category'],
            json['correct_option'],
            json['options'] as List<dynamic>,
            json['matchingImage']);
      case 5:
        // SubitisingQuestion uses NonsymbolicQuestion
        return NonSymbolicQuestion(
          json['id'],
          json['category'],
          json['correct_option'],
          json['options'] as List<dynamic>,
        );
      case 6:
        // RecognitionQuestion uses SymbolicQuestion
        return SymbolicQuestion(
          json['id'],
          json['category'],
          json['correct_option'],
          json['options'] as List<dynamic>,
        );
      case 7:
        return MissingNoQuestion(
            json['id'],
            json['category'],
            json['correct_option'],
            json['options'] as List<dynamic>,
            json['equation']);
      case 8:
      case 9:
        return SingleDigitOpsQuestion(
            json['id'],
            json['category'],
            json['correct_option'],
            json['options'] as List<dynamic>,
            json['equation']);
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
      case 6:
      case 7:
      case 8:
      case 9:
      case 10:
        return AppLocalizations.of(context)!.question6;
      case 11:
        return AppLocalizations.of(context)!.question11;
      case 12:
        return AppLocalizations.of(context)!.question12;
      case 13:
        return AppLocalizations.of(context)!.question13;
      case 14:
        return AppLocalizations.of(context)!.question14;
      case 15:
        return AppLocalizations.of(context)!.question15;
      case 16:
        return AppLocalizations.of(context)!.question16;
      case 17:
        return AppLocalizations.of(context)!.question17;
      case 18:
        return AppLocalizations.of(context)!.question18;
      case 19:
        return AppLocalizations.of(context)!.question19;
      case 20:
        return AppLocalizations.of(context)!.question20;
      case 21:
        return AppLocalizations.of(context)!.question21;
      case 22:
        return AppLocalizations.of(context)!.question22;
      case 23:
        return AppLocalizations.of(context)!.question23;
      case 24:
        return AppLocalizations.of(context)!.question24;
      case 25:
        return AppLocalizations.of(context)!.question25;
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
      case 31:
        return AppLocalizations.of(context)!.question31;
      case 32:
      case 33:
      case 34:
      case 35:
        return AppLocalizations.of(context)!.question32;
      case 36:
        return AppLocalizations.of(context)!.question36;
      case 37:
        return AppLocalizations.of(context)!.question37;
      case 38:
        return AppLocalizations.of(context)!.question38;
      case 39:
        return AppLocalizations.of(context)!.question39;
      case 40:
        return AppLocalizations.of(context)!.question40;
      case 41:
        return AppLocalizations.of(context)!.question41;
      case 42:
        return AppLocalizations.of(context)!.question42;
      case 43:
        return AppLocalizations.of(context)!.question43;
      case 44:
        return AppLocalizations.of(context)!.question44;
      case 45:
        return AppLocalizations.of(context)!.question45;
      default:
        return AppLocalizations.of(context)!.question26;
    }
  }
}

class QuestionState {
  final List<Question> questions;
  final List<int> selectedOptions;
  final int currentQuestionIndex;
  final bool isLoading;
  final bool showEncouragement;
  final bool playAudio;

  QuestionState(
      {required this.questions,
      required this.selectedOptions,
      required this.currentQuestionIndex,
      required this.isLoading,
      required this.showEncouragement,
      required this.playAudio});

  QuestionState copyWith(
      {List<Question>? questions,
      List<int>? selectedOptions,
      int? currentQuestionIndex,
      bool? isLoading,
      bool? showEncouragement,
      bool? playAudio}) {
    return QuestionState(
        questions: questions ?? this.questions,
        selectedOptions: selectedOptions ?? this.selectedOptions,
        currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
        isLoading: isLoading ?? this.isLoading,
        showEncouragement: showEncouragement ?? this.showEncouragement,
        playAudio: playAudio ?? false);
  }
}

class NonSymbolicQuestion extends Question {
  List<List<DotPaintOption>> options = [];

  NonSymbolicQuestion(
      super.id, super.category, super.correctOption, List<dynamic> options) {
    if (options.length < 2) {
      throw const FormatException('At least two options must be provided');
    }
    parseOptions(options);
  }

  @override
  void parseOptions(List<dynamic> options) {
    this.options = options.map((optionList) {
      if (optionList is List<dynamic>) {
        return optionList.map((dot) {
          if (dot is Map<String, dynamic>) {
            return DotPaintOption.fromJson(dot);
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

class SymbolicQuestion extends Question {
  List<int> options = [];

  SymbolicQuestion(
      super.id, super.category, super.correctOption, List<dynamic> options) {
    if (options.length < 2) {
      throw const FormatException('At least two options must be provided');
    }
    parseOptions(options);
  }

  @override
  void parseOptions(List<dynamic> options) {
    this.options = options.map((option) {
      try {
        return int.parse(option.toString());
      } catch (e) {
        throw FormatException('Error parsing option: $option');
      }
    }).toList();
  }
}

class ClassificationQuestion extends Question {
  List<ImagePaintOption> options = [];

  ClassificationQuestion(
      super.id, super.category, super.correctOption, List<dynamic> options) {
    if (options.isEmpty) {
      throw const FormatException('At least one valid option must be provided');
    }
    parseOptions(options);
  }

  @override
  void parseOptions(List<dynamic> options) {
    this.options = options.map((option) {
      if (option is Map<String, dynamic>) {
        try {
          return ImagePaintOption.fromJson(option);
        } catch (e) {
          throw FormatException('Error parsing option: $option');
        }
      } else {
        throw const FormatException(
            'Invalid option format: expected Map<String, dynamic>');
      }
    }).toList();
  }
}

class PatterningQuestion extends Question {
  String? matchingImagePath;
  List<String> options = [];
  Map<String, String> imagePaths = {
    'finger_1': '${Config.imagePathPrefix}question_finger_1.png',
    'finger_2': '${Config.imagePathPrefix}question_finger_2.png',
    'finger_4': '${Config.imagePathPrefix}question_finger_4.png',
    'finger_5': '${Config.imagePathPrefix}question_finger_5.png',
    'cake_2l': '${Config.imagePathPrefix}question_cake_2l.png',
    'cake_2r': '${Config.imagePathPrefix}question_cake_2r.png',
    'cake_3': '${Config.imagePathPrefix}question_cake_3.png',
    'cake_4': '${Config.imagePathPrefix}question_cake_4.png',
    'ladybird_2': '${Config.imagePathPrefix}question_ladybird_2.png',
    'ladybird_4': '${Config.imagePathPrefix}question_ladybird_4.png',
    'ladybird_5': '${Config.imagePathPrefix}question_ladybird_5.png',
    'ladybird_6': '${Config.imagePathPrefix}question_ladybird_6.png',
    'dice_1': '${Config.imagePathPrefix}question_dice_1.png',
    'dice_3': '${Config.imagePathPrefix}question_dice_3.png',
    'dice_4': '${Config.imagePathPrefix}question_dice_4.png',
    'dice_5': '${Config.imagePathPrefix}question_dice_5.png',
    'candle_holder': '${Config.imagePathPrefix}question_candle_holder.png',
    'candle_1': '${Config.imagePathPrefix}question_candle_1.png',
    'candle_2': '${Config.imagePathPrefix}question_candle_2.png',
    'candle_3': '${Config.imagePathPrefix}question_candle_3.png',
    'candle_4': '${Config.imagePathPrefix}question_candle_4.png',
  };

  PatterningQuestion(super.id, super.category, super.correctOption,
      List<dynamic> options, String matchingImage) {
    if (options.length < 2) {
      throw const FormatException('At least two options must be provided');
    }
    matchingImagePath = imagePaths[matchingImage] ??
        (throw FormatException(
            'Error: No image path found for option: $matchingImage'));
    parseOptions(options);
  }

  @override
  void parseOptions(List<dynamic> options) {
    this.options = options.map((option) {
      String? imagePath = imagePaths[option];
      if (imagePath == null) {
        throw FormatException('Error: No image path found for option: $option');
      }
      return imagePath;
    }).toList();
  }
}

class MissingNoQuestion extends Question {
  String equation;
  List<int> options = [];

  MissingNoQuestion(super.id, super.category, super.correctOption,
      List<dynamic> options, this.equation) {
    if (options.length != 4) {
      throw const FormatException(
          'Exactly four valid options must be provided');
    }
    parseOptions(options);
  }

  @override
  void parseOptions(List<dynamic> options) {
    this.options = options.map((option) {
      try {
        return int.parse(option.toString());
      } catch (e) {
        throw FormatException('Error parsing option: $option');
      }
    }).toList();
  }
}

class SingleDigitOpsQuestion extends Question {
  String equation;
  List<int> options = [];

  SingleDigitOpsQuestion(super.id, super.category, super.correctOption,
      List<dynamic> options, this.equation) {
    if (options.length < 2) {
      throw const FormatException('At least two options must be provided');
    }
    parseOptions(options);
  }

  @override
  void parseOptions(List<dynamic> options) {
    this.options = options.map((option) {
      try {
        return int.parse(option.toString());
      } catch (e) {
        throw FormatException('Error parsing option: $option');
      }
    }).toList();
  }
}
