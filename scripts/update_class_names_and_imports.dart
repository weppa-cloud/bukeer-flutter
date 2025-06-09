#!/usr/bin/env dart

import 'dart:io';

void main() async {
  print('Starting class names and imports update process...');

  final projectRoot = Directory.current.path;

  // Define the mappings for class names and imports
  final updates = {
    // Date picker
    'ComponentDate': 'DatePicker',
    'component_date_model': 'date_picker_model',
    'component_date_widget': 'date_picker_widget',

    // Date range picker
    'ComponentDateRange': 'DateRangePicker',
    'component_date_range_model': 'date_range_picker_model',
    'component_date_range_widget': 'date_range_picker_widget',

    // Place picker
    'ComponentPlace': 'PlacePicker',
    'component_place_model': 'place_picker_model',
    'component_place_widget': 'place_picker_widget',

    // Birth date picker
    'ComponentBirthDate': 'BirthDatePicker',
    'component_birth_date_model': 'birth_date_picker_model',
    'component_birth_date_widget': 'birth_date_picker_widget',

    // Currency selector
    'ComponentAddCurrency': 'CurrencySelector',
    'component_add_currency_model': 'currency_selector_model',
    'component_add_currency_widget': 'currency_selector_widget',

    // Payment add
    'ComponentAddPaid': 'PaymentAdd',
    'component_add_paid_model': 'payment_add_model',
    'component_add_paid_widget': 'payment_add_widget',

    // Payment provider
    'ComponentProviderPayments': 'PaymentProvider',
    'component_provider_payments_model': 'payment_provider_model',
    'component_provider_payments_widget': 'payment_provider_widget',
  };

  // Step 1: Update all Dart files
  print('\n1. Updating Dart files...');
  await updateDartFiles(projectRoot, updates);

  // Step 2: Update export files
  print('\n2. Updating export files...');
  await updateExportFiles(projectRoot);

  print('\nClass names and imports update completed!');
}

Future<void> updateDartFiles(
    String projectRoot, Map<String, String> updates) async {
  final dir = Directory(projectRoot);

  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final path = entity.path;

      // Skip certain directories
      if (path.contains('/.git/') ||
          path.contains('/build/') ||
          path.contains('/.dart_tool/') ||
          path.contains('/coverage/')) {
        continue;
      }

      try {
        var content = await entity.readAsString();
        var modified = false;

        // Update class names and imports
        for (final entry in updates.entries) {
          final oldPattern = entry.key;
          final newPattern = entry.value;

          // Update class names
          if (oldPattern[0].toUpperCase() == oldPattern[0]) {
            // It's a class name
            final classPatterns = [
              RegExp(r'\b' + oldPattern + r'Widget\b'),
              RegExp(r'\b' + oldPattern + r'Model\b'),
              RegExp(r'\b' + oldPattern + r'State\b'),
              RegExp(r'\b_' + oldPattern + r'WidgetState\b'),
              RegExp(r'\bcreateModel<' + oldPattern + r'Model>\b'),
              RegExp(r'\blate ' + oldPattern + r'Model\b'),
              RegExp(r'\b' + oldPattern + r'Model\s+_model\b'),
            ];

            for (final pattern in classPatterns) {
              if (pattern.hasMatch(content)) {
                content = content.replaceAllMapped(pattern, (match) {
                  return match.group(0)!.replaceAll(oldPattern, newPattern);
                });
                modified = true;
              }
            }
          } else {
            // It's a file import
            final importPatterns = [
              RegExp("import\\s+'([^']*/" + oldPattern + r"\.dart)'"),
              RegExp("export\\s+'([^']*/" + oldPattern + r"\.dart)'"),
            ];

            for (final pattern in importPatterns) {
              if (pattern.hasMatch(content)) {
                content = content.replaceAllMapped(pattern, (match) {
                  return match.group(0)!.replaceAll(oldPattern, newPattern);
                });
                modified = true;
              }
            }
          }
        }

        // Special handling for wrapWithModel calls
        content = content.replaceAllMapped(
            RegExp(r'wrapWithModel\(\s*model:\s*_model\.(\w+),'), (match) {
          final modelName = match.group(1)!;
          final mappings = {
            'datePickerModel': 'datePickerModel',
            'dateRangePickerModel': 'dateRangePickerModel',
            'placePickerModel': 'placePickerModel',
            'birthDatePickerModel': 'birthDatePickerModel',
            'currencySelectorModel': 'currencySelectorModel',
            'paymentAddModel': 'paymentAddModel',
            'paymentProviderModel': 'paymentProviderModel',
          };

          if (mappings.containsKey(modelName)) {
            modified = true;
            return 'wrapWithModel(\n                          model: _model.${mappings[modelName]},';
          }
          return match.group(0)!;
        });

        // Update model field names
        final modelFieldMappings = {
          'datePickerModel': 'datePickerModel',
          'dateRangePickerModel': 'dateRangePickerModel',
          'placePickerModel': 'placePickerModel',
          'birthDatePickerModel': 'birthDatePickerModel',
          'currencySelectorModel': 'currencySelectorModel',
          'paymentAddModel': 'paymentAddModel',
          'paymentProviderModel': 'paymentProviderModel',
        };

        for (final entry in modelFieldMappings.entries) {
          if (content.contains(entry.key)) {
            content = content.replaceAll(entry.key, entry.value);
            modified = true;
          }
        }

        if (modified) {
          print('  Updated: ${path.substring(projectRoot.length + 1)}');
          await entity.writeAsString(content);
        }
      } catch (e) {
        print('  Error processing $path: $e');
      }
    }
  }
}

