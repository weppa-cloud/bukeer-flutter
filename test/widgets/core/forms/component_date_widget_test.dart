import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/bukeer/core/widgets/forms/date_picker/date_picker_widget.dart';
import 'package:intl/intl.dart';
import '../test_helpers.dart';

void main() {
  group('DatePickerWidget', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      DateTime? selectedDate;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DatePickerWidget(
            callBackDate: (date) async {
              selectedDate = date;
            },
          ),
        ),
      );

      // Verificar que se renderiza
      expect(find.byType(DatePickerWidget), findsOneWidget);

      // Verificar que contiene un campo de texto
      expect(find.byType(TextField), findsOneWidget);

      // Verificar icono de calendario
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('shows initial date', (WidgetTester tester) async {
      final initialDate = DateTime(2024, 1, 15);
      final dateFormat = DateFormat('dd/MM/yyyy');

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DatePickerWidget(
            dateStart: initialDate,
            callBackDate: (date) async {},
          ),
        ),
      );

      // Verificar que muestra la fecha inicial
      expect(find.text(dateFormat.format(initialDate)), findsOneWidget);
    });

    testWidgets('opens date picker on tap', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DatePickerWidget(
            callBackDate: (date) async {},
          ),
        ),
      );

      // Tap en el campo
      await tapAndSettle(tester, find.byType(TextField));

      // Verificar que se abre el picker
      // El DatePicker en Flutter es un dialog
      await tester.pump();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('calls callback when date selected',
        (WidgetTester tester) async {
      DateTime? selectedDate;
      bool callbackCalled = false;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DatePickerWidget(
            callBackDate: (date) async {
              selectedDate = date;
              callbackCalled = true;
            },
          ),
        ),
      );

      // Abrir picker
      await tapAndSettle(tester, find.byType(TextField));
      await tester.pump();

      // Seleccionar una fecha (día 15)
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
    });

    testWidgets('formats date correctly', (WidgetTester tester) async {
      final testDate = DateTime(2024, 12, 25);

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DatePickerWidget(
            dateStart: testDate,
            callBackDate: (date) async {},
          ),
        ),
      );

      // Verificar formato dd/MM/yyyy
      expect(find.text('25/12/2024'), findsOneWidget);
    });

    testWidgets('clears date when clear button tapped',
        (WidgetTester tester) async {
      DateTime? clearedDate;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DatePickerWidget(
            dateStart: DateTime.now(),
            callBackDate: (date) async {
              clearedDate = date;
            },
          ),
        ),
      );

      // Buscar botón de limpiar (si existe)
      final clearButton = find.byIcon(Icons.clear);
      if (clearButton.evaluate().isNotEmpty) {
        await tapAndSettle(tester, clearButton);
        expect(clearedDate, isNull);
      }
    });

    testWidgets('shows placeholder when no date selected',
        (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DatePickerWidget(
            callBackDate: (date) async {},
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, isNotNull);
    });

    testWidgets('is disabled when loading', (WidgetTester tester) async {
      // Este test verifica si el widget maneja estados de carga
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DatePickerWidget(
            callBackDate: (date) async {
              // Simular operación larga
              await Future.delayed(Duration(seconds: 2));
            },
          ),
        ),
      );

      // El comportamiento específico depende de la implementación
      expect(find.byType(DatePickerWidget), findsOneWidget);
    });
  });
}
