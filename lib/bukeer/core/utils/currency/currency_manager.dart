/// Currency list management utilities

/// Updates the base currency in a currency list
///
/// This function manages the currency list by setting a new base currency
/// and converting the previous base to an optional currency
///
/// [baseCurrency] - The new base currency code
/// [currencyList] - The existing currency list
///
/// Returns the updated currency list
List<dynamic>? accountCurrencyJsonCopy(
  String? baseCurrency,
  List<dynamic>? currencyList,
) {
  currencyList ??= [];

  if (baseCurrency == null || baseCurrency.isEmpty) {
    return currencyList;
  }

  // Check if the new base is already an optional currency
  bool isNewBaseAnOptional = currencyList
      .any((item) => item["name"] == baseCurrency && item["type"] == "opt");

  if (isNewBaseAnOptional) {
    return currencyList; // Don't change if already optional
  }

  // Find current base currency
  int currentBaseIndex =
      currencyList.indexWhere((item) => item["type"] == "base");

  if (currentBaseIndex != -1) {
    // Convert current base to optional
    Map<String, dynamic> currentBase = currencyList.removeAt(currentBaseIndex);
    currentBase["type"] = "opt";
    currencyList.add(currentBase);
  }

  // Add new base at the beginning
  currencyList.insert(0, {"name": baseCurrency, "type": "base", "rate": 1});

  return currencyList;
}

/// Manages currency list with base and optional currencies
///
/// [baseCurrency] - The base currency code
/// [optCurrency] - An optional currency to add
/// [rate] - The exchange rate for the optional currency
/// [currencyList] - The existing currency list
///
/// Returns the updated currency list
List<dynamic>? accountCurrencyJson(
  String? baseCurrency,
  String? optCurrency,
  double? rate,
  List<dynamic>? currencyList,
) {
  currencyList ??= [];

  if (baseCurrency == null || baseCurrency.isEmpty) {
    return currencyList;
  }

  // Find current base currency
  int currentBaseIndex =
      currencyList.indexWhere((item) => item["type"] == "base");
  Map<String, dynamic>? currentBase =
      currentBaseIndex != -1 ? currencyList[currentBaseIndex] : null;

  // Check if new base is already optional
  bool isNewBaseAnOptional = currencyList
      .any((item) => item["name"] == baseCurrency && item["type"] == "opt");

  if (isNewBaseAnOptional) {
    return currencyList;
  }

  // Update base currency if needed
  if (currentBase != null && currentBase["name"] != baseCurrency) {
    currentBase["type"] = "opt";
    currencyList.insert(0, {"type": "base", "name": baseCurrency, "rate": 1});
  } else if (currentBase == null) {
    currencyList.insert(0, {"type": "base", "name": baseCurrency, "rate": 1});
  }

  // Add or update optional currency
  if (optCurrency != null &&
      optCurrency.isNotEmpty &&
      optCurrency != baseCurrency &&
      rate != null) {
    int existingIndex =
        currencyList.indexWhere((item) => item["name"] == optCurrency);

    if (existingIndex != -1) {
      currencyList[existingIndex]["rate"] = rate;
    } else {
      currencyList.add({"type": "opt", "name": optCurrency, "rate": rate});
    }
  }

  return currencyList;
}
