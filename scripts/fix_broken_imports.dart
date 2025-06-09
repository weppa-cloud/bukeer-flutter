import 'dart:io';

/// Script para corregir imports mal formados
void main() async {
  print('🔧 Corrigiendo imports mal formados...\n');

  final projectRoot = Directory.current.path;

  // Patrones específicos de imports mal formados
  final brokenPatterns = {
    // Error en nav.dart
    '../../../package:bukeer/': 'package:bukeer/',
    '../../package:bukeer/': 'package:bukeer/',
    '../package:bukeer/': 'package:bukeer/',

    // Error en modal_details_product
    'package:bukeer/products/component_add_schedule_activity/':
        'package:bukeer/bukeer/products/component_add_schedule_activity/',
    'package:bukeer/products/component_preview_schedule_activity/':
        'package:bukeer/bukeer/products/component_preview_schedule_activity/',
    'package:bukeer/products/component_inclusion/':
        'package:bukeer/bukeer/products/component_inclusion/',

    // Corrección para la carpeta flutter_flow que todavía existe
    'lib/flutter_flow/': 'lib/legacy/flutter_flow/',
  };

  // Archivos específicos con problemas
  final problemFiles = [
    'lib/legacy/flutter_flow/nav/nav.dart',
    'lib/legacy/flutter_flow/nav/serialization_util.dart',
    'lib/legacy/flutter_flow/custom_functions.dart',
    'lib/flutter_flow/nav/nav.dart',
    'lib/flutter_flow/nav/serialization_util.dart',
    'lib/bukeer/core/widgets/modals/product/details/modal_details_product_widget.dart',
    'lib/bukeer/core/widgets/modals/product/details/modal_details_product_model.dart',
    'lib/bukeer/itineraries/preview/component_itinerary_preview_activities/component_itinerary_preview_activities_widget.dart',
    'lib/bukeer/itineraries/preview/component_itinerary_preview_activities/component_itinerary_preview_activities_model.dart',
    'lib/bukeer/itineraries/preview/component_itinerary_preview_hotels/component_itinerary_preview_hotels_widget.dart',
    'lib/bukeer/itineraries/preview/component_itinerary_preview_hotels/component_itinerary_preview_hotels_model.dart',
  ];

  // Primero, mover flutter_flow a legacy si todavía existe
  final flutterFlowDir = Directory('$projectRoot/lib/flutter_flow');
  if (flutterFlowDir.existsSync()) {
    print('📁 Moviendo flutter_flow a legacy...');
    try {
      await flutterFlowDir.rename('$projectRoot/lib/legacy/flutter_flow_temp');
      // Si ya existe legacy/flutter_flow, eliminar el temporal
      final existingLegacy = Directory('$projectRoot/lib/legacy/flutter_flow');
      if (existingLegacy.existsSync()) {
        await Directory('$projectRoot/lib/legacy/flutter_flow_temp')
            .delete(recursive: true);
      } else {
        await Directory('$projectRoot/lib/legacy/flutter_flow_temp')
            .rename('$projectRoot/lib/legacy/flutter_flow');
      }
    } catch (e) {
      print('⚠️  Error al mover flutter_flow: $e');
    }
  }

  var totalFixed = 0;

  // Corregir archivos específicos
  for (final filePath in problemFiles) {
    final file = File('$projectRoot/$filePath');
    if (file.existsSync()) {
      try {
        var content = await file.readAsString();
        var modified = false;

        for (final entry in brokenPatterns.entries) {
          if (content.contains(entry.key)) {
            content = content.replaceAll(entry.key, entry.value);
            modified = true;
          }
        }

        if (modified) {
          await file.writeAsString(content);
          print('✅ Corregido: $filePath');
          totalFixed++;
        }
      } catch (e) {
        print('❌ Error procesando $filePath: $e');
      }
    }
  }

  // Buscar y corregir todos los archivos .dart
  print('\n🔍 Buscando otros archivos con imports incorrectos...');
  final dartFiles = await findDartFiles(Directory('$projectRoot/lib'));

  for (final file in dartFiles) {
    var content = await file.readAsString();
    var modified = false;

    for (final entry in brokenPatterns.entries) {
      if (content.contains(entry.key)) {
        content = content.replaceAll(entry.key, entry.value);
        modified = true;
      }
    }

    if (modified) {
      await file.writeAsString(content);
      totalFixed++;
    }
  }

  print('\n✅ Total de archivos corregidos: $totalFixed');
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