Future<void> updateExportFiles(String projectRoot) async {
  // Update the main forms index file
  final formsIndexPath =
      '$projectRoot/lib/bukeer/core/widgets/forms/index.dart';
  final formsIndexFile = File(formsIndexPath);

  if (await formsIndexFile.exists()) {
    await formsIndexFile
        .writeAsString('''// Form Components - All form-related widgets
// Centralized exports for form components

// Basic Input Components
export 'currency_selector/currency_selector_widget.dart';
export 'birth_date_picker/birth_date_picker_widget.dart';
export 'date_picker/date_picker_widget.dart';
export 'date_range_picker/date_range_picker_widget.dart';
export 'place_picker/place_picker_widget.dart';
export 'search_box/search_box_widget.dart';

// Dropdown Components
export 'dropdowns/accounts/dropdown_accounts_widget.dart';
export 'dropdowns/airports/dropdown_airports_widget.dart';
export 'dropdowns/contacts/dropdown_contacts_widget.dart';
export 'dropdowns/products/dropdown_products_widget.dart';
export 'dropdowns/travel_planner/dropdown_travel_planner_widget.dart';
''');
    print('  Updated forms index file');
  }

  // Update the payments index file
  final paymentsIndexPath =
      '$projectRoot/lib/bukeer/core/widgets/payments/index.dart';
  final paymentsIndexFile = File(paymentsIndexPath);

  if (await paymentsIndexFile.exists()) {
    await paymentsIndexFile.writeAsString(
        '''// Payment Components - Centralized payment management widgets
// All payment-related components in one place

// Add payment transaction component
export 'payment_add/payment_add_widget.dart';

// Provider payment management component
export 'payment_provider/payment_provider_widget.dart';

// Payment methods configuration component
export 'edit_payment_methods/edit_payment_methods_widget.dart';
''');
    print('  Updated payments index file');
  }

  // Update the main widgets index file
  final mainIndexPath = '$projectRoot/lib/bukeer/core/widgets/index.dart';
  final mainIndexFile = File(mainIndexPath);

  if (await mainIndexFile.exists()) {
    var content = await mainIndexFile.readAsString();

    // Update form widget exports
    content = content.replaceAll(
        "export 'forms/date_picker/date_picker_widget.dart';",
        "export 'forms/date_picker/date_picker_widget.dart';");
    content = content.replaceAll(
        "export 'forms/date_range_picker/date_range_picker_widget.dart';",
        "export 'forms/date_range_picker/date_range_picker_widget.dart';");
    content = content.replaceAll(
        "export 'forms/birth_date_picker/birth_date_picker_widget.dart';",
        "export 'forms/birth_date_picker/birth_date_picker_widget.dart';");
    content = content.replaceAll(
        "export 'forms/place_picker/place_picker_widget.dart';",
        "export 'forms/place_picker/place_picker_widget.dart';");
    content = content.replaceAll(
        "export 'forms/currency_selector/currency_selector_widget.dart';",
        "export 'forms/currency_selector/currency_selector_widget.dart';");

    await mainIndexFile.writeAsString(content);
    print('  Updated main widgets index file');
  }

  // Update the componentes compatibility index file
  final componentesIndexPath = '$projectRoot/lib/bukeer/componentes/index.dart';
  final componentesIndexFile = File(componentesIndexPath);

  if (await componentesIndexFile.exists()) {
    await componentesIndexFile.writeAsString(
        '''// Archivo de compatibilidad temporal para la migración gradual
// Este archivo re-exporta componentes desde su nueva ubicación en core/widgets

// Re-export moved components from core
export '../core/widgets/buttons/btn_back/btn_back_widget.dart';
export '../core/widgets/buttons/btn_create/btn_create_widget.dart';
export '../core/widgets/buttons/btn_mobile_menu/btn_mobile_menu_widget.dart';
export '../core/widgets/forms/search_box/search_box_widget.dart';
export '../core/widgets/forms/date_picker/date_picker_widget.dart';
export '../core/widgets/forms/date_range_picker/date_range_picker_widget.dart';
export '../core/widgets/forms/birth_date_picker/birth_date_picker_widget.dart';
export '../core/widgets/forms/place_picker/place_picker_widget.dart';
export '../core/widgets/forms/currency_selector/currency_selector_widget.dart';
export '../core/widgets/navigation/web_nav/web_nav_widget.dart';
export '../core/widgets/navigation/mobile_nav/mobile_nav_widget.dart';
export '../core/widgets/navigation/main_logo_small/main_logo_small_widget.dart';

// All components have been migrated to /core/widgets/
// Moved to core/widgets/buttons/
// Moved to core/widgets/forms/
''');
    print('  Updated componentes compatibility index file');
  }
}
