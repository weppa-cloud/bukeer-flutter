#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

void main() async {
  print('Starting form component renaming process...');

  final projectRoot = Directory.current.path;

  // Define the renaming mappings
  final renamings = {
    // Form components
    'date_picker': 'date_picker',
    'DatePicker': 'DatePicker',
    'date_range_picker': 'date_range_picker',
    'DateRangePicker': 'DateRangePicker',
    'place_picker': 'place_picker',
    'PlacePicker': 'PlacePicker',
    'birth_date_picker': 'birth_date_picker',
    'BirthDatePicker': 'BirthDatePicker',
    'currency_selector': 'currency_selector',
    'CurrencySelector': 'CurrencySelector',

    // Payment components
    'payment_add': 'payment_add',
    'PaymentAdd': 'PaymentAdd',
    'payment_provider': 'payment_provider',
    'PaymentProvider': 'PaymentProvider',
  };

  // Step 1: Rename directories
  print('\n1. Renaming directories...');
  await renameDirectories(projectRoot, renamings);

  // Step 2: Update file contents
  print('\n2. Updating file contents...');
  await updateFileContents(projectRoot, renamings);

  // Step 3: Update imports
  print('\n3. Updating imports...');
  await updateImports(projectRoot, renamings);

  // Step 4: Generate report
  print('\n4. Generating report...');
  await generateReport(projectRoot, renamings);

  print('\nRenaming process completed!');
}

Future<void> renameDirectories(
    String projectRoot, Map<String, String> renamings) async {
  final directories = [
    '$projectRoot/lib/bukeer/core/widgets/forms',
    '$projectRoot/lib/bukeer/core/widgets/payments',
    '$projectRoot/test/widgets/core/forms',
    '$projectRoot/test/widgets/core/payments',
  ];

  for (final dirPath in directories) {
    final dir = Directory(dirPath);
    if (!await dir.exists()) continue;

    await for (final entity in dir.list()) {
      if (entity is Directory) {
        final dirName = entity.path.split('/').last;

        for (final oldName in renamings.keys) {
          if (dirName == oldName) {
            final newName = renamings[oldName]!;
            final newPath = entity.path.replaceAll('/$oldName', '/$newName');

            print('  Renaming directory: $oldName -> $newName');
            await entity.rename(newPath);
            break;
          }
        }
      }
    }
  }
}

Future<void> updateFileContents(
    String projectRoot, Map<String, String> renamings) async {
  final extensions = ['.dart', '.md', '.yaml', '.json'];
  final dir = Directory(projectRoot);

  await for (final entity in dir.list(recursive: true)) {
    if (entity is File) {
      final path = entity.path;

      // Skip directories we don't want to modify
      if (path.contains('/.git/') ||
          path.contains('/build/') ||
          path.contains('/.dart_tool/') ||
          path.contains('/coverage/') ||
          path.contains('/node_modules/')) {
        continue;
      }

      // Check if file has a relevant extension
      if (!extensions.any((ext) => path.endsWith(ext))) {
        continue;
      }

      try {
        var content = await entity.readAsString();
        var modified = false;

        for (final entry in renamings.entries) {
          final oldPattern = entry.key;
          final newPattern = entry.value;

          // Create various patterns to match
          final patterns = [
            // Direct matches
            RegExp(r'\b' + oldPattern + r'\b'),
            // Import paths
            RegExp('/' + oldPattern + '/'),
            RegExp('/' + oldPattern + r'\.dart'),
            // Class names (for PascalCase entries)
            if (oldPattern[0] == oldPattern[0].toUpperCase())
              RegExp(r'\b' + oldPattern + r'(?=Model|Widget|State)\b'),
          ];

          for (final pattern in patterns) {
            if (pattern.hasMatch(content)) {
              content = content.replaceAllMapped(pattern, (match) {
                final matched = match.group(0)!;
                if (matched.contains('/')) {
                  return matched.replaceAll(oldPattern, newPattern);
                } else if (matched.endsWith('.dart')) {
                  return matched.replaceAll(oldPattern, newPattern);
                } else {
                  return newPattern;
                }
              });
              modified = true;
            }
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

Future<void> updateImports(
    String projectRoot, Map<String, String> renamings) async {
  // Special handling for import statements
  final dartFiles = await findDartFiles(projectRoot);

  for (final filePath in dartFiles) {
    try {
      final file = File(filePath);
      var content = await file.readAsString();
      var modified = false;

      // Update import statements
      for (final entry in renamings.entries) {
        final oldName = entry.key;
        final newName = entry.value;

        // Match import statements
        final importPattern =
            RegExp("import\\s+'([^']*/$oldName/[^']*)'", multiLine: true);

        if (importPattern.hasMatch(content)) {
          content = content.replaceAllMapped(importPattern, (match) {
            final importPath = match.group(1)!;
            final newImportPath =
                importPath.replaceAll('/$oldName/', '/$newName/');
            return "import '$newImportPath'";
          });
          modified = true;
        }
      }

      if (modified) {
        print(
            '  Updated imports in: ${filePath.substring(projectRoot.length + 1)}');
        await file.writeAsString(content);
      }
    } catch (e) {
      print('  Error updating imports in $filePath: $e');
    }
  }
}

Future<List<String>> findDartFiles(String projectRoot) async {
  final files = <String>[];
  final dir = Directory(projectRoot);

  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final path = entity.path;
      if (!path.contains('/.git/') &&
          !path.contains('/build/') &&
          !path.contains('/.dart_tool/')) {
        files.add(path);
      }
    }
  }

  return files;
}

Future<void> generateReport(
    String projectRoot, Map<String, String> renamings) async {
  final report = StringBuffer();

  report.writeln('# Form Component Renaming Report');
  report.writeln('\nDate: ${DateTime.now()}');
  report.writeln('\n## Renamed Components\n');

  report.writeln('### Form Components');
  report.writeln('| Old Name | New Name |');
  report.writeln('|----------|----------|');

  final formComponents = [
    'date_picker',
    'date_range_picker',
    'place_picker',
    'birth_date_picker',
    'currency_selector',
  ];

  for (final oldName in formComponents) {
    if (renamings.containsKey(oldName)) {
      report.writeln('| $oldName | ${renamings[oldName]} |');
    }
  }

  report.writeln('\n### Payment Components');
  report.writeln('| Old Name | New Name |');
  report.writeln('|----------|----------|');

  final paymentComponents = [
    'payment_add',
    'payment_provider',
  ];

  for (final oldName in paymentComponents) {
    if (renamings.containsKey(oldName)) {
      report.writeln('| $oldName | ${renamings[oldName]} |');
    }
  }

  report.writeln('\n## Updated Locations\n');
  report.writeln('- `/lib/bukeer/core/widgets/forms/` - Form components');
  report.writeln('- `/lib/bukeer/core/widgets/payments/` - Payment components');
  report.writeln('- `/test/widgets/core/forms/` - Form component tests');
  report.writeln('- `/test/widgets/core/payments/` - Payment component tests');

  report.writeln('\n## Class Name Changes\n');
  for (final entry in renamings.entries) {
    if (entry.key[0] == entry.key[0].toUpperCase()) {
      report.writeln('- `${entry.key}Model` → `${entry.value}Model`');
      report.writeln('- `${entry.key}Widget` → `${entry.value}Widget`');
      report.writeln('- `${entry.key}State` → `${entry.value}State`');
    }
  }

  final reportFile = File('$projectRoot/FORM_COMPONENT_RENAMING_REPORT.md');
  await reportFile.writeAsString(report.toString());

  print('\nReport saved to: FORM_COMPONENT_RENAMING_REPORT.md');
}
