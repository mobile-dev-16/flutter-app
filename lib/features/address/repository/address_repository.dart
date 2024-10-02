import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/features/address/domain/address.dart';

class AddressRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save address method expecting both userId and address
  Future<void> saveAddress(String userId, Address address) async {
    await _firestore.collection('users/$userId/addresses').add(address.toMap());
  }

  Future<List<Address>> fetchUserAddresses(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection('users/$userId/addresses').get();
    return querySnapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => Address.fromMap(doc.data())).toList();
  }
}
