import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/avatar_animal.dart';
import 'package:math_assessment/src/data/models/avatar_color.dart';
import 'package:math_assessment/src/data/models/child_models.dart';
import 'package:math_assessment/src/notifiers/child_update_notifier.dart';
import 'package:math_assessment/src/notifiers/children_state_notifier.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/notifiers/theme_notifier.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';
import 'package:math_assessment/src/settings/settings_view.dart';
import 'package:math_assessment/src/views/account_view.dart';
import 'package:math_assessment/src/views/child_edit_view.dart';
import 'package:math_assessment/src/views/home_view.dart';
import 'package:math_assessment/src/views/child_add_view.dart';

class ChildSelectView extends ConsumerStatefulWidget {
  const ChildSelectView({super.key});

  static const routeName = '/childselect';

  @override
  ChildSelectViewState createState() => ChildSelectViewState();
}

class ChildSelectViewState extends ConsumerState<ChildSelectView> {
  @override
  void initState() {
    super.initState();
    ref
        .read(childrenStateProvider.notifier)
        .fetchChildren(ref.read(userStateProvider)?.userId);
  }

  @override
  Widget build(BuildContext context) {
    final children = ref.watch(childrenStateProvider);
    ref.listen<Child?>(selectedChildProvider, (previousChild, currentChild) {
      final newColor = currentChild == null
          ? Colors.blue
          : ColorSeed.fromId(currentChild.favColour).color;
      ref.read(themeNotifierProvider.notifier).updateThemeColor(newColor);
    });

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
                      IconButton(
                          onPressed: () => Navigator.restorablePushNamed(
                              context, AccountView.routeName),
                          iconSize: 40,
                          icon: const Icon(Icons.account_circle))
                    ],
                  ),
                  const Spacer(),
                  children == null
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          height: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...children
                                  .map((child) => ChildProfile(child: child)),
                              const AddChild(),
                            ],
                          )),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: OutlinedButton(
                                onPressed: ref.watch(selectedChildProvider) ==
                                        null
                                    ? null
                                    : () {
                                        ref
                                            .read(childUpdateProvider.notifier)
                                            .syncWithSelectedChild(ref
                                                .read(selectedChildProvider)!);
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
                                onPressed:
                                    ref.watch(selectedChildProvider) == null
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
    final isSelected = ref.watch(selectedChildProvider) == child;
    return Column(
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
              ref.read(selectedChildProvider.notifier).state = child;
            },
            child: CircleAvatar(
              radius: isSelected ? 48 : 32,
              backgroundImage: AssetImage(avatarAnimal.imagePath),
            ),
          ),
        ),
        SizedBox(
          height: 30,
          width: 120,
          child: Padding(
              padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
              child: Center(
                child: Text(
                  child.name,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: isSelected ? FontWeight.bold : null),
                ),
              )),
        )
      ],
    );
  }
}

class AddChild extends ConsumerWidget {
  const AddChild({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 120,
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
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
                  AppLocalizations.of(context)!.addChild,
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
