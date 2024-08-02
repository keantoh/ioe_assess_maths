import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:math_assessment/src/data/models/result_models.dart';

Future<Map<String, dynamic>> addResult(ResultCreate result) async {
  final String apiUrl = 'http://localhost:8000/result';

  return {
    'status': 201,
    'response': {},
  };

  try {
    final response = await http
        .post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(result.toJson()),
        )
        .timeout(const Duration(seconds: 10));
    final responseBody = json.decode(response.body);

    if (response.statusCode == 201) {
      return {
        'status': response.statusCode,
        'response': responseBody,
      };
    } else {
      return {
        'status': response.statusCode,
        'message': responseBody['detail'] ?? 'Server error occurred',
      };
    }
  } on http.ClientException catch (e) {
    return {
      'status': 400,
      'message': 'Client error: ${e.message}',
    };
  } on TimeoutException catch (_) {
    return {
      'status': 408,
      'message': 'Request timed out. Please try again.',
    };
  } on SocketException catch (e) {
    return {
      'status': 503,
      'message': 'Client error: ${e.message}. Please check your connection.',
    };
  } on Exception catch (e) {
    return {
      'status': 500,
      'message': 'An error occurred: $e',
    };
  }
}
