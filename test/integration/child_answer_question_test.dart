import 'package:assess_math/src/models/child.dart';
import 'package:assess_math/src/models/question.dart';
import 'package:assess_math/src/models/result.dart';
import 'package:assess_math/src/notifiers/children_state_notifier.dart';
import 'package:assess_math/src/notifiers/question_state_notifier.dart';
import 'package:assess_math/src/repositories/child_repository.dart';
import 'package:assess_math/src/repositories/question_repository.dart';
import 'package:assess_math/src/repositories/user_repository.dart';
import 'package:assess_math/src/services/question_service.dart';
import 'package:assess_math/src/views/home_view.dart';
import 'package:assess_math/src/views/question_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(ResultCreateFake());
  });
  testWidgets('Child answers question and response is saved successfully',
      (WidgetTester tester) async {
    final mockChildRepository = MockChildRepository();
    when(() => mockChildRepository.getAllChildren(any(), any()))
        .thenAnswer((_) async => {
              'status': 200,
            });
    when(() => mockChildRepository.children).thenReturn([
      Child(
          childId: 3,
          name: 'Charlie',
          gender: 'male',
          dob: DateTime(2018, 5, 1),
          favAnimal: 1,
          favColour: 1),
    ]);
    final mockUserRepository = MockUserRepository();
    when(() => mockUserRepository.token).thenReturn('fake_token');

    final mockSelectedChild = Child(
        childId: 3,
        name: 'Charlie',
        gender: 'male',
        dob: DateTime(2018, 5, 1),
        favAnimal: 1,
        favColour: 1);

    final mockQuestionService = MockQuestionService();
    final mockQuestionRepository = MockQuestionRepository();
    when(() => mockQuestionRepository.getAllQuestions())
        .thenAnswer((_) async => {
              'status': 200,
            });
    when(() => mockQuestionRepository.questions).thenReturn([
      NonSymbolicQuestion(1, 1, 1, [
        [
          {"x": 0.4, "y": 0.5, "radius": 0.08}
        ],
        [
          {"x": 0.4, "y": 0.5, "radius": 0.08}
        ]
      ]),
      NonSymbolicQuestion(2, 1, 1, [
        [
          {"x": 0.4, "y": 0.5, "radius": 0.08}
        ],
        [
          {"x": 0.4, "y": 0.5, "radius": 0.08}
        ]
      ]),
      SymbolicQuestion(6, 2, 1, [1, 2])
    ]);
    when(() => mockQuestionService.addResultService(any()))
        .thenAnswer((_) async => {
              'status': 201,
              'response': {},
            });
    await tester.pumpWidget(
      ProviderScope(
          overrides: [
            childrenStateProvider.overrideWith((ref) => ChildrenStateNotifier(
                mockChildRepository, ref, '123',
                selectedChild: mockSelectedChild)),
            questionStateProvider.overrideWith((ref) => QuestionStateNotifier(
                mockQuestionRepository, mockQuestionService, ref)),
            childRepositoryProvider.overrideWithValue(mockChildRepository),
            questionRepositoryProvider
                .overrideWithValue(mockQuestionRepository),
            questionServiceProvider.overrideWithValue(mockQuestionService),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('es', ''),
            ],
            home: const HomeView(),
            onGenerateRoute: (RouteSettings settings) {
              if (settings.name == QuestionView.routeName) {
                return MaterialPageRoute(
                  builder: (_) => const QuestionView(),
                  settings: settings,
                );
              }
              return null;
            },
          )),
    );

    await tester.pump();

    // Find and tap on start button
    final startButtonFinder = find.widgetWithText(FilledButton, 'Start');
    expect(startButtonFinder, findsOneWidget);
    await tester.tap(startButtonFinder);
    await tester.pumpAndSettle();

    // Find question and options. Tap on option
    expect(find.text('Tap the side that has more'), findsOneWidget);
    final leftOptionFinder = find.byKey(const ValueKey(0));
    expect(leftOptionFinder, findsOneWidget);
    final rightOptionFinder = find.byKey(const ValueKey(1));
    expect(rightOptionFinder, findsOneWidget);
    await tester.tap(rightOptionFinder);
    await tester.pumpAndSettle();

    // Tap another option for the second question
    final wrongOption = find.byKey(const ValueKey(0));
    expect(wrongOption, findsOneWidget);
    await tester.tap(wrongOption);
    await tester.pumpAndSettle();

    // Find the next question of a different category
    expect(find.text('Tap which one is more'), findsOneWidget);
  });
}

class MockQuestionService extends Mock implements QuestionService {}

class MockQuestionRepository extends Mock implements QuestionRepository {}

class MockChildRepository extends Mock implements ChildRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class ResultCreateFake extends Fake implements ResultCreate {}
