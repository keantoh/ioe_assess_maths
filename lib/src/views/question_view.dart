import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/question.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';
import 'package:math_assessment/src/utils/dot_painter.dart';
import 'package:math_assessment/src/views/login_view.dart';

class QuestionView extends ConsumerStatefulWidget {
  const QuestionView({super.key});

  static const routeName = '/question';

  @override
  QuestionViewState createState() => QuestionViewState();
}

Future<List<Question>> loadQuestions() async {
  final jsonString = await rootBundle.loadString('assets/question_data.json');
  final jsonData = json.decode(jsonString);

  List<Question> questions = (jsonData['questions'] as List)
      .map((item) => Question.fromJson(item))
      .toList();

  return questions;
}

class QuestionViewState extends ConsumerState<QuestionView> {
  late Future<List<Question>> _questions;

  @override
  void initState() {
    super.initState();
    _questions = loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              final double height = constraints.maxHeight;

              return FutureBuilder<List<Question>>(
                  future: _questions,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No questions available.'));
                    } else {
                      List<Question> questions = snapshot.data!;
                      var firstQuestion = questions[0];

                      if (firstQuestion is SubitisingQuestion) {
                        final currentQuestion = firstQuestion;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Progress Bar',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    ref
                                        .read(userStateProvider.notifier)
                                        .logout();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => LoginView()),
                                        ModalRoute.withName('/'));
                                  },
                                  child: Text(
                                    'QUIT',
                                  ),
                                ),
                              ],
                            ),
                            Text('INSTRUCTONS'),
                            const Spacer(),
                            subitisingOptions(width, height, currentQuestion),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text('STARS'),
                            )
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }
                  });
            },
          ),
        ),
      ),
    );
  }

  Widget subitisingOptions(
      double rowWidth, double rowHeight, SubitisingQuestion question) {
    return Row(
        children: question.options.map((option) {
      return Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(builder: (context, constraints) {
            return InkWell(
              onTap: () {},
              child: Container(
                width: constraints.maxWidth,
                height: rowHeight * 0.5,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: CustomPaint(
                    painter:
                        DotsPainter(option, rowWidth * 0.45, rowHeight * 0.45)),
              ),
            );
          }),
        ),
      );
    }).toList());
  }
}
