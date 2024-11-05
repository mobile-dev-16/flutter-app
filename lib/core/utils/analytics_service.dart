import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> logLoadingTime(String screenName, int milliseconds) async {
  await FirebaseAnalytics.instance.logEvent(
    name: 'loading_time',
    parameters: <String, Object>{
      'screen_name': screenName,
      'milliseconds': milliseconds,
    },
  );
}

Future<void> logUserSessionStart() async {
  await FirebaseAnalytics.instance.logEvent(
    name: 'user_session_start',
    parameters: <String, Object>{
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}

Future<void> logUserSessionEnd(int sessionDurationMilliseconds) async {
  await FirebaseAnalytics.instance.logEvent(
    name: 'user_session_end',
    parameters: <String, Object>{
      'timestamp': DateTime.now().toIso8601String(),
      'session_duration': sessionDurationMilliseconds,
    },
  );
}

Future<void> logLoginTime(int milliseconds) async {
  await FirebaseAnalytics.instance.logEvent(
    name: 'login_time',
    parameters: <String, Object>{
      'milliseconds': milliseconds,
    },
  );
}

Future<void> logCustomError(String errorDescription) async {
  await FirebaseCrashlytics.instance.log(errorDescription);
}

Future<void> logNonFatalError(Exception e, StackTrace stackTrace) async {
  await FirebaseCrashlytics.instance.recordError(e, stackTrace);
}

Future<void> logUserRetention(String userId, int daysSinceLastVisit) async {
  await FirebaseAnalytics.instance.logEvent(
    name: 'user_retention',
    parameters: <String, Object>{
      'user_id': userId,
      'days_since_last_visit': daysSinceLastVisit,
    },
  );
}
