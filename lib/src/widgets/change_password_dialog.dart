import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:assess_math/src/models/user.dart';
import 'package:assess_math/src/notifiers/user_state_notifier.dart';
import 'package:assess_math/src/utils/helper_functions.dart';

final isChangingProvider = StateProvider<bool>(
  (ref) => false,
);

class ChangePasswordDialog extends HookConsumerWidget {
  ChangePasswordDialog({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPasswordController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final confirmNewPasswordController = useTextEditingController();

    Future<void> handleChangePasswordConfirm(BuildContext dialogContext) async {
      ref.read(isChangingProvider.notifier).state = true;
      final userPasswordChange = UserPasswordChange(
          password: currentPasswordController.text,
          newPassword: newPasswordController.text);
      final userId = ref.read(userStateProvider)?.userId;
      if (userId == null) {
        HelperFunctions.showSnackBar(dialogContext, 2000,
            AppLocalizations.of(dialogContext)!.userIdNull);
        return;
      }

      await ref
          .read(userStateProvider.notifier)
          .changeUserPassword(userId, userPasswordChange);
      final responseCode = ref.read(userStateResponseCodeProvider);

      ref.read(isChangingProvider.notifier).state = false;
      if (dialogContext.mounted) {
        switch (responseCode) {
          case 200:
            Navigator.of(dialogContext).pop();
            HelperFunctions.showSnackBar(context, 2000,
                AppLocalizations.of(context)!.changedPasswordSuccess);
            break;
          case 400:
            HelperFunctions.showSnackBar(
                dialogContext, 2000, AppLocalizations.of(context)!.error400);
            break;
          case 401:
            HelperFunctions.showSnackBar(
                dialogContext, 2000, AppLocalizations.of(context)!.error401);
            break;
          case 404:
            HelperFunctions.showSnackBar(
                dialogContext, 2000, AppLocalizations.of(context)!.error404);
            break;
          case 408:
            HelperFunctions.showSnackBar(
                dialogContext, 2000, AppLocalizations.of(context)!.error408);
            break;
          case 503:
            HelperFunctions.showSnackBar(
                dialogContext, 2000, AppLocalizations.of(context)!.error503);
            break;
          default:
            HelperFunctions.showSnackBar(
                dialogContext, 2000, AppLocalizations.of(context)!.error500);
            break;
        }
      }
    }

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ScaffoldMessenger(
        child: Builder(builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: TextFormField(
                          controller: currentPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                AppLocalizations.of(context)!.currentPassword,
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
                        margin: const EdgeInsets.symmetric(vertical: 6),
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
                              return AppLocalizations.of(context)!.emptyField;
                            }
                            if (text.length < 6) {
                              return AppLocalizations.of(context)!.weakPassword;
                            }
                            return null;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: TextFormField(
                          controller: confirmNewPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                AppLocalizations.of(context)!.confirmPassword,
                          ),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return AppLocalizations.of(context)!.emptyField;
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
                      ),
                      ref.watch(isChangingProvider)
                          ? const Padding(
                              padding:
                                  EdgeInsets.only(left: 36, right: 36, top: 20),
                              child: CircularProgressIndicator())
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 36, right: 36, top: 20),
                                    child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .cancel)),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 36, right: 36, top: 20),
                                    child: FilledButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            handleChangePasswordConfirm(
                                                context);
                                          }
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .changePassword,
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
          );
        }),
      ),
    );
  }
}
