import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:assess_math/src/models/user.dart';
import 'package:assess_math/src/notifiers/reset_password_notifier.dart';
import 'package:assess_math/src/utils/helper_functions.dart';

final isUpdatingProvider = StateProvider<bool>(
  (ref) => false,
);

class ForgotPasswordView extends HookConsumerWidget {
  ForgotPasswordView({super.key});

  static const routeName = '/forgotpassword';
  final _emailFormKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final fieldMargin = const EdgeInsets.symmetric(horizontal: 20, vertical: 4);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final tokenController = useTextEditingController();

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
                            AppLocalizations.of(context)!.forgotPassword,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        const Spacer(),
                        // EMAIL AND TOKEN BUTTON
                        Row(
                          children: [
                            Flexible(
                                child: Container(
                              margin: fieldMargin,
                              child: Form(
                                key: _emailFormKey,
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
                              ),
                            )),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 60),
                                child: ref.watch(isUpdatingProvider)
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : FilledButton(
                                        onPressed: () => _sendResetToken(
                                            context, ref, emailController.text),
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .sendToken))),
                              ),
                            ),
                          ],
                        ),
                        // NEW PASSWORD and CONFIRM PASSWORD
                        Row(
                          children: [
                            Flexible(
                                child: Container(
                              margin: fieldMargin,
                              child: TextFormField(
                                controller: newPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText:
                                      AppLocalizations.of(context)!.newPassword,
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
                            Flexible(
                                child: Container(
                              margin: fieldMargin,
                              child: TextFormField(
                                controller: confirmPasswordController,
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
                                  if (text != newPasswordController.text) {
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
                        // TOKEN and UPDATE BUTTON
                        Row(
                          children: [
                            Flexible(
                                child: Container(
                              margin: fieldMargin,
                              child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(8)
                                ],
                                controller: tokenController,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText:
                                      AppLocalizations.of(context)!.resetToken,
                                ),
                                validator: (text) {
                                  if (text == null || text.length < 8) {
                                    return AppLocalizations.of(context)!
                                        .invalidToken;
                                  }
                                  return null;
                                },
                              ),
                            )),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 60),
                                child: ref.watch(isUpdatingProvider)
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : FilledButton(
                                        onPressed: () {
                                          final user = UserPasswordUpdate(
                                              email: emailController.text,
                                              token: tokenController.text,
                                              newPassword:
                                                  newPasswordController.text);
                                          _updatePassword(context, ref, user);
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .updatePassword)),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ref.watch(isUpdatingProvider)
                            ? const CircularProgressIndicator()
                            : Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 4),
                                child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: Text(
                                          AppLocalizations.of(context)!.back),
                                    )),
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

  Future<void> _sendResetToken(
      BuildContext context, WidgetRef ref, String email) async {
    if (_emailFormKey.currentState!.validate()) {
      ref.read(isUpdatingProvider.notifier).state = true;

      await ref.read(resetPasswordProvider.notifier).sendPasswordToken(email);
      final responseCode = ref.read(resetPasswordResponseCodeProvider);

      ref.read(isUpdatingProvider.notifier).state = false;
      if (context.mounted) {
        switch (responseCode) {
          case 200:
            HelperFunctions.showSnackBar(context, 2000,
                AppLocalizations.of(context)!.passwordTokenSuccess);
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

  Future<void> _updatePassword(
      BuildContext context, WidgetRef ref, UserPasswordUpdate user) async {
    if (_emailFormKey.currentState!.validate() &&
        _formKey.currentState!.validate()) {
      ref.read(isUpdatingProvider.notifier).state = true;

      await ref.read(resetPasswordProvider.notifier).updateUserPassword(user);
      final responseCode = ref.read(resetPasswordResponseCodeProvider);

      ref.read(isUpdatingProvider.notifier).state = false;
      if (context.mounted) {
        switch (responseCode) {
          case 200:
            HelperFunctions.showSnackBar(context, 2000,
                AppLocalizations.of(context)!.changedPasswordSuccess);
            Navigator.of(context).pop();
            break;
          case 400:
            HelperFunctions.showSnackBar(
                context, 2000, AppLocalizations.of(context)!.error400);
            break;
          case 401:
            HelperFunctions.showSnackBar(context, 2000,
                AppLocalizations.of(context)!.error401_updatePassword);
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
}
