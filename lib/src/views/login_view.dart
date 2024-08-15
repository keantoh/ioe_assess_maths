import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/api/user_api.dart';
import 'package:math_assessment/src/data/models/user_models.dart';
import 'package:math_assessment/src/notifiers/token_state_provider.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';
import 'package:math_assessment/src/utils/helper_functions.dart';
import 'package:math_assessment/src/views/child_select_view.dart';
import 'package:math_assessment/src/views/forgot_password_view.dart';
import 'package:math_assessment/src/views/settings_view.dart';
import 'package:math_assessment/src/views/sign_up_view.dart';

final isLoggingInProvider = StateProvider<bool>(
  (ref) => false,
);

class LoginView extends StatelessWidget {
  LoginView({super.key});

  static const routeName = '/login';
  final _formKey = GlobalKey<FormState>();
  final fieldMargin = const EdgeInsets.symmetric(horizontal: 32, vertical: 8);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Future<void> submitForm(WidgetRef ref) async {
      ref.read(isLoggingInProvider.notifier).state = true;
      var newUser = UserLogin(
          email: emailController.text, password: passwordController.text);
      final result = await loginUser(newUser);
      final status = result['status'];

      ref.read(isLoggingInProvider.notifier).state = false;
      if (context.mounted) {
        switch (status) {
          case 200:
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
                              AppLocalizations.of(context)!.appTitle,
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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                          ),
                        ),
                        Container(
                          margin: fieldMargin,
                          child: TextFormField(
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
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 60, vertical: 12),
                                      child:
                                          Consumer(builder: (context, ref, _) {
                                        return OutlinedButton(
                                            onPressed: () {
                                              Navigator.restorablePushNamed(
                                                  context,
                                                  SignUpView.routeName);
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 40),
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .signUp)));
                                      }),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 60, vertical: 12),
                                      child: FilledButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              submitForm(ref);
                                            }
                                          },
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40),
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .logIn))),
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
}
