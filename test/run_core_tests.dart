// Core test runner for tests that work without external dependencies
import 'package:flutter_test/flutter_test.dart';

// Import only tests that work standalone
import 'custom_actions/calculate_functions_test.dart' as calculate_tests;
import 'services/error_service_test.dart' as error_tests;
import 'services/contact_service_test_fixed.dart' as contact_tests;

void main() {
  group('Core Bukeer Tests - Production Ready', () {
    group('Business Logic Tests', () {
      calculate_tests.main();
    });
    
    group('Error Management Tests', () {
      error_tests.main();
    });
    
    group('Service Tests', () {
      contact_tests.main();
    });
  });
}