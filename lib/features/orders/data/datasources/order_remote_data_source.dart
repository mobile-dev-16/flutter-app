import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/core/error/exceptions.dart';
import 'package:eco_bites/features/orders/data/models/order_model.dart';
import 'package:eco_bites/features/orders/domain/entities/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders();
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus);
  Future<void> createOrder(OrderModel order);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  const OrderRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final String? userId = _auth.currentUser?.uid;
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
    await _firestore.collection('orders').doc().set(order.toMap());
  }
}
