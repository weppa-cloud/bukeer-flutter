import 'dart:io';

/// Script para reorganizar la estructura del proyecto Bukeer
///
/// Este script realiza las siguientes acciones:
/// 1. Renombra carpetas de español a inglés
/// 2. Actualiza todos los imports afectados
/// 3. Genera un reporte de cambios
///
/// Uso: dart run scripts/reorganize_project_structure.dart

void main() async {
  print('🚀 Iniciando reorganización de la estructura del proyecto...\n');

  final projectRoot = Directory.current.path;
  final changes = <String>[];

  // Mapeo de nombres de carpetas español -> inglés
  final folderMappings = {
    'lib/bukeer/components': 'lib/bukeer/components',
    'lib/bukeer/contacts': 'lib/bukeer/contacts',
    'lib/bukeer/itineraries': 'lib/bukeer/itineraries',
    'lib/bukeer/products': 'lib/bukeer/products',
    'lib/bukeer/users': 'lib/bukeer/users', // Ya está en inglés
    'lib/bukeer/dashboard': 'lib/bukeer/dashboard', // Ya está en inglés
    'lib/bukeer/agenda': 'lib/bukeer/agenda', // Mantener por ahora
  };

  // Paso 1: Renombrar carpetas
  print('📁 Renombrando carpetas...');
  for (final entry in folderMappings.entries) {
    final oldPath = '$projectRoot/${entry.key}';
    final newPath = '$projectRoot/${entry.value}';

    final oldDir = Directory(oldPath);
    if (oldDir.existsSync() && entry.key != entry.value) {
      try {
        await oldDir.rename(newPath);
        changes.add('✅ Renombrado: ${entry.key} → ${entry.value}');
        print('  ✅ ${entry.key} → ${entry.value}');
      } catch (e) {
        print('  ❌ Error al renombrar ${entry.key}: $e');
      }
    }
  }

  // Paso 2: Actualizar imports en todos los archivos .dart
  print('\n📝 Actualizando imports...');
  await updateImports(projectRoot, folderMappings);

  // Paso 3: Generar reporte
  await generateReport(changes);

  print('\n✨ Reorganización completada!');
  print('📄 Ver reporte completo en: docs/REORGANIZATION_REPORT.md');
}

Future<void> updateImports(
    String projectRoot, Map<String, String> mappings) async {
  final dartFiles = await findDartFiles(Directory(projectRoot));
  var updatedFiles = 0;

  for (final file in dartFiles) {
    var content = await file.readAsString();
    var modified = false;

    for (final entry in mappings.entries) {
      final oldImport = entry.key.replaceAll('lib/', '');
      final newImport = entry.value.replaceAll('lib/', '');

      if (oldImport != newImport && content.contains(oldImport)) {
        content = content.replaceAll(oldImport, newImport);
        modified = true;
      }
    }

    if (modified) {
      await file.writeAsString(content);
      updatedFiles++;
    }
  }

  print('  ✅ Actualizados $updatedFiles archivos');
}

Future<List<File>> findDartFiles(Directory dir) async {
  final files = <File>[];

  await for (final entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      // Excluir carpetas de build y packages
      if (!entity.path.contains('/build/') &&
          !entity.path.contains('/.dart_tool/') &&
          !entity.path.contains('/node_modules/')) {
        files.add(entity);
      }
    }
  }

  return files;
}

Future<void> generateReport(List<String> changes) async {
  final report = StringBuffer();
  report.writeln('# Reporte de Reorganización del Proyecto');
  report.writeln('\nFecha: ${DateTime.now().toIso8601String()}');
  report.writeln('\n## Cambios Realizados\n');

  for (final change in changes) {
    report.writeln(change);
  }

  report.writeln('\n## Próximos Pasos\n');
  report.writeln('1. Ejecutar `flutter clean && flutter pub get`');
  report.writeln('2. Verificar que todos los imports estén correctos');
  report.writeln('3. Ejecutar los tests para asegurar que todo funciona');
  report.writeln('4. Eliminar archivos duplicados (_optimized)');
  report.writeln('5. Mover documentación a la carpeta docs/');

  final reportFile = File('docs/REORGANIZATION_REPORT.md');
  await reportFile.create(recursive: true);
  await reportFile.writeAsString(report.toString());
}
