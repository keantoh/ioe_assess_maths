import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/models/question.dart';
import 'package:assess_math/src/notifiers/question_state_notifier.dart';
import 'package:assess_math/src/repositories/question_repository.dart';
import 'package:assess_math/src/services/question_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockQuestionRepository extends Mock implements QuestionRepository {}

class MockQuestionService extends Mock implements QuestionService {}

void main() {
  late MockQuestionRepository mockQuestionRepository;
  late MockQuestionService mockQuestionService;
  late ProviderContainer container;

  setUp(() {
    mockQuestionRepository = MockQuestionRepository();
    mockQuestionService = MockQuestionService();
    container = ProviderContainer(overrides: [
      questionRepositoryProvider.overrideWithValue(mockQuestionRepository),
      questionServiceProvider.overrideWithValue(mockQuestionService),
    ]);
  });

  tearDown(() {
    container.dispose();
  });

  group('QuestionStateNotifier', () {
    test('getQuestions sets isLoading to true and updates state with questions',
        () async {
      final questions = [
        SymbolicQuestion(27, 6, 0, [5, 4]),
        SymbolicQuestion(28, 6, 1, [3, 6]),
      ];

      when(() => mockQuestionRepository.getAllQuestions())
          .thenAnswer((_) async {
        when(() => mockQuestionRepository.questions).thenReturn(questions);
      });
      final notifier = container.read(questionStateProvider.notifier);

      await notifier.getQuestions();

      expect(container.read(questionStateProvider).isLoading, false);
      expect(
          container.read(questionStateProvider).questions, equals(questions));
      expect(container.read(questionStateProvider).currentQuestionIndex, 0);
      expect(container.read(questionStateProvider).playAudio, true);
    });

    test('addToSelectedOption adds a new option if not already selected', () {
      final notifier = container.read(questionStateProvider.notifier);

      notifier.addToSelectedOption(1);

      expect(container.read(questionStateProvider).selectedOptions, [1]);

      // Test adding another option
      notifier.addToSelectedOption(2);

      expect(container.read(questionStateProvider).selectedOptions, [1, 2]);

      // Test adding a duplicate option (should not add again)
      notifier.addToSelectedOption(1);

      expect(container.read(questionStateProvider).selectedOptions, [1, 2]);
    });

    test('clearSelectedOptions clears the selected options', () {
      final notifier = container.read(questionStateProvider.notifier);

      notifier.addToSelectedOption(1);
      notifier.addToSelectedOption(2);

      notifier.clearSelectedOptions();

      expect(container.read(questionStateProvider).selectedOptions, isEmpty);
    });

    test('nextQuestion advances the question index and handles encouragement',
        () async {
      final questions = [
        SymbolicQuestion(1, 6, 0, [5, 4]),
        SymbolicQuestion(2, 6, 1, [3, 6]),
        SymbolicQuestion(3, 6, 0, [5, 4]),
        SymbolicQuestion(4, 6, 1, [3, 6]),
        SymbolicQuestion(5, 6, 0, [5, 4]),
        SymbolicQuestion(6, 6, 1, [3, 6]),
        SymbolicQuestion(7, 6, 0, [5, 4]),
        SymbolicQuestion(8, 6, 1, [3, 6]),
        SymbolicQuestion(9, 6, 0, [5, 4]),
        SymbolicQuestion(10, 6, 1, [3, 6]),
        SymbolicQuestion(11, 6, 0, [5, 4]),
        SymbolicQuestion(12, 6, 1, [3, 6]),
      ];

      when(() => mockQuestionRepository.getAllQuestions())
          .thenAnswer((_) async {
        when(() => mockQuestionRepository.questions).thenReturn(questions);
      });

      final notifier = container.read(questionStateProvider.notifier);

      await notifier.getQuestions();

      final windowValue = notifier.getEncouragementWindow;

      for (int i = 0; i < windowValue - 1; i++) {
        notifier.nextQuestion();
      }

      expect(container.read(questionStateProvider).currentQuestionIndex, 9);
      expect(container.read(questionStateProvider).showEncouragement, false);

      notifier.nextQuestion();
      expect(container.read(questionStateProvider).showEncouragement, true);

      notifier.nextQuestion();
      expect(container.read(questionStateProvider).currentQuestionIndex, 10);
      expect(container.read(questionStateProvider).showEncouragement, false);
    });
  });
}
