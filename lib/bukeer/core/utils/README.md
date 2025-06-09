# Bukeer Core Utilities

This directory contains reusable utility functions organized by functionality. These utilities are designed to be pure functions that can be used across the application without dependencies on specific widgets or services.

## Directory Structure

### `/date`
Date-related utilities for formatting, parsing, and calculating dates.
- Date formatting helpers
- Date range calculations
- Night calculations between dates
- Date manipulation functions

### `/currency`
Currency formatting and conversion utilities.
- Currency formatting with localization
- Multi-currency conversion helpers
- Exchange rate calculations
- Currency display utilities
- Account types and payment methods management
- JSON array calculations for financial data

### `/validation`
Form validation and data validation utilities.
- Email validation
- Phone number validation
- Passenger data validation
- Payment validation
- General form field validators
- Reservation validation

### `/pdf`
PDF generation and manipulation utilities.
- PDF creation helpers
- Itinerary PDF formatters
- Voucher PDF formatters
- PDF styling utilities
- Layout calculations and pagination

### `/general`
General purpose utilities.
- JSON manipulation and parsing
- Data transformation helpers
- Nested object operations
- Common utility functions

## Usage

Import the specific utility category you need:

```dart
import 'package:bukeer/bukeer/core/utils/date/index.dart';
import 'package:bukeer/bukeer/core/utils/currency/index.dart';
import 'package:bukeer/bukeer/core/utils/validation/index.dart';
import 'package:bukeer/bukeer/core/utils/pdf/index.dart';
```

Or import all utilities:

```dart
import 'package:bukeer/bukeer/core/utils/index.dart';
```

## Guidelines

1. **Pure Functions**: All utilities should be pure functions without side effects
2. **No Dependencies**: Avoid dependencies on services, widgets, or state management
3. **Well Documented**: Each function should have clear documentation
4. **Type Safe**: Use strong typing and avoid dynamic types when possible
5. **Testable**: All utilities should be easily testable with unit tests

## Adding New Utilities

When adding new utility functions:
1. Place them in the appropriate category directory
2. Export them from the category's `index.dart` file
3. Add documentation and examples
4. Write unit tests for the new utilities