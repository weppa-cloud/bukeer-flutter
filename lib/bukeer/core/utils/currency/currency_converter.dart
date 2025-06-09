/// Currency conversion utilities for multi-currency support

/// Calculates cost in a specific currency using exchange rates
///
/// [listCurrency] - List of currency objects with 'name' and 'rate' fields
/// [typeCurrency] - The target currency code (e.g., 'USD', 'EUR')
/// [cost] - The base cost to convert
///
/// Returns the converted cost or null if conversion fails
double? costMultiCurrency(
  List<dynamic>? listCurrency,
  String? typeCurrency,
  double? cost,
) {
  if (listCurrency == null || typeCurrency == null || cost == null) {
    return null;
  }

  // Find the currency object matching the requested type
  final currency = listCurrency.firstWhere(
    (item) => item["name"] == typeCurrency,
    orElse: () => {},
  );

  if (currency.isEmpty) {
    return null;
  }

  // Extract rate and perform multiplication
  double rate = currency["rate"] ?? 1.0;
  return cost * rate;
}

/// Gets the exchange rate for a specific currency
///
/// [listCurrency] - List of currency objects
/// [typeCurrency] - The currency code to get rate for
///
/// Returns the exchange rate, with special handling for COP
double? getExchangeRate(
  List<dynamic>? listCurrency,
  String? typeCurrency,
) {
  if (listCurrency == null || typeCurrency == null) {
    return null;
  }

  final currency = listCurrency.firstWhere(
    (item) => item["name"] == typeCurrency,
    orElse: () => {},
  );

  if (currency.isEmpty) {
    return null;
  }

  double rate = currency["rate"] ?? 1.0;

  // Special handling for COP - invert the rate
  if (typeCurrency != "COP") {
    rate = 1 / rate;
  }

  return rate;
}

/// Converts an amount from optional currency to base currency
///
/// [amount] - The amount to convert
/// [currency] - The source currency code
/// [rates] - List of currency rate objects
///
/// Returns the converted amount rounded to 2 decimal places
dynamic convertCurrencyOptToBase(
  double amount,
  String currency,
  List<dynamic>? rates,
) {
  try {
    if (rates == null || rates.isEmpty) {
      return amount;
    }

    // Find the base currency
    Map<String, dynamic>? baseRate;
    for (var rate in rates) {
      if (rate['type'] == 'base') {
        baseRate = rate;
        break;
      }
    }

    if (baseRate == null) {
      return amount;
    }

    String baseCurrency = baseRate['name'];

    // If already in base currency, just round
    if (currency == baseCurrency) {
      return (amount * 100).round() / 100;
    }

    // Find the rate for the input currency
    Map<String, dynamic>? currencyRate;
    for (var rate in rates) {
      if (rate['name'] == currency) {
        currencyRate = rate;
        break;
      }
    }

    if (currencyRate == null) {
      return amount;
    }

    // Convert to base currency
    double convertedAmount = amount / currencyRate['rate'];

    // Round to 2 decimal places
    return (convertedAmount * 100).round() / 100;
  } catch (e) {
    return amount;
  }
}

/// Converts an amount from base currency to optional currency
///
/// [amount] - The amount to convert
/// [currency] - The target currency code
/// [rates] - List of currency rate objects
///
/// Returns the converted amount rounded to 2 decimal places
dynamic convertCurrencyBaseToOpt(
  double amount,
  String currency,
  List<dynamic>? rates,
) {
  try {
    if (rates == null || rates.isEmpty) {
      return amount;
    }

    // Find the base currency
    Map<String, dynamic>? baseRate;
    for (var rate in rates) {
      if (rate['type'] == 'base') {
        baseRate = rate;
        break;
      }
    }

    if (baseRate == null) {
      return amount;
    }

    String baseCurrency = baseRate['name'];

    // If target is base currency, just round
    if (currency == baseCurrency) {
      return (amount * 100).round() / 100;
    }

    // Find the rate for the target currency
    Map<String, dynamic>? currencyRate;
    for (var rate in rates) {
      if (rate['name'] == currency) {
        currencyRate = rate;
        break;
      }
    }

    if (currencyRate == null) {
      return amount;
    }

    // Convert from base to target currency
    double convertedAmount = amount * currencyRate['rate'];

    // Round to 2 decimal places
    return (convertedAmount * 100).round() / 100;
  } catch (e) {
    return amount;
  }
}
