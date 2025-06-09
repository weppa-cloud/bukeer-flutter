/// General form validation utilities

/// Validates email format
///
/// [email] - The email address to validate
///
/// Returns true if email format is valid
bool validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return false;
  }

  // RFC 5322 compliant email regex
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  return emailRegex.hasMatch(email);
}

/// Validates phone number format
///
/// [phone] - The phone number to validate
/// [allowInternational] - Whether to allow international format
///
/// Returns true if phone format is valid
bool validatePhone(String? phone, {bool allowInternational = true}) {
  if (phone == null || phone.isEmpty) {
    return false;
  }

  // Remove common formatting characters
  final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

  if (allowInternational) {
    // International format: optional + followed by 7-15 digits
    return RegExp(r'^\+?[0-9]{7,15}$').hasMatch(cleanPhone);
  } else {
    // Local format: 7-10 digits
    return RegExp(r'^[0-9]{7,10}$').hasMatch(cleanPhone);
  }
}

/// Validates required field
///
/// [value] - The field value to validate
/// [fieldName] - Name of the field for error messages
///
/// Returns error message if invalid, null if valid
String? validateRequired(dynamic value, String fieldName) {
  if (value == null ||
      (value is String && value.trim().isEmpty) ||
      (value is List && value.isEmpty)) {
    return '$fieldName es requerido';
  }
  return null;
}

/// Validates minimum length
///
/// [value] - The string value to validate
/// [minLength] - Minimum required length
/// [fieldName] - Name of the field for error messages
///
/// Returns error message if invalid, null if valid
String? validateMinLength(String? value, int minLength, String fieldName) {
  if (value == null || value.length < minLength) {
    return '$fieldName debe tener al menos $minLength caracteres';
  }
  return null;
}

/// Validates maximum length
///
/// [value] - The string value to validate
/// [maxLength] - Maximum allowed length
/// [fieldName] - Name of the field for error messages
///
/// Returns error message if invalid, null if valid
String? validateMaxLength(String? value, int maxLength, String fieldName) {
  if (value != null && value.length > maxLength) {
    return '$fieldName no puede exceder $maxLength caracteres';
  }
  return null;
}

/// Validates numeric range
///
/// [value] - The numeric value to validate
/// [min] - Minimum value (optional)
/// [max] - Maximum value (optional)
/// [fieldName] - Name of the field for error messages
///
/// Returns error message if invalid, null if valid
String? validateNumericRange(double? value, String fieldName,
    {double? min, double? max}) {
  if (value == null) {
    return '$fieldName debe ser un número válido';
  }

  if (min != null && value < min) {
    return '$fieldName debe ser mayor o igual a $min';
  }

  if (max != null && value > max) {
    return '$fieldName debe ser menor o igual a $max';
  }

  return null;
}

/// Validates URL format
///
/// [url] - The URL to validate
///
/// Returns true if URL format is valid
bool validateUrl(String? url) {
  if (url == null || url.isEmpty) {
    return false;
  }

  try {
    final uri = Uri.parse(url);
    return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  } catch (e) {
    return false;
  }
}

/// Validates date string format
///
/// [dateStr] - The date string to validate
/// [format] - Expected date format (default: yyyy-MM-dd)
///
/// Returns true if date format is valid
bool validateDateFormat(String? dateStr, {String format = 'yyyy-MM-dd'}) {
  if (dateStr == null || dateStr.isEmpty) {
    return false;
  }

  try {
    if (format == 'yyyy-MM-dd') {
      DateTime.parse(dateStr);
      return true;
    }
    // For other formats, would need additional parsing logic
    return false;
  } catch (e) {
    return false;
  }
}
