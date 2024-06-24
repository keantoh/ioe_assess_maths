import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/country_key.dart';
import 'package:math_assessment/src/utils/helper_functions.dart';

import '../settings/settings_view.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});

  static const routeName = '/signup';
  final _formKey = GlobalKey<FormState>();
  final fieldMargin = const EdgeInsets.symmetric(horizontal: 20, vertical: 4);

  @override
  Widget build(BuildContext context) {
    List<CountryKey> countries = CountryKey.getAllCountries(context);
    CountryKey? selectedCountry;
    final passwordController = TextEditingController();

    void submitForm() {
      if (selectedCountry == null) {
        HelperFunctions.showSnackBar(
            context, 2000, 'Please select your country.');
        return;
      }

      // Form validation successful, update global state
      // context.read(formSubmitProvider).state = email;

      HelperFunctions.showSnackBar(context, 2000, 'Form submitted');
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings),
        onPressed: () {
          Navigator.restorablePushNamed(context, SettingsView.routeName);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SIGNUP", // Replace with your localized string
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                // FIRST NAME AND EMAIL ADDRESS
                Row(
                  children: [
                    Flexible(
                        child: Container(
                      margin: fieldMargin,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.firstName,
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return AppLocalizations.of(context)!.emptyField;
                          }
                          return null;
                        },
                      ),
                    )),
                    Flexible(
                        child: Container(
                      margin: fieldMargin,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.emailAddress,
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return AppLocalizations.of(context)!.emptyField;
                          }
                          if (!EmailValidator.validate(text)) {
                            return AppLocalizations.of(context)!.invalidEmail;
                          }
                          return null;
                        },
                      ),
                    )),
                  ],
                ),
                // LAST NAME AND PASSWORD
                Row(
                  children: [
                    Flexible(
                        child: Container(
                      margin: fieldMargin,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.lastName,
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return AppLocalizations.of(context)!.emptyField;
                          }
                          return null;
                        },
                      ),
                    )),
                    Flexible(
                        child: Container(
                      margin: fieldMargin,
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.password,
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return AppLocalizations.of(context)!.emptyField;
                          }
                          if (text.length < 6) {
                            return AppLocalizations.of(context)!.weakPassword;
                          }
                          return null;
                        },
                      ),
                    )),
                  ],
                ),
                // COUNTRY AND CONFIRM PASSWORD
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: fieldMargin,
                        child: DropdownMenu<CountryKey>(
                          initialSelection: selectedCountry,
                          expandedInsets: const EdgeInsets.all(0),
                          requestFocusOnTap: true,
                          label: Text(AppLocalizations.of(context)!.country),
                          onSelected: (CountryKey? country) {
                            selectedCountry = country;
                          },
                          dropdownMenuEntries: countries
                              .map<DropdownMenuEntry<CountryKey>>(
                                  (CountryKey country) {
                            return DropdownMenuEntry<CountryKey>(
                                value: country, label: country.translation);
                          }).toList(),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      margin: fieldMargin,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText:
                              AppLocalizations.of(context)!.confirmPassword,
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return AppLocalizations.of(context)!.emptyField;
                          }
                          if (text != passwordController.text) {
                            return AppLocalizations.of(context)!
                                .mismatchPassword;
                          }
                          return null;
                        },
                      ),
                    )),
                  ],
                ),
                // BUTTONS
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
                                    Text(AppLocalizations.of(context)!.login)));
                      }),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 12),
                      child: Consumer(builder: (context, ref, _) {
                        bool isLoading = false;
                        return isLoading
                            ? const CircularProgressIndicator()
                            : FilledButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    submitForm();
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: Text(
                                        AppLocalizations.of(context)!.signup)));
                      }),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
