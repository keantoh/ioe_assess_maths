import 'package:assess_math/src/models/question.dart';
import 'package:test/test.dart';

void main() {
  group('Question class', () {
    test('should create NonSymbolicQuestion for category 1', () {
      final json = {
        "id": 1,
        "category": 1,
        "options": [
          [
            {"x": 0.4, "y": 0.5, "radius": 0.08}
          ],
          [
            {"x": 0.2, "y": 0.3, "radius": 0.05}
          ]
        ],
        "correct_option": 1
      };

      final question = Question.fromJson(json);
      expect(question, isA<NonSymbolicQuestion>());
    });

    test('should create SymbolicQuestion for category 2', () {
      final json = {
        "id": 10,
        "category": 2,
        "options": [9, 8],
        "correct_option": 0
      };

      final question = Question.fromJson(json);
      expect(question, isA<SymbolicQuestion>());
    });

    test('should throw ArgumentError for unknown category', () {
      final json = {
        'id': 3,
        'category': 99,
        'correct_option': 1,
        'options': []
      };

      expect(() => Question.fromJson(json), throwsArgumentError);
    });
  });
  // CAT 1: NONSYMBOLIC

  group('NonSymbolic Subclass', () {
    test('should parse options correctly', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'category': 1,
        'correct_option': 2,
        "options": [
          [
            {"x": 0.4, "y": 0.5, "radius": 0.08}
          ],
          [
            {"x": 0.2, "y": 0.3, "radius": 0.05}
          ]
        ],
      };

      final question = NonSymbolicQuestion(
        json['id'],
        json['category'],
        json['correct_option'],
        json['options'] as List<dynamic>,
      );

      expect(question.options.length, 2);
      expect(question.options[0][0].x, 0.4);
      expect(question.options[0][0].radius, 0.08);
    });

    test('should throw FormatException for invalid options', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'category': 1,
        'correct_option': 2,
        'options': [
          [
            {"x": 0.4, "y": 0.5, "radius": 0.08}
          ],
          ['null']
        ]
      };

      expect(
        () => NonSymbolicQuestion(
          json['id'],
          json['category'],
          json['correct_option'],
          json['options'] as List<dynamic>,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test(
        'should throw FormatException when fewer than two options are provided',
        () {
      final Map<String, dynamic> json = {
        'id': 1,
        'category': 1,
        'correct_option': 2,
        'options': [
          [
            {"x": 0.4, "y": 0.5, "radius": 0.08}
          ],
        ]
      };

      expect(
        () => NonSymbolicQuestion(
          json['id'],
          json['category'],
          json['correct_option'],
          json['options'] as List<dynamic>,
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });

  // CAT 2: SYMBOLIC
  group('Symbolic Subclass', () {
    test('should parse options correctly', () {
      final Map<String, dynamic> json = {
        "id": 6,
        "category": 2,
        "options": [1, 2],
        "correct_option": 1
      };

      final question = SymbolicQuestion(
        json['id'],
        json['category'],
        json['correct_option'],
        json['options'] as List<dynamic>,
      );

      expect(question.options.length, 2);
      expect(question.options[0], 1);
      expect(question.options[1], 2);
    });

    test('should throw FormatException for invalid options', () {
      final Map<String, dynamic> json = {
        "id": 6,
        "category": 2,
        "options": [1, '2'],
        "correct_option": 1
      };

      expect(
        () => NonSymbolicQuestion(
          json['id'],
          json['category'],
          json['correct_option'],
          json['options'] as List<dynamic>,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test(
        'should throw FormatException when fewer than two options are provided',
        () {
      final Map<String, dynamic> json = {
        'id': 1,
        'category': 1,
        'correct_option': 2,
        "options": [1],
      };

      expect(
        () => NonSymbolicQuestion(
          json['id'],
          json['category'],
          json['correct_option'],
          json['options'] as List<dynamic>,
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });

  // CAT 3: CLASSIFICATION
  group('Classification Subclass', () {
    test('should parse options correctly', () {
      final Map<String, dynamic> json = {
        "id": 11,
        "category": 3,
        "options": [
          {
            "x": 0.1,
            "y": 0.1,
            "height": 0.3,
            "image": "fish",
            "isCorrect": true
          },
          {
            "x": 0.6,
            "y": 0.1,
            "height": 0.3,
            "image": "dog",
            "isCorrect": false
          }
        ]
      };

      final question = ClassificationQuestion(
        json['id'],
        json['category'],
        (json['options'] as List<dynamic>)
            .where((option) => option['isCorrect'] == true)
            .length,
        json['options'] as List<dynamic>,
      );

      expect(question.options.length, 2);
      expect(question.options[0].x, 0.1);
      expect(question.options[1].y, 0.1);
    });

    test('should throw FormatException for invalid options', () {
      final Map<String, dynamic> json = {
        "id": 11,
        "category": 3,
        "options": [
          {
            "x": 0.1,
            "y": 0.1,
            "height": 0.3,
            "image": "fish",
            "isCorrect": true
          },
          {"x": 0.6, "y": 0.1, "isCorrect": false}
        ]
      };

      expect(
        () => ClassificationQuestion(
          json['id'],
          json['category'],
          (json['options'] as List<dynamic>)
              .where((option) => option['isCorrect'] == true)
              .length,
          json['options'] as List<dynamic>,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw FormatException for invalid option image', () {
      final Map<String, dynamic> json = {
        "id": 11,
        "category": 3,
        "options": [
          {
            "x": 0.1,
            "y": 0.1,
            "height": 0.3,
            "image": "fish",
            "isCorrect": true
          },
          {
            "x": 0.1,
            "y": 0.1,
            "height": 0.3,
            "image": "tyrannosaurus",
            "isCorrect": true
          },
        ]
      };

      expect(
        () => ClassificationQuestion(
          json['id'],
          json['category'],
          (json['options'] as List<dynamic>)
              .where((option) => option['isCorrect'] == true)
              .length,
          json['options'] as List<dynamic>,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw FormatException when no options are provided', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'category': 1,
        'correct_option': 2,
        "options": []
      };

      expect(
        () => ClassificationQuestion(
          json['id'],
          json['category'],
          (json['options'] as List<dynamic>)
              .where((option) => option['isCorrect'] == true)
              .length,
          json['options'] as List<dynamic>,
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });

  // CAT 4: PATTERNING
  group('Patterning Subclass', () {
    test('should parse options correctly', () {
      final Map<String, dynamic> json = {
        "id": 16,
        "category": 4,
        "matchingImage": "finger_2",
        "options": ["finger_4", "finger_5", "finger_1", "finger_2"],
        "correct_option": 3
      };

      final question = PatterningQuestion(
          json['id'],
          json['category'],
          json['correct_option'],
          json['options'] as List<dynamic>,
          json['matchingImage']);

      expect(question.options.length, 4);
      expect(question.options[0], "assets/images/question_finger_4.png");
      expect(question.options[1], "assets/images/question_finger_5.png");
    });

    test('should throw FormatException for invalid option image', () {
      final Map<String, dynamic> json = {
        "id": 16,
        "category": 4,
        "matchingImage": "finger_2",
        "options": ["finger_100", "finger_5", "finger_1", "finger_2"],
        "correct_option": 3
      };

      expect(
        () => PatterningQuestion(
            json['id'],
            json['category'],
            json['correct_option'],
            json['options'] as List<dynamic>,
            json['matchingImage']),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw FormatException when no options are provided', () {
      final Map<String, dynamic> json = {
        "id": 16,
        "category": 4,
        "matchingImage": "finger_2",
        "options": [],
        "correct_option": 3
      };

      expect(
        () => PatterningQuestion(
            json['id'],
            json['category'],
            json['correct_option'],
            json['options'] as List<dynamic>,
            json['matchingImage']),
        throwsA(isA<FormatException>()),
      );
    });
  });

  // CAT 5: SUBITISING uses NONSYMBOLIC
  // CAT 6: RECOGNITION uses SYMBOLIC
  // CAT 7: MISSINGNO
  group('MissingNo Subclass', () {
    test('should parse options correctly', () {
      final Map<String, dynamic> json = {
        "id": 32,
        "category": 7,
        "equation": "1 2 _ 4",
        "options": [4, 3, 7, 6],
        "correct_option": 1
      };

      final question = MissingNoQuestion(
          json['id'],
          json['category'],
          json['correct_option'],
          json['options'] as List<dynamic>,
          json['equation']);

      expect(question.options.length, 4);
      expect(question.options[0], 4);
      expect(question.options[2], 7);
    });

    test('should throw FormatException for invalid options', () {
      final Map<String, dynamic> json = {
        "id": 32,
        "category": 7,
        "equation": "1 2 _ 4",
        "options": [4, 3, 7, 'abc'],
        "correct_option": 1
      };

      expect(
        () => MissingNoQuestion(
            json['id'],
            json['category'],
            json['correct_option'],
            json['options'] as List<dynamic>,
            json['equation']),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw FormatException when options provided not equal to 4',
        () {
      final Map<String, dynamic> json = {
        "id": 32,
        "category": 7,
        "equation": "1 2 _ 4",
        "options": [],
        "correct_option": 1
      };

      expect(
        () => MissingNoQuestion(
            json['id'],
            json['category'],
            json['correct_option'],
            json['options'] as List<dynamic>,
            json['equation']),
        throwsA(isA<FormatException>()),
      );
    });
  });
  // CAT 8 & 9: SINGLEDIGITOPS
  group('SingleDigitOps Subclass', () {
    test('should parse options correctly', () {
      final Map<String, dynamic> json = {
        "id": 45,
        "category": 9,
        "equation": "7 - 3 =",
        "options": [4, 5],
        "correct_option": 0
      };

      final question = SingleDigitOpsQuestion(
          json['id'],
          json['category'],
          json['correct_option'],
          json['options'] as List<dynamic>,
          json['equation']);

      expect(question.options.length, 2);
      expect(question.options[0], 4);
      expect(question.options[1], 5);
    });

    test('should throw FormatException for invalid options', () {
      final Map<String, dynamic> json = {
        "id": 45,
        "category": 9,
        "equation": "7 - 3 =",
        "options": [4, 'abcd'],
        "correct_option": 0
      };

      expect(
        () => SingleDigitOpsQuestion(
            json['id'],
            json['category'],
            json['correct_option'],
            json['options'] as List<dynamic>,
            json['equation']),
        throwsA(isA<FormatException>()),
      );
    });

    test(
        'should throw FormatException when fewer than two options are provided',
        () {
      final Map<String, dynamic> json = {
        "id": 32,
        "category": 7,
        "equation": "1 2 _ 4",
        "options": [],
        "correct_option": 1
      };

      expect(
        () => SingleDigitOpsQuestion(
            json['id'],
            json['category'],
            json['correct_option'],
            json['options'] as List<dynamic>,
            json['equation']),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
