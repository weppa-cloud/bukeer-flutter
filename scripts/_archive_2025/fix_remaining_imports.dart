import 'dart:io';

/// Script para corregir imports que no se actualizaron correctamente
void main() async {
  print('🔧 Corrigiendo imports restantes...\n');

  final projectRoot = Directory.current.path;
  final fixes = <String, String>{
    // Corregir referencias a productos -> products
    '../../../../../products/': '../../../../../products/',
    '../../../products/': '../../../products/',
    '../../products/': '../../products/',

    // Corregir imports en legacy/flutter_flow
    '../../backend/schema/': '../../../backend/schema/',
    '../../backend/supabase/': '../../../backend/supabase/',
    '../../auth/supabase_auth/': '../../../auth/supabase_auth/',

    // Corregir referencias en tests
    'package:bukeer/bukeer/components/': 'package:bukeer/bukeer/components/',
    'package:bukeer/bukeer/contacts/': 'package:bukeer/bukeer/contacts/',
    'package:bukeer/bukeer/itineraries/': 'package:bukeer/bukeer/itineraries/',
    'package:bukeer/bukeer/products/': 'package:bukeer/bukeer/products/',
  };

  final dartFiles = await findDartFiles(Directory(projectRoot));
  var totalFixed = 0;
  final fixedFiles = <String>{};

  for (final file in dartFiles) {
    var content = await file.readAsString();
    var modified = false;

    for (final entry in fixes.entries) {
      if (content.contains(entry.key)) {
        content = content.replaceAll(entry.key, entry.value);
        modified = true;
      }
    }

    if (modified) {
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
