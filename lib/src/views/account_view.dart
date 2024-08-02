import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/api/user_api.dart';
import 'package:math_assessment/src/data/models/country_key.dart';
import 'package:math_assessment/src/data/models/user_models.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';
import 'package:math_assessment/src/utils/helper_functions.dart';
import 'package:math_assessment/src/views/login_view.dart';

final isSigningUpProvider = StateProvider<bool>(
  (ref) => false,
);

class AccountView extends ConsumerWidget {
  AccountView({super.key});

  static const routeName = '/account';
  final _formKey = GlobalKey<FormState>();
  final fieldMargin = const EdgeInsets.symmetric(horizontal: 20, vertical: 4);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CountryKey> countries = CountryKey.getAllCountries(context);
    CountryKey? selectedCountry;
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();

    void submitForm() async {
      ref.read(isSigningUpProvider.notifier).state = true;
      var newUser = UserCreate(
          email: emailController.text,
          password: passwordController.text,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          country: selectedCountry!.countryKeyCode,
          isAdmin: false);
      final result = await signUpUser(newUser);
      final status = result['status'];

      ref.read(isSigningUpProvider.notifier).state = false;
      if (context.mounted) {
        switch (status) {
          case 201:
            HelperFunctions.showSnackBar(
                context, 2000, AppLocalizations.of(context)!.signUpSuccess);
            Navigator.pop(context);
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
                            'Account Details',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        const Spacer(),
                        // FIRST NAME AND EMAIL ADDRESS
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
                              ),
                            )),
                            Flexible(
                              child: Container(
                                margin: fieldMargin,
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText:
                                        AppLocalizations.of(context)!.country,
                                  ),
                                  validator: (value) => value == null
                                      ? AppLocalizations.of(context)!.emptyField
                                      : null,
                                  onChanged: (CountryKey? country) {
                                    selectedCountry = country;
                                  },
                                  items: countries
                                      .map<DropdownMenuItem<CountryKey>>(
                                          (CountryKey country) {
                                    return DropdownMenuItem<CountryKey>(
                                        value: country,
                                        child: Text(country.translation));
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // LAST NAME AND PASSWORD
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
                              ),
                            )),
                          ],
                        ),
                        const Spacer(),
                        // BUTTONS
                        Consumer(builder: (context, ref, _) {
                          return ref.watch(isSigningUpProvider)
                              ? const CircularProgressIndicator()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 4),
                                        child: Consumer(
                                            builder: (context, ref, _) {
                                          return OutlinedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .editPassword)));
                                        }),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 4),
                                        child: Consumer(
                                            builder: (context, ref, _) {
                                          return OutlinedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .saveChanges)));
                                        }),
                                      ),
                                    ),
                                  ],
                                );
                        }),
                        Consumer(builder: (context, ref, _) {
                          return ref.watch(isSigningUpProvider)
                              ? const CircularProgressIndicator()
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
                                        child: OutlinedButton(
                                            onPressed: () {
                                              ref
                                                  .read(selectedChildProvider
                                                      .notifier)
                                                  .state = null;
                                              ref
                                                  .read(userStateProvider
                                                      .notifier)
                                                  .logout();
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
                                        child: OutlinedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .deleteAccount)),
                                      ),
                                    ),
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
}
