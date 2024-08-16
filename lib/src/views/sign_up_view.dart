import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/api/user_api.dart';
import 'package:math_assessment/src/models/country_key.dart';
import 'package:math_assessment/src/models/user.dart';
import 'package:math_assessment/src/notifiers/token_state_provider.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';
import 'package:math_assessment/src/utils/helper_functions.dart';
import 'package:math_assessment/src/views/child_select_view.dart';
import 'package:math_assessment/src/views/settings_view.dart';

final isSigningUpProvider = StateProvider<bool>(
  (ref) => false,
);

class SignUpView extends ConsumerWidget {
  SignUpView({super.key});

  static const routeName = '/signup';
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
            ref
                .read(userStateProvider.notifier)
                .setUserLoginState(UserLoginState.fromJson(result['response']));
            Navigator.pushReplacementNamed(context, ChildSelectView.routeName);
            final tokenManager = ref.read(tokenManagerProvider);
            await tokenManager.saveToken(result['response']['token']);
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
                            AppLocalizations.of(context)!.signUp,
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
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
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
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20)
                                ],
                              ),
                            )),
                            Flexible(
                                child: Container(
                              margin: fieldMargin,
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText:
                                      AppLocalizations.of(context)!.password,
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
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
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
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  isDense: false,
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
                            Expanded(
                                child: Container(
                              margin: fieldMargin,
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: AppLocalizations.of(context)!
                                      .confirmPassword,
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .emptyField;
                                  }
                                  if (text != passwordController.text) {
                                    return AppLocalizations.of(context)!
                                        .mismatchPassword;
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
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
                                                    .logIn)));
                                      }),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 60),
                                      child: FilledButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              submitForm();
                                            }
                                          },
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40),
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .signUp))),
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
}
