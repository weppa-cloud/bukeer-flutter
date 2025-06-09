#!/usr/bin/env dart

import 'dart:io';

void main() async {
  print('Fixing import/export statements...');

  final projectRoot = Directory.current.path;

  // Define the import/export fixes
  final fixes = {
    // Date picker
    "import 'date_picker_model.dart';": "import 'date_picker_model.dart';",
    "export 'date_picker_model.dart';": "export 'date_picker_model.dart';",
    "import 'date_picker_widget.dart'": "import 'date_picker_widget.dart'",

    // Date range picker
    "import 'date_range_picker_model.dart';":
        "import 'date_range_picker_model.dart';",
    "export 'date_range_picker_model.dart';":
        "export 'date_range_picker_model.dart';",
    "import 'date_range_picker_widget.dart'":
        "import 'date_range_picker_widget.dart'",

    // Place picker
    "import 'place_picker_model.dart';": "import 'place_picker_model.dart';",
    "export 'place_picker_model.dart';": "export 'place_picker_model.dart';",
    "import 'place_picker_widget.dart'": "import 'place_picker_widget.dart'",

    // Birth date picker
    "import 'birth_date_picker_model.dart';":
        "import 'birth_date_picker_model.dart';",
    "export 'birth_date_picker_model.dart';":
        "export 'birth_date_picker_model.dart';",
    "import 'birth_date_picker_widget.dart'":
        "import 'birth_date_picker_widget.dart'",

    // Currency selector
    "import 'currency_selector_model.dart';":
        "import 'currency_selector_model.dart';",
    "export 'currency_selector_model.dart';":
        "export 'currency_selector_model.dart';",
    "import 'currency_selector_widget.dart'":
        "import 'currency_selector_widget.dart'",

    // Payment add
    "import 'payment_add_model.dart';": "import 'payment_add_model.dart';",
    "export 'payment_add_model.dart';": "export 'payment_add_model.dart';",
    "import 'payment_add_widget.dart'": "import 'payment_add_widget.dart'",

    // Payment provider
    "import 'payment_provider_model.dart';":
        "import 'payment_provider_model.dart';",
    "export 'payment_provider_model.dart';":
        "export 'payment_provider_model.dart';",
    "import 'payment_provider_widget.dart'":
        "import 'payment_provider_widget.dart'",
  };

  await fixImportsExports(projectRoot, fixes);

  print('Import/export fixes completed!');
}

Future<void> fixImportsExports(
    String projectRoot, Map<String, String> fixes) async {
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

        for (final entry in fixes.entries) {
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
