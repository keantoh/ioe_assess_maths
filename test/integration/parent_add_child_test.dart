import 'package:assess_math/src/models/child.dart';
import 'package:assess_math/src/models/user.dart';
import 'package:assess_math/src/notifiers/children_state_notifier.dart';
import 'package:assess_math/src/notifiers/token_state_provider.dart';
import 'package:assess_math/src/notifiers/user_state_notifier.dart';
import 'package:assess_math/src/repositories/child_repository.dart';
import 'package:assess_math/src/repositories/user_repository.dart';
import 'package:assess_math/src/services/user_service.dart';
import 'package:assess_math/src/views/child_add_view.dart';
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
  testWidgets('Parent successfully adds a child', (WidgetTester tester) async {
    final mockUserService = MockUserService();
    final mockUserRepository = MockUserRepository();
    final mockTokenManager = MockTokenManager();
    final mockChildRepository = MockChildRepository();

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

    when(() => mockChildRepository.getAllChildren(any()))
        .thenAnswer((_) async => {
              'status': 200,
            });

    when(() => mockChildRepository.children).thenReturn([]);

    when(() => mockChildRepository.addChild(any())).thenAnswer((_) async {
      when(() => mockChildRepository.children).thenAnswer((_) => [
            Child(
                childId: 1,
                name: 'Alice',
                gender: 'female',
                dob: DateTime(2015, 7, 1),
                favColour: 1,
                favAnimal: 2),
          ]);
      return {'status': 201};
    });

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
              } else if (settings.name == ChildAddView.routeName) {
                return MaterialPageRoute(
                  builder: (_) => const ChildAddView(),
                  settings: settings,
                );
              }
              return null;
            },
          )),
    );

    await tester.pumpAndSettle();

    // SelectChild's widgets rendered and go to ChildAdd screen
    final iconButtonFinder = find.byIcon(Icons.account_circle);
    expect(iconButtonFinder, findsOneWidget);
    final childAddButtonFinder =
        find.byKey(const Key('select_child_add_child_button'));
    expect(childAddButtonFinder, findsOneWidget);
    await tester.tap(childAddButtonFinder);
    await tester.pumpAndSettle();

    // Find and fill nameField
    final nameField = find.byKey(const Key('add_child_name_field'));
    expect(nameField, findsOneWidget);
    await tester.enterText(nameField, 'Alice');
    expect(find.text('Alice'), findsOneWidget);

    // Find and fill genderField
    final genderField = find.byKey(const Key('add_child_gender_field'));
    expect(genderField, findsOneWidget);
    await tester.tap(genderField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Female'));
    await tester.pumpAndSettle();
    expect(find.text('Female'), findsOneWidget);

    // Find and fill dobField
    final dobField = find.byKey(const Key('add_child_dob_field'));
    expect(dobField, findsOneWidget);
    await tester.tap(dobField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('1'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Tap on AddChild
    final addChildButton = find.byKey(const Key('add_child_add_child_button'));
    await tester.tap(addChildButton);
    await tester.pumpAndSettle();

    // Find Alice's profile
    final aliceChildFinder = find.byKey(const ValueKey(1));
    expect(aliceChildFinder, findsOneWidget);
  });
}

class MockUserService extends Mock implements UserService {}

class MockUserRepository extends Mock implements UserRepository {}

class MockTokenManager extends Mock implements TokenManager {}

class UserLoginFake extends Fake implements UserLogin {}

class ChildCreateFake extends Fake implements ChildCreate {}

class MockChildRepository extends Mock implements ChildRepository {}
