import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/notifiers/user_state_notifier.dart';
import 'package:assess_math/src/views/child_select_view.dart';
import 'package:assess_math/src/views/login_view.dart';

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
    final isValidToken =
        await ref.read(userStateProvider.notifier).checkAndValidateToken();
    if (isValidToken && mounted) {
      Navigator.pushReplacementNamed(context, ChildSelectView.routeName);
    } else {
      _navigateToLogin();
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
