import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/question.dart';
import 'package:math_assessment/src/notifiers/children_state_notifier.dart';
import 'package:math_assessment/src/notifiers/question_state_notifier.dart';
import 'package:math_assessment/src/widgets/classification_options_widget.dart';
import 'package:math_assessment/src/widgets/missing_no_options_widget.dart';
import 'package:math_assessment/src/widgets/non_symbolic_options_widget.dart';
import 'package:math_assessment/src/widgets/single_digit_ops_options_widget.dart';
import 'package:math_assessment/src/widgets/subitising_options_widget.dart';
import 'package:math_assessment/src/widgets/symbolic_options_widget.dart';

class QuestionView extends ConsumerStatefulWidget {
  const QuestionView({super.key});
  static const routeName = '/question';

  @override
  QuestionViewState createState() => QuestionViewState();
}

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(questionStateProvider.notifier).getQuestions();
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionState = ref.watch(questionStateProvider);
    final completedQuestions = questionState.currentQuestionIndex +
        (questionState.showEncouragement ? 1 : 0);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final double height = constraints.maxHeight;

                return questionState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : questionState.questions.isEmpty
                        ? Center(
                            child: Text(AppLocalizations.of(context)!
                                .errorLoadingQuestions))
                        : Consumer(builder: (context, ref, _) {
                            final currentQuestion = questionState
                                .questions[questionState.currentQuestionIndex];
                            final totalQuestions =
                                questionState.questions.length;
                            if (questionState.playAudio) {
                              _playAudio(
                                  AppLocalizations.of(context)!.localeName,
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
                                        value: completedQuestions /
                                            questionState.questions.length,
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
                                questionState.showEncouragement
                                    ? const SizedBox.shrink()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                currentQuestion
                                                    .getQuestionInstruction(
                                                        context),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                questionState.showEncouragement
                                    ? Expanded(
                                        child: encouragementScreen(
                                            questionState.currentQuestionIndex,
                                            totalQuestions - 1,
                                            completedQuestions),
                                      )
                                    : Expanded(
                                        child: buildQuestionOptions(
                                            currentQuestion,
                                            totalQuestions,
                                            width,
                                            height,
                                            sessionStartTime)),
                                progressStars(
                                    width, completedQuestions, totalQuestions)
                              ],
                            );
                          });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget progressStars(width, numStars, totalQuestions) {
    final double sectionWidth = width / totalQuestions;
    final double starSize = min(sectionWidth, 16);
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              textAlign: TextAlign.center,
              AppLocalizations.of(context)!.encouragementTitle(
                  ref.read(childrenStateProvider).selectedChild?.name ?? ''),
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
                      ref.read(questionStateProvider.notifier).nextQuestion();
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
        ),
      ),
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
      return ClassificationOptionsWidget(
          currentQuestion, totalQuestions, sessionStartTime);
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
