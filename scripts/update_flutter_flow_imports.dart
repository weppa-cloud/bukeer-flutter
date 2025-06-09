import 'dart:io';

/// Script para actualizar los imports de flutter_flow a legacy/flutter_flow
void main() async {
  print('🔄 Actualizando imports de flutter_flow...');

  final projectRoot = Directory.current.path;
  final dartFiles = await findDartFiles(Directory('$projectRoot/lib'));
  var updatedFiles = 0;

  for (final file in dartFiles) {
    var content = await file.readAsString();
    var modified = false;

    // Actualizar imports de flutter_flow
    if (content.contains("'package:bukeer/flutter_flow/")) {
      content = content.replaceAll("'package:bukeer/flutter_flow/",
          "'package:bukeer/legacy/flutter_flow/");
      modified = true;
    }

    if (content.contains('"package:bukeer/flutter_flow/')) {
      content = content.replaceAll('"package:bukeer/flutter_flow/',
          '"package:bukeer/legacy/flutter_flow/');
      modified = true;
    }

    if (modified) {
      await file.writeAsString(content);
      updatedFiles++;
    }
  }

  print('✅ Actualizados $updatedFiles archivos');
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
