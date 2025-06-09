/// Profit and total calculation utilities for pricing

/// Calculates total or profit based on cost and either profit percentage or total
///
/// This function can calculate:
/// - Total when given cost and profit percentage
/// - Profit percentage when given cost and total
///
/// [costo] - The base cost as string
/// [profit] - The profit percentage as string (optional)
/// [total] - The total price as string (optional)
///
/// Returns the calculated value rounded to 1 decimal place
double? calculateTotalOrProfit(
  String costo,
  String? profit,
  String? total,
) {
  // Convert values to double
  final double? costoValue = double.tryParse(costo);
  final double? profitValue = double.tryParse(profit ?? '');
  final double? totalValue = double.tryParse(total ?? '');

  // If cost and profit are provided, calculate total
  if (costoValue != null && profitValue != null) {
    final result = costoValue / (1 - (profitValue / 100));
    return double.parse(result.toStringAsFixed(1));
  }

  // If cost and total are provided, calculate profit
  if (costoValue != null && totalValue != null && costoValue > 0) {
    final result = (1 - (costoValue / totalValue)) * 100;
    return double.parse(result.toStringAsFixed(1));
  }

  return null;
}

/// Calculates total price from cost and profit percentage
///
/// Uses simple markup formula: total = cost * (1 + profit/100)
///
/// [costo] - The base cost as string
/// [profit] - The profit percentage as string
///
/// Returns the total as formatted string with 2 decimal places
String calculateTotalFunction(
  String costo,
  String profit,
) {
  final double? costoValue = double.tryParse(costo);
  double? profitValue = double.tryParse(profit);

  if (costoValue != null && profitValue != null) {
    // Simple markup formula
    double total = costoValue * (1 + (profitValue / 100));
    return total.toStringAsFixed(2);
  }

  return '';
}

/// Calculates profit percentage from cost and total with high precision
///
/// This function attempts to find the exact profit percentage that,
/// when recalculated, produces the exact total with 2 decimal places
///
/// [costo] - The base cost as string
/// [total] - The total price as string
///
/// Returns the profit percentage as string
Future<String> calculateProfitWithPrecision(String costo, String total) async {
  final double? costoValue = double.tryParse(costo);
  double? totalValue = double.tryParse(total);

  if (costoValue != null &&
      totalValue != null &&
      totalValue > 0 &&
      costoValue > 0) {
    // Round total to 2 decimals for consistency
    totalValue = double.parse(totalValue.toStringAsFixed(2));

    // Calculate initial profit percentage
    double profitResult = ((totalValue - costoValue) / costoValue) * 100;

    // Try different precisions to find exact match
    for (int precision = 1; precision <= 15; precision++) {
      String valueWithPrecision = profitResult.toStringAsFixed(precision);
      double calculatedValue = double.parse(valueWithPrecision);

      // Recalculate total with the rounded profit
      double recalculatedTotal = costoValue * (1 + (calculatedValue / 100));
      recalculatedTotal = double.parse(recalculatedTotal.toStringAsFixed(2));

      if (recalculatedTotal == totalValue) {
        return valueWithPrecision;
      }
    }

    // If no exact match, try fine adjustment
    double adjustedPercentage = profitResult;
    double step = 0.00001;

    // Try incrementing
    for (int i = 0; i < 10000; i++) {
      adjustedPercentage += step;
      double recalculatedTotal = costoValue * (1 + (adjustedPercentage / 100));
      recalculatedTotal = double.parse(recalculatedTotal.toStringAsFixed(2));

      if (recalculatedTotal == totalValue) {
        return adjustedPercentage.toString();
      }
    }

    // Try decrementing
    adjustedPercentage = profitResult;
    for (int i = 0; i < 10000; i++) {
      adjustedPercentage -= step;
      if (adjustedPercentage <= 0) break;

      double recalculatedTotal = costoValue * (1 + (adjustedPercentage / 100));
      recalculatedTotal = double.parse(recalculatedTotal.toStringAsFixed(2));

      if (recalculatedTotal == totalValue) {
        return adjustedPercentage.toString();
      }
    }

    // Return initial result if no exact match found
    return profitResult.toString();
  }

  return '';
}
