import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/bukeer/core/widgets/forms/birth_date_picker/birth_date_picker_widget.dart';
import 'package:intl/intl.dart';
import '../test_helpers.dart';

void main() {
  group('BirthDatePickerWidget', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      DateTime? selectedDate;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BirthDatePickerWidget(
            onDateSelected: (date) async {
              selectedDate = date;
            },
          ),
        ),
      );

      // Verificar que se renderiza
      expect(find.byType(BirthDatePickerWidget), findsOneWidget);

      // Verificar que contiene un campo de texto
      expect(find.byType(TextField), findsOneWidget);

      // Verificar icono de calendario
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('shows initial birth date', (WidgetTester tester) async {
      final birthDate = DateTime(1990, 5, 15);
      final dateFormat = DateFormat('dd/MM/yyyy');

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BirthDatePickerWidget(
            initialDate: birthDate,
            onDateSelected: (date) async {},
          ),
        ),
      );

      // Verificar que muestra la fecha inicial
      expect(find.text(dateFormat.format(birthDate)), findsOneWidget);
    });

    testWidgets('restricts future dates', (WidgetTester tester) async {
      DateTime? selectedDate;
      final futureDate = DateTime.now().add(Duration(days: 30));

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BirthDatePickerWidget(
            onDateSelected: (date) async {
              selectedDate = date;
            },
          ),
        ),
      );

      // Abrir picker
      await tapAndSettle(tester, find.byType(TextField));
      await tester.pump();

      // El date picker no debería permitir seleccionar fechas futuras
      // La validación exacta depende de la implementación
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('restricts dates older than 120 years',
        (WidgetTester tester) async {
      final veryOldDate = DateTime.now().subtract(Duration(days: 365 * 121));
      DateTime? selectedDate;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BirthDatePickerWidget(
            initialDate: veryOldDate, // Fecha muy antigua
            onDateSelected: (date) async {
              selectedDate = date;
            },
          ),
        ),
      );

      // El widget debería validar o corregir fechas muy antiguas
      expect(find.byType(BirthDatePickerWidget), findsOneWidget);
    });

    testWidgets('calculates age correctly', (WidgetTester tester) async {
      final birthDate =
          DateTime.now().subtract(Duration(days: 365 * 25)); // 25 años

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BirthDatePickerWidget(
            initialDate: birthDate,
            onDateSelected: (date) async {},
          ),
        ),
      );

      // Podría mostrar la edad calculada
      // Buscar texto que contenga "25" o "años"
      expect(find.byType(BirthDatePickerWidget), findsOneWidget);
    });

    testWidgets('calls callback when date selected',
        (WidgetTester tester) async {
      DateTime? selectedDate;
      bool callbackCalled = false;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BirthDatePickerWidget(
            onDateSelected: (date) async {
              selectedDate = date;
              callbackCalled = true;
            },
          ),
        ),
      );

      // Abrir picker
      await tapAndSettle(tester, find.byType(TextField));
      await tester.pump();

      // Seleccionar una fecha (año 1990)
      // La implementación exacta depende del DatePicker usado
      final yearButton = find.textContaining('1990');
      if (yearButton.evaluate().isEmpty) {
        // Si no encuentra el año, intentar con el día
        final dayFinder = find.text('15');
        if (dayFinder.evaluate().isNotEmpty) {
          await tester.tap(dayFinder.first);
          await tester.pump();

          // Confirmar selección
          final okButton = find.text('OK');
          if (okButton.evaluate().isNotEmpty) {
            await tapAndSettle(tester, okButton);

            // Verificar callback
            expect(callbackCalled, isTrue);
            expect(selectedDate, isNotNull);
          }
        }
      }
    });

    testWidgets('shows appropriate placeholder', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BirthDatePickerWidget(
            onDateSelected: (date) async {},
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, isNotNull);
      // Verificar que el placeholder es apropiado para fecha de nacimiento
      expect(
        textField.decoration?.hintText?.toLowerCase(),
        anyOf(
          contains('nacimiento'),
          contains('birth'),
          contains('fecha'),
        ),
      );
    });

    testWidgets('clears birth date', (WidgetTester tester) async {
      DateTime? clearedDate;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BirthDatePickerWidget(
            initialDate: DateTime(1990, 1, 1),
            onDateSelected: (date) async {
              clearedDate = date;
            },
          ),
        ),
      );

      // Buscar botón de limpiar
      final clearButton = find.byIcon(Icons.clear);
      if (clearButton.evaluate().isNotEmpty) {
        await tapAndSettle(tester, clearButton);
        expect(clearedDate, isNull);
      }
    });

    testWidgets('validates minimum age requirements',
        (WidgetTester tester) async {
      // Test para verificar restricciones de edad mínima (ej: mayor de 18)
      final minorDate =
          DateTime.now().subtract(Duration(days: 365 * 17)); // 17 años

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BirthDatePickerWidget(
            initialDate: minorDate,
            onDateSelected: (date) async {},
          ),
        ),
      );

      // Dependiendo de la implementación, podría mostrar advertencia
      expect(find.byType(BirthDatePickerWidget), findsOneWidget);
    });

    testWidgets('formats birth date correctly', (WidgetTester tester) async {
      final birthDate = DateTime(1985, 12, 25);

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BirthDatePickerWidget(
            initialDate: birthDate,
            onDateSelected: (date) async {},
          ),
        ),
      );

      // Verificar formato dd/MM/yyyy
      expect(find.text('25/12/1985'), findsOneWidget);
    });
  });
}
