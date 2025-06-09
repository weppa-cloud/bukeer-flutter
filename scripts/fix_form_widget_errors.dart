import 'dart:io';

/// Script para corregir errores en widgets de formularios
void main() async {
  print('🔧 Corrigiendo errores en widgets de formularios...\n');

  final projectRoot = Directory.current.path;
  
  // Primero, verifiquemos qué widgets existen realmente
  print('📁 Verificando widgets de formularios existentes...');
  await verifyFormWidgets(projectRoot);
  
  // Ahora actualizar los ejemplos
  await updateExamples(projectRoot);
}

Future<void> verifyFormWidgets(String projectRoot) async {
  final formWidgetsPath = '$projectRoot/lib/bukeer/core/widgets/forms';
  final formDir = Directory(formWidgetsPath);
  
  if (formDir.existsSync()) {
    print('\n📋 Widgets encontrados en forms:');
    await for (final entity in formDir.list()) {
      if (entity is Directory) {
        final dirName = entity.path.split('/').last;
        print('   - $dirName');
        
        // Buscar archivos widget dentro
        await for (final file in entity.list()) {
          if (file is File && file.path.endsWith('_widget.dart')) {
            print('     └─ ${file.path.split('/').last}');
          }
        }
      }
    }
  }
}

Future<void> updateExamples(String projectRoot) async {
  print('\n🔄 Actualizando ejemplos...');
  
  // Archivo de ejemplos principal
  final examplesFile = File('$projectRoot/lib/examples/examples/core_widgets_examples.dart');
  
  if (examplesFile.existsSync()) {
    var content = await examplesFile.readAsString();
    
    // Mapeo de widgets antiguos a nuevos con parámetros correctos
    final widgetReplacements = {
      // DatePickerWidget
      '''DatePickerWidget(
          dateStart: DateTime.now(),
          callBackDate: (date) {
            print('Date selected: \$date');
          },
        )''': '''DatePickerWidget(
          initialDate: DateTime.now(),
          onDateSelected: (date) {
            print('Date selected: \$date');
          },
        )''',
      
      // DateRangePickerWidget
      '''DateRangePickerWidget(
          dateStart: DateTime.now(),
          dateEnd: DateTime.now().add(Duration(days: 7)),
          callBackDateRange: (start, end) {
            print('Range: \$start to \$end');
          },
        )''': '''DateRangePickerWidget(
          initialStartDate: DateTime.now(),
          initialEndDate: DateTime.now().add(Duration(days: 7)),
          onDateRangeSelected: (start, end) {
            print('Range: \$start to \$end');
          },
        )''',
      
      // BirthDatePickerWidget
      '''BirthDatePickerWidget(
          birthDate: DateTime(1990, 1, 1),
          callBackDate: (date) {
            print('Birth date: \$date');
          },
        )''': '''BirthDatePickerWidget(
          initialDate: DateTime(1990, 1, 1),
          onDateSelected: (date) {
            print('Birth date: \$date');
          },
        )''',
      
      // PlacePickerWidget
      '''PlacePickerWidget(
          city: 'Madrid',
          country: 'España',
          callBackPlace: (place) {
            print('Place selected: \$place');
          },
        )''': '''PlacePickerWidget(
          initialCity: 'Madrid',
          initialCountry: 'España',
          onPlaceSelected: (place) {
            print('Place selected: \$place');
          },
        )''',
      
      // CurrencySelectorWidget
      '''CurrencySelectorWidget(
          amount: 100.0,
          currency: 'USD',
          onAmountChanged: (amount) {
            print('Amount: \$amount');
          },
          onCurrencyChanged: (currency) {
            print('Currency: \$currency');
          },
        )''': '''CurrencySelectorWidget(
          initialAmount: 100.0,
          initialCurrency: 'USD',
          onAmountChanged: (amount) {
            print('Amount: \$amount');
          },
          onCurrencyChanged: (currency) {
            print('Currency: \$currency');
          },
        )''',
    };
    
    // Aplicar reemplazos
    for (final entry in widgetReplacements.entries) {
      content = content.replaceAll(entry.key, entry.value);
    }
    
    // Corregir imports
    content = content.replaceAll(
      'ComponentDateWidget',
      'DatePickerWidget'
    );
    content = content.replaceAll(
      'ComponentDateRangeWidget',
      'DateRangePickerWidget'
    );
    content = content.replaceAll(
      'ComponentBirthDateWidget',
      'BirthDatePickerWidget'
    );
    content = content.replaceAll(
      'ComponentPlaceWidget',
      'PlacePickerWidget'
    );
    content = content.replaceAll(
      'ComponentAddCurrencyWidget',
      'CurrencySelectorWidget'
    );
    
    // Corregir el widget BotonCrearWidget
    content = content.replaceAll(
      '''BotonCrearWidget(
          onPressed: () {
            print('Create button pressed');
          },
        )''',
      '''BtnCreateWidget()'''
    );
    
    await examplesFile.writeAsString(content);
    print('✅ Actualizado: core_widgets_examples.dart');
  }
  
  // Actualizar tests también
  await updateTests(projectRoot);
}

Future<void> updateTests(String projectRoot) async {
  print('\n🧪 Actualizando tests de formularios...');
  
  final testMappings = {
    'dateStart:': 'initialDate:',
    'dateEnd:': 'initialEndDate:',
    'callBackDate:': 'onDateSelected:',
    'callBackDateRange:': 'onDateRangeSelected:',
    'birthDate:': 'initialDate:',
    'callBackPlace:': 'onPlaceSelected:',
    'city:': 'initialCity:',
    'country:': 'initialCountry:',
    'amount:': 'initialAmount:',
    'currency:': 'initialCurrency:',
  };
  
  final testDir = Directory('$projectRoot/test/widgets/core/forms');
  if (testDir.existsSync()) {
    await for (final file in testDir.list(recursive: true)) {
      if (file is File && file.path.endsWith('_test.dart')) {
        var content = await file.readAsString();
        var modified = false;
        
        for (final entry in testMappings.entries) {
          if (content.contains(entry.key)) {
            content = content.replaceAll(entry.key, entry.value);
            modified = true;
          }
        }
        
        if (modified) {
          await file.writeAsString(content);
          print('✅ Actualizado: ${file.path.split('/').last}');
        }
      }
    }
  }
}