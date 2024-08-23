import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/models/child.dart';
import 'package:assess_math/src/models/user.dart';
import 'package:assess_math/src/services/user_service.dart';

class ResetPasswordNotifier extends StateNotifier<List<Child>?> {
  final UserService _userService;
  final Ref ref;
  int? _responseCode;

  ResetPasswordNotifier(this._userService, this.ref) : super(null);

  int? get responseCode => _responseCode;

  Future<void> sendPasswordToken(String email) async {
    final result = await _userService.sendPasswordTokenService(email);
    _responseCode = result['status'];
    ref.read(resetPasswordResponseCodeProvider.notifier).state = _responseCode;
  }

  Future<void> updateUserPassword(UserPasswordUpdate user) async {
    final result = await _userService.updateUserPasswordService(user);
    _responseCode = result['status'];
    ref.read(resetPasswordResponseCodeProvider.notifier).state = _responseCode;
  }
}

final resetPasswordProvider =
    StateNotifierProvider<ResetPasswordNotifier, List<Child>?>((ref) {
  final userService = ref.watch(userServiceProvider);
  return ResetPasswordNotifier(userService, ref);
});

final resetPasswordResponseCodeProvider = StateProvider<int?>(
    (ref) => ref.watch(resetPasswordProvider.notifier).responseCode);
