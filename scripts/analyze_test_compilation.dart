#!/usr/bin/env dart

import 'dart:io';
import 'dart:async';

void main() async {
  print('Analizando compilación de tests...\n');

  final testDir = Directory('test');
  final results = <String, bool>{};
  final errors = <String, String>{};

  await for (final file in testDir.list(recursive: true)) {
    if (file is File && file.path.endsWith('_test.dart')) {
      final relativePath = file.path.replaceFirst('test/', '');
      print('Verificando: $relativePath');

      final result = await Process.run(
        'flutter',
        ['test', file.path, '--no-pub'],
        runInShell: true,
      );

      final compiles = !result.stderr.toString().contains('Compilation failed');
      results[relativePath] = compiles;

      if (!compiles) {
        // Extract first error
        final errorLines = result.stderr.toString().split('\n');
        for (final line in errorLines) {
          if (line.contains('Error:')) {
            errors[relativePath] = line.trim();
            break;
          }
        }
      }
    }
  }

  // Generate report
  print('\n' + '=' * 80);
  print('REPORTE DE COMPILACIÓN DE TESTS');
  print('=' * 80 + '\n');

  final totalTests = results.length;
  final compilingTests = results.values.where((v) => v).length;
  final failingTests = totalTests - compilingTests;

  print('Total de archivos de test: $totalTests');
  print(
      'Tests compilando exitosamente: $compilingTests (${(compilingTests / totalTests * 100).toStringAsFixed(1)}%)');
  print(
      'Tests con errores de compilación: $failingTests (${(failingTests / totalTests * 100).toStringAsFixed(1)}%)');

  if (failingTests > 0) {
    print('\n' + '-' * 80);
    print('TESTS CON ERRORES DE COMPILACIÓN:');
    print('-' * 80 + '\n');

    results.forEach((path, compiles) {
      if (!compiles) {
        print('❌ $path');
        if (errors.containsKey(path)) {
          print('   Error: ${errors[path]}');
        }
      }
    });
  }

  print('\n' + '-' * 80);
  print('TESTS COMPILANDO EXITOSAMENTE:');
  print('-' * 80 + '\n');

  results.forEach((path, compiles) {
    if (compiles) {
      print('✅ $path');
    }
  });
}
