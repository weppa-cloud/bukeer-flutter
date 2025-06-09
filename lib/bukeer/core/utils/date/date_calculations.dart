import 'package:intl/intl.dart';

/// Calculates the number of nights between two dates
///
/// Takes [endDate] and [startDate] as ISO 8601 date strings (yyyy-MM-dd)
/// Returns the number of nights (days) between the dates
///
/// Example:
/// ```dart
/// final nights = calculateNights('2024-01-10', '2024-01-05'); // Returns 5
/// ```
int? calculateNights(String endDate, String startDate) {
  try {
    DateTime end = DateTime.parse(endDate);
    DateTime start = DateTime.parse(startDate);
    Duration difference = end.difference(start);
    int days = difference.inDays;
    return days;
  } catch (e) {
    print('Error calculating nights: $e');
    return null;
  }
}

/// Calculates the end date by adding nights to a start date
///
/// Takes [dateStart] as ISO 8601 date string and [nights] as number of days to add
/// Returns the calculated end date as ISO 8601 string
///
/// Example:
/// ```dart
/// final endDate = calculateDate('2024-01-05', 5); // Returns '2024-01-10'
/// ```
String calculateDate(String dateStart, int nights) {
  if (dateStart == "stop") {
    return "";
  }

  try {
    DateTime dateSt = DateTime.parse(dateStart);
    DateTime dateEnd = dateSt.add(Duration(days: nights));
    return DateFormat('yyyy-MM-dd').format(dateEnd);
  } catch (e) {
    print('Error calculating date: $e');
    return "";
  }
}

/// Formats a date string to a localized display format
///
/// Takes an ISO 8601 date string and formats it for display
/// Returns formatted string like '5 Jan 2024'
String formatDateForDisplay(String dateStr, {String locale = 'es'}) {
  try {
    final date = DateTime.parse(dateStr);
    return DateFormat('d MMM yyyy', locale).format(date);
  } catch (e) {
    print('Error formatting date for display: $e');
    return dateStr;
  }
}

/// Formats a date range for display
///
/// Takes start and end date strings and formats them
/// Returns formatted string like '5 Jan 2024 - 10 Jan 2024'
String formatDateRangeForDisplay(String startDateStr, String endDateStr,
    {String locale = 'es'}) {
  try {
    final startDate = DateTime.parse(startDateStr);
    final endDate = DateTime.parse(endDateStr);
    final startStr = DateFormat('d MMM yyyy', locale).format(startDate);
    final endStr = DateFormat('d MMM yyyy', locale).format(endDate);
    return '$startStr - $endStr';
  } catch (e) {
    print('Error formatting date range for display: $e');
    return '$startDateStr - $endDateStr';
  }
}

/// Checks if a date string is valid
bool isValidDateString(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty || dateStr == 'd/m/y') {
    return false;
  }

  try {
    DateTime.parse(dateStr);
    return true;
  } catch (e) {
    return false;
  }
}

/// Converts a DateTime to ISO 8601 date string
String? dateTimeToString(DateTime? date) {
  if (date == null) return null;
  return DateFormat('yyyy-MM-dd').format(date);
}

/// Converts an ISO 8601 date string to DateTime
DateTime? stringToDateTime(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty || dateStr == 'd/m/y') return null;
  try {
    return DateTime.parse(dateStr);
  } catch (e) {
    print('Error converting string to DateTime: $dateStr - $e');
    return null;
  }
}
