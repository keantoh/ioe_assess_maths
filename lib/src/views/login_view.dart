import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/user_state.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';
import 'package:math_assessment/src/utils/helper_functions.dart';
import 'package:math_assessment/src/views/sign_up_view.dart';

import '../settings/settings_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  static const routeName = '/login';
  final _formKey = GlobalKey<FormState>();
  final fieldMargin = const EdgeInsets.symmetric(horizontal: 32, vertical: 8);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    void submitForm(WidgetRef ref) {
      HelperFunctions.showSnackBar(context, 2000, 'Form submitted');
      ref
          .read(userStateProvider.notifier)
          .login(email: 'default.com', password: 'password', context: context);
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
                        Expanded(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .appTitle, // Replace with your localized string
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ),
                        Container(
                          margin: fieldMargin,
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText:
                                  AppLocalizations.of(context)!.emailAddress,
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return AppLocalizations.of(context)!.emptyField;
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
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
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            child: Text(
                                AppLocalizations.of(context)!.forgotPassword),
                            onPressed: () {},
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 12),
                                child: Consumer(builder: (context, ref, _) {
                                  return OutlinedButton(
                                      onPressed: () {
                                        Navigator.restorablePushNamed(
                                            context, SignUpView.routeName);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40),
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .signUp)));
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
                                            submitForm(ref);
                                            if (_formKey.currentState!
                                                .validate()) {}
                                          },
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40),
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .logIn)));
                                }),
                              )
                            ],
                          ),
                        ),
                        const Center(
                            child: Text(
                                "By continuing, you agree to our terms of service and privacy policy.")),
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

// class LoginButton extends ConsumerWidget {
//   const LoginButton({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userState = ref.watch(userStateProvider);
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 40),
//       child: Consumer(builder: (context, ref, _) {
//         bool isLoading = userState.isLoading;
//         return isLoading
//             ? const CircularProgressIndicator()
//             : FilledButton(
//                 onPressed: () {
//                   ref.read(userStateProvider.notifier).login(
//                       email: 'default.com',
//                       password: 'password',
//                       context: context);
//                 },
//                 child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: Text(AppLocalizations.of(context)!.logIn)));
//       }),
//     );
//   }
// }
