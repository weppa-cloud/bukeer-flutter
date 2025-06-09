#!/usr/bin/env dart

import 'dart:io';

/// Migration script to replace hardcoded values with design system constants
///
/// Usage: dart scripts/migrate_hardcoded_values.dart [--dry-run]
///
/// Options:
///   --dry-run    Preview changes without modifying files
///   --verbose    Show detailed output
void main(List<String> args) async {
  final isDryRun = args.contains('--dry-run');
  final isVerbose = args.contains('--verbose');

  print('🚀 Starting migration of hardcoded values to design system constants');
  print(
      'Mode: ${isDryRun ? "DRY RUN (no files will be modified)" : "LIVE (files will be modified)"}');
  print('');

  final migrator = HardcodedValueMigrator(
    isDryRun: isDryRun,
    isVerbose: isVerbose,
  );

  await migrator.run();
}

class HardcodedValueMigrator {
  final bool isDryRun;
  final bool isVerbose;

  // Track statistics
  int filesProcessed = 0;
  int filesModified = 0;
  int totalReplacements = 0;
  final Map<String, int> replacementCounts = {};

  HardcodedValueMigrator({
    required this.isDryRun,
    required this.isVerbose,
  });

  // Define replacement patterns
  final List<ReplacementPattern> patterns = [
    // EdgeInsets patterns
    ReplacementPattern(
      name: 'EdgeInsets.all(4)',
      pattern: RegExp(r'EdgeInsets\.all\(\s*4(?:\.0)?\s*\)'),
      replacement: 'EdgeInsets.all(BukeerSpacing.xs)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'EdgeInsets.all(8)',
      pattern: RegExp(r'EdgeInsets\.all\(\s*8(?:\.0)?\s*\)'),
      replacement: 'EdgeInsets.all(BukeerSpacing.s)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'EdgeInsets.all(12)',
      pattern: RegExp(r'EdgeInsets\.all\(\s*12(?:\.0)?\s*\)'),
      replacement: 'EdgeInsets.all(BukeerSpacing.sm)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'EdgeInsets.all(16)',
      pattern: RegExp(r'EdgeInsets\.all\(\s*16(?:\.0)?\s*\)'),
      replacement: 'EdgeInsets.all(BukeerSpacing.m)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'EdgeInsets.all(20)',
      pattern: RegExp(r'EdgeInsets\.all\(\s*20(?:\.0)?\s*\)'),
      replacement: 'EdgeInsets.all(BukeerSpacing.ml)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'EdgeInsets.all(24)',
      pattern: RegExp(r'EdgeInsets\.all\(\s*24(?:\.0)?\s*\)'),
      replacement: 'EdgeInsets.all(BukeerSpacing.l)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'EdgeInsets.all(32)',
      pattern: RegExp(r'EdgeInsets\.all\(\s*32(?:\.0)?\s*\)'),
      replacement: 'EdgeInsets.all(BukeerSpacing.xl)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),

    // EdgeInsets.symmetric patterns
    ReplacementPattern(
      name: 'EdgeInsets.symmetric(horizontal: 16)',
      pattern:
          RegExp(r'EdgeInsets\.symmetric\(\s*horizontal:\s*16(?:\.0)?\s*\)'),
      replacement: 'EdgeInsets.symmetric(horizontal: BukeerSpacing.m)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'EdgeInsets.symmetric(horizontal: 24)',
      pattern:
          RegExp(r'EdgeInsets\.symmetric\(\s*horizontal:\s*24(?:\.0)?\s*\)'),
      replacement: 'EdgeInsets.symmetric(horizontal: BukeerSpacing.l)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'EdgeInsets.symmetric(vertical: 16)',
      pattern: RegExp(r'EdgeInsets\.symmetric\(\s*vertical:\s*16(?:\.0)?\s*\)'),
      replacement: 'EdgeInsets.symmetric(vertical: BukeerSpacing.m)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'EdgeInsets.symmetric(vertical: 24)',
      pattern: RegExp(r'EdgeInsets\.symmetric\(\s*vertical:\s*24(?:\.0)?\s*\)'),
      replacement: 'EdgeInsets.symmetric(vertical: BukeerSpacing.l)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),

    // BorderRadius patterns
    ReplacementPattern(
      name: 'BorderRadius.circular(4)',
      pattern: RegExp(r'BorderRadius\.circular\(\s*4(?:\.0)?\s*\)'),
      replacement: 'BorderRadius.circular(BukeerSpacing.xs)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'BorderRadius.circular(8)',
      pattern: RegExp(r'BorderRadius\.circular\(\s*8(?:\.0)?\s*\)'),
      replacement: 'BorderRadius.circular(BukeerSpacing.s)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'BorderRadius.circular(12)',
      pattern: RegExp(r'BorderRadius\.circular\(\s*12(?:\.0)?\s*\)'),
      replacement: 'BorderRadius.circular(BukeerSpacing.sm)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'BorderRadius.circular(16)',
      pattern: RegExp(r'BorderRadius\.circular\(\s*16(?:\.0)?\s*\)'),
      replacement: 'BorderRadius.circular(BukeerSpacing.m)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'BorderRadius.circular(24)',
      pattern: RegExp(r'BorderRadius\.circular\(\s*24(?:\.0)?\s*\)'),
      replacement: 'BorderRadius.circular(BukeerSpacing.l)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),

    // Duration patterns
    ReplacementPattern(
      name: 'Duration(milliseconds: 150)',
      pattern: RegExp(r'Duration\(\s*milliseconds:\s*150\s*\)'),
      replacement: 'UiConstants.animationDurationFast',
      requiredImport: "import '/flutter_flow/flutter_flow_util.dart';",
    ),
    ReplacementPattern(
      name: 'Duration(milliseconds: 200)',
      pattern: RegExp(r'Duration\(\s*milliseconds:\s*200\s*\)'),
      replacement: 'UiConstants.animationDurationFast',
      requiredImport: "import '/flutter_flow/flutter_flow_util.dart';",
    ),
    ReplacementPattern(
      name: 'Duration(milliseconds: 300)',
      pattern: RegExp(r'Duration\(\s*milliseconds:\s*300\s*\)'),
      replacement: 'UiConstants.animationDuration',
      requiredImport: "import '/flutter_flow/flutter_flow_util.dart';",
    ),
    ReplacementPattern(
      name: 'Duration(milliseconds: 400)',
      pattern: RegExp(r'Duration\(\s*milliseconds:\s*400\s*\)'),
      replacement: 'UiConstants.animationDuration',
      requiredImport: "import '/flutter_flow/flutter_flow_util.dart';",
    ),
    ReplacementPattern(
      name: 'Duration(milliseconds: 600)',
      pattern: RegExp(r'Duration\(\s*milliseconds:\s*600\s*\)'),
      replacement: 'UiConstants.animationDurationSlow',
      requiredImport: "import '/flutter_flow/flutter_flow_util.dart';",
    ),

    // SizedBox patterns
    ReplacementPattern(
      name: 'SizedBox(width: 8)',
      pattern: RegExp(r'SizedBox\(\s*width:\s*8(?:\.0)?\s*\)'),
      replacement: 'SizedBox(width: BukeerSpacing.s)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'SizedBox(width: 16)',
      pattern: RegExp(r'SizedBox\(\s*width:\s*16(?:\.0)?\s*\)'),
      replacement: 'SizedBox(width: BukeerSpacing.m)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'SizedBox(height: 8)',
      pattern: RegExp(r'SizedBox\(\s*height:\s*8(?:\.0)?\s*\)'),
      replacement: 'SizedBox(height: BukeerSpacing.s)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'SizedBox(height: 16)',
      pattern: RegExp(r'SizedBox\(\s*height:\s*16(?:\.0)?\s*\)'),
      replacement: 'SizedBox(height: BukeerSpacing.m)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
    ReplacementPattern(
      name: 'SizedBox(height: 24)',
      pattern: RegExp(r'SizedBox\(\s*height:\s*24(?:\.0)?\s*\)'),
      replacement: 'SizedBox(height: BukeerSpacing.l)',
      requiredImport:
          "import 'package:bukeer/design_system/tokens/index.dart';",
    ),
  ];

  Future<void> run() async {
    final libDir = Directory('lib/bukeer');

    if (!await libDir.exists()) {
      print('❌ Directory lib/bukeer not found!');
      return;
    }

    await _processDirectory(libDir);

    _printReport();
  }

  Future<void> _processDirectory(Directory dir) async {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        await _processFile(entity);
      }
    }
  }

  Future<void> _processFile(File file) async {
    filesProcessed++;

    if (isVerbose) {
      print('Processing: ${file.path}');
    }

    try {
      var content = await file.readAsString();
      final originalContent = content;

      // Skip files that are likely comments or strings heavy
      if (_shouldSkipFile(content)) {
        if (isVerbose) {
          print('  Skipped (likely contains many strings/comments)');
        }
        return;
      }

      var fileModified = false;
      final requiredImports = <String>{};
      final fileReplacements = <String, int>{};

      // Apply each pattern
      for (final pattern in patterns) {
        final matches = pattern.pattern.allMatches(content);

        if (matches.isNotEmpty) {
          // Check if replacement would be in a string or comment
          for (final match in matches.toList().reversed) {
            if (!_isInStringOrComment(content, match.start)) {
              content = content.replaceRange(
                match.start,
                match.end,
                pattern.replacement,
              );

              fileModified = true;
              requiredImports.add(pattern.requiredImport);
              fileReplacements[pattern.name] =
                  (fileReplacements[pattern.name] ?? 0) + 1;
              replacementCounts[pattern.name] =
                  (replacementCounts[pattern.name] ?? 0) + 1;
              totalReplacements++;
            }
          }
        }
      }

      // Add imports if needed
      if (fileModified && requiredImports.isNotEmpty) {
        content = _addImports(content, requiredImports);
      }

      // Write file if modified
      if (fileModified && content != originalContent) {
        filesModified++;

        if (!isDryRun) {
          await file.writeAsString(content);
        }

        print('✅ Modified: ${file.path}');
        for (final entry in fileReplacements.entries) {
          print('   - ${entry.key}: ${entry.value} replacements');
        }
      }
    } catch (e) {
      print('❌ Error processing ${file.path}: $e');
    }
  }

  bool _shouldSkipFile(String content) {
    // Skip files with too many string literals (likely not UI code)
    final stringCount =
        RegExp(r'''['"][^'"]*['"]''').allMatches(content).length;
    final lineCount = content.split('\n').length;

    // If more than 50% of lines contain strings, skip
    return stringCount > lineCount * 0.5;
  }

  bool _isInStringOrComment(String content, int position) {
    // Simple check for strings and comments
    // This is not perfect but covers most cases

    // Find the line containing this position
    var currentPos = 0;
    for (final line in content.split('\n')) {
      if (currentPos + line.length >= position) {
        final posInLine = position - currentPos;

        // Check if in comment
        if (line.trimLeft().startsWith('//')) return true;
        if (line.contains('//') && line.indexOf('//') < posInLine) return true;

        // Check if in string (simple check)
        var inString = false;
        var stringChar = '';

        for (var i = 0; i < posInLine; i++) {
          if (i > 0 && line[i - 1] == '\\') continue;

          if (!inString && (line[i] == '"' || line[i] == "'")) {
            inString = true;
            stringChar = line[i];
          } else if (inString && line[i] == stringChar) {
            inString = false;
          }
        }

        return inString;
      }
      currentPos += line.length + 1; // +1 for newline
    }

    return false;
  }

  String _addImports(String content, Set<String> imports) {
    final lines = content.split('\n');

    // Find where to insert imports (after existing imports)
    var insertIndex = 0;
    var lastImportIndex = -1;

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].trimLeft().startsWith('import ')) {
        lastImportIndex = i;
      } else if (lastImportIndex >= 0 && lines[i].trim().isEmpty) {
        insertIndex = i;
        break;
      }
    }

