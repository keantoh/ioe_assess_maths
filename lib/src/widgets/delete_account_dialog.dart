import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:assess_math/src/models/user.dart';
import 'package:assess_math/src/notifiers/user_state_notifier.dart';
import 'package:assess_math/src/utils/helper_functions.dart';
import 'package:assess_math/src/views/login_view.dart';

final isDeletingProvider = StateProvider<bool>(
  (ref) => false,
);

class DeleteAccountDialog extends HookConsumerWidget {
  DeleteAccountDialog({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordController = useTextEditingController();

    Future<void> handleDeleteAccountConfirm(BuildContext dialogContext) async {
      ref.read(isDeletingProvider.notifier).state = true;
      final userId = ref.read(userStateProvider)?.userId;
      if (userId == null) {
        HelperFunctions.showSnackBar(dialogContext, 2000,
            AppLocalizations.of(dialogContext)!.userIdNull);
        return;
      }
      final userAccountDelete =
          UserAccountDelete(userId: userId, password: passwordController.text);

      await ref
          .read(userStateProvider.notifier)
          .deleteUserAccount(userAccountDelete);
      final responseCode = ref.read(userStateResponseCodeProvider);

      ref.read(isDeletingProvider.notifier).state = false;
      if (dialogContext.mounted) {
        switch (responseCode) {
          case 200:
            Navigator.of(dialogContext).pop();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginView()),
                ModalRoute.withName('/'));
            HelperFunctions.showSnackBar(context, 2000,
                AppLocalizations.of(context)!.deleteAccountSuccess);
            break;
          case 400:
            HelperFunctions.showSnackBar(
                dialogContext, 2000, AppLocalizations.of(context)!.error400);
            break;
          case 401:
            HelperFunctions.showSnackBar(dialogContext, 2000,
                AppLocalizations.of(context)!.error401_invalidPassword);
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ScaffoldMessenger(
        child: Builder(builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)!.deleteAccount,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .deleteAccountMessage,
                                )),
                            const Spacer(),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
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
                                  return null;
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                              ),
                            ),
                            const Spacer(),
                            ref.watch(isDeletingProvider)
                                ? const Padding(
                                    padding: EdgeInsets.only(
                                        left: 36, right: 36, top: 20),
                                    child: CircularProgressIndicator())
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                                  handleDeleteAccountConfirm(
                                                      context);
                                                }
                                              },
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
          );
        }),
      ),
    );
  }
}
