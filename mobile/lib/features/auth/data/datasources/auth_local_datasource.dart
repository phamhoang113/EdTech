import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'dart:convert';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheTokens({required String accessToken, required String refreshToken});
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
  Future<UserModel?> getCachedUser();
}

@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _userKey = 'user';

  AuthLocalDataSourceImpl(this._storage);

  @override
  Future<void> cacheTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await _storage.write(key: _userKey, value: json.encode(user.toJson()));
  }

  @override
  Future<void> clearCache() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userKey);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userStr = await _storage.read(key: _userKey);
    if (userStr != null) {
      return UserModel.fromJson(json.decode(userStr));
    }
    return null;
  }
}
