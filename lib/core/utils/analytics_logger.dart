import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalyticsLogger {
  const AnalyticsLogger._();

  static Future<void> logEvent({
    required String eventName,
    Map<String, dynamic>? additionalData,
    int? milliseconds,
    bool? authenticated,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('logs').add(<String, dynamic>{
        'eventName': eventName,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': await _getCurrentUserId(),
        if (milliseconds != null) 'milliseconds': milliseconds,
        if (authenticated != null) 'authenticated': authenticated,
        if (additionalData != null) ...additionalData,
      });
    } catch (e) {
      // Silently fail if logging fails
    }
  }

  static Future<String?> _getCurrentUserId() async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      return userId;
    } catch (e) {
      return null;
    }
  }
}
