import 'dart:io';

/// Script para convertir imports relativos largos a imports absolutos
void main() async {
  print('🔄 Convirtiendo imports relativos a absolutos...\n');

  final projectRoot = Directory.current.path;
  final dartFiles = await findDartFiles(Directory('$projectRoot/lib'));
  var totalFixed = 0;
  final fixedFiles = <String>{};

  for (final file in dartFiles) {
    var content = await file.readAsString();
    var modified = false;

    // Buscar líneas de import con muchos ../
    final lines = content.split('\n');
    final newLines = <String>[];

    for (final line in lines) {
      var newLine = line;

      // Detectar imports relativos con 5 o más ../
      if (line.trim().startsWith('import') &&
          line.contains('../../../../../')) {
        // Extraer la ruta del import
        final match = RegExp(r'''import\s+['"]([^'"]+)['"]''').firstMatch(line);
        if (match != null) {
          final importPath = match.group(1)!;

          // Contar cuántos ../ hay
          final dotCount = '../'.allMatches(importPath).length;

          // Si hay 5 o más, convertir a absoluto
          if (dotCount >= 5) {
            // Remover todos los ../
            var cleanPath = importPath;
            for (var i = 0; i < dotCount; i++) {
              cleanPath = cleanPath.replaceFirst('../', '');
            }

            // Crear el import absoluto
            final absoluteImport = 'package:bukeer/$cleanPath';
            newLine = line.replaceAll(importPath, absoluteImport);
            modified = true;
          }
        }
      }

      newLines.add(newLine);
    }

    if (modified) {
      content = newLines.join('\n');
      await file.writeAsString(content);
      fixedFiles.add(file.path.replaceAll(projectRoot, ''));
      totalFixed++;
    }
  }

  print('✅ Corregidos $totalFixed archivos\n');

  if (fixedFiles.isNotEmpty) {
    print('Archivos modificados:');
    for (final path in fixedFiles) {
      print('  - $path');
    }
  }

  // Ahora aplicar correcciones específicas
  print('\n🔧 Aplicando correcciones específicas...\n');
  await applySpecificFixes(projectRoot);
}

Future<void> applySpecificFixes(String projectRoot) async {
  // Correcciones específicas para imports de legacy/flutter_flow
  final specificFixes = {
    '../backend/schema/': 'package:bukeer/backend/schema/',
    '../backend/supabase/': 'package:bukeer/backend/supabase/',
    '../auth/supabase_auth/': 'package:bukeer/auth/supabase_auth/',
  };

  final legacyDir = Directory('$projectRoot/lib/legacy/flutter_flow');
  if (legacyDir.existsSync()) {
    final files = await findDartFiles(legacyDir);
    var fixed = 0;

    for (final file in files) {
      var content = await file.readAsString();
      var modified = false;

      for (final entry in specificFixes.entries) {
        if (content.contains(entry.key)) {
          content = content.replaceAll(entry.key, entry.value);
          modified = true;
        }
      }

      if (modified) {
        await file.writeAsString(content);
        fixed++;
      }
    }

    print('✅ Corregidos $fixed archivos en legacy/flutter_flow');
  }
}

Future<List<File>> findDartFiles(Directory dir) async {
  final files = <File>[];

  await for (final entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      if (!entity.path.contains('/build/') &&
          !entity.path.contains('/.dart_tool/')) {
        files.add(entity);
      }
    }
  }

  return files;
}
