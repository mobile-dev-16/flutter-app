import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/features/address/data/models/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<void> saveAddress(String userId, AddressModel address);
  Future<List<AddressModel>> fetchUserAddresses(String userId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  const AddressRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<void> saveAddress(String userId, AddressModel address) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .add(address.toMap());
    } catch (e) {
      throw FirebaseException(
        message: 'Failed to save address: $e',
        plugin: 'cloud_firestore',
      );
    }
  }

  @override
  Future<List<AddressModel>> fetchUserAddresses(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .get();

      return querySnapshot.docs
          .map(
            (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                AddressModel.fromMap(doc.data()),
          )
          .toList();
    } catch (e) {
      throw FirebaseException(
        message: 'Failed to fetch addresses: $e',
        plugin: 'cloud_firestore',
      );
    }
  }
}
