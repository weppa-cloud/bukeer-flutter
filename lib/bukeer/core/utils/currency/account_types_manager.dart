/// Account types and payment methods management utilities

/// Manages account type increase rates
///
/// Adds or updates account type with its rate increase
///
/// [types] - List of account types with rates
/// [name] - Name of the account type
/// [rate] - Rate increase percentage
///
/// Returns updated types list
List<dynamic>? accountTypesIncreaseJson(
  List<dynamic>? types,
  String? name,
  double? rate,
) {
  types ??= [];

  if (name == null || name.isEmpty || rate == null) {
    return types;
  }

  // Find existing type
  int existingIndex = types.indexWhere((item) => item["name"] == name);

  if (existingIndex != -1) {
    // Update existing rate
    types[existingIndex]["rate"] = rate;
  } else {
    // Add new type
    types.add({"name": name, "rate": rate});
  }

  return types;
}

/// Gets account increase percentage for a specific type
///
/// [types] - List of account types
/// [requestType] - The type to get rate for
///
/// Returns the rate percentage or null if not found
double? accountIncreasePercentage(
  List<dynamic>? types,
  String? requestType,
) {
  if (types == null || requestType == null || types.isEmpty) {
    return null;
  }

  String requestTypeLower = requestType.toLowerCase();

  for (var type in types) {
    if (type is Map && type.containsKey('name') && type.containsKey('rate')) {
      String typeName = type['name'].toString().toLowerCase();

      if (typeName == requestTypeLower) {
        var rate = type['rate'];
        if (rate is num) {
          return rate.toDouble();
        } else if (rate is String) {
          return double.tryParse(rate);
        }
      }
    }
  }

  return null;
}

/// Adds a payment method to the list
///
/// [paymentMethods] - List of payment methods
/// [name] - Name of the payment method to add
///
/// Returns updated payment methods list with auto-incremented IDs
List<dynamic>? addPaymentMethod(
  List<dynamic>? paymentMethods,
  String? name,
) {
  paymentMethods ??= [];

  if (name == null || name.isEmpty) {
    return paymentMethods;
  }

  // Check if already exists
  int existingIndex = paymentMethods.indexWhere((item) => item["name"] == name);

  if (existingIndex == -1) {
    // Find max ID
    int maxId = -1;

    for (var method in paymentMethods) {
      if (method.containsKey("id") &&
          method["id"] is int &&
          method["id"] > maxId) {
        maxId = method["id"];
      }
    }

    // Add new method with incremented ID
    paymentMethods.add({"id": maxId + 1, "name": name});
  }

  return paymentMethods;
}

/// Edits or removes a payment method
///
/// [edit] - true to edit, false to remove
/// [id] - ID of the payment method
/// [paymentMethods] - List of payment methods
/// [name] - New name when editing
///
/// Returns updated payment methods list
List<dynamic>? editOrRemovePaymentMethod(
  bool? edit,
  int? id,
  List<dynamic>? paymentMethods,
  String? name,
) {
  paymentMethods ??= [];

  if (id == null) {
    return paymentMethods;
  }

  // Find method by ID
  int existingIndex = paymentMethods.indexWhere((item) => item["id"] == id);

  if (existingIndex == -1) {
    return paymentMethods;
  }

  if (edit == true) {
    // Edit mode - update name
    if (name != null && name.isNotEmpty) {
      paymentMethods[existingIndex]["name"] = name;
    }
  } else if (edit == false) {
    // Delete mode - remove and reorganize IDs
    paymentMethods.removeAt(existingIndex);

    // Reorganize IDs
    for (int i = 0; i < paymentMethods.length; i++) {
      if (paymentMethods[i] is Map && paymentMethods[i].containsKey("id")) {
        paymentMethods[i]["id"] = i;
      }
    }
  }

  return paymentMethods;
}
