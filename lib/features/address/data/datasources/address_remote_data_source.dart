import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/features/address/data/models/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<void> saveAddress(String userId, AddressModel address);
  Future<AddressModel?> fetchUserAddress(String userId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  const AddressRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<void> saveAddress(String userId, AddressModel address) async {
    try {
      // Aquí aseguramos que el UID sea el mismo que el del usuario registrado
      await _firestore
          .collection('profiles')
          .doc(userId) // Usamos el UID del usuario para referenciar el mismo documento
          .set(
            <String, dynamic>{'address': address.toMap()},
            SetOptions(merge: true), // Esto solo agrega/actualiza el campo "address"
          );
    } catch (e) {
      throw FirebaseException(
        message: 'Failed to save address: $e',
        plugin: 'cloud_firestore',
      );
    }
  }

  @override
  Future<AddressModel?> fetchUserAddress(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('profiles').doc(userId).get();

      if (snapshot.exists && snapshot.data()?['address'] != null) {
        return AddressModel.fromMap(snapshot.data()!['address']);
      }
      return null;
    } catch (e) {
      throw FirebaseException(
        message: 'Failed to fetch address: $e',
        plugin: 'cloud_firestore',
      );
    }
  }
}
