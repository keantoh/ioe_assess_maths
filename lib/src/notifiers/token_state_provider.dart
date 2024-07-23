import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final tokenManagerProvider = Provider<TokenManager>((ref) {
  final storage = ref.read(flutterSecureStorageProvider);
  return TokenManager(storage);
});

final tokenStateProvider = FutureProvider<String?>((ref) async {
  final tokenManager = ref.read(tokenManagerProvider);
  return await tokenManager.readToken();
});

class TokenManager {
  final FlutterSecureStorage _storage;

  TokenManager(this._storage);

  Future<String?> readToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }
}
