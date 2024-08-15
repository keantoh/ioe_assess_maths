import 'package:collection/collection.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:math_assessment/src/api/user_api.dart';
import 'package:math_assessment/src/data/models/country_key.dart';
import 'package:math_assessment/src/data/models/user_models.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/notifiers/token_state_provider.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';
import 'package:math_assessment/src/notifiers/user_update_notifier.dart';
import 'package:math_assessment/src/utils/helper_functions.dart';
import 'package:math_assessment/src/views/change_password_dialog.dart';
import 'package:math_assessment/src/views/delete_account_dialog.dart';
import 'package:math_assessment/src/views/login_view.dart';

final isUpdatingProvider = StateProvider<bool>(
  (ref) => false,
);

class AccountView extends HookConsumerWidget {
  AccountView({super.key});

  static const routeName = '/account';
  final _formKey = GlobalKey<FormState>();
  final fieldMargin = const EdgeInsets.symmetric(horizontal: 20, vertical: 4);

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangePasswordDialog();
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteAccountDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userUpdateNotifier = ref.watch(userUpdateProvider.notifier);
    final userUpdateDetails = ref.watch(userUpdateProvider);

    final List<CountryKey> countries =
        useMemoized(() => CountryKey.getAllCountries(context));
    final emailController =
        useTextEditingController(text: userUpdateDetails.email);
    final firstNameController =
        useTextEditingController(text: userUpdateDetails.firstName);
    final lastNameController =
        useTextEditingController(text: userUpdateDetails.lastName);

    Future<void> handleUpdate(BuildContext context, WidgetRef ref) async {
      if (_formKey.currentState!.validate()) {
        final newDetails = userUpdateDetails;

        await submitUpdate(context, ref, newDetails);
      }
    }

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
                            AppLocalizations.of(context)!.myAccount,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        const Spacer(),
                        // FIRST NAME AND COUNTRY
                        Row(
                          children: [
                            Flexible(
                                child: Container(
                              margin: fieldMargin,
                              child: TextFormField(
                                controller: firstNameController,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText:
                                      AppLocalizations.of(context)!.firstName,
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .emptyField;
                                  }
                                  return null;
                                },
                                onChanged: (value) =>
                                    userUpdateNotifier.updateFirstName(value),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20)
                                ],
                              ),
                            )),
                            Flexible(
                              child: Container(
                                margin: fieldMargin,
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  isDense: false,
                                  value: countries.firstWhereOrNull((country) =>
                                      country.countryKeyCode ==
                                      userUpdateDetails.country),
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText:
                                        AppLocalizations.of(context)!.country,
                                  ),
                                  validator: (value) => value == null
                                      ? AppLocalizations.of(context)!.emptyField
                                      : null,
                                  onChanged: (CountryKey? country) {
                                    if (country != null) {
                                      userUpdateNotifier.updateCountry(
                                          country.countryKeyCode);
                                    }
                                  },
                                  items: countries
                                      .map<DropdownMenuItem<CountryKey>>(
                                          (CountryKey country) {
                                    return DropdownMenuItem<CountryKey>(
                                        value: country,
                                        child: Text(country.translation));
                                  }).toList(),
                                  selectedItemBuilder: (BuildContext context) {
                                    return countries
                                        .map<Widget>((CountryKey country) {
                                      return Text(
                                        country.translation,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        // LAST NAME AND EMAIL
                        Row(
                          children: [
                            Flexible(
                                child: Container(
                              margin: fieldMargin,
                              child: TextFormField(
                                controller: lastNameController,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText:
                                      AppLocalizations.of(context)!.lastName,
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .emptyField;
                                  }
                                  return null;
                                },
                                onChanged: (value) =>
                                    userUpdateNotifier.updateLastName(value),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20)
                                ],
                              ),
                            )),
                            Flexible(
                                child: Container(
                              margin: fieldMargin,
                              child: TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: AppLocalizations.of(context)!
                                      .emailAddress,
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .emptyField;
                                  }
                                  if (!EmailValidator.validate(text)) {
                                    return AppLocalizations.of(context)!
                                        .invalidEmail;
                                  }
                                  return null;
                                },
                                onChanged: (value) =>
                                    userUpdateNotifier.updateEmail(value),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                              ),
                            )),
                          ],
                        ),
                        const Spacer(),
                        // BUTTONS
                        ref.watch(isUpdatingProvider)
                            ? const Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: CircularProgressIndicator())
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: OutlinedButton(
                                          onPressed: () {
                                            _showChangePasswordDialog(context);
                                          },
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .changePassword))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: FilledButton(
                                          onPressed: userUpdateNotifier
                                                  .hasChanges
                                              ? () {
                                                  handleUpdate(context, ref);
                                                }
                                              : null,
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .saveChanges))),
                                    ),
                                  ),
                                ],
                              ),
                        ref.watch(isUpdatingProvider)
                            ? const SizedBox.shrink()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 4),
                                      child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .back)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 4),
                                      child: FilledButton(
                                          onPressed: () {
                                            ref
                                                .read(selectedChildProvider
                                                    .notifier)
                                                .state = null;
                                            ref
                                                .read(
                                                    userStateProvider.notifier)
                                                .logout();
                                            final tokenManager =
                                                ref.read(tokenManagerProvider);
                                            tokenManager.deleteToken();
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginView()),
                                                    ModalRoute.withName('/'));
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .logOut)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 4),
                                      child: FilledButton(
                                          onPressed: () =>
                                              _showDeleteAccountDialog(context),
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
                                                .deleteAccount,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    ),
                                  ),
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

  Future<void> submitUpdate(
      BuildContext context, WidgetRef ref, UserUpdate newDetails) async {
    final userId = ref.read(userStateProvider)?.userId;
    if (userId == null) {
      HelperFunctions.showSnackBar(
          context, 2000, AppLocalizations.of(context)!.userIdNull);
      return;
    }
    ref.read(isUpdatingProvider.notifier).state = true;

    final result = await updateUserDetails(userId, newDetails);
    final status = result['status'];

    ref.read(isUpdatingProvider.notifier).state = false;
    if (context.mounted) {
      switch (status) {
        case 200:
          HelperFunctions.showSnackBar(context, 2000,
              AppLocalizations.of(context)!.updateDetailsSuccess);
          ref.read(userStateProvider.notifier).updateUserDetails(newDetails);

          break;
        case 400:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error400);
          break;
        case 408:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error408);
          break;
        case 409:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error409_signup);
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
