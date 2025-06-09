import 'package:flutter_test/flutter_test.dart';

// Extracted logic from custom actions for testing
double calculateTotalLogic(double cost, double profitPercentage) {
  return cost * (1 + (profitPercentage / 100));
}

double calculateProfitLogic(double cost, double total) {
  if (cost <= 0) return 0;
  return ((total - cost) / cost) * 100;
}

bool validatePassengerCountLogic(int expectedCount, int actualCount) {
  return expectedCount == actualCount;
}

void main() {
  group('Custom Actions Logic Tests', () {
    group('Calculate Total Logic', () {
      test('should calculate total correctly with 20% profit', () {
        // Arrange
        const cost = 100.0;
        const profit = 20.0;

        // Act
        final result = calculateTotalLogic(cost, profit);

        // Assert
        expect(result, equals(120.0));
      });

      test('should handle zero cost', () {
        // Arrange
        const cost = 0.0;
        const profit = 20.0;

        // Act
        final result = calculateTotalLogic(cost, profit);

        // Assert
        expect(result, equals(0.0));
      });

      test('should handle zero profit', () {
        // Arrange
        const cost = 100.0;
        const profit = 0.0;

        // Act
        final result = calculateTotalLogic(cost, profit);

        // Assert
        expect(result, equals(100.0));
      });

      test('should handle negative profit', () {
        // Arrange
        const cost = 100.0;
        const profit = -10.0;

        // Act
        final result = calculateTotalLogic(cost, profit);

        // Assert
        expect(result, equals(90.0));
      });

      test('should handle decimal values', () {
        // Arrange
        const cost = 150.75;
        const profit = 15.5;

        // Act
        final result = calculateTotalLogic(cost, profit);

        // Assert
        expect(result, closeTo(174.116, 0.01));
      });

      test('should handle large numbers', () {
        // Arrange
        const cost = 999999.99;
        const profit = 100.0;

        // Act
        final result = calculateTotalLogic(cost, profit);

        // Assert
        expect(result, equals(1999999.98));
      });
    });

    group('Calculate Profit Logic', () {
      test('should calculate profit percentage correctly', () {
        // Arrange
        const cost = 100.0;
        const total = 120.0;

        // Act
        final result = calculateProfitLogic(cost, total);

        // Assert
        expect(result, equals(20.0));
      });

      test('should handle zero profit scenario', () {
        // Arrange
        const cost = 100.0;
        const total = 100.0;

        // Act
        final result = calculateProfitLogic(cost, total);

        // Assert
        expect(result, equals(0.0));
      });

      test('should handle loss scenario', () {
        // Arrange
        const cost = 100.0;
        const total = 80.0;

        // Act
        final result = calculateProfitLogic(cost, total);

        // Assert
        expect(result, equals(-20.0));
      });

      test('should handle zero cost', () {
        // Arrange
        const cost = 0.0;
        const total = 100.0;

        // Act
        final result = calculateProfitLogic(cost, total);

        // Assert
        expect(result, equals(0.0));
      });

      test('should handle decimal values', () {
        // Arrange
        const cost = 33.33;
        const total = 44.44;

        // Act
        final result = calculateProfitLogic(cost, total);

        // Assert
        expect(result, closeTo(33.33, 0.01));
      });

      test('should be consistent with calculate total', () {
        // Arrange
        const originalCost = 150.0;
        const profitPercentage = 25.0;

        // Act
        final calculatedTotal = calculateTotalLogic(originalCost, profitPercentage);
        final calculatedProfit = calculateProfitLogic(originalCost, calculatedTotal);

        // Assert
        expect(calculatedProfit, closeTo(profitPercentage, 0.01));
      });
    });

    group('Validate Passenger Count Logic', () {
      test('should return true when counts match', () {
        // Arrange
        const expected = 5;
        const actual = 5;

        // Act
        final result = validatePassengerCountLogic(expected, actual);

        // Assert
        expect(result, isTrue);
      });

      test('should return false when counts do not match', () {
        // Arrange
        const expected = 5;
        const actual = 3;

        // Act
        final result = validatePassengerCountLogic(expected, actual);

        // Assert
        expect(result, isFalse);
      });

      test('should handle zero passengers', () {
        // Arrange
        const expected = 0;
        const actual = 0;

        // Act
        final result = validatePassengerCountLogic(expected, actual);

        // Assert
        expect(result, isTrue);
      });

      test('should handle large passenger counts', () {
        // Arrange
        const expected = 1000;
        const actual = 1000;

        // Act
        final result = validatePassengerCountLogic(expected, actual);

        // Assert
        expect(result, isTrue);
      });
    });

    group('Edge Cases and Error Scenarios', () {
      test('should handle very small numbers', () {
        // Arrange
        const cost = 0.01;
        const profit = 0.01;

        // Act
        final result = calculateTotalLogic(cost, profit);

        // Assert
        expect(result, closeTo(0.0100001, 0.000001));
      });

      test('should handle very large profit percentages', () {
        // Arrange
        const cost = 100.0;
        const profit = 1000.0; // 1000%

        // Act
        final result = calculateTotalLogic(cost, profit);

        // Assert
        expect(result, equals(1100.0));
      });

      test('should maintain precision with multiple calculations', () {
        // Test chain: cost -> total -> profit -> total again
        const originalCost = 123.45;
        const originalProfit = 67.89;

        // Calculate total
        final total1 = calculateTotalLogic(originalCost, originalProfit);
        
        // Calculate profit back
        final calculatedProfit = calculateProfitLogic(originalCost, total1);
        
        // Calculate total again with calculated profit
        final total2 = calculateTotalLogic(originalCost, calculatedProfit);

        // Assert that we get back to the same total (within reasonable precision)
        expect(total2, closeTo(total1, 0.01));
      });

      test('should handle negative cost in profit calculation', () {
        // Arrange
        const cost = -100.0;
        const total = -80.0;

        // Act
        final result = calculateProfitLogic(cost, total);

        // Assert - With negative or zero cost, the function returns 0
        expect(result, equals(0.0));
      });
    });

    group('Business Logic Validation', () {
      test('should calculate correct markup for common business scenarios', () {
        // Test common business markups
        final testCases = [
          {'cost': 50.0, 'markup': 100.0, 'expected': 100.0}, // 100% markup
          {'cost': 100.0, 'markup': 50.0, 'expected': 150.0}, // 50% markup
          {'cost': 200.0, 'markup': 25.0, 'expected': 250.0}, // 25% markup
          {'cost': 75.0, 'markup': 33.33, 'expected': 99.9975}, // 33.33% markup
        ];

        for (final testCase in testCases) {
          final result = calculateTotalLogic(
            testCase['cost']! as double,
            testCase['markup']! as double,
          );
          expect(result, closeTo(testCase['expected']! as double, 0.01));
        }
      });

      test('should validate passenger scenarios', () {
        // Test realistic passenger scenarios
        final scenarios = [
          {'expected': 1, 'actual': 1, 'valid': true}, // Solo traveler
          {'expected': 2, 'actual': 2, 'valid': true}, // Couple
          {'expected': 4, 'actual': 4, 'valid': true}, // Family
          {'expected': 10, 'actual': 10, 'valid': true}, // Group
          {'expected': 4, 'actual': 3, 'valid': false}, // Missing passenger
          {'expected': 2, 'actual': 3, 'valid': false}, // Extra passenger
        ];

        for (final scenario in scenarios) {
          final result = validatePassengerCountLogic(
            scenario['expected']! as int,
            scenario['actual']! as int,
          );
          expect(result, equals(scenario['valid']));
        }
      });

      test('should handle typical hotel pricing scenarios', () {
        // Test hotel pricing with different markup strategies
        final hotelScenarios = [
          {'cost': 80.0, 'markup': 25.0}, // Standard hotel markup
          {'cost': 150.0, 'markup': 40.0}, // Luxury hotel markup
          {'cost': 45.0, 'markup': 60.0}, // Budget hotel high markup
        ];

        for (final scenario in hotelScenarios) {
          final cost = scenario['cost']! as double;
          final markup = scenario['markup']! as double;
          
          final total = calculateTotalLogic(cost, markup);
          final calculatedMarkup = calculateProfitLogic(cost, total);
          
          // Verify roundtrip calculation maintains accuracy
          expect(calculatedMarkup, closeTo(markup, 0.01));
        }
      });

      test('should handle activity pricing scenarios', () {
        // Test activity pricing
        final activityScenarios = [
          {'cost': 25.0, 'markup': 100.0}, // Tour with 100% markup
          {'cost': 75.0, 'markup': 33.33}, // Activity with 33% markup
          {'cost': 120.0, 'markup': 20.0}, // Premium activity low markup
        ];

        for (final scenario in activityScenarios) {
          final cost = scenario['cost']! as double;
          final markup = scenario['markup']! as double;
          
          final total = calculateTotalLogic(cost, markup);
          
          // Verify the total is always greater than cost for positive markup
          if (markup > 0) {
            expect(total, greaterThan(cost));
          } else if (markup < 0) {
            expect(total, lessThan(cost));
          } else {
            expect(total, equals(cost));
          }
        }
      });
    });
  });
}