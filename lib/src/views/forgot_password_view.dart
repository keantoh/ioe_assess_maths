import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:math_assessment/src/api/user_api.dart';
import 'package:math_assessment/src/data/models/user_models.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';
import 'package:math_assessment/src/utils/helper_functions.dart';

final isUpdatingProvider = StateProvider<bool>(
  (ref) => false,
);

class ForgotPasswordView extends HookConsumerWidget {
  ForgotPasswordView({super.key});

  static const routeName = '/forgotpassword';
  final _emailFormKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final fieldMargin = const EdgeInsets.symmetric(horizontal: 20, vertical: 4);

  void _sendResetToken(BuildContext context) {
    if (_emailFormKey.currentState!.validate()) {
      // send token
    }
  }

  void _updatePassword(BuildContext context) {
    if (_emailFormKey.currentState!.validate() &&
        _formKey.currentState!.validate()) {
      // update pw
    }
  }

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
                                        onPressed: () =>
                                            _sendResetToken(context),
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
                                          _updatePassword(context);
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
