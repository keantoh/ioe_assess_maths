import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/avatar_animal.dart';
import 'package:math_assessment/src/models/avatar_color.dart';
import 'package:math_assessment/src/models/child.dart';
import 'package:math_assessment/src/notifiers/child_update_notifier.dart';
import 'package:math_assessment/src/notifiers/children_state_notifier.dart';
import 'package:math_assessment/src/notifiers/theme_notifier.dart';
import 'package:math_assessment/src/notifiers/user_search_notifier.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';
import 'package:math_assessment/src/views/account_view.dart';
import 'package:math_assessment/src/views/child_add_view.dart';
import 'package:math_assessment/src/views/child_edit_view.dart';
import 'package:math_assessment/src/views/home_view.dart';
import 'package:math_assessment/src/views/settings_view.dart';
import 'package:math_assessment/src/views/user_search_view.dart';

class ChildSelectView extends ConsumerStatefulWidget {
  const ChildSelectView({super.key});

  static const routeName = '/childselect';

  @override
  ChildSelectViewState createState() => ChildSelectViewState();
}

class ChildSelectViewState extends ConsumerState<ChildSelectView> {
  // @override
  // void initState() {
  //   super.initState();
  //   ref
  //       .read(childrenStateProvider.notifier)
  //       .fetchChildren(ref.read(userStateProvider)?.userId);
  // }

  @override
  Widget build(BuildContext context) {
    final children = ref.watch(childrenStateProvider).children;
    final userState = ref.watch(userStateProvider);
    ref.listen<ChildState>(childrenStateProvider,
        (previousState, currentState) {
      final currentChild = currentState.selectedChild;
      final newColor = currentChild == null
          ? Colors.blue
          : ColorSeed.fromId(currentChild.favColour).color;
      ref.read(themeNotifierProvider.notifier).updateThemeColor(newColor);
    });

    if (userState == null) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings),
        onPressed: () {
          Navigator.restorablePushNamed(context, SettingsView.routeName);
        },
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // TITLE AND ICONS
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)!.selectChild,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                      ref.read(userStateProvider)!.isAdmin
                          ? Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: IconButton(
                                  onPressed: () {
                                    ref
                                        .read(userSearchProvider.notifier)
                                        .setDefault();
                                    Navigator.restorablePushNamed(
                                        context, UserSearchView.routeName);
                                  },
                                  iconSize: 40,
                                  icon: const Icon(Icons.manage_accounts)),
                            )
                          : const SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: IconButton(
                            onPressed: () => Navigator.restorablePushNamed(
                                context, AccountView.routeName),
                            iconSize: 40,
                            icon: const Icon(Icons.account_circle)),
                      )
                    ],
                  ),
                  ref.watch(childrenStateProvider).isFetching
                      ? const Expanded(
                          child: Center(child: CircularProgressIndicator()))
                      : Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...children
                                  .map((child) => ChildProfile(child: child)),
                              const AddChild(),
                            ],
                          ),
                        ),
                  // BUTTONS
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: OutlinedButton(
                                onPressed: ref
                                            .watch(childrenStateProvider)
                                            .selectedChild ==
                                        null
                                    ? null
                                    : () {
                                        ref
                                            .read(childUpdateProvider.notifier)
                                            .syncWithSelectedChild(ref
                                                .read(childrenStateProvider)
                                                .selectedChild!);
                                        Navigator.restorablePushNamed(
                                            context, ChildEditView.routeName);
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Text(AppLocalizations.of(context)!
                                      .editDetails),
                                )),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: FilledButton(
                                onPressed: ref
                                            .watch(childrenStateProvider)
                                            .selectedChild ==
                                        null
                                    ? null
                                    : () {
                                        Navigator.restorablePushNamed(
                                            context, HomeView.routeName);
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 36),
                                  child:
                                      Text(AppLocalizations.of(context)!.next),
                                )),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChildProfile extends ConsumerWidget {
  final Child child;
  const ChildProfile({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorSeed = ColorSeed.fromId(child.favColour);
    final avatarAnimal = AvatarAnimal.fromId(child.favAnimal);
    final isSelected = ref.watch(childrenStateProvider).selectedChild == child;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 120,
          width: 120,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 3.0)
                  : null),
          child: FilledButton(
            style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: colorSeed.color),
            onPressed: () {
              ref
                  .read(childrenStateProvider.notifier)
                  .selectChild(child.childId);
            },
            child: CircleAvatar(
              radius: isSelected ? 48 : 32,
              backgroundImage: AssetImage(avatarAnimal.imagePath),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
            child: Center(
              child: Text(
                child.name,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: isSelected ? FontWeight.bold : null),
              ),
            ))
      ],
    );
  }
}

class AddChild extends ConsumerWidget {
  const AddChild({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 120,
          width: 120,
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
            onPressed: () {
              Navigator.restorablePushNamed(context, ChildAddView.routeName);
            },
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
              child: const Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.addChild,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ))
      ],
    );
  }
}
