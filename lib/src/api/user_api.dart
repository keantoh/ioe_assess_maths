import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:math_assessment/src/data/models/user_models.dart';

Future<Map<String, dynamic>> signUpUser(UserCreate user) async {
  final String apiUrl = 'http://localhost:8000/signup';

  try {
    final response = await http
        .post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(user.toJson()),
        )
        .timeout(const Duration(seconds: 5));
    final responseBody = json.decode(response.body);

    return {
      'status': response.statusCode,
      'message': responseBody,
    };
  } on TimeoutException catch (_) {
    return {
      'status': 408, // HTTP status code for request timeout
      'message': 'Request timed out. Please try again.',
    };
  } on Exception catch (e) {
    return {
      'status': 500,
      'message': 'An error occurred: $e',
    };
  }
}

Future<Map<String, dynamic>> loginUser(UserLogin user) async {
  final String apiUrl = 'http://localhost:8000/login';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );
    final responseBody = json.decode(response.body);

    return {
      'status': response.statusCode,
      'response': responseBody,
    };
  } on TimeoutException catch (_) {
    return {
      'status': 408, // HTTP status code for request timeout
      'message': 'Request timed out. Please try again.',
    };
  } on Exception catch (e) {
    return {
      'status': 500,
      'message': 'An error occurred: $e',
    };
  }
}
