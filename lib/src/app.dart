import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/notifiers/theme_state_notifier.dart';
import 'package:assess_math/src/views/account_view.dart';
import 'package:assess_math/src/views/child_add_view.dart';
import 'package:assess_math/src/views/child_edit_view.dart';
import 'package:assess_math/src/views/child_select_view.dart';
import 'package:assess_math/src/views/forgot_password_view.dart';
import 'package:assess_math/src/views/home_view.dart';
import 'package:assess_math/src/views/login_view.dart';
import 'package:assess_math/src/views/question_view.dart';
import 'package:assess_math/src/views/settings_view.dart';
import 'package:assess_math/src/views/sign_up_view.dart';
import 'package:assess_math/src/views/splash_view.dart';
import 'package:assess_math/src/views/user_search_view.dart';

/// The Widget that configures your application.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeNotifierProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',

      // Provide the generated AppLocalizations to the MaterialApp. This
      // allows descendant Widgets to display the correct translations
      // depending on the user's locale.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],

      // The appTitle is defined in the localization directory.
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,

      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: themeSettings.themeColor,
              brightness: themeSettings.themeMode == ThemeMode.dark
                  ? Brightness.dark
                  : Brightness.light,
              dynamicSchemeVariant: DynamicSchemeVariant.fidelity)),

      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      home: const SplashView(),
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case SettingsView.routeName:
                return SettingsView();
              case ForgotPasswordView.routeName:
                return ForgotPasswordView();
              case LoginView.routeName:
                return LoginView();
              case SignUpView.routeName:
                return SignUpView();
              case HomeView.routeName:
                return const HomeView();
              case ChildSelectView.routeName:
                return const ChildSelectView();
              case ChildAddView.routeName:
                return const ChildAddView();
              case ChildEditView.routeName:
                return ChildEditView();
              case AccountView.routeName:
                return AccountView();
              case UserSearchView.routeName:
                return const UserSearchView();
              case QuestionView.routeName:
                return const QuestionView();
              default:
                return LoginView();
            }
          },
        );
      },
    );
  }
}
