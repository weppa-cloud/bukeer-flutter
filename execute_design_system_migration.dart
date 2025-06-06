#!/usr/bin/env dart

/// 🚀 Script de Migración Masiva al Design System - Bukeer
///
/// Este script ejecuta la migración automatizada de valores hardcodeados
/// a design tokens del sistema de diseño de Bukeer.
///
/// Uso:
///   dart execute_design_system_migration.dart [--dry-run] [--target=dir]
///
/// Opciones:
///   --dry-run    Ejecuta sin modificar archivos (solo análisis)
///   --target     Directorio específico a migrar (default: lib/bukeer)
///   --help       Muestra esta ayuda

import 'dart:io';
import 'dart:async';
import 'lib/design_system/tools/migration_helper.dart';

void main(List<String> arguments) async {
  print('🚀 Bukeer Design System Migration Tool');
  print('=====================================\n');

  // Parsear argumentos
  final args = parseArguments(arguments);

  if (args['help'] == true) {
    printHelp();
    return;
  }

  final bool dryRun = args['dry-run'] == true;
  final String targetDir = args['target'] ?? 'lib/bukeer';

  print('⚙️  Configuración:');
  print('   Directorio: $targetDir');
  print('   Modo: ${dryRun ? 'DRY RUN (sin cambios)' : 'MIGRACIÓN REAL'}');
  print('');

  if (!dryRun) {
    print('⚠️  ATENCIÓN: Este script modificará archivos.');
    print('   ¿Continuar? (y/N): ');

    final input = stdin.readLineSync()?.toLowerCase().trim();
    if (input != 'y' && input != 'yes') {
      print('❌ Operación cancelada.');
      return;
    }
    print('');
  }

  try {
    // Fase 1: Análisis inicial
    print('🔍 FASE 1: Análisis de archivos...');
    final analysisResults = await analyzeDirectory(targetDir);
    printAnalysisResults(analysisResults);

    if (analysisResults.isEmpty) {
      print('✅ No se encontraron archivos que requieran migración.');
      return;
    }

    // Fase 2: Backup (solo en modo real)
    if (!dryRun) {
      print('\n💾 FASE 2: Creando backup...');
      await createBackup();
    }

    // Fase 3: Migración
    print('\n🔄 FASE 3: Ejecutando migración...');
    final migrationResults = await MigrationHelper.migrateDirectory(
      targetDir,
      dryRun: dryRun,
    );

    // Fase 4: Resultados
    print('\n📊 FASE 4: Resultados de migración:');
    printMigrationResults(migrationResults);

    // Fase 5: Validación (solo en modo real)
    if (!dryRun) {
      print('\n🧪 FASE 5: Validación del código...');
      await validateCode();
    }

    print('\n🎉 Migración completada exitosamente!');

    if (!dryRun) {
      print('\n📋 Próximos pasos recomendados:');
      print('   1. flutter analyze');
      print('   2. flutter test');
      print('   3. flutter run -d chrome');
      print(
          '   4. git add . && git commit -m "feat: migrate to design system tokens"');
    }
  } catch (e, stackTrace) {
    print('\n❌ Error durante la migración:');
    print('   $e');
    if (args['verbose'] == true) {
      print('\nStack trace:');
      print(stackTrace);
    }
    exit(1);
  }
}

/// Analiza el directorio y genera reporte de archivos que necesitan migración
Future<List<MigrationReport>> analyzeDirectory(String dirPath) async {
  final dir = Directory(dirPath);
  if (!await dir.exists()) {
    throw Exception('Directorio no encontrado: $dirPath');
  }

  final reports = <MigrationReport>[];
  final dartFiles = await dir
      .list(recursive: true)
      .where((entity) => entity is File && entity.path.endsWith('.dart'))
      .cast<File>()
      .toList();

  print('   Analizando ${dartFiles.length} archivos...');

  for (final file in dartFiles) {
    try {
      final report = await MigrationHelper.analyzeFile(file.path);
      if (report.hasIssues) {
        reports.add(report);
      }
    } catch (e) {
      print('   ⚠️  Error analizando ${file.path}: $e');
    }
  }

  return reports;
}

/// Muestra los resultados del análisis
void printAnalysisResults(List<MigrationReport> reports) {
  if (reports.isEmpty) {
    print('   ✅ No se encontraron problemas.');
    return;
  }

  final totalFiles = reports.length;
  final totalIssues =
      reports.fold<int>(0, (sum, report) => sum + report.totalIssues);
  final spacingIssues =
      reports.fold<int>(0, (sum, report) => sum + report.spacingIssues.length);
  final colorIssues =
      reports.fold<int>(0, (sum, report) => sum + report.colorIssues.length);
  final typographyIssues = reports.fold<int>(
      0, (sum, report) => sum + report.typographyIssues.length);

  print('   📊 Resultados del análisis:');
  print('      Archivos con problemas: $totalFiles');
  print('      Total de problemas: $totalIssues');
  print(
      '      - Espaciado: $spacingIssues (${(spacingIssues / totalIssues * 100).toStringAsFixed(1)}%)');
  print(
      '      - Colores: $colorIssues (${(colorIssues / totalIssues * 100).toStringAsFixed(1)}%)');
  print(
      '      - Tipografía: $typographyIssues (${(typographyIssues / totalIssues * 100).toStringAsFixed(1)}%)');

  // Top 10 archivos con más problemas
  reports.sort((a, b) => b.totalIssues.compareTo(a.totalIssues));
  print('\n   🔥 Top 10 archivos con más problemas:');
  for (int i = 0; i < reports.length && i < 10; i++) {
    final report = reports[i];
    final fileName = report.filePath.split('/').last;
    print('      ${i + 1}. $fileName (${report.totalIssues} problemas)');
  }
}

