import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assess_math/src/models/user.dart';
import 'package:assess_math/src/notifiers/children_state_notifier.dart';
import 'package:assess_math/src/notifiers/token_state_provider.dart';
import 'package:assess_math/src/notifiers/user_state_notifier.dart';
import 'package:assess_math/src/repositories/child_repository.dart';
import 'package:assess_math/src/repositories/user_repository.dart';
import 'package:assess_math/src/services/user_service.dart';
import 'package:assess_math/src/views/child_select_view.dart';
import 'package:assess_math/src/views/login_view.dart';
import 'package:assess_math/src/views/sign_up_view.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(UserLoginFake());
    registerFallbackValue(UserCreateFake());
  });
  testWidgets('Parent signs up and logs in successfully',
      (WidgetTester tester) async {
    final mockUserService = MockUserService();
    final mockUserRepository = MockUserRepository();
    final mockTokenManager = MockTokenManager();
    final mockChildRepository = MockChildRepository();

    when(() => mockUserRepository.userLoginState).thenReturn(UserLoginState(
        userId: 'testId',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        country: 'ALB',
        isActive: true,
        isAdmin: false));

    when(() => mockUserRepository.signUpUser(any())).thenAnswer((_) async => {
          'status': 201,
          'response': {'token': 'fake_token'}
        });

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

    await tester.pumpWidget(
      ProviderScope(
          overrides: [
            userStateProvider.overrideWith((ref) => UserStateNotifier(
                  mockUserService,
                  mockUserRepository,
                  mockTokenManager,
                  ref,
                  // initialState: null,
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
            home: LoginView(),
            onGenerateRoute: (RouteSettings settings) {
              if (settings.name == SignUpView.routeName) {
                return MaterialPageRoute(
                  builder: (_) => SignUpView(),
                  settings: settings,
                );
              } else if (settings.name == ChildSelectView.routeName) {
                return MaterialPageRoute(
                  builder: (_) => const ChildSelectView(),
                  settings: settings,
                );
              }
              return null;
            },
          )),
    );

    await tester.pump();

    // Tap on LoginView's sign up button
    final toSignUpButtonFinder = find.widgetWithText(OutlinedButton, 'Sign Up');
    expect(toSignUpButtonFinder, findsOneWidget);
    await tester.tap(toSignUpButtonFinder);
    await tester.pumpAndSettle();

    // Find and fill emailField, passwordField, confirmPasswordField
    final emailField = find.byKey(const Key('sign_up_email_field'));
    final passwordField = find.byKey(const Key('sign_up_password_field'));
    final confirmPasswordField =
        find.byKey(const Key('sign_up_confirm_password_field'));
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(confirmPasswordField, findsOneWidget);
    await tester.enterText(emailField, 'test@example.com');
    expect(find.text('test@example.com'), findsOneWidget);
    await tester.enterText(passwordField, 'password');
    await tester.enterText(confirmPasswordField, 'password');
    expect(find.text('password'), findsExactly(2));

    // Find and fill firstNameField, lastNameField
    final firstNameField = find.byKey(const Key('sign_up_first_name_field'));
    final lastNameField = find.byKey(const Key('sign_up_last_name_field'));
    expect(firstNameField, findsOneWidget);
    expect(lastNameField, findsOneWidget);
    await tester.enterText(firstNameField, 'John');
    expect(find.text('John'), findsOneWidget);
    await tester.enterText(lastNameField, 'Doe');
    expect(find.text('Doe'), findsOneWidget);

    // Find and fill countryField
    final countryField = find.byKey(const Key('sign_up_country_field'));
    expect(countryField, findsOneWidget);
    await tester.tap(countryField);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Albania'));
    await tester.pumpAndSettle();
    expect(find.text('Albania'), findsOneWidget);

    // Find and tap sign up button
    final signUpButton = find.widgetWithText(FilledButton, 'Sign Up');
    expect(signUpButton, findsOneWidget);
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    // UserState updated
    final element = tester.element(find.byType(ChildSelectView));
    final container = ProviderScope.containerOf(element);
    final userStateEmail = container.read(userStateProvider)?.email;
    expect(userStateEmail, 'test@example.com');

    // SelectChildView's widgets rendered
    final iconButtonFinder = find.byIcon(Icons.account_circle);
    expect(iconButtonFinder, findsOneWidget);
    expect(find.text('Select Child'), findsOneWidget);
    expect(find.text('Add Child'), findsOneWidget);
  });
}

class MockUserService extends Mock implements UserService {}

class MockUserRepository extends Mock implements UserRepository {}

class MockTokenManager extends Mock implements TokenManager {}

class UserLoginFake extends Fake implements UserLogin {}

class UserCreateFake extends Fake implements UserCreate {}

class MockChildRepository extends Mock implements ChildRepository {}
