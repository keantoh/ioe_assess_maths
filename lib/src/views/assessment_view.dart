import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/views/question_view.dart';

import '../settings/settings_view.dart';

class AssessmentView extends ConsumerWidget {
  const AssessmentView({super.key});

  static const routeName = '/assessment';
  final fieldMargin = const EdgeInsets.symmetric(horizontal: 32, vertical: 8);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChild = ref.read(selectedChildProvider);
    if (selectedChild == null) {
      Future.microtask(() {
        Navigator.of(context).pop();
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings),
        onPressed: () {
          Navigator.restorablePushNamed(context, SettingsView.routeName);
        },
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.hi(selectedChild.name),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.readyForChallenge,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 12),
                      child: Consumer(builder: (context, ref, _) {
                        return OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child:
                                    Text(AppLocalizations.of(context)!.back)));
                      }),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 12),
                      child: FilledButton(
                          onPressed: () {
                            ref
                                .read(currentQuestionIndexProvider.notifier)
                                .state = 0;
                            Navigator.restorablePushNamed(
                                context, QuestionView.routeName);
                          },
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child:
                                  Text(AppLocalizations.of(context)!.start))),
                    )
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
