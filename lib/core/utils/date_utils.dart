import 'package:intl/intl.dart';

class DateUtils {
  static String formatOrderDate(DateTime date) {
    final DateFormat formatter = DateFormat.yMMMd();
    return formatter.format(date);
  }
}
