import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';

Future<Map<String, dynamic>> makeHttpRequest(
  String url,
  String method, {
  Map<String, String>? headers,
  dynamic body,
}) async {
  try {
    late http.Response response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await http
            .get(Uri.parse(url), headers: headers)
            .timeout(const Duration(seconds: 10));
        break;
      case 'POST':
        response = await http
            .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
            .timeout(const Duration(seconds: 10));
        break;
      case 'PUT':
        response = await http
            .put(Uri.parse(url), headers: headers, body: jsonEncode(body))
            .timeout(const Duration(seconds: 10));
        break;
      case 'DELETE':
        response = await http
            .delete(Uri.parse(url), headers: headers)
            .timeout(const Duration(seconds: 10));
        break;
      default:
        throw Exception('HTTP method not supported');
    }

    final responseBody = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
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
