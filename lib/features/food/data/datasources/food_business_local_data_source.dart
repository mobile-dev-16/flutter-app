import 'package:eco_bites/core/error/exceptions.dart';
import 'package:eco_bites/features/food/data/models/food_business_model.dart';
import 'package:eco_bites/features/food/data/models/offer_model.dart';
import 'package:eco_bites/features/food/domain/entities/category.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';
import 'package:eco_bites/features/food/domain/entities/diet_type.dart';
import 'package:eco_bites/features/food/domain/entities/offer.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class FoodBusinessLocalDataSource {
  Future<void> cacheFoodBusinesses(List<FoodBusinessModel> businesses);
  Future<List<FoodBusinessModel>> getCachedFoodBusinesses();
  Future<void> clearCache();
}

class FoodBusinessLocalDataSourceImpl implements FoodBusinessLocalDataSource {
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'food_business.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create food business table
        await db.execute('''
          CREATE TABLE food_businesses(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            imageUrl TEXT,
            category TEXT NOT NULL,
            cuisineType TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            isNew INTEGER NOT NULL
          )
        ''');

        // Create offers table with foreign key to food businesses
        await db.execute('''
          CREATE TABLE offers(
            id TEXT PRIMARY KEY,
            businessId TEXT NOT NULL,
            description TEXT NOT NULL,
            imageUrl TEXT,
            normalPrice REAL NOT NULL,
            offerPrice REAL NOT NULL,
            availableQuantity INTEGER NOT NULL,
            validUntil TEXT NOT NULL,
            FOREIGN KEY (businessId) REFERENCES food_businesses (id)
          )
        ''');

        // Create table for diet types of offers (many-to-many relationship)
        await db.execute('''
          CREATE TABLE offer_diet_types(
            offerId TEXT NOT NULL,
            dietType TEXT NOT NULL,
            PRIMARY KEY (offerId, dietType),
            FOREIGN KEY (offerId) REFERENCES offers (id)
          )
        ''');
      },
    );
  }

  @override
  Future<void> cacheFoodBusinesses(List<FoodBusinessModel> businesses) async {
    try {
      final Database db = await database;
      await db.transaction((Transaction txn) async {
        // Clear existing data
        await txn.delete('offer_diet_types');
        await txn.delete('offers');
        await txn.delete('food_businesses');

        // Insert new data
        for (final FoodBusinessModel business in businesses) {
          await txn.insert(
            'food_businesses',
            <String, dynamic>{
              'id': business.id,
              'name': business.name,
              'imageUrl': business.imageUrl,
              'category': business.category.displayName,
              'cuisineType': business.cuisineType.name,
              'latitude': business.latitude,
              'longitude': business.longitude,
              'isNew': business.isNew ? 1 : 0,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          for (final Offer offer in business.offers) {
            await txn.insert(
              'offers',
              <String, dynamic>{
                'id': offer.id,
                'businessId': business.id,
                'description': offer.description,
                'imageUrl': offer.imageUrl,
                'normalPrice': offer.normalPrice,
                'offerPrice': offer.offerPrice,
                'availableQuantity': offer.availableQuantity,
                'validUntil': offer.validUntil.toIso8601String(),
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );

            // Insert diet types for the offer
            for (final DietType dietType in offer.suitableFor) {
              await txn.insert(
                'offer_diet_types',
                <String, dynamic>{
                  'offerId': offer.id,
                  'dietType': dietType.name,
                },
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          }
        }
      });
    } catch (e) {
      Logger().e('Error caching food businesses: $e');
      throw const CacheException('Failed to cache food businesses');
    }
  }

  @override
  Future<List<FoodBusinessModel>> getCachedFoodBusinesses() async {
    try {
      final Database db = await database;

      // Log the database path
      Logger().d('Database path: ${await getDatabasesPath()}');

      // Log the number of cached businesses
      final List<Map<String, dynamic>> businessMaps =
          await db.query('food_businesses');
      Logger().d('Number of cached businesses: ${businessMaps.length}');

      return Future.wait(
        businessMaps.map((Map<String, dynamic> businessMap) async {
          // Fetch offers for this business
          final List<Map<String, dynamic>> offerMaps = await db.query(
            'offers',
            where: 'businessId = ?',
            whereArgs: <String>[businessMap['id'] as String],
          );

          final List<OfferModel> offers = await Future.wait(
            offerMaps.map((Map<String, dynamic> offerMap) async {
              // Fetch diet types for this offer
              final List<Map<String, dynamic>> dietTypeMaps = await db.query(
                'offer_diet_types',
                where: 'offerId = ?',
                whereArgs: <String>[offerMap['id'] as String],
              );

              final List<DietType> dietTypes = dietTypeMaps
                  .map(
                    (Map<String, dynamic> dietMap) =>
                        DietTypeExtension.fromString(
                      dietMap['dietType'] as String,
                    ),
                  )
                  .toList();

              return OfferModel(
                id: offerMap['id'] as String,
                businessId: offerMap['businessId'] as String,
                description: offerMap['description'] as String,
                imageUrl: offerMap['imageUrl'] as String?,
                normalPrice: offerMap['normalPrice'] as double,
                offerPrice: offerMap['offerPrice'] as double,
                availableQuantity: offerMap['availableQuantity'] as int,
                validUntil: DateTime.parse(offerMap['validUntil'] as String),
                suitableFor: dietTypes,
              );
            }),
          );

          return FoodBusinessModel(
            id: businessMap['id'] as String,
            name: businessMap['name'] as String,
            imageUrl: businessMap['imageUrl'] as String?,
            category: Category.values.firstWhere(
              (Category c) => c.displayName == businessMap['category'],
            ),
            cuisineType: CuisineTypeExtension.fromString(
              businessMap['cuisineType'] as String,
            ),
            latitude: businessMap['latitude'] as double,
            longitude: businessMap['longitude'] as double,
            offers: offers,
            isNew: (businessMap['isNew'] as int) == 1,
          );
        }),
      );
    } catch (e) {
      Logger().e('Error getting cached food businesses: $e');
      throw const CacheException('Failed to get cached food businesses');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final Database db = await database;
      await db.transaction((Transaction txn) async {
        await txn.delete('offer_diet_types');
        await txn.delete('offers');
        await txn.delete('food_businesses');
      });
    } catch (e) {
      Logger().e('Error clearing cache: $e');
      throw const CacheException('Failed to clear cache');
    }
  }
}
