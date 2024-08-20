import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/question.dart';
import 'package:math_assessment/src/models/result.dart';
import 'package:math_assessment/src/repositories/question_repository.dart';
import 'package:math_assessment/src/services/question_service.dart';
import 'package:math_assessment/src/utils/helper_functions.dart';

class QuestionStateNotifier extends StateNotifier<QuestionState> {
  final QuestionRepository _questionRepository;
  final QuestionService _questionService;
  final Ref ref;
  final encouragementWindow = 10;
  int? _responseCode;

  QuestionStateNotifier(
      this._questionRepository, this._questionService, this.ref)
      : super(QuestionState(
            questions: [],
            selectedOptions: [],
            currentQuestionIndex: -1,
            isLoading: false,
            showEncouragement: false,
            playAudio: false));

  int? get responseCode => _responseCode;

  Future<void> getQuestions() async {
    state = state.copyWith(isLoading: true);
    await _questionRepository.getAllQuestions();
    state = state.copyWith(
        isLoading: false,
        questions: _questionRepository.questions,
        currentQuestionIndex: 0,
        playAudio: true);
  }

  void addToSelectedOption(int option) {
    if (!state.selectedOptions.contains(option)) {
      final List<int> updatedSelectedOptions = List.from(state.selectedOptions)
        ..add(option);
      state = state.copyWith(selectedOptions: updatedSelectedOptions);
    }
  }

  void clearSelectedOptions() {
    state = state.copyWith(selectedOptions: []);
  }

  Future<void> addResult(BuildContext context, ResultCreate newResult) async {
    final result = await _questionService.addResultService(newResult);
    final responseCode = result['status'];

    if (context.mounted) {
      switch (responseCode) {
        case 201:
          ref.read(questionStateProvider.notifier).nextQuestion();
          break;
        case 400:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error400);
          break;
        case 408:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error408);
          break;
        case 503:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error503);
          break;
        default:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error500);
          break;
      }
    }

    ref.read(questionResponseCodeProvider.notifier).state = responseCode;
  }

  void nextQuestion() {
    if (state.showEncouragement) {
      state = state.copyWith(
          currentQuestionIndex: state.currentQuestionIndex + 1,
          selectedOptions: [],
          showEncouragement: false,
          playAudio: true);
    } else if ((state.currentQuestionIndex + 1) % encouragementWindow == 0 ||
        state.currentQuestionIndex == state.questions.length - 1) {
      state = state.copyWith(showEncouragement: true);
    } else {
      state = state.copyWith(
          currentQuestionIndex: state.currentQuestionIndex + 1,
          selectedOptions: [],
          playAudio: true);
    }
  }

  void resetQuestionIndex() {
    state = state.copyWith(
        currentQuestionIndex: 0, selectedOptions: [], showEncouragement: false);
  }
}

final questionStateProvider =
    StateNotifierProvider<QuestionStateNotifier, QuestionState>((ref) {
  final questionRepository = ref.watch(questionRepositoryProvider);
  final questionService = ref.watch(questionServiceProvider);
  return QuestionStateNotifier(questionRepository, questionService, ref);
});

final questionResponseCodeProvider = StateProvider<int?>(
    (ref) => ref.watch(questionStateProvider.notifier).responseCode);
