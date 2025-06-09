/// PDF formatting utilities for document generation

import 'package:intl/intl.dart';

/// Formats currency for PDF display
///
/// [amount] - The amount to format
/// [currency] - The currency code (e.g., 'USD', 'EUR')
/// [locale] - The locale for formatting (default: 'es')
///
/// Returns formatted currency string
String formatCurrencyForPDF(double amount, String currency,
    {String locale = 'es'}) {
  final formatter = NumberFormat.currency(
    locale: locale,
    symbol: currency,
    decimalDigits: 2,
  );
  return formatter.format(amount);
}

/// Formats date for PDF display
///
/// [date] - The date to format
/// [locale] - The locale for formatting (default: 'es')
///
/// Returns formatted date string
String formatDateForPDF(DateTime date, {String locale = 'es'}) {
  return DateFormat('d MMM yyyy', locale).format(date);
}

/// Formats date range for PDF display
///
/// [startDate] - The start date
/// [endDate] - The end date
/// [locale] - The locale for formatting (default: 'es')
///
/// Returns formatted date range string
String formatDateRangeForPDF(DateTime startDate, DateTime endDate,
    {String locale = 'es'}) {
  final start = DateFormat('d MMM', locale).format(startDate);
  final end = DateFormat('d MMM yyyy', locale).format(endDate);
  return '$start - $end';
}

/// Formats passenger name for PDF display
///
/// [firstName] - First name
/// [lastName] - Last name
/// [title] - Optional title (Mr., Mrs., etc.)
///
/// Returns formatted name
String formatPassengerNameForPDF(String firstName, String lastName,
    {String? title}) {
  if (title != null && title.isNotEmpty) {
    return '$title $firstName $lastName'.toUpperCase();
  }
  return '$firstName $lastName'.toUpperCase();
}

/// Formats flight information for PDF display
///
/// [flightNumber] - Flight number
/// [airline] - Airline name
/// [departure] - Departure airport code
/// [arrival] - Arrival airport code
///
/// Returns formatted flight info
String formatFlightInfoForPDF(
  String flightNumber,
  String airline,
  String departure,
  String arrival,
) {
  return '$airline $flightNumber: $departure - $arrival';
}

/// Formats hotel information for PDF display
///
/// [hotelName] - Hotel name
/// [roomType] - Room type
/// [nights] - Number of nights
///
/// Returns formatted hotel info
String formatHotelInfoForPDF(
  String hotelName,
  String roomType,
  int nights,
) {
  final nightText = nights == 1 ? 'noche' : 'noches';
  return '$hotelName - $roomType ($nights $nightText)';
}

/// Formats address for PDF display
///
/// [street] - Street address
/// [city] - City
/// [state] - State/Province (optional)
/// [country] - Country
/// [postalCode] - Postal code (optional)
///
/// Returns formatted address
String formatAddressForPDF(String street, String city, String country,
    {String? state, String? postalCode}) {
  final parts = [street];

  if (state != null && state.isNotEmpty) {
    parts.add('$city, $state');
  } else {
    parts.add(city);
  }

  if (postalCode != null && postalCode.isNotEmpty) {
    parts.add(postalCode);
  }

  parts.add(country);

  return parts.join('\n');
}

/// Formats phone number for PDF display
///
/// [phone] - Phone number
/// [countryCode] - Country code (optional)
///
/// Returns formatted phone number
String formatPhoneForPDF(String phone, {String? countryCode}) {
  if (countryCode != null && countryCode.isNotEmpty) {
    return '+$countryCode $phone';
  }
  return phone;
}

/// Truncates text for PDF display with ellipsis
///
/// [text] - Text to truncate
/// [maxLength] - Maximum length
///
/// Returns truncated text
String truncateTextForPDF(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  }
  return '${text.substring(0, maxLength - 3)}...';
}
