import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:assess_math/src/models/avatar_animal.dart';
import 'package:assess_math/src/models/avatar_color.dart';
import 'package:assess_math/src/models/child.dart';
import 'package:assess_math/src/models/gender.dart';
import 'package:assess_math/src/notifiers/child_update_notifier.dart';
import 'package:assess_math/src/notifiers/children_state_notifier.dart';
import 'package:assess_math/src/notifiers/theme_state_notifier.dart';
import 'package:assess_math/src/utils/helper_functions.dart';

final isEditingChildProvider = StateProvider<bool>(
  (ref) => false,
);

class ChildEditView extends HookConsumerWidget {
  static const routeName = '/childedit';
  final _formKey = GlobalKey<FormState>();

  final fieldMargin = const EdgeInsets.symmetric(horizontal: 20, vertical: 4);

  ChildEditView({super.key});

  Future<void> handleUpdate(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      await submitUpdate(ref, context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeName = AppLocalizations.of(context)?.localeName ?? 'en';
    final childUpdateNotifier = ref.watch(childUpdateProvider.notifier);
    final childUpdateDetails = ref.watch(childUpdateProvider);

    final nameController =
        useTextEditingController(text: childUpdateDetails.name);
    final dobController = useTextEditingController(
        text: DateFormat.yMMMMd(localeName).format(childUpdateDetails.dob));

    return Scaffold(
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
                            AppLocalizations.of(context)!.editChild,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  // NAME
                                  Container(
                                    margin: fieldMargin,
                                    child: TextFormField(
                                      textCapitalization:
                                          TextCapitalization.words,
                                      controller: nameController,
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
                                      onChanged: (value) =>
                                          childUpdateNotifier.updateName(value),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(20)
                                      ],
                                    ),
                                  ),
                                  // GENDER
                                  Container(
                                    margin: fieldMargin,
                                    child: DropdownButtonFormField(
                                      isExpanded: true,
                                      isDense: false,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: AppLocalizations.of(context)!
                                            .gender,
                                      ),
                                      validator: (value) => value == null
                                          ? AppLocalizations.of(context)!
                                              .emptyField
                                          : null,
                                      value: Gender.fromString(
                                          childUpdateDetails.gender),
                                      onChanged: (Gender? gender) {
                                        if (gender != null) {
                                          childUpdateNotifier
                                              .updateGender(gender.name);
                                        }
                                      },
                                      items: Gender.values
                                          .map<DropdownMenuItem<Gender>>(
                                              (Gender gender) {
                                        return DropdownMenuItem<Gender>(
                                            value: gender,
                                            child: Text(
                                                gender.getGenderName(context)));
                                      }).toList(),
                                      selectedItemBuilder:
                                          (BuildContext context) {
                                        return Gender.values
                                            .map<Widget>((Gender gender) {
                                          return Text(
                                            gender.getGenderName(context),
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ),
                                  // DOB
                                  Container(
                                    margin: fieldMargin,
                                    child: TextFormField(
                                      controller: dobController,
                                      onTap: () async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        final date = await showDatePicker(
                                            context: context,
                                            initialDate: childUpdateDetails.dob,
                                            firstDate: DateTime(
                                                DateTime.now().year - 20),
                                            lastDate: DateTime.now());
                                        if (date != null) {
                                          childUpdateNotifier.updateDob(date);
                                          dobController.text =
                                              DateFormat.yMMMMd(localeName)
                                                  .format(date);
                                        }
                                      },
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
                        ref.watch(isEditingChildProvider)
                            ? const CircularProgressIndicator()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 4),
                                      child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            final color = ColorSeed.fromId(ref
                                                    .read(childrenStateProvider)
                                                    .selectedChild!
                                                    .favColour)
                                                .color;
                                            ref
                                                .read(themeNotifierProvider
                                                    .notifier)
                                                .updateThemeColor(color);
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!.back,
                                            textAlign: TextAlign.center,
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 4),
                                      child: FilledButton(
                                          onPressed: () =>
                                              _showDeleteChildDialog(context,
                                                  ref, childUpdateDetails),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .deleteChild,
                                            textAlign: TextAlign.center,
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 4),
                                      child: FilledButton(
                                          onPressed: childUpdateNotifier
                                                  .hasChanges
                                              ? () {
                                                  handleUpdate(context, ref);
                                                }
                                              : null,
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .editChild,
                                            textAlign: TextAlign.center,
                                          )),
                                    ),
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

  void _showDeleteChildDialog(
      BuildContext context, WidgetRef ref, Child child) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteChild),
          content: Text(
              AppLocalizations.of(context)!.deleteChildMessage(child.name)),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.error,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  submitDelete(ref, context);
                },
                child: Text(AppLocalizations.of(context)!.delete),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> submitUpdate(WidgetRef ref, BuildContext context) async {
    ref.read(isEditingChildProvider.notifier).state = true;
    final updatedChild = ref.read(childUpdateProvider);

    await ref.read(childrenStateProvider.notifier).updateChild(updatedChild);

    final responseCode = ref.read(childrenResponseCodeProvider);

    ref.read(isEditingChildProvider.notifier).state = false;
    if (context.mounted) {
      switch (responseCode) {
        case 200:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.childUpdateSuccess);
          Navigator.pop(context);
          break;
        case 400:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error400);
          break;
        case 401:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error401);
          break;
        case 404:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error404_child);
          break;
        case 408:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error408);
          break;
        case 503:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error503);
          break;
        default:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error500);
          break;
      }
    }
  }

  Future<void> submitDelete(WidgetRef ref, BuildContext context) async {
    ref.read(isEditingChildProvider.notifier).state = true;
    final childId = ref.read(childUpdateProvider).childId;

    await ref.read(childrenStateProvider.notifier).removeChild(childId);

    final responseCode = ref.read(childrenResponseCodeProvider);

    ref.read(isEditingChildProvider.notifier).state = false;
    if (context.mounted) {
      switch (responseCode) {
        case 200:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.childDeleteSuccess);
          Navigator.pop(context);
          break;
        case 400:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error400);
          break;
        case 401:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error401);
          break;
        case 404:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error404_child);
          break;
        case 408:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error408);
          break;
        case 503:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error503);
          break;
        default:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error500);
          break;
      }
    }
  }
}

class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAnimalId = ref.watch(childUpdateProvider).favAnimal;
    final selectedColorId = ref.watch(childUpdateProvider).favColour;
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
                backgroundColor: ColorSeed.fromId(selectedColorId).color),
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
                    backgroundImage: AssetImage(
                        AvatarAnimal.fromId(selectedAnimalId).imagePath),
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
              ref
                  .read(themeNotifierProvider.notifier)
                  .updateThemeColor(itemColorSeed.color);
              ref
                  .read(childUpdateProvider.notifier)
                  .updateFavColour(itemColorSeed.id);
            },
            child: Text(itemColorSeed.getColorName(context)),
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
    final selectedAnimalId = ref.watch(childUpdateProvider).favAnimal;
    final selectedAnimal = AvatarAnimal.fromId(selectedAnimalId);
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
              children: AvatarAnimal.values.map((AvatarAnimal avatar) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: selectedAnimal == avatar
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.5,
                          ),
                        )
                      : null,
                  child: CircleAvatar(
                      radius: selectedAnimal == avatar ? 60 : 48,
                      backgroundImage: AssetImage(avatar.imagePath),
                      child: Material(
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => {
                            ref
                                .read(childUpdateProvider.notifier)
                                .updateFavAnimal(avatar.id)
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
