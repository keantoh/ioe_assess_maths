import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assess_math/src/views/sign_up_view.dart';

void main() {
  final providerWidget = ProviderScope(
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
      home: SignUpView(),
    ),
  );
  testWidgets('Form validation: empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(providerWidget);

    final signUpButton = find.widgetWithText(FilledButton, 'Sign Up');
    expect(signUpButton, findsOneWidget);

    await tester.tap(signUpButton);
    await tester.pump();

    expect(find.text('Field is empty'), findsNWidgets(6));
  });

  testWidgets('Form validation: invalid email', (WidgetTester tester) async {
    await tester.pumpWidget(providerWidget);

    await tester.enterText(
        find.byKey(const Key('sign_up_email_field')), 'invalid@email');
    await tester.pump();

    final signUpButton = find.widgetWithText(FilledButton, 'Sign Up');
    expect(signUpButton, findsOneWidget);

    await tester.tap(signUpButton);
    await tester.pump();

    expect(find.text('Email address is invalid'), findsOneWidget);
  });

  testWidgets('Form validation: password mismatch',
      (WidgetTester tester) async {
    await tester.pumpWidget(providerWidget);

    await tester.enterText(
        find.byKey(const Key('sign_up_password_field')), 'password123');
    await tester.enterText(
        find.byKey(const Key('sign_up_confirm_password_field')),
        'differentpassword');
    await tester.pump();

    final signUpButton = find.widgetWithText(FilledButton, 'Sign Up');
    expect(signUpButton, findsOneWidget);

    await tester.tap(signUpButton);
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}
