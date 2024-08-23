import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_assessment/src/views/child_add_view.dart';

void main() {
  testWidgets('Form validation: empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''),
            Locale('es', ''),
          ],
          home: ChildAddView(),
        ),
      ),
    );

    final addChildButton = find.widgetWithText(FilledButton, 'Add Child');
    expect(addChildButton, findsOneWidget);

    await tester.tap(addChildButton);
    await tester.pump();

    expect(find.text('Field is empty'), findsNWidgets(3));
  });
}
