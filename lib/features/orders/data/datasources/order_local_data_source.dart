import 'package:eco_bites/core/error/exceptions.dart';
import 'package:eco_bites/features/orders/data/models/order_model.dart';
import 'package:eco_bites/features/orders/domain/entities/order.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class OrderLocalDataSource {
  Future<void> cacheOrders(List<OrderModel> orders);
  Future<List<OrderModel>> getCachedOrders();
  Future<void> clearCache();
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'orders.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create orders table
        await db.execute('''
          CREATE TABLE orders(
            id TEXT PRIMARY KEY,
            businessId TEXT NOT NULL,
            businessName TEXT NOT NULL,
            totalAmount REAL NOT NULL,
            status TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            completedAt TEXT
          )
        ''');

        // Create order items table with foreign key to orders
        await db.execute('''
          CREATE TABLE order_items(
            id TEXT PRIMARY KEY,
            orderId TEXT NOT NULL,
            name TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            price REAL NOT NULL,
            FOREIGN KEY (orderId) REFERENCES orders (id)
          )
        ''');
      },
    );
  }

  @override
  Future<void> cacheOrders(List<OrderModel> orders) async {
    try {
      final Database db = await database;
      await db.transaction((Transaction txn) async {
        // Clear existing data
        await txn.delete('order_items');
        await txn.delete('orders');

        // Insert new data
        for (final OrderModel order in orders) {
          await txn.insert(
            'orders',
            <String, dynamic>{
              'id': order.id,
              'businessId': order.businessId,
              'businessName': order.businessName,
              'totalAmount': order.totalAmount,
              'status': order.status.name,
              'createdAt': order.createdAt.toIso8601String(),
              if (order.completedAt != null)
                'completedAt': order.completedAt!.toIso8601String(),
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          // Insert order items
          for (final OrderItem item in order.items) {
            await txn.insert(
              'order_items',
              <String, dynamic>{
                'id': item.id,
                'orderId': order.id,
                'name': item.name,
                'quantity': item.quantity,
                'price': item.price,
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        }
      });
    } catch (e) {
      Logger().e('Error caching orders: $e');
      throw const CacheException('Failed to cache orders');
    }
  }

  @override
  Future<List<OrderModel>> getCachedOrders() async {
    try {
      final Database db = await database;

      // Log the database path
      Logger().d('Database path: ${await getDatabasesPath()}');

      // Get all orders
      final List<Map<String, dynamic>> orderMaps = await db.query('orders');
      Logger().d('Number of cached orders: ${orderMaps.length}');

      return Future.wait(
        orderMaps.map((Map<String, dynamic> orderMap) async {
          // Get items for this order
          final List<Map<String, dynamic>> itemMaps = await db.query(
            'order_items',
            where: 'orderId = ?',
            whereArgs: <String>[orderMap['id'] as String],
          );

          final List<OrderItemModel> items = itemMaps
              .map(
                (Map<String, dynamic> itemMap) => OrderItemModel(
                  id: itemMap['id'] as String,
                  name: itemMap['name'] as String,
                  quantity: itemMap['quantity'] as int,
                  price: itemMap['price'] as double,
                ),
              )
              .toList();

          return OrderModel(
            id: orderMap['id'] as String,
            businessId: orderMap['businessId'] as String,
            businessName: orderMap['businessName'] as String,
            items: items,
            totalAmount: orderMap['totalAmount'] as double,
            status: OrderStatus.values.firstWhere(
              (OrderStatus s) => s.name == (orderMap['status'] as String),
            ),
            createdAt: DateTime.parse(orderMap['createdAt'] as String),
            completedAt: orderMap['completedAt'] != null
                ? DateTime.parse(orderMap['completedAt'] as String)
                : null,
          );
        }),
      );
    } catch (e) {
      Logger().e('Error getting cached orders: $e');
      throw const CacheException('Failed to get cached orders');
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      final Database db = await database;
      await db.update(
        'orders',
        <String, dynamic>{
          'status': newStatus.name,
          if (newStatus == OrderStatus.completed)
            'completedAt': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: <String>[orderId],
      );
    } catch (e) {
      Logger().e('Error updating order status: $e');
      throw const CacheException('Failed to update order status');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final Database db = await database;
      await db.transaction((Transaction txn) async {
        await txn.delete('order_items');
        await txn.delete('orders');
      });
    } catch (e) {
      Logger().e('Error clearing cache: $e');
      throw const CacheException('Failed to clear cache');
    }
  }
}
