import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/user_state.dart';
import 'package:math_assessment/src/services/auth_services.dart';
import 'package:math_assessment/src/views/home_view.dart';
import 'package:math_assessment/src/views/login_view.dart';

final userStateProvider = StateNotifierProvider<UserStateNotifier, UserState>(
    (ref) => UserStateNotifier(ref.watch(authServiceProvider)));

class UserStateNotifier extends StateNotifier<UserState> {
  final AuthServices _authServices;
  UserStateNotifier(this._authServices) : super(UserState());

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final userDetails = await _authServices.login(email, password);
      state = state.copyWith(userDetails: userDetails, isLoading: false);
      if (userDetails != null) {
        if (!context.mounted) return;
        Navigator.pushReplacementNamed(context, HomeView.routeName);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Handle error (show a snackbar, dialog, etc.)
    }
  }

  void logout({required BuildContext context}) {
    state = state.copyWith(userDetails: null);
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, LoginView.routeName);
  }
}
