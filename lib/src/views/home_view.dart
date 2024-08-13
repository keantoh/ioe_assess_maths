import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/avatar_animal.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/views/question_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static const routeName = '/home';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.hi(selectedChild.name),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 48,
                backgroundImage: AssetImage(
                    AvatarAnimal.fromId(selectedChild.favAnimal).imagePath),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.readyForChallenge,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 60),
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
                      margin: const EdgeInsets.symmetric(horizontal: 60),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
