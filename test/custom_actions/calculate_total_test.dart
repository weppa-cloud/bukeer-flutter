import 'package:flutter_test/flutter_test.dart';

import '../../lib/custom_code/actions/calculate_total.dart';

void main() {
  group('CalculateTotal Tests', () {
    test('should calculate total correctly with valid inputs', () async {
      // Arrange
      const costo = '100.0';
      const profit = '20.0'; // 20%

      // Act
      final result = await calculateTotal(costo, profit);

      // Assert
      expect(result, equals('120.00'));
    });

    test('should handle zero cost', () async {
      // Arrange
      const costo = '0.0';
      const profit = '20.0';

      // Act
      final result = await calculateTotal(costo, profit);

      // Assert
      expect(result, equals('0.00'));
    });

    test('should handle zero profit', () async {
      // Arrange
      const costo = '100.0';
      const profit = '0.0';

      // Act
      final result = await calculateTotal(costo, profit);

      // Assert
      expect(result, equals('100.00'));
    });

    test('should handle decimal inputs', () async {
      // Arrange
      const costo = '150.75';
      const profit = '15.5'; // 15.5%

      // Act
      final result = await calculateTotal(costo, profit);

      // Assert
      final expected = (150.75 * (1 + 15.5/100)).toStringAsFixed(2);
      expect(result, equals(expected));
    });

    test('should return empty string for invalid costo', () async {
      // Arrange
      const costo = 'invalid';
      const profit = '20.0';

      // Act
      final result = await calculateTotal(costo, profit);

      // Assert
      expect(result, equals(''));
    });

    test('should return empty string for invalid profit', () async {
      // Arrange
      const costo = '100.0';
      const profit = 'invalid';

      // Act
      final result = await calculateTotal(costo, profit);

      // Assert
      expect(result, equals(''));
    });

    test('should return empty string for empty inputs', () async {
      // Arrange
      const costo = '';
      const profit = '';

      // Act
      final result = await calculateTotal(costo, profit);

      // Assert
      expect(result, equals(''));
    });

    test('should handle negative values', () async {
      // Arrange
      const costo = '100.0';
      const profit = '-10.0'; // -10%

      // Act
      final result = await calculateTotal(costo, profit);

      // Assert
      expect(result, equals('90.00'));
    });

    test('should handle large numbers', () async {
      // Arrange
      const costo = '999999.99';
      const profit = '100.0'; // 100%

      // Act
      final result = await calculateTotal(costo, profit);

      // Assert
      expect(result, equals('1999999.98'));
    });

    test('should round to 2 decimal places', () async {
      // Arrange
      const costo = '33.33';
      const profit = '33.33';

      // Act
      final result = await calculateTotal(costo, profit);

      // Assert
      // 33.33 * (1 + 33.33/100) = 33.33 * 1.3333 = 44.4389
      expect(result, equals('44.44'));
    });
  });
}