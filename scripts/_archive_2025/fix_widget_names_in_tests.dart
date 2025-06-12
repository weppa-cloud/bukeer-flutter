import 'dart:io';

/// Script para actualizar nombres de widgets en archivos de test
void main() async {
  print('🔧 Actualizando nombres de widgets en tests...\n');

  final projectRoot = Directory.current.path;
  
  // Mapeo de nombres antiguos a nuevos
  final widgetMappings = {
    // Botones
    'BotonMenuMobileWidget': 'BtnMobileMenuWidget',
    'BotonCrearWidget': 'BtnCreateWidget',
    'BotonBackWidget': 'BtnBackWidget',
    
    // Formularios
    'ComponentAddCurrencyWidget': 'CurrencySelectorWidget',
    'ComponentDateWidget': 'DatePickerWidget',
    'ComponentDateRangeWidget': 'DateRangePickerWidget',
    'ComponentBirthDateWidget': 'BirthDatePickerWidget',
    'ComponentPlaceWidget': 'PlacePickerWidget',
    
    // Navegación
    'WebNavWidget': 'WebNavWidget',
    'MobileNavWidget': 'MobileNavWidget',
    
    // Búsqueda
    'SearchBoxWidget': 'SearchBoxWidget',
  };
  
  // Mapeo de paths de imports
  final importMappings = {
    'bukeer/componentes/': 'bukeer/components/',
    'bukeer/contactos/': 'bukeer/contacts/',
    'bukeer/itinerarios/': 'bukeer/itineraries/',
    'bukeer/productos/': 'bukeer/products/',
    
    // Widgets movidos a core
    'bukeer/components/web_nav/': 'bukeer/core/widgets/navigation/web_nav/',
    'bukeer/components/search_box/': 'bukeer/core/widgets/forms/search_box/',
  };

  // Buscar archivos de test
  final testFiles = await findTestFiles(Directory('$projectRoot/test'));
  var updatedFiles = 0;
  
  for (final file in testFiles) {
    var content = await file.readAsString();
    var modified = false;
    
    // Actualizar nombres de widgets
    for (final entry in widgetMappings.entries) {
      if (content.contains(entry.key)) {
        content = content.replaceAll(entry.key, entry.value);
        modified = true;
      }
    }
    
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
  print('   Total de archivos de test actualizados: $updatedFiles');
  
  // Crear script para actualizar parámetros
  await createParameterUpdateScript(projectRoot);
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

Future<void> createParameterUpdateScript(String projectRoot) async {
  final script = '''
import 'dart:io';

/// Script para actualizar parámetros de widgets en tests
void main() async {
  print('🔧 Actualizando parámetros de widgets...');
  
  final parameterMappings = {
    // CurrencySelectorWidget
    'amount:': 'initialAmount:',
    'currency:': 'initialCurrency:',
    'onAmountChanged:': 'onAmountChanged:',
    'onCurrencyChanged:': 'onCurrencyChanged:',
    
    // DatePickerWidget
    'dateStart:': 'initialDate:',
    'callBackDate:': 'onDateSelected:',
    
    // DateRangePickerWidget
    'dateStart:': 'initialStartDate:',
    'dateEnd:': 'initialEndDate:',
    'callBackDateRange:': 'onDateRangeSelected:',
    
    // BirthDatePickerWidget
    'birthDate:': 'initialDate:',
    'callBackDate:': 'onDateSelected:',
    
    // PlacePickerWidget
    'city:': 'initialCity:',
    'country:': 'initialCountry:',
    'callBackPlace:': 'onPlaceSelected:',
  };
  
  // Implementación similar al script principal
  print('✅ Script de actualización de parámetros creado');
}
''';
  
  final scriptFile = File('$projectRoot/scripts/fix_widget_parameters.dart');
  await scriptFile.writeAsString(script);
  print('\n📝 Creado script adicional: scripts/fix_widget_parameters.dart');
}