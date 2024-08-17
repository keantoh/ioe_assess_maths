import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/user.dart';
import 'package:math_assessment/src/services/user_service.dart';

class UserRepository {
  final UserService _userService;
  UserLoginState? _userLoginState;

  UserRepository(this._userService);

  UserLoginState? get userLoginState => _userLoginState;

  Future<Map<String, dynamic>> signUpUser(UserCreate user) async {
    final result = await _userService.signUpUserService(user);
    if (result['status'] == 201) {
      _userLoginState = UserLoginState.fromJson(result['response']);
    }
    return result;
  }

  Future<Map<String, dynamic>> loginUser(UserLogin user) async {
    final result = await _userService.loginUserService(user);
    if (result['status'] == 200) {
      _userLoginState = UserLoginState.fromJson(result['response']);
    }
    return result;
  }

  Future<Map<String, dynamic>> validateToken(String token) async {
    final result = await _userService.validateTokenService(token);
    if (result['status'] == 200) {
      _userLoginState = UserLoginState.fromJson(result['response']);
    }
    return result;
  }

  Future<Map<String, dynamic>> updateUserDetails(
      String userId, UserUpdate user) async {
    final result = await _userService.updateUserDetailsService(userId, user);
    if (result['status'] == 200 && _userLoginState != null) {
      _userLoginState = _userLoginState!.copyWith(
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        country: user.country,
      );
    }
    return result;
  }

  void logOut() {
    _userLoginState = null;
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userService = ref.watch(userServiceProvider);
  return UserRepository(userService);
});
