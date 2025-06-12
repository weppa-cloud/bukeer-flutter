import 'dart:io';

/// Script para corregir imports de widgets en tests
void main() async {
  print('🔧 Corrigiendo imports de widgets en tests...\n');

  final projectRoot = Directory.current.path;
  
  // Mapeo de imports antiguos a nuevos
  final importMappings = {
    // Botones
    'bukeer/core/widgets/buttons/boton_menu_mobile/boton_menu_mobile_widget.dart':
        'bukeer/core/widgets/buttons/btn_mobile_menu/btn_mobile_menu_widget.dart',
    'bukeer/core/widgets/buttons/boton_crear/boton_crear_widget.dart':
        'bukeer/core/widgets/buttons/btn_create/btn_create_widget.dart',
    'bukeer/core/widgets/buttons/boton_back/boton_back_widget.dart':
        'bukeer/core/widgets/buttons/btn_back/btn_back_widget.dart',
    
    // Formularios
    'bukeer/core/widgets/forms/component_add_currency/component_add_currency_widget.dart':
        'bukeer/core/widgets/forms/currency_selector/currency_selector_widget.dart',
    'bukeer/core/widgets/forms/component_date/component_date_widget.dart':
        'bukeer/core/widgets/forms/date_picker/date_picker_widget.dart',
    'bukeer/core/widgets/forms/component_date_range/component_date_range_widget.dart':
        'bukeer/core/widgets/forms/date_range_picker/date_range_picker_widget.dart',
    'bukeer/core/widgets/forms/component_birth_date/component_birth_date_widget.dart':
        'bukeer/core/widgets/forms/birth_date_picker/birth_date_picker_widget.dart',
    'bukeer/core/widgets/forms/component_place/component_place_widget.dart':
        'bukeer/core/widgets/forms/place_picker/place_picker_widget.dart',
        
    // Navegación - casos especiales
    'bukeer/components/web_nav/web_nav_widget.dart':
        'bukeer/core/widgets/navigation/web_nav/web_nav_widget.dart',
    'bukeer/components/search_box/search_box_widget.dart':
        'bukeer/core/widgets/forms/search_box/search_box_widget.dart',
  };

  // Buscar archivos de test
  final testFiles = await findTestFiles(Directory('$projectRoot/test'));
  var updatedFiles = 0;
  
  for (final file in testFiles) {
    var content = await file.readAsString();
    var modified = false;
    
    // Actualizar imports
    for (final entry in importMappings.entries) {
      if (content.contains(entry.key)) {
        content = content.replaceAll(entry.key, entry.value);
        modified = true;
      }
    }
    
    if (modified) {
      await file.writeAsString(content);
      updatedFiles++;
      print('✅ Actualizado: ${file.path.replaceAll(projectRoot, '')}');
    }
  }
  
  print('\n📊 Resumen:');
  print('   Total de archivos actualizados: $updatedFiles');
}

Future<List<File>> findTestFiles(Directory dir) async {
  final files = <File>[];
  
  await for (final entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('_test.dart')) {
      files.add(entity);
    }
  }
  
  return files;
}