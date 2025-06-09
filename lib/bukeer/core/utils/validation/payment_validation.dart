/// Payment validation utilities

/// Validates if a payment amount is valid
///
/// [amount] - The payment amount to validate
/// [minAmount] - Minimum allowed amount (default: 0)
///
/// Returns true if amount is valid
bool validatePaymentAmount(double? amount, {double minAmount = 0}) {
  if (amount == null) return false;
  return amount > minAmount;
}

/// Validates if payment is needed based on pending amount
///
/// Checks the pending_paid_cost field to determine if payment button should show
///
/// [data] - Map containing payment data
///
/// Returns true if payment registration button should be hidden
bool shouldHidePaymentButton(dynamic data) {
  if (data is Map && data.containsKey('pending_paid_cost')) {
    final pendingPaidCost = data['pending_paid_cost'];

    // Hide button if no pending payment
    if (pendingPaidCost <= 0) {
      return true;
    }
  }

  return false;
}

/// Validates payment method
///
/// Checks if payment method is valid and exists in allowed methods
///
/// [paymentMethod] - The payment method to validate
/// [allowedMethods] - List of allowed payment methods
///
/// Returns true if payment method is valid
bool validatePaymentMethod(
  String? paymentMethod,
  List<dynamic>? allowedMethods,
) {
  if (paymentMethod == null || paymentMethod.isEmpty) {
    return false;
  }

  if (allowedMethods == null || allowedMethods.isEmpty) {
    return true; // No restrictions
  }

  return allowedMethods
      .any((method) => method is Map && method['name'] == paymentMethod);
}

/// Validates if total payments match expected total
///
/// [totalPaid] - Sum of all payments
/// [expectedTotal] - Expected total amount
/// [tolerance] - Acceptable difference (default: 0.01)
///
/// Returns true if payments match within tolerance
bool validatePaymentTotal(double totalPaid, double expectedTotal,
    {double tolerance = 0.01}) {
  final difference = (totalPaid - expectedTotal).abs();
  return difference <= tolerance;
}

/// Validates payment date
///
/// Checks if payment date is within acceptable range
///
/// [paymentDate] - The payment date to validate
/// [minDate] - Minimum allowed date (optional)
/// [maxDate] - Maximum allowed date (optional)
///
/// Returns true if date is valid
bool validatePaymentDate(DateTime paymentDate,
    {DateTime? minDate, DateTime? maxDate}) {
  if (minDate != null && paymentDate.isBefore(minDate)) {
    return false;
  }

  if (maxDate != null && paymentDate.isAfter(maxDate)) {
    return false;
  }

  return true;
}
