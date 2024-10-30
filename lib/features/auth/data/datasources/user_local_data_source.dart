import 'dart:convert';

import 'package:eco_bites/core/error/exceptions.dart';
import 'package:eco_bites/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  /// Gets the cached [UserModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<UserModel?> getCachedUser();

  Future<void> cacheUser(UserModel userToCache);

  Future<void> clearUserCache();

  Future<String?> getCachedUserId();

  Future<void> cacheUserId(String userId);

  Future<void> clearUserId();
}

const String cachedUserKey = 'CACHED_USER';
const String cachedUserIdKey = 'CACHED_USER_ID';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  const UserLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  @override
  Future<UserModel?> getCachedUser() async {
    final String? jsonString = sharedPreferences.getString(cachedUserKey);
    if (jsonString != null) {
      return UserModel.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel userToCache) async {
    await sharedPreferences.setString(
      cachedUserKey,
      json.encode(userToCache.toJson()),
    );
  }

  @override
  Future<void> clearUserCache() async {
    await sharedPreferences.remove(cachedUserKey);
  }

  @override
  Future<String?> getCachedUserId() async {
    return sharedPreferences.getString(cachedUserIdKey);
  }

  @override
  Future<void> cacheUserId(String userId) async {
    await sharedPreferences.setString(cachedUserIdKey, userId);
  }

  @override
  Future<void> clearUserId() async {
    await sharedPreferences.remove(cachedUserIdKey);
  }
}
