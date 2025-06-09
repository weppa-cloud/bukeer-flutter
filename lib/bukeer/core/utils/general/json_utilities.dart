/// General JSON manipulation utilities

import 'dart:convert';

/// Parses a JSON string and returns the first element if it's an array
///
/// [jsonString] - The JSON string to parse
///
/// Returns the parsed data or null if invalid
dynamic parseJsonSafely(String? jsonString) {
  if (jsonString == null || jsonString.isEmpty) {
    return null;
  }

  try {
    final parsedData = json.decode(jsonString);

    // If it's an array and not empty, return first element
    if (parsedData is List && parsedData.isNotEmpty) {
      return parsedData[0];
    }

    // If it's an object, return as-is
    if (parsedData is Map<String, dynamic>) {
      return parsedData;
    }

    return parsedData;
  } catch (e) {
    print('Error parsing JSON: $e');
    return null;
  }
}

/// Deep clones a JSON object
///
/// [source] - The object to clone
///
/// Returns a deep copy of the object
dynamic deepCloneJson(dynamic source) {
  if (source == null) return null;

  try {
    // Convert to JSON string and back to create deep copy
    return json.decode(json.encode(source));
  } catch (e) {
    print('Error cloning JSON: $e');
    return source;
  }
}

/// Merges two JSON objects
///
/// [base] - The base object
/// [updates] - The updates to apply
/// [deep] - Whether to deep merge nested objects
///
/// Returns merged object
Map<String, dynamic> mergeJson(
    Map<String, dynamic> base, Map<String, dynamic> updates,
    {bool deep = false}) {
  final result = Map<String, dynamic>.from(base);

  updates.forEach((key, value) {
    if (deep &&
        result[key] is Map<String, dynamic> &&
        value is Map<String, dynamic>) {
      // Deep merge nested objects
      result[key] = mergeJson(
        result[key] as Map<String, dynamic>,
        value,
        deep: true,
      );
    } else {
      // Simple override
      result[key] = value;
    }
  });

  return result;
}

/// Filters null values from a JSON object
///
/// [data] - The object to filter
/// [recursive] - Whether to filter recursively
///
/// Returns filtered object
Map<String, dynamic> filterNullValues(Map<String, dynamic> data,
    {bool recursive = false}) {
  final filtered = <String, dynamic>{};

  data.forEach((key, value) {
    if (value != null) {
      if (recursive && value is Map<String, dynamic>) {
        filtered[key] = filterNullValues(value, recursive: true);
      } else {
        filtered[key] = value;
      }
    }
  });

  return filtered;
}

/// Safely gets a nested value from a JSON object
///
/// [data] - The JSON object
/// [path] - Dot-separated path (e.g., 'user.profile.name')
/// [defaultValue] - Default value if path not found
///
/// Returns the value at path or default
dynamic getNestedValue(Map<String, dynamic>? data, String path,
    {dynamic defaultValue}) {
  if (data == null) return defaultValue;

  final keys = path.split('.');
  dynamic current = data;

  for (final key in keys) {
    if (current is Map<String, dynamic> && current.containsKey(key)) {
      current = current[key];
    } else {
      return defaultValue;
    }
  }

  return current;
}

/// Safely sets a nested value in a JSON object
///
/// [data] - The JSON object
/// [path] - Dot-separated path (e.g., 'user.profile.name')
/// [value] - Value to set
///
/// Returns the modified object
Map<String, dynamic> setNestedValue(
  Map<String, dynamic> data,
  String path,
  dynamic value,
) {
  final result = Map<String, dynamic>.from(data);
  final keys = path.split('.');

  Map<String, dynamic> current = result;

  for (int i = 0; i < keys.length - 1; i++) {
    final key = keys[i];
    if (!current.containsKey(key) || current[key] is! Map<String, dynamic>) {
      current[key] = <String, dynamic>{};
    }
    current = current[key] as Map<String, dynamic>;
  }

  current[keys.last] = value;

  return result;
}
