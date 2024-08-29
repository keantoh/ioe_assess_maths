import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/models/user.dart';
import 'package:assess_math/src/notifiers/token_state_provider.dart';
import 'package:assess_math/src/repositories/user_repository.dart';
import 'package:assess_math/src/services/user_service.dart';

class UserStateNotifier extends StateNotifier<UserLoginState?> {
  final UserService _userService;
  final UserRepository _userRepository;
  final TokenManager _tokenManager;
  final Ref ref;
  int? _responseCode;

  UserStateNotifier(
    this._userService,
    this._userRepository,
    this._tokenManager,
    this.ref, {
    UserLoginState? initialState,
  }) : super(initialState);

  int? get responseCode => _responseCode;

  Future<void> signUpUser(UserCreate user) async {
    final result = await _userRepository.signUpUser(user);
    final responseCode = result['status'];

    if (responseCode == 201) {
      state = _userRepository.userLoginState;
      await _tokenManager.saveToken(result['response']['token']);
    }
    ref.read(userStateResponseCodeProvider.notifier).state = responseCode;
  }

  Future<void> loginUser(UserLogin user) async {
    final result = await _userRepository.loginUser(user);
    final responseCode = result['status'];

    if (responseCode == 200) {
      state = _userRepository.userLoginState;
      await _tokenManager.saveToken(result['response']['token']);
    }
    ref.read(userStateResponseCodeProvider.notifier).state = responseCode;
  }

  Future<bool> checkAndValidateToken() async {
    final token = await _tokenManager.readToken();
    if (token == null) {
      return false;
    }

    final result = await _userRepository.validateToken(token);
    final responseCode = result['status'];

    if (responseCode == 200) {
      state = _userRepository.userLoginState;
      return true;
    } else {
      await _tokenManager.deleteToken();
      return false;
    }
  }

  Future<void> updateUserDetails(String userId, UserUpdate user) async {
    final result = await _userRepository.updateUserDetails(
        userId, user, ref.read(userRepositoryProvider).token);
    final responseCode = result['status'];

    if (responseCode == 200) {
      state = _userRepository.userLoginState;
    }
    ref.read(userStateResponseCodeProvider.notifier).state = responseCode;
  }

  Future<void> changeUserPassword(
      String userId, UserPasswordChange user) async {
    final result = await _userService.changeUserPasswordService(userId, user);
    _responseCode = result['status'];
    ref.read(userStateResponseCodeProvider.notifier).state = _responseCode;
  }

  Future<void> deleteUserAccount(UserAccountDelete user) async {
    final result = await _userService.deleteUserAccountService(user);
    _responseCode = result['status'];
    ref.read(userStateResponseCodeProvider.notifier).state = _responseCode;
    if (_responseCode == 200) {
      logout();
    }
  }

  Future<void> logout() async {
    await _tokenManager.deleteToken();
    _userRepository.logOut();
    state = _userRepository.userLoginState;
  }
}

final userStateProvider =
    StateNotifierProvider<UserStateNotifier, UserLoginState?>((ref) {
  final userService = ref.watch(userServiceProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  final tokenManager = ref.watch(tokenManagerProvider);
  return UserStateNotifier(userService, userRepository, tokenManager, ref);
});

final userStateResponseCodeProvider = StateProvider<int?>(
    (ref) => ref.watch(userStateProvider.notifier).responseCode);