/// Muestra los resultados de la migración
void printMigrationResults(List<MigrationResult> results) {
  final successCount = results.where((r) => r.success).length;
  final errorCount = results.where((r) => !r.success).length;
  final totalIssuesFixed = results
      .where((r) => r.success)
      .fold<int>(0, (sum, result) => sum + (result.report?.totalIssues ?? 0));

  print('   📈 Resumen de migración:');
  print('      ✅ Archivos migrados exitosamente: $successCount');
  print('      ❌ Archivos con errores: $errorCount');
  print('      🔧 Total de problemas solucionados: $totalIssuesFixed');

  if (errorCount > 0) {
    print('\n   ⚠️  Archivos con errores:');
    for (final result in results.where((r) => !r.success)) {
      final fileName = result.filePath.split('/').last;
      print('      - $fileName: ${result.error}');
    }
  }

  // Archivos más impactados
  final successfulResults =
      results.where((r) => r.success && r.report != null).toList();
  successfulResults
      .sort((a, b) => b.report!.totalIssues.compareTo(a.report!.totalIssues));

  if (successfulResults.isNotEmpty) {
    print('\n   🎯 Archivos con mayor impacto migrado:');
    for (int i = 0; i < successfulResults.length && i < 5; i++) {
      final result = successfulResults[i];
      final fileName = result.filePath.split('/').last;
      print(
          '      ${i + 1}. $fileName (${result.report!.totalIssues} cambios)');
    }
  }
}

/// Crea un backup del estado actual
Future<void> createBackup() async {
  final timestamp =
      DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];
  final backupBranch = 'backup-before-design-system-migration-$timestamp';

  try {
    // Verificar si estamos en un repositorio git
    final gitStatus = await Process.run('git', ['status', '--porcelain']);

    if (gitStatus.exitCode == 0) {
      // Crear commit de backup
      await Process.run('git', ['add', '.']);
      await Process.run(
          'git', ['commit', '-m', 'backup: before design system migration']);

      // Crear branch de backup
      await Process.run('git', ['branch', backupBranch]);

      print('   ✅ Backup creado en branch: $backupBranch');
    } else {
      print('   ⚠️  No es un repositorio git, saltando backup automático');
    }
  } catch (e) {
    print('   ⚠️  Error creando backup: $e');
    print('   💡 Recomendado: crear backup manual antes de continuar');
  }
}

/// Valida el código después de la migración
Future<void> validateCode() async {
  print('   🔍 Ejecutando flutter analyze...');

  try {
    final analyzeResult =
        await Process.run('flutter', ['analyze', '--no-fatal-infos']);

    if (analyzeResult.exitCode == 0) {
      print('   ✅ flutter analyze: Sin problemas');
    } else {
      print('   ⚠️  flutter analyze: Encontró warnings/errores');
      print('      Salida: ${analyzeResult.stdout}');
      if (analyzeResult.stderr.isNotEmpty) {
        print('      Errores: ${analyzeResult.stderr}');
      }
    }
  } catch (e) {
    print('   ⚠️  Error ejecutando flutter analyze: $e');
  }
}

/// Parsea los argumentos de línea de comandos
Map<String, dynamic> parseArguments(List<String> arguments) {
  final args = <String, dynamic>{};

  for (final arg in arguments) {
    if (arg == '--help' || arg == '-h') {
      args['help'] = true;
    } else if (arg == '--dry-run') {
      args['dry-run'] = true;
    } else if (arg == '--verbose' || arg == '-v') {
      args['verbose'] = true;
    } else if (arg.startsWith('--target=')) {
      args['target'] = arg.split('=')[1];
    }
  }

  return args;
}

/// Muestra la ayuda
void printHelp() {
  print('''
🚀 Bukeer Design System Migration Tool

Este script migra automáticamente valores hardcodeados a design tokens.

USO:
  dart execute_design_system_migration.dart [opciones]

OPCIONES:
  --dry-run              Ejecuta análisis sin modificar archivos
  --target=directorio    Especifica directorio a migrar (default: lib/bukeer)
  --verbose, -v          Muestra información detallada de errores
  --help, -h             Muestra esta ayuda

EJEMPLOS:
  # Análisis sin cambios
  dart execute_design_system_migration.dart --dry-run

  # Migrar solo componentes
  dart execute_design_system_migration.dart --target=lib/bukeer/componentes

  # Migración completa
  dart execute_design_system_migration.dart

PATRONES QUE SE MIGRAN:
  • EdgeInsets.all(16.0) → EdgeInsets.all(BukeerSpacing.m)
  • SizedBox(width: 8.0) → SizedBox(width: BukeerSpacing.s)
  • BorderRadius.circular(12.0) → BorderRadius.circular(BukeerSpacing.s)
  • Color(0xFF1976D2) → BukeerColors.primaryMain
  • fontSize: 16.0 → fontSize: BukeerTypography.bodyMediumSize

ARCHIVOS MODIFICADOS:
  ✅ Se agrega import del design system automáticamente
  ✅ Se preserva la funcionalidad existente
  ✅ Se mantiene la compatibilidad con FlutterFlow

SEGURIDAD:
  ✅ Backup automático en git (si disponible)
  ✅ Validación con flutter analyze
  ✅ Modo dry-run para testing seguro
''');
}
