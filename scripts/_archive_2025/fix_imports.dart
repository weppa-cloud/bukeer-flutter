#!/usr/bin/env dart

import 'dart:io';

/// Fix script to add missing design system imports for migrated constants
void main() async {
  print('🔧 Fixing missing design system imports...');

  final libDir = Directory('lib/bukeer');
  var filesFixed = 0;

  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();

      // Check if file uses BukeerSpacing but doesn't import it
      if (content.contains('BukeerSpacing') &&
          !content.contains(
              "import 'package:bukeer/design_system/tokens/index.dart';") &&
          !content
              .contains("import '../../../design_system/tokens/index.dart';") &&
          !content
              .contains("import '../../design_system/tokens/index.dart';") &&
          !content.contains("import '../design_system/tokens/index.dart';")) {
        // Find where to add the import
        final lines = content.split('\n');
        var insertIndex = -1;

        // Find the last import statement
        for (var i = 0; i < lines.length; i++) {
          if (lines[i].trimLeft().startsWith('import ') &&
              !lines[i].contains('export')) {
            insertIndex = i + 1;
          }
        }

        if (insertIndex > 0) {
          lines.insert(insertIndex,
              "import 'package:bukeer/design_system/tokens/index.dart';");
          await entity.writeAsString(lines.join('\n'));
          filesFixed++;
          print('✅ Fixed: ${entity.path}');
        }
      }
    }
  }

  print('\n📊 Fixed $filesFixed files');
}
