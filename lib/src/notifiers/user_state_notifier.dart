import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/user_models.dart';
import 'package:math_assessment/src/views/child_select_view.dart';
import 'package:math_assessment/src/views/login_view.dart';

final userStateProvider =
    StateNotifierProvider<UserStateNotifier, UserLoginState?>(
        (ref) => UserStateNotifier());

class UserStateNotifier extends StateNotifier<UserLoginState?> {
  UserStateNotifier() : super(null);
  void setUserLoginState(UserLoginState newState, BuildContext context) {
    state = newState;
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, ChildSelectView.routeName);
    }
  }

  void logout({required BuildContext context}) {
    state = null;
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginView()),
        ModalRoute.withName('/'),
      );
    }
  }
}
