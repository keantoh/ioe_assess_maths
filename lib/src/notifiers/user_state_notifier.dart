import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/user.dart';

class UserStateNotifier extends StateNotifier<UserLoginState?> {
  UserStateNotifier() : super(null);

  void setUserLoginState(UserLoginState newState) {
    state = newState;
  }

  void logout() {
    state = null;
  }

  void updateUserDetails(UserUpdate updatedDetails) {
    if (state != null) {
      state = state!.copyWith(
        email: updatedDetails.email,
        firstName: updatedDetails.firstName,
        lastName: updatedDetails.lastName,
        country: updatedDetails.country,
      );
    }
  }
}

final userStateProvider =
    StateNotifierProvider<UserStateNotifier, UserLoginState?>(
        (ref) => UserStateNotifier());
