import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/config.dart';
import 'package:assess_math/src/models/child.dart';
import 'package:assess_math/src/utils/http_request.dart';

class ChildService {
  final String baseUrl = Config.apiUrl;

  Future<Map<String, dynamic>> fetchChildrenService(
      String userId, String token) async {
    final url = '$baseUrl/child/$userId';
    return await makeHttpRequest(url, 'GET', headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
  }

  Future<Map<String, dynamic>> addChildService(
      ChildCreate child, String token) async {
    final url = '$baseUrl/child';
    return await makeHttpRequest(url, 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: child.toJson());
  }

  Future<Map<String, dynamic>> updateChildService(
      Child child, String token) async {
    final userId = child.childId;
    final url = '$baseUrl/update_child/$userId';
    return await makeHttpRequest(url, 'PUT',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: child.toJson());
  }

  Future<Map<String, dynamic>> deleteChildService(
      int childId, String token) async {
    final url = '$baseUrl/delete_child/$childId';
    return await makeHttpRequest(url, 'DELETE', headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
  }
}

final childServiceProvider = Provider<ChildService>((ref) {
  return ChildService();
});
