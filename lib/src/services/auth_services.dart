import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/user_state.dart';

final authServiceProvider = Provider<AuthServices>((ref) => AuthServices());

class AuthServices {
  UserDetails? details;
  Future<UserDetails?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500), () {
      details = UserDetails(email: 'test@email.com', username: 'test');
    });
    return details;
  }
}
