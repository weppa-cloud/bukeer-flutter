#!/usr/bin/env dart

import 'dart:io';
import '../lib/design_system/tools/migration_helper.dart';

void main(List<String> args) async {
  print('🎨 Bukeer Design System - Migración Masiva');
  print('==========================================\n');

  // Configuración
  final dryRun = args.contains('--dry-run') || args.contains('-d');
  final verbose = args.contains('--verbose') || args.contains('-v');
  
  if (dryRun) {
    print('🔍 MODO DRY RUN - No se escribirán archivos\n');
  }

  // Directorios a migrar en orden de prioridad
  final directories = [
    'lib/bukeer/componentes',
    'lib/bukeer/dashboard', 
    'lib/bukeer/itinerarios',
    'lib/bukeer/productos',
    'lib/bukeer/contactos',
    'lib/bukeer/users',
    'lib/bukeer/modal_add_edit_itinerary',
    'lib/components',
    'lib/custom_code/widgets',
  ];

  var totalFiles = 0;
  var totalIssues = 0;
  var migratedFiles = 0;
  var errorFiles = 0;

  for (final dir in directories) {
    final dirPath = dir;
    final directory = Directory(dirPath);
    
    if (!await directory.exists()) {
      print('⚠️  Directorio no encontrado: $dirPath');
      continue;
    }

    print('📁 Procesando: $dirPath');
    print('   ' + '─' * 40);

    try {
      final results = await MigrationHelper.migrateDirectory(dirPath, dryRun: dryRun);
      
      if (results.isEmpty) {
        print('   ✨ No hay archivos que requieran migración\n');
        continue;
      }

      for (final result in results) {
        totalFiles++;
        
        if (result.success) {
          migratedFiles++;
          final issueCount = result.report?.totalIssues ?? 0;
          totalIssues += issueCount;
          
          if (issueCount > 0) {
            final fileName = result.filePath.split('/').last;
            print('   ✅ $fileName ($issueCount issues)');
            
            if (verbose && result.report != null) {
              final report = result.report!;
              if (report.spacingIssues.isNotEmpty) {
                print('      📏 Espaciado: ${report.spacingIssues.length} issues');
              }
              if (report.colorIssues.isNotEmpty) {
                print('      🎨 Colores: ${report.colorIssues.length} issues');
              }
              if (report.typographyIssues.isNotEmpty) {
                print('      🔤 Tipografía: ${report.typographyIssues.length} issues');
              }
            }
          }
        } else {
          errorFiles++;
          final fileName = result.filePath.split('/').last;
          print('   ❌ $fileName - Error: ${result.error}');
        }
      }
      
      final successCount = results.where((r) => r.success).length;
      final issueCount = results.fold<int>(0, (sum, r) => sum + (r.report?.totalIssues ?? 0));
      print('   📊 $successCount archivos procesados, $issueCount issues migrados\n');
      
    } catch (e) {
      print('   ❌ Error procesando directorio: $e\n');
      errorFiles++;
    }
  }

  // Resumen final
  print('🎯 RESUMEN DE MIGRACIÓN');
  print('======================');
  print('📁 Total archivos procesados: $totalFiles');
  print('✅ Archivos migrados exitosamente: $migratedFiles');
  print('❌ Archivos con errores: $errorFiles');
  print('🔧 Total issues corregidos: $totalIssues');
  
  if (dryRun) {
    print('\n💡 Para aplicar los cambios, ejecuta sin --dry-run');
  } else {
    print('\n🎉 Migración completada!');
    print('📝 Siguiente paso: Ejecutar flutter analyze para verificar');
  }

  // Exit code
  if (errorFiles > 0) {
    exit(1);
  }
  exit(0);
}