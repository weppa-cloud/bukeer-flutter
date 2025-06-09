/// JSON array calculation utilities

/// Sums values from a specific field in a JSON array
///
/// [arrayJson] - Array of JSON objects
/// [field] - Field name to sum
///
/// Returns the sum of all values in the specified field
double? jsonArraySummation(
  List<dynamic> arrayJson,
  String field,
) {
  try {
    List<Map<String, dynamic>> productos =
        arrayJson.cast<Map<String, dynamic>>();

    String campoASumar = field;
    double sumaTotal = 0.0;

    sumaTotal = productos
        .map<double>(
            (producto) => (producto[campoASumar] as num?)?.toDouble() ?? 0.0)
        .reduce((a, b) => a + b);

    return sumaTotal;
  } catch (e) {
    print('Error in jsonArraySummation: $e');
    return null;
  }
}

/// Calculates average value from a specific field in a JSON array
///
/// [arrayJson] - Array of JSON objects
/// [field] - Field name to average
///
/// Returns the average of all values in the specified field
double? jsonArrayAverage(
  List<dynamic> arrayJson,
  String field,
) {
  if (arrayJson.isEmpty) return null;

  final sum = jsonArraySummation(arrayJson, field);
  if (sum == null) return null;

  return sum / arrayJson.length;
}

/// Finds minimum value from a specific field in a JSON array
///
/// [arrayJson] - Array of JSON objects
/// [field] - Field name to find minimum
///
/// Returns the minimum value in the specified field
double? jsonArrayMinimum(
  List<dynamic> arrayJson,
  String field,
) {
  if (arrayJson.isEmpty) return null;

  try {
    List<Map<String, dynamic>> items = arrayJson.cast<Map<String, dynamic>>();

    double? minValue;
    for (var item in items) {
      final value = (item[field] as num?)?.toDouble();
      if (value != null) {
        minValue =
            minValue == null ? value : (value < minValue ? value : minValue);
      }
    }

    return minValue;
  } catch (e) {
    print('Error in jsonArrayMinimum: $e');
    return null;
  }
}

/// Finds maximum value from a specific field in a JSON array
///
/// [arrayJson] - Array of JSON objects
/// [field] - Field name to find maximum
///
/// Returns the maximum value in the specified field
double? jsonArrayMaximum(
  List<dynamic> arrayJson,
  String field,
) {
  if (arrayJson.isEmpty) return null;

  try {
    List<Map<String, dynamic>> items = arrayJson.cast<Map<String, dynamic>>();

    double? maxValue;
    for (var item in items) {
      final value = (item[field] as num?)?.toDouble();
      if (value != null) {
        maxValue =
            maxValue == null ? value : (value > maxValue ? value : maxValue);
      }
    }

    return maxValue;
  } catch (e) {
    print('Error in jsonArrayMaximum: $e');
    return null;
  }
}

/// Counts items in JSON array that meet a condition
///
/// [arrayJson] - Array of JSON objects
/// [field] - Field name to check
/// [value] - Value to match
///
/// Returns count of matching items
int jsonArrayCount(
  List<dynamic> arrayJson,
  String field,
  dynamic value,
) {
  try {
    List<Map<String, dynamic>> items = arrayJson.cast<Map<String, dynamic>>();

    return items.where((item) => item[field] == value).length;
  } catch (e) {
    print('Error in jsonArrayCount: $e');
    return 0;
  }
}
