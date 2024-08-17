import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:math_assessment/src/config.dart';
import 'package:math_assessment/src/models/child.dart';

Future<Map<String, dynamic>> addChild(ChildCreate child) async {
  const String apiUrl = '${Config.apiUrl}/child';

  try {
    final response = await http
        .post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(child.toJson()),
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

Future<List<Child>> getChildren(String userId) async {
  final String apiUrl = 'http://localhost:8000/child/$userId';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = json.decode(response.body);
      return responseBody.map((json) => Child.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load children: ${response.statusCode}');
    }
  } on http.ClientException catch (e) {
    throw Exception('Client error: ${e.message}');
  } on TimeoutException catch (_) {
    throw Exception('Request timed out. Please try again.');
  } on Exception catch (e) {
    throw Exception('An unexpected error occurred: $e');
  }
}

Future<Map<String, dynamic>> updateChild(int childId, Child child) async {
  final String apiUrl = 'http://localhost:8000/update_child/$childId';

  try {
    final response = await http
        .put(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(child.toJson()),
        )
        .timeout(const Duration(seconds: 10));
    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
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

Future<Map<String, dynamic>> deleteChild(int childId) async {
  final String apiUrl = 'http://localhost:8000/delete_child/$childId';

  try {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 10));

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
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
