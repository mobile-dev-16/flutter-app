import 'package:eco_bites/core/error/exceptions.dart';
import 'package:eco_bites/features/address/data/models/address_model.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class AddressLocalDataSource {
  Future<void> cacheAddress(String userId, AddressModel address);
  Future<AddressModel?> getCachedAddress(String userId);
  Future<void> clearCache();
}

class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'address.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE addresses(
            userId TEXT PRIMARY KEY,
            fullAddress TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            deliveryDetails TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<void> cacheAddress(String userId, AddressModel address) async {
    try {
      final Database db = await database;
      await db.insert(
        'addresses',
        <String, dynamic>{
          'userId': userId,
          ...address.toMap(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      Logger().d('Address cached successfully for user: $userId');
    } catch (e) {
      Logger().e('Error caching address: $e');
      throw const CacheException('Failed to cache address');
    }
  }

  @override
  Future<AddressModel?> getCachedAddress(String userId) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'addresses',
        where: 'userId = ?',
        whereArgs: <String>[userId],
      );

      if (maps.isEmpty) {
        Logger().d('No cached address found for user: $userId');
        return null;
      }

      Logger().d('Retrieved cached address for user: $userId');
      return AddressModel.fromMap(maps.first);
    } catch (e) {
      Logger().e('Error getting cached address: $e');
      throw const CacheException('Failed to get cached address');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final Database db = await database;
      await db.delete('addresses');
      Logger().d('Address cache cleared');
    } catch (e) {
      Logger().e('Error clearing address cache: $e');
      throw const CacheException('Failed to clear address cache');
    }
  }
}
