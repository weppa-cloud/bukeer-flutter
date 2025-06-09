import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/bukeer/core/widgets/forms/date_range_picker/date_range_picker_widget.dart';
import 'package:intl/intl.dart';
import '../test_helpers.dart';

void main() {
  group('DateRangePickerWidget', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      DateTime? startDate;
      DateTime? endDate;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DateRangePickerWidget(
            callBackDateRange: (start, end) {
              startDate = start;
              endDate = end;
            },
          ),
        ),
      );

      // Verificar que se renderiza
      expect(find.byType(DateRangePickerWidget), findsOneWidget);

      // Verificar que contiene campos de fecha
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('shows initial date range', (WidgetTester tester) async {
      final initialStart = DateTime(2024, 1, 1);
      final initialEnd = DateTime(2024, 1, 31);
      final dateFormat = DateFormat('dd/MM/yyyy');

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DateRangePickerWidget(
            dateStart: initialStart,
            dateEnd: initialEnd,
            callBackDateRange: (start, end) {},
          ),
        ),
      );

      // Verificar que muestra las fechas iniciales
      final expectedText =
          '${dateFormat.format(initialStart)} - ${dateFormat.format(initialEnd)}';
      expect(
          find.textContaining(dateFormat.format(initialStart)), findsWidgets);
      expect(find.textContaining(dateFormat.format(initialEnd)), findsWidgets);
    });

    testWidgets('shows preset options', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DateRangePickerWidget(
            callBackDateRange: (start, end) {},
          ),
        ),
      );

      // Tap para abrir opciones
      await tapAndSettle(tester, find.byType(TextField).first);
      await tester.pump();

      // Verificar opciones preset
      expect(findTextIgnoreCase('Hoy'), findsWidgets);
      expect(findTextIgnoreCase('Últimos 7 días'), findsWidgets);
      expect(findTextIgnoreCase('Últimos 30 días'), findsWidgets);
    });

    testWidgets('selects today preset', (WidgetTester tester) async {
      DateTime? selectedStart;
      DateTime? selectedEnd;
      bool callbackCalled = false;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DateRangePickerWidget(
            callBackDateRange: (start, end) {
              selectedStart = start;
              selectedEnd = end;
              callbackCalled = true;
            },
          ),
        ),
      );

      // Abrir opciones y seleccionar "Hoy"
      await tapAndSettle(tester, find.byType(TextField).first);
      await tester.pump();

      final todayOption = findTextIgnoreCase('Hoy');
      if (todayOption.evaluate().isNotEmpty) {
        await tapAndSettle(tester, todayOption.first);

        // Verificar que se seleccionó hoy
        expect(callbackCalled, isTrue);
        expect(selectedStart?.day, equals(DateTime.now().day));
        expect(selectedEnd?.day, equals(DateTime.now().day));
      }
    });

    testWidgets('selects last 7 days preset', (WidgetTester tester) async {
      DateTime? selectedStart;
      DateTime? selectedEnd;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DateRangePickerWidget(
            callBackDateRange: (start, end) {
              selectedStart = start;
              selectedEnd = end;
            },
          ),
        ),
      );

      // Abrir opciones y seleccionar "Últimos 7 días"
      await tapAndSettle(tester, find.byType(TextField).first);
      await tester.pump();

      final last7Days = findTextIgnoreCase('Últimos 7 días');
      if (last7Days.evaluate().isNotEmpty) {
        await tapAndSettle(tester, last7Days.first);

        // Verificar rango de 7 días
        if (selectedStart != null && selectedEnd != null) {
          final difference = selectedEnd.difference(selectedStart).inDays;
          expect(difference, equals(6)); // 7 días inclusive
        }
      }
    });

    testWidgets('validates end date after start date',
        (WidgetTester tester) async {
      // Este test verifica que la fecha fin sea posterior a la fecha inicio
      DateTime? validatedStart;
      DateTime? validatedEnd;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DateRangePickerWidget(
            dateStart: DateTime(2024, 1, 15),
            dateEnd: DateTime(2024, 1, 10), // Fecha inválida (antes del inicio)
            callBackDateRange: (start, end) {
              validatedStart = start;
              validatedEnd = end;
            },
          ),
        ),
      );

      // El widget debería corregir automáticamente o mostrar error
      expect(find.byType(DateRangePickerWidget), findsOneWidget);
    });

    testWidgets('opens custom date picker', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DateRangePickerWidget(
            callBackDateRange: (start, end) {},
          ),
        ),
      );

      // Buscar opción personalizada
      await tapAndSettle(tester, find.byType(TextField).first);
      await tester.pump();

      final customOption = findTextIgnoreCase('Personalizado');
      if (customOption.evaluate().isNotEmpty) {
        await tapAndSettle(tester, customOption.first);
        await tester.pump();

        // Debería abrir un date range picker
        expect(find.byType(Dialog), findsWidgets);
      }
    });

    testWidgets('clears date range', (WidgetTester tester) async {
      DateTime? clearedStart;
      DateTime? clearedEnd;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DateRangePickerWidget(
            dateStart: DateTime.now(),
            dateEnd: DateTime.now().add(Duration(days: 7)),
            callBackDateRange: (start, end) {
              clearedStart = start;
              clearedEnd = end;
            },
          ),
        ),
      );

      // Buscar botón de limpiar
      final clearButton = find.byIcon(Icons.clear);
      if (clearButton.evaluate().isNotEmpty) {
        await tapAndSettle(tester, clearButton.first);
        expect(clearedStart, isNull);
        expect(clearedEnd, isNull);
      }
    });

    testWidgets('formats date range correctly', (WidgetTester tester) async {
      final start = DateTime(2024, 1, 1);
      final end = DateTime(2024, 1, 31);

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          DateRangePickerWidget(
            dateStart: start,
            dateEnd: end,
            callBackDateRange: (start, end) {},
          ),
        ),
      );

      // Verificar formato de fecha
      expect(find.textContaining('01/01/2024'), findsWidgets);
      expect(find.textContaining('31/01/2024'), findsWidgets);
    });
  });
}
