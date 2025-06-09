/// Passenger validation utilities

/// Validates if the number of passengers matches the expected count
///
/// This function checks if the actual number of passengers in the database
/// matches the expected passenger count for an itinerary.
///
/// [itineraryId] - The ID of the itinerary to validate
/// [actualPassengerCount] - The actual number of passengers
/// [expectedPassengerCount] - The expected number of passengers
///
/// Returns true if counts match, false otherwise
bool validatePassengerCount(
  int actualPassengerCount,
  int expectedPassengerCount,
) {
  return actualPassengerCount == expectedPassengerCount;
}

/// Validates passenger information completeness
///
/// Checks if all required passenger fields are filled
///
/// [passenger] - Map containing passenger data
///
/// Returns true if all required fields are present
bool validatePassengerData(Map<String, dynamic> passenger) {
  final requiredFields = [
    'name',
    'lastname',
    'nationality',
    'document_type',
    'document_number',
  ];

  for (final field in requiredFields) {
    if (!passenger.containsKey(field) ||
        passenger[field] == null ||
        passenger[field].toString().isEmpty) {
      return false;
    }
  }

  return true;
}

/// Validates passenger age requirements
///
/// Checks if passenger age meets minimum requirements
///
/// [birthDate] - The passenger's birth date
/// [minimumAge] - The minimum required age (default: 18)
///
/// Returns true if age requirement is met
bool validatePassengerAge(DateTime birthDate, {int minimumAge = 18}) {
  final now = DateTime.now();
  final age = now.year - birthDate.year;

  // Adjust for birthday not yet occurred this year
  if (now.month < birthDate.month ||
      (now.month == birthDate.month && now.day < birthDate.day)) {
    return (age - 1) >= minimumAge;
  }

  return age >= minimumAge;
}

/// Validates document number format
///
/// Checks if document number follows expected patterns
///
/// [documentType] - Type of document (passport, id, etc)
/// [documentNumber] - The document number to validate
///
/// Returns true if format is valid
bool validateDocumentNumber(String documentType, String documentNumber) {
  if (documentNumber.isEmpty) return false;

  switch (documentType.toLowerCase()) {
    case 'passport':
      // Passport: alphanumeric, 6-9 characters
      return RegExp(r'^[A-Z0-9]{6,9}$').hasMatch(documentNumber.toUpperCase());

    case 'dni':
    case 'id':
      // ID: numeric or alphanumeric depending on country
      return RegExp(r'^[A-Z0-9]{5,20}$').hasMatch(documentNumber.toUpperCase());

    default:
      // Generic validation: not empty and reasonable length
      return documentNumber.length >= 5 && documentNumber.length <= 20;
  }
}