    if (lastImportIndex >= 0) {
      insertIndex = lastImportIndex + 1;
    }

    // Check which imports are already present
    final newImports = <String>[];
    for (final import in imports) {
      if (!content.contains(import)) {
        newImports.add(import);
      }
    }

    // Insert new imports
    if (newImports.isNotEmpty) {
      lines.insert(insertIndex, newImports.join('\n'));
    }

    return lines.join('\n');
  }

  void _printReport() {
    print('\n' + '=' * 60);
    print('📊 MIGRATION REPORT');
    print('=' * 60);
    print('Files processed: $filesProcessed');
    print('Files modified: $filesModified');
    print('Total replacements: $totalReplacements');

    if (replacementCounts.isNotEmpty) {
      print('\n📈 Replacement breakdown:');

      final sortedEntries = replacementCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      for (final entry in sortedEntries) {
        print('   ${entry.key}: ${entry.value}');
      }
    }

    if (isDryRun) {
      print('\n⚠️  This was a DRY RUN - no files were actually modified');
      print('Run without --dry-run to apply changes');
    } else {
      print('\n✅ Migration completed successfully!');
    }
  }
}

class ReplacementPattern {
  final String name;
  final RegExp pattern;
  final String replacement;
  final String requiredImport;

  ReplacementPattern({
    required this.name,
    required this.pattern,
    required this.replacement,
    required this.requiredImport,
  });
}
