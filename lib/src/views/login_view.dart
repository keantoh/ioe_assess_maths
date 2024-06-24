import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/user_state.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';
import 'package:math_assessment/src/views/sign_up_view.dart';

import '../settings/settings_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings),
        onPressed: () {
          Navigator.restorablePushNamed(context, SettingsView.routeName);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .appTitle, // Replace with your localized string
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ),
                const EmailInput(),
                const PasswordInput(),
                Container(
                  color: Colors.pink,
                  child: Center(
                      child:
                          Text(AppLocalizations.of(context)!.forgotPassword)),
                ),
                // Expanded(
                //   flex: 1,
                //   child: Container(
                //     color: Colors.blue,
                //     child: EmailInput(),
                //   ),
                // ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.green,
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [SignUpButton(), LoginButton()],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.brown,
                  child: const Center(child: Text("Agree to terms")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// child: SingleChildScrollView(
//   child: Container(
//     margin: const EdgeInsets.all(0),
//     child: Column(
//       children: [
//         Container(
//             padding: const EdgeInsets.all(18),
//             child: Center(
//                 child: Text(
//               AppLocalizations.of(context)!.appTitle,
//               style: Theme.of(context).textTheme.headlineMedium,
//             ))),
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: const Column(
//             children: [EmailInput(), EmailInput()],
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: const Column(
//             children: [LoginButton(), ForgotPasswordButton()],
//           ),
//         ),
//       ],
//     ),
//   ),
// ),

class EmailInput extends ConsumerWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: TextField(
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.emailAddress)));
  }
}

class PasswordInput extends ConsumerWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: TextField(
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.password)));
  }
}

class SignUpButton extends ConsumerWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: Consumer(builder: (context, ref, _) {
        bool isLoading = userState.isLoading;
        return FilledButton(
            onPressed: () {
              Navigator.restorablePushNamed(context, SignUpView.routeName);
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(AppLocalizations.of(context)!.signup)));
      }),
    );
  }
}

class LoginButton extends ConsumerWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: Consumer(builder: (context, ref, _) {
        bool isLoading = userState.isLoading;
        return isLoading
            ? const CircularProgressIndicator()
            : FilledButton(
                onPressed: () {
                  ref.read(userStateProvider.notifier).login(
                      email: 'default.com',
                      password: 'password',
                      context: context);
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(AppLocalizations.of(context)!.login)));
      }),
    );
  }
}

class ForgotPasswordButton extends ConsumerWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final userState = ref.watch(userStateProvider);
    return Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
            onPressed: () {},
            child: Text(AppLocalizations.of(context)!.forgotPassword)));
  }
}
