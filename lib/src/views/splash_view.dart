import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/notifiers/token_state_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:math_assessment/src/views/child_select_view.dart';
import 'package:math_assessment/src/views/login_view.dart';

class SplashView extends ConsumerStatefulWidget {
  static const routeName = '/';
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
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
      _navigateToHome();
      // final isValid = await _validateToken(token);
      // if (isValid) {
      //   _navigateToHome();
      // } else {
      //   _navigateToLogin();
      // }
    }
  }

  Future<bool> _validateToken(String token) async {
    final response = await http.get(
      Uri.parse('http://your-api-url/validate-token'),
      headers: {'Authorization': 'Bearer $token'},
    );

    // ref.read(userStateProvider.notifier).setUserLoginState(
    //     UserLoginState.fromJson(result['response']), context);
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['valid'];
    } else {
      return false;
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, ChildSelectView.routeName);

    // Navigator.of(context).pushReplacementNamed('/home');
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
