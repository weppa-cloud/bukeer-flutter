#!/usr/bin/env dart

import 'dart:io';

void main() async {
  print('Starting file renaming process...');

  final projectRoot = Directory.current.path;

  // Define the file renaming mappings
  final fileRenamings = {
    // Date picker
    'component_date_model.dart': 'date_picker_model.dart',
    'component_date_widget.dart': 'date_picker_widget.dart',

    // Date range picker
    'component_date_range_model.dart': 'date_range_picker_model.dart',
    'component_date_range_widget.dart': 'date_range_picker_widget.dart',

    // Place picker
    'component_place_model.dart': 'place_picker_model.dart',
    'component_place_widget.dart': 'place_picker_widget.dart',

    // Birth date picker
    'component_birth_date_model.dart': 'birth_date_picker_model.dart',
    'component_birth_date_widget.dart': 'birth_date_picker_widget.dart',

    // Currency selector
    'component_add_currency_model.dart': 'currency_selector_model.dart',
    'component_add_currency_widget.dart': 'currency_selector_widget.dart',

    // Payment add
    'component_add_paid_model.dart': 'payment_add_model.dart',
    'component_add_paid_widget.dart': 'payment_add_widget.dart',

    // Payment provider
    'component_provider_payments_model.dart': 'payment_provider_model.dart',
    'component_provider_payments_widget.dart': 'payment_provider_widget.dart',
  };

  // Step 1: Rename files
  print('\n1. Renaming files...');
  await renameFiles(projectRoot, fileRenamings);

  print('\nFile renaming process completed!');
}

Future<void> renameFiles(
    String projectRoot, Map<String, String> renamings) async {
  final directories = [
    '$projectRoot/lib/bukeer/core/widgets/forms/date_picker',
    '$projectRoot/lib/bukeer/core/widgets/forms/date_range_picker',
    '$projectRoot/lib/bukeer/core/widgets/forms/place_picker',
    '$projectRoot/lib/bukeer/core/widgets/forms/birth_date_picker',
    '$projectRoot/lib/bukeer/core/widgets/forms/currency_selector',
    '$projectRoot/lib/bukeer/core/widgets/payments/payment_add',
    '$projectRoot/lib/bukeer/core/widgets/payments/payment_provider',
  ];

  for (final dirPath in directories) {
    final dir = Directory(dirPath);
    if (!await dir.exists()) continue;

    await for (final entity in dir.list()) {
      if (entity is File) {
        final fileName = entity.path.split('/').last;

        if (renamings.containsKey(fileName)) {
          final newFileName = renamings[fileName]!;
          final newPath = entity.path.replaceAll(fileName, newFileName);

          print('  Renaming file: $fileName -> $newFileName');
          await entity.rename(newPath);
        }
      }
    }
  }
}
