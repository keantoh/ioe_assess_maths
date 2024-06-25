import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';

import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class ChildSelectView extends ConsumerWidget {
  const ChildSelectView({super.key});

  static const routeName = '/childselect';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)!.selectChild,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () => ref
                                  .read(userStateProvider.notifier)
                                  .logout(context: context),
                              child: Text(
                                AppLocalizations.of(context)!.logOut,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 140,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              ChildProfile(),
                              ChildProfile(),
                              ChildProfile(),
                              ChildProfile(),
                              AddChild(),
                            ],
                          ),
                        ),
                        const Spacer(),
                        //ref.widget ? null :
                        Container(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: OutlinedButton(
                                      onPressed: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .editDetails),
                                      )),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: FilledButton(
                                      onPressed: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 36),
                                        child: Text(
                                            AppLocalizations.of(context)!.next),
                                      )),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChildProfile extends ConsumerWidget {
  const ChildProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 128,
      width: 128,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary,
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        ),
        onPressed: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              // backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
              // foregroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
              child: const Icon(
                Icons.pets,
                size: 40,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Text(
                  "Christopherrr",
                  style: TextStyle(
                      // color: Theme.of(context).colorScheme.onPrimaryFixed,
                      overflow: TextOverflow.ellipsis),
                ))
          ],
        ),
      ),
    );
  }
}

class AddChild extends ConsumerWidget {
  const AddChild({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 128,
      width: 128,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryFixedDim,
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        ),
        onPressed: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
              child: const Icon(
                Icons.add,
                size: 40,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Text(
                  "Add Child",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryFixed,
                      overflow: TextOverflow.ellipsis),
                ))
          ],
        ),
      ),
    );
  }
}
