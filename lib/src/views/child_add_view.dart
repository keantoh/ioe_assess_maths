import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:assess_math/src/models/avatar_animal.dart';
import 'package:assess_math/src/models/avatar_color.dart';
import 'package:assess_math/src/models/child.dart';
import 'package:assess_math/src/models/gender.dart';
import 'package:assess_math/src/notifiers/children_state_notifier.dart';
import 'package:assess_math/src/notifiers/user_state_notifier.dart';
import 'package:assess_math/src/utils/helper_functions.dart';
import 'package:assess_math/src/views/settings_view.dart';

final isAddingChildProvider = StateProvider<bool>(
  (ref) => false,
);

final animalProvider = StateProvider<AvatarAnimal>(
  (ref) => AvatarAnimal.values[0],
);

final colorProvider = StateProvider<ColorSeed>(
  (ref) => ColorSeed.values[0],
);

AvatarAnimal selectedAnimal = AvatarAnimal.values.first;

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
  DateTime? selectedDob;

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final dobController = TextEditingController();
    final localeName = AppLocalizations.of(context)?.localeName ?? 'en';

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
                                      key: const Key('add_child_name_field'),
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
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(20)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: fieldMargin,
                                    child: DropdownButtonFormField(
                                      key: const Key('add_child_gender_field'),
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
                                      onChanged: (Gender? gender) {
                                        selectedGender = gender;
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
                                  Container(
                                    margin: fieldMargin,
                                    child: TextFormField(
                                      key: const Key('add_child_dob_field'),
                                      controller: dobController,
                                      onTap: () async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        final date = await showDatePicker(
                                            context: context,
                                            initialDate: selectedDob,
                                            firstDate: DateTime(
                                                DateTime.now().year - 20),
                                            lastDate: DateTime.now());
                                        if (date != null) {
                                          selectedDob = date;
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
                        Consumer(builder: (context, ref, _) {
                          return ref.watch(isAddingChildProvider)
                              ? const CircularProgressIndicator()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 60),
                                      child:
                                          Consumer(builder: (context, ref, _) {
                                        return OutlinedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 40),
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .back)));
                                      }),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 60),
                                      child: FilledButton(
                                          key: const Key(
                                              'add_child_add_child_button'),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              submitForm(
                                                  ref,
                                                  nameController,
                                                  selectedGender,
                                                  selectedDob,
                                                  localeName,
                                                  context);
                                            }
                                          },
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40),
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .addChild))),
                                    )
                                  ],
                                );
                        }),
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

  Future<void> submitForm(
      WidgetRef ref,
      TextEditingController nameController,
      Gender? selectedGender,
      DateTime? selectedDob,
      String localeName,
      BuildContext context) async {
    ref.read(isAddingChildProvider.notifier).state = true;
    var newChild = ChildCreate(
        parentId: ref.read(userStateProvider)!.userId,
        name: nameController.text,
        gender: selectedGender!.name,
        dob: selectedDob!,
        favColour: ref.read(colorProvider.notifier).state.id,
        favAnimal: ref.read(animalProvider.notifier).state.id);

    await ref.read(childrenStateProvider.notifier).addChild(newChild);

    final responseCode = ref.read(childrenResponseCodeProvider);
    ref.read(isAddingChildProvider.notifier).state = false;

    if (context.mounted) {
      switch (responseCode) {
        case 201:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.childAddSuccess);
          Navigator.pop(context);
          break;
        case 400:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error400);
          break;
        case 404:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error404_login);
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
    final selectedAnimal = ref.watch(animalProvider);
    final selectedColorSeed = ref.watch(colorProvider);
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
                    backgroundImage: AssetImage(selectedAnimal.imagePath),
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
              ref.read(colorProvider.notifier).state = itemColorSeed;
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
    final selectedAnimal = ref.watch(animalProvider);
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
                            ref.read(animalProvider.notifier).state = avatar
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
