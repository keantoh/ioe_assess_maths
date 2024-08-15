import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/question.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/widgets/classification_options_widget.dart';
import 'package:math_assessment/src/widgets/missing_no_options_widget.dart';
import 'package:math_assessment/src/widgets/non_symbolic_options_widget.dart';
import 'package:math_assessment/src/widgets/single_digit_ops_options_widget.dart';
import 'package:math_assessment/src/widgets/subitising_options_widget.dart';
import 'package:math_assessment/src/widgets/symbolic_options_widget.dart';

final showResultsProvider = StateProvider<bool>(
  (ref) => false,
);

final completedQuestionsProvider = StateProvider<int>(
  (ref) => 0,
);

class QuestionView extends ConsumerStatefulWidget {
  const QuestionView({super.key});
  static const routeName = '/question';

  @override
  QuestionViewState createState() => QuestionViewState();
}

final questionListProvider = FutureProvider<List<Question>>((ref) async {
  final jsonString = await rootBundle.loadString('assets/question_data.json');
  final jsonData = json.decode(jsonString);

  List<Question> questions = (jsonData['questions'] as List)
      .map((item) => Question.fromJson(item))
      .toList();

  return questions;
});

class QuestionViewState extends ConsumerState<QuestionView> {
  final AudioPlayer audioPlayer = AudioPlayer();
  late final DateTime sessionStartTime;

  Future<void> _playAudio(String localeName, int id) async {
    await audioPlayer.stop();
    if (id >= 1 && id <= 5) {
      id = 1;
    } else if (id >= 6 && id <= 10) {
      id = 6;
    } else if (id >= 32 && id <= 35) {
      id = 32;
    }
    final audioPath = 'audios/$localeName/$id.mp3';
    await audioPlayer.play(AssetSource(audioPath));
  }

  @override
  void initState() {
    super.initState();
    sessionStartTime = DateTime.now().toUtc();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsyncValue = ref.watch(questionListProvider);
    final currentQuestionIndex = ref.watch(currentQuestionIndexProvider);
    final completedQuestions = ref.read(completedQuestionsProvider);
    final showResults = ref.watch(showResultsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              final double height = constraints.maxHeight;

              return questionsAsyncValue.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                      child: Text(
                          AppLocalizations.of(context)!.errorLoadingQuestions)),
                  data: (questions) {
                    if (questions.isEmpty) {
                      return Center(
                          child: Text(AppLocalizations.of(context)!
                              .errorLoadingQuestions));
                    } else {
                      final currentQuestion = questions[currentQuestionIndex];
                      if (!showResults) {
                        _playAudio(AppLocalizations.of(context)!.localeName,
                            currentQuestion.id);
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  minHeight: 12,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer,
                                  value: completedQuestions / questions.length,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.close,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                iconSize: 32,
                              ),
                            ],
                          ),
                          showResults
                              ? const SizedBox.shrink()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _playAudio(
                                            AppLocalizations.of(context)!
                                                .localeName,
                                            currentQuestion.id);
                                      },
                                      icon: Icon(Icons.volume_up,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                      iconSize: 32,
                                    ),
                                    Flexible(
                                      child: Text(
                                        currentQuestion
                                            .getQuestionInstruction(context),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                          showResults
                              ? Expanded(
                                  child: encouragementScreen(
                                      currentQuestionIndex,
                                      questions.length - 1,
                                      completedQuestions),
                                )
                              : Expanded(
                                  child: buildQuestionOptions(
                                      currentQuestion,
                                      questions.length,
                                      width,
                                      height,
                                      sessionStartTime)),
                          progressStars(width, questions.length)
                        ],
                      );
                    }
                  });
            },
          ),
        ),
      ),
    );
  }

  Widget progressStars(width, totalQuestions) {
    final double sectionWidth = width / totalQuestions;
    final double starSize = min(sectionWidth, 16);
    final numStars = ref.read(completedQuestionsProvider);
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: List.generate(totalQuestions, (index) {
          bool isCompleted = index < numStars;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            width: sectionWidth,
            alignment: Alignment.center,
            child: isCompleted
                ? Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: starSize,
                    shadows: <Shadow>[
                      Shadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 4.0)
                    ],
                  )
                : Container(height: 12),
          );
        }),
      ),
    );
  }

  Widget encouragementScreen(
      int currentQuestionIndex, int lastQuestionIndex, int completedQuestions) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textAlign: TextAlign.center,
          AppLocalizations.of(context)!
              .encouragementTitle(ref.read(selectedChildProvider)?.name ?? ''),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            textAlign: TextAlign.center,
            currentQuestionIndex == lastQuestionIndex
                ? AppLocalizations.of(context)!
                    .completionMessage(completedQuestions)
                : AppLocalizations.of(context)!
                    .encouragementMessage(completedQuestions),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        currentQuestionIndex == lastQuestionIndex
            ? FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: FilledButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    AppLocalizations.of(context)!.ok,
                  ),
                ))
            : FilledButton(
                onPressed: () {
                  ref.read(showResultsProvider.notifier).state = false;
                  ref.read(currentQuestionIndexProvider.notifier).state += 1;
                },
                style: FilledButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    AppLocalizations.of(context)!.keepGoing,
                  ),
                ))
      ],
    );
  }

  Widget buildQuestionOptions(Question currentQuestion, int totalQuestions,
      double screenWidth, double screenHeight, DateTime sessionStartTime) {
    if (currentQuestion is NonSymbolicQuestion) {
      return NonSymbolicOptionsWidget(
          currentQuestion, totalQuestions, sessionStartTime);
    } else if (currentQuestion is SymbolicQuestion) {
      return SymbolicOptionsWidget(
          currentQuestion, totalQuestions, sessionStartTime);
    } else if (currentQuestion is ClassificationQuestion) {
      return ClassificationOptionsWidget(currentQuestion, totalQuestions,
          screenWidth, screenHeight, sessionStartTime);
    } else if (currentQuestion is SubitisingQuestion) {
      return SubitisingOptionsWidget(
          currentQuestion, totalQuestions, sessionStartTime);
    } else if (currentQuestion is MissingNoQuestion) {
      return MissingNoOptionsWidget(
          currentQuestion, totalQuestions, sessionStartTime);
    } else if (currentQuestion is SingleDigitOpsQuestion) {
      return SingleDigitsOpsOptionsWidget(
          currentQuestion, totalQuestions, sessionStartTime);
    }
    // Add more cases for other question types here
    return Center(
        child: Text(AppLocalizations.of(context)!.unknownQuestionType));
  }
}
