import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/api/user_api.dart';
import 'package:math_assessment/src/data/models/user_models.dart';
import 'package:math_assessment/src/notifiers/token_state_provider.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';
import 'package:math_assessment/src/views/child_select_view.dart';
import 'package:math_assessment/src/views/login_view.dart';

class SplashView extends ConsumerStatefulWidget {
  static const routeName = '/';

  const SplashView({super.key});
  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await ref.read(tokenStateProvider.future);
    if (token == null) {
      _navigateToLogin();
    } else {
      final result = await validateToken(token);
      final status = result['status'];
      if (status == 200 && mounted) {
        ref
            .read(userStateProvider.notifier)
            .setUserLoginState(UserLoginState.fromJson(result['response']));
        Navigator.pushReplacementNamed(context, ChildSelectView.routeName);
      } else {
        _navigateToLogin();
      }
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, LoginView.routeName);
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
