import 'dart:io';

/// Script para actualizar TODOS los imports de flutter_flow a legacy/flutter_flow
void main() async {
  print(
      '🔄 Actualizando TODOS los imports de flutter_flow a legacy/flutter_flow...\n');

  final projectRoot = Directory.current.path;
  final dartFiles = await findDartFiles(Directory('$projectRoot/lib'));

  var totalFixed = 0;
  final fixedFiles = <String>{};

  // Patrones de imports a actualizar
  final patterns = [
    // Imports directos
    RegExp(r"import '(\.\.\/)*flutter_flow\/"),
    RegExp(r'import "(\.\.\/)*flutter_flow\/'),

    // Imports absolutos
    RegExp(r"import 'package:bukeer\/flutter_flow\/"),
    RegExp(r'import "package:bukeer\/flutter_flow\/'),
  ];

  for (final file in dartFiles) {
    var content = await file.readAsString();
    var modified = false;

    // Aplicar cada patrón
    for (final pattern in patterns) {
      if (pattern.hasMatch(content)) {
        content = content.replaceAllMapped(pattern, (match) {
          final original = match.group(0)!;

          if (original.contains('package:bukeer/')) {
            return original.replaceAll('flutter_flow/', 'legacy/flutter_flow/');
          } else {
            // Para imports relativos, necesitamos determinar el nivel correcto
            final filePath = file.path.replaceAll(projectRoot, '');
            final depth = filePath.split('/').length -
                2; // -2 porque no contamos lib/ y el archivo

            // Si es un archivo en components/, examples/, etc. necesita ../
            if (filePath.contains('/components/') ||
                filePath.contains('/examples/') ||
                filePath.contains('/custom_code/') ||
                filePath.contains('/index.dart')) {
              return original.replaceAll(
                  'flutter_flow/', 'legacy/flutter_flow/');
            } else {
              // Calcular el número correcto de ../
              final prefix = '../' * (depth - 1);
              return original.replaceFirst(RegExp(r'(\.\.\/)*flutter_flow/'),
                  '${prefix}legacy/flutter_flow/');
            }
          }
        });
        modified = true;
      }
    }

    if (modified) {
      await file.writeAsString(content);
      fixedFiles.add(file.path.replaceAll(projectRoot, ''));
      totalFixed++;
    }
  }

  print('✅ Actualizados $totalFixed archivos\n');

  if (fixedFiles.isNotEmpty) {
    print('Archivos modificados:');
    final sortedFiles = fixedFiles.toList()..sort();
    for (final path in sortedFiles) {
      print('  - $path');
    }
  }
}

Future<List<File>> findDartFiles(Directory dir) async {
  final files = <File>[];

  await for (final entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      files.add(entity);
    }
  }

  return files;
}
