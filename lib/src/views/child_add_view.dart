import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/avatar.dart';
import 'package:math_assessment/src/data/models/gender.dart';
import 'package:math_assessment/src/data/models/color_seed.dart';

import '../settings/settings_view.dart';

final avatarProvider = StateProvider<Avatar>(
  (ref) => Avatar.values[0],
);

final colorSeedProvider = StateProvider<ColorSeed>(
  (ref) => ColorSeed.values[0],
);

Avatar selectedAvatar = Avatar.values.first;

class ChildAddView extends StatefulWidget {
  const ChildAddView({super.key});

  static const routeName = '/childadd';

  @override
  State<ChildAddView> createState() => _ChildAddViewState();
}

class _ChildAddViewState extends State<ChildAddView> {
  final _formKey = GlobalKey<FormState>();

  final fieldMargin = const EdgeInsets.symmetric(horizontal: 20, vertical: 4);

  Gender? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings),
        onPressed: () {
          Navigator.restorablePushNamed(context, SettingsView.routeName);
        },
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)!.addChild,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: fieldMargin,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText:
                                            AppLocalizations.of(context)!.name,
                                      ),
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return AppLocalizations.of(context)!
                                              .emptyField;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: fieldMargin,
                                    child: DropdownMenu<Gender>(
                                      initialSelection: selectedGender,
                                      expandedInsets: const EdgeInsets.all(0),
                                      requestFocusOnTap: true,
                                      label: Text(
                                          AppLocalizations.of(context)!.gender),
                                      onSelected: (Gender? gender) {
                                        selectedGender = gender;
                                      },
                                      dropdownMenuEntries: Gender.values
                                          .map<DropdownMenuEntry<Gender>>(
                                              (Gender gender) {
                                        return DropdownMenuEntry<Gender>(
                                            value: gender,
                                            label:
                                                getGenderName(gender, context));
                                      }).toList(),
                                    ),
                                  ),
                                  Container(
                                    margin: fieldMargin,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText:
                                            AppLocalizations.of(context)!.dob,
                                      ),
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return AppLocalizations.of(context)!
                                              .emptyField;
                                        }
                                        if (text.length < 6) {
                                          return AppLocalizations.of(context)!
                                              .weakPassword;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(
                                child: Column(
                              children: [
                                ProfileAvatar(),
                              ],
                            )),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              child: Consumer(builder: (context, ref, _) {
                                return OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .back)));
                              }),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              child: Consumer(builder: (context, ref, _) {
                                bool isLoading = false;
                                return isLoading
                                    ? const CircularProgressIndicator()
                                    : FilledButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            // submitForm();
                                          }
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .addChild)));
                              }),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAvatar = ref.watch(avatarProvider);
    final selectedColorSeed = ref.watch(colorSeedProvider);
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.shadow,
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: MenuAnchor(
        builder:
            (BuildContext context, MenuController controller, Widget? widget) {
          return FilledButton(
            style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: selectedColorSeed.color),
            onPressed: () {
              if (!controller.isOpen) {
                controller.open();
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: CircleAvatar(
                    radius: 48,
                    // backgroundColor:
                    //     Theme.of(context).colorScheme.primaryFixedDim,
                    backgroundImage:
                        AssetImage(getAvatarImagePath(selectedAvatar)),
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) =>
                              const AvatarDialog(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        menuChildren:
            List<Widget>.generate(ColorSeed.values.length, (int index) {
          final ColorSeed itemColorSeed = ColorSeed.values[index];
          return MenuItemButton(
            leadingIcon: Icon(Icons.circle, color: itemColorSeed.color),
            onPressed: () {
              ref.read(colorSeedProvider.notifier).state = itemColorSeed;
            },
            child: Text(itemColorSeed.label),
          );
        }),
      ),
    );
  }
}

class AvatarDialog extends ConsumerWidget {
  const AvatarDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAvatar = ref.watch(avatarProvider);
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.editAvatar,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: Avatar.values.map((Avatar avatar) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: selectedAvatar == avatar
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 2.5,
                          ),
                        )
                      : null,
                  child: CircleAvatar(
                      radius: selectedAvatar == avatar ? 60 : 48,
                      backgroundImage: AssetImage(getAvatarImagePath(avatar)),
                      child: Material(
                        shape: CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => {
                            ref.read(avatarProvider.notifier).state = avatar
                          },
                        ),
                      )),
                );
              }).toList(),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                child: Consumer(builder: (context, ref, _) {
                  return FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(AppLocalizations.of(context)!.ok)));
                }),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
