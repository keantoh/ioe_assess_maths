import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/models/user.dart';
import 'package:assess_math/src/services/user_service.dart';

class UserRepository {
  final UserService _userService;
  UserLoginState? _userLoginState;
  String _token = '';

  UserRepository(this._userService);

  UserLoginState? get userLoginState => _userLoginState;
  String get token => _token;

  Future<Map<String, dynamic>> signUpUser(UserCreate user) async {
    final result = await _userService.signUpUserService(user);
    if (result['status'] == 201) {
      _token = result['response']['token'];
      _userLoginState = UserLoginState.fromJson(result['response']);
    }
    return result;
  }

  Future<Map<String, dynamic>> loginUser(UserLogin user) async {
    final result = await _userService.loginUserService(user);
    if (result['status'] == 200) {
      _token = result['response']['token'];
      _userLoginState = UserLoginState.fromJson(result['response']);
    }
    return result;
  }

  Future<Map<String, dynamic>> validateToken(String token) async {
    final result = await _userService.validateTokenService(token);
    if (result['status'] == 200) {
      _token = token;
      _userLoginState = UserLoginState.fromJson(result['response']);
    }
    return result;
  }

  Future<Map<String, dynamic>> updateUserDetails(
      String userId, UserUpdate user, String token) async {
    final result =
        await _userService.updateUserDetailsService(userId, user, token);
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
    _token = '';
    _userLoginState = null;
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userService = ref.watch(userServiceProvider);
  return UserRepository(userService);
});
