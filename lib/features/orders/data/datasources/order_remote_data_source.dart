import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/core/error/exceptions.dart';
import 'package:eco_bites/core/utils/user_util.dart';
import 'package:eco_bites/features/orders/data/models/order_model.dart';
import 'package:eco_bites/features/orders/domain/entities/order.dart';
import 'package:logger/logger.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders();
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus);
  Future<void> createOrder(OrderModel order);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  const OrderRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final String? userId = await getUserId();
      if (userId == null) {
        throw const AuthException('User not authenticated');
      }

      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                OrderModel.fromMap(doc.data(), doc.id),
          )
          .toList();
    } catch (e) {
      Logger().e('Error fetching orders: $e');
      throw AuthException('Failed to fetch orders: $e');
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update(<String, dynamic>{
        'status': newStatus.name,
        if (newStatus == OrderStatus.completed)
          'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Logger().e('Error updating order status: $e');
      throw AuthException('Failed to update order status: $e');
    }
  }

  @override
  Future<void> createOrder(OrderModel order) async {
    try {
      final String? userId = await getUserId();
      if (userId == null) {
        throw const AuthException('User not authenticated');
      }

      // validate if the order items are not empty
      if (order.items.isEmpty) {
        Logger().e('Order items cannot be empty');
        // do not throw, snackbar will handle this
        return;
      }

      // Get business name from Firestore
      final DocumentSnapshot<Map<String, dynamic>> businessDoc =
          await _firestore
              .collection('foodBusiness')
              .doc(order.businessId)
              .get();

      if (!businessDoc.exists) {
        Logger().e('Business not found');
      }

      final String businessName = businessDoc.data()?['name'] as String;

      // Create the order with the fetched business name
      final Map<String, dynamic> orderData = order.toMap()
        ..['userId'] = userId
        ..['businessName'] = businessName;

      await _firestore.collection('orders').doc().set(orderData);
    } catch (e) {
      Logger().e('Error creating order: $e');
      throw AuthException('Failed to create order: $e');
    }
  }
}
