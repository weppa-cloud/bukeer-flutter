/// Reservation validation utilities

/// Validates if reservation button should be shown
///
/// Checks reservation status to determine button visibility
///
/// [data] - Map containing reservation data
///
/// Returns true if button should be shown
bool shouldShowReservationButton(dynamic data) {
  if (data is Map && data.containsKey('reservation_status')) {
    final reservationStatus = data['reservation_status'];

    // Hide button if reservation is already made
    if (reservationStatus == false) {
      return false;
    }
  }

  // Show button by default
  return true;
}

/// Validates reservation dates
///
/// Checks if check-in and check-out dates are valid
///
/// [checkIn] - Check-in date
/// [checkOut] - Check-out date
///
/// Returns true if dates are valid
bool validateReservationDates(DateTime checkIn, DateTime checkOut) {
  // Check-out must be after check-in
  if (checkOut.isBefore(checkIn) || checkOut.isAtSameMomentAs(checkIn)) {
    return false;
  }

  // Check-in should not be in the past
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final checkInDate = DateTime(checkIn.year, checkIn.month, checkIn.day);

  if (checkInDate.isBefore(today)) {
    return false;
  }

  return true;
}

/// Validates reservation guest count
///
/// [guestCount] - Number of guests
/// [minGuests] - Minimum allowed guests (default: 1)
/// [maxGuests] - Maximum allowed guests (optional)
///
/// Returns true if guest count is valid
bool validateGuestCount(int guestCount, {int minGuests = 1, int? maxGuests}) {
  if (guestCount < minGuests) {
    return false;
  }

  if (maxGuests != null && guestCount > maxGuests) {
    return false;
  }

  return true;
}

/// Validates reservation total amount
///
/// [nights] - Number of nights
/// [ratePerNight] - Rate per night
/// [totalAmount] - Total amount to validate
/// [tolerance] - Acceptable difference (default: 0.01)
///
/// Returns true if total is correct
bool validateReservationTotal(
    int nights, double ratePerNight, double totalAmount,
    {double tolerance = 0.01}) {
  final expectedTotal = nights * ratePerNight;
  final difference = (totalAmount - expectedTotal).abs();
  return difference <= tolerance;
}
