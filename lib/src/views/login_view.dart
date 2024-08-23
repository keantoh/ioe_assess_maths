import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/models/user.dart';
import 'package:assess_math/src/notifiers/user_state_notifier.dart';
import 'package:assess_math/src/utils/helper_functions.dart';
import 'package:assess_math/src/views/child_select_view.dart';
import 'package:assess_math/src/views/forgot_password_view.dart';
import 'package:assess_math/src/views/settings_view.dart';
import 'package:assess_math/src/views/sign_up_view.dart';

final isLoggingInProvider = StateProvider<bool>(
  (ref) => false,
);

class LoginView extends StatelessWidget {
  LoginView({super.key});

  static const routeName = '/login';
  final _formKey = GlobalKey<FormState>();
  final fieldMargin = const EdgeInsets.symmetric(horizontal: 20, vertical: 4);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.appTitle,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ),
                        Container(
                          margin: fieldMargin,
                          child: TextFormField(
                            key: const Key('log_in_email_field'),
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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                          ),
                        ),
                        Container(
                          margin: fieldMargin,
                          child: TextFormField(
                            key: const Key('log_in_password_field'),
                            controller: passwordController,
                            obscureText: true,
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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            child: Text(
                                AppLocalizations.of(context)!.forgotPassword),
                            onPressed: () => Navigator.restorablePushNamed(
                                context, ForgotPasswordView.routeName),
                          ),
                        ),
                        Center(child: Consumer(builder: (context, ref, _) {
                          return ref.watch(isLoggingInProvider)
                              ? const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator())
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 60, vertical: 8),
                                        child: Consumer(
                                            builder: (context, ref, _) {
                                          return OutlinedButton(
                                              onPressed: () {
                                                Navigator.restorablePushNamed(
                                                    context,
                                                    SignUpView.routeName);
                                              },
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .signUp));
                                        }),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 60, vertical: 8),
                                        child: FilledButton(
                                            key: const Key(
                                                'log_in_log_in_button'),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                submitForm(
                                                    context,
                                                    ref,
                                                    emailController,
                                                    passwordController);
                                              }
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .logIn)),
                                      ),
                                    )
                                  ],
                                );
                        })),
                        Center(
                            child: Text(AppLocalizations.of(context)!
                                .privacyPolicyStatement)),
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
      BuildContext context,
      WidgetRef ref,
      TextEditingController emailController,
      TextEditingController passwordController) async {
    ref.read(isLoggingInProvider.notifier).state = true;
    var user = UserLogin(
        email: emailController.text, password: passwordController.text);

    await ref.read(userStateProvider.notifier).loginUser(user);
    final responseCode = ref.read(userStateResponseCodeProvider);

    ref.read(isLoggingInProvider.notifier).state = false;
    if (context.mounted) {
      switch (responseCode) {
        case 200:
          Navigator.pushReplacementNamed(context, ChildSelectView.routeName);
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
