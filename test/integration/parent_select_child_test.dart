import 'package:assess_math/src/models/child.dart';
import 'package:assess_math/src/models/user.dart';
import 'package:assess_math/src/notifiers/children_state_notifier.dart';
import 'package:assess_math/src/notifiers/token_state_provider.dart';
import 'package:assess_math/src/notifiers/user_state_notifier.dart';
import 'package:assess_math/src/repositories/child_repository.dart';
import 'package:assess_math/src/repositories/user_repository.dart';
import 'package:assess_math/src/services/user_service.dart';
import 'package:assess_math/src/views/child_select_view.dart';
import 'package:assess_math/src/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(UserLoginFake());
    registerFallbackValue(ChildCreateFake());
  });
  testWidgets('Parent selects a child and proceeds to the next screen',
      (WidgetTester tester) async {
    final mockUserService = MockUserService();
    final mockUserRepository = MockUserRepository();
    final mockTokenManager = MockTokenManager();
    final mockChildRepository = MockChildRepository();

    when(() => mockUserRepository.token).thenReturn('fake_token');

    when(() => mockUserRepository.userLoginState).thenReturn(UserLoginState(
        userId: 'testId',
        email: 'test@test.com',
        firstName: 'tester',
        lastName: 'tester',
        country: 'GBR',
        isActive: true,
        isAdmin: true));

    when(() => mockUserRepository.loginUser(any())).thenAnswer((_) async => {
          'status': 200,
          'response': {'token': 'fake_token'}
        });

    when(() => mockTokenManager.saveToken(any())).thenAnswer((_) async => {
          'status': 200,
        });

    when(() => mockChildRepository.getAllChildren(any(), any()))
        .thenAnswer((_) async => {
              'status': 200,
            });

    when(() => mockChildRepository.children).thenReturn([
      Child(
          childId: 1,
          name: 'Alice',
          gender: 'female',
          dob: DateTime(2015, 7, 15),
          favColour: 1,
          favAnimal: 2),
      Child(
          childId: 2,
          name: 'Bob',
          gender: 'male',
          dob: DateTime(2018, 5, 1),
          favColour: 3,
          favAnimal: 1),
    ]);

    await tester.pumpWidget(
      ProviderScope(
          overrides: [
            userStateProvider.overrideWith((ref) => UserStateNotifier(
                  mockUserService,
                  mockUserRepository,
                  mockTokenManager,
                  ref,
                  initialState: UserLoginState(
                    userId: 'testId',
                    email: 'test@test.com',
                    firstName: 'tester',
                    lastName: 'tester',
                    country: 'GBR',
                    isActive: true,
                    isAdmin: true,
                  ),
                )),
            childrenStateProvider.overrideWith((ref) =>
                ChildrenStateNotifier(mockChildRepository, ref, '123')),
            userServiceProvider.overrideWithValue(mockUserService),
            userRepositoryProvider.overrideWithValue(mockUserRepository),
            tokenManagerProvider.overrideWithValue(mockTokenManager),
            childRepositoryProvider.overrideWithValue(mockChildRepository)
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
            home: const ChildSelectView(),
            onGenerateRoute: (RouteSettings settings) {
              if (settings.name == HomeView.routeName) {
                return MaterialPageRoute(
                  builder: (_) => const HomeView(),
                  settings: settings,
                );
              }
              return null;
            },
          )),
    );

    await tester.pumpAndSettle();

    // SelectChild's widgets rendered and select Bob's profile
    final iconButtonFinder = find.byIcon(Icons.account_circle);
    expect(iconButtonFinder, findsOneWidget);
    final aliceChildFinder = find.byKey(const ValueKey(1));
    final bobChildFinder = find.byKey(const ValueKey(2));
    expect(aliceChildFinder, findsOneWidget);
    expect(bobChildFinder, findsOneWidget);
    await tester.tap(bobChildFinder);
    await tester.pumpAndSettle();

    // Selected child updated as Bob
    final element = tester.element(find.byType(ChildSelectView));
    final container = ProviderScope.containerOf(element);
    final selectedChild = container.read(childrenStateProvider).selectedChild;
    expect(selectedChild?.name, 'Bob');

    // // Tap on next button to go to HomeView
    final nextButton = find.byKey(const Key('select_child_next_button'));
    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    // HomeView's widgets rendered
    expect(find.text('Ready For A Challenge?'), findsOneWidget);
    final backButtonFinder = find.widgetWithText(OutlinedButton, 'Back');
    expect(backButtonFinder, findsOneWidget);
    final startButtonFinder = find.widgetWithText(FilledButton, 'Start');
    expect(startButtonFinder, findsOneWidget);
  });
}

class MockUserService extends Mock implements UserService {}

class MockUserRepository extends Mock implements UserRepository {}

class MockTokenManager extends Mock implements TokenManager {}

class UserLoginFake extends Fake implements UserLogin {}

class ChildCreateFake extends Fake implements ChildCreate {}

class MockChildRepository extends Mock implements ChildRepository {}
