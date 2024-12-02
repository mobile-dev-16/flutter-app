import 'package:intl/intl.dart';

/// Utility class for date related operations.
class DateUtils {
  DateUtils._();

  /// Formats the given date into a string in the format "MMM d, y".
  /// Example output: "Apr 27, 2023"
  static String formatDateMonthDayYear(DateTime date) {
    final DateFormat formatter = DateFormat.yMMMd();
    return formatter.format(date);
  }

  /// Formats the given date to show only the day and month.
  /// Example output: "04/27"
  static String formatDayMonth(DateTime date) {
    return DateFormat('d MMM').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('d MMM y, HH:mm').format(dateTime);
  }
}
