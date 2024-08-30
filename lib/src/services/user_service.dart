import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/config.dart';
import 'package:assess_math/src/models/user.dart';
import 'package:assess_math/src/utils/http_request.dart';

class UserService {
  final String baseUrl = Config.apiUrl;

  Future<Map<String, dynamic>> signUpUserService(UserCreate user) async {
    final url = '$baseUrl/signup';
    final trimmedUser = user.trimmed();

    return await makeHttpRequest(url, 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: trimmedUser.toJson());
  }

  Future<Map<String, dynamic>> loginUserService(UserLogin user) async {
    final url = '$baseUrl/login';
    return await makeHttpRequest(url, 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson());
  }

  Future<Map<String, dynamic>> validateTokenService(String token) async {
    final url = '$baseUrl/validate-token';
    return await makeHttpRequest(url, 'POST', headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: {
      'token': token
    });
  }

  Future<Map<String, dynamic>> updateUserDetailsService(
      String userId, UserUpdate user, String token) async {
    final url = '$baseUrl/update_user_details/$userId';
    final trimmedUser = user.trimmed();
    return await makeHttpRequest(url, 'PUT',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: trimmedUser.toJson());
  }

  Future<Map<String, dynamic>> changeUserPasswordService(
      String userId, UserPasswordChange user) async {
    final url = '$baseUrl/change_user_password/$userId';
    return await makeHttpRequest(url, 'PUT',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson());
  }

  Future<Map<String, dynamic>> deleteUserAccountService(
      UserAccountDelete user) async {
    final url = '$baseUrl/delete_user_account';
    return await makeHttpRequest(url, 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson());
  }

  Future<Map<String, dynamic>> sendPasswordTokenService(String email) async {
    final url = '$baseUrl/send_password_token';
    return await makeHttpRequest(url, 'PUT', headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: {
      'email': email
    });
  }

  Future<Map<String, dynamic>> updateUserPasswordService(
      UserPasswordUpdate user) async {
    final url = '$baseUrl/update_user_password';
    return await makeHttpRequest(url, 'PUT',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson());
  }

  Future<Map<String, dynamic>> searchUsersService(
      String searchQuery, String token) async {
    final url = '$baseUrl/search_users';
    return await makeHttpRequest(url, 'POST', headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    }, body: {
      'query': searchQuery
    });
  }

  Future<Map<String, dynamic>> deleteUserService(
      String userId, String token) async {
    final url = '$baseUrl/delete_user';
    return await makeHttpRequest(url, 'POST', headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    }, body: {
      'userId': userId
    });
  }
}

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});
