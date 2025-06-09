import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/bukeer/core/widgets/forms/search_box/search_box_widget.dart';
import 'package:bukeer/services/app_services.dart';
import '../test_helpers.dart';

void main() {
  group('SearchBoxWidget', () {
    late AppServices appServices;

    setUp(() {
      appServices = AppServices();
      // Limpiar estado previo
      appServices.ui.searchQuery = '';
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(SearchBoxWidget()),
      );

      // Verificar que se renderiza
      expect(find.byType(SearchBoxWidget), findsOneWidget);

      // Verificar que contiene un campo de texto
      expect(find.byType(TextFormField), findsOneWidget);

      // Verificar icono de búsqueda
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('shows placeholder text', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(SearchBoxWidget()),
      );

      final textField =
          tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.decoration?.hintText, isNotNull);
      expect(
        textField.decoration?.hintText?.toLowerCase(),
        anyOf(
          contains('buscar'),
          contains('search'),
        ),
      );
    });

    testWidgets('updates global search state on text input',
        (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(SearchBoxWidget()),
      );

      // Ingresar texto de búsqueda
      final searchField = find.byType(TextFormField);
      await tester.enterText(searchField, 'hotel playa');

      // Esperar el debounce (300ms)
      await tester.pump(Duration(milliseconds: 350));

      // Verificar que actualizó el estado global
      expect(appServices.ui.searchQuery, equals('hotel playa'));
    });

    testWidgets('shows clear button when text is entered',
        (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(SearchBoxWidget()),
      );

      // Verificar que no hay botón clear inicialmente
      expect(find.byIcon(Icons.clear), findsNothing);

      // Ingresar texto
      final searchField = find.byType(TextFormField);
      await tester.enterText(searchField, 'test search');
      await tester.pump();

      // Verificar que aparece el botón clear
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('clears search when clear button pressed',
        (WidgetTester tester) async {
      // Establecer valor inicial
      appServices.ui.searchQuery = 'existing search';

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(SearchBoxWidget()),
      );

      // Debería mostrar el texto existente
      expect(find.text('existing search'), findsOneWidget);

      // Tap en botón clear
      final clearButton = find.byIcon(Icons.clear);
      await tapAndSettle(tester, clearButton);

      // Verificar que se limpió
      expect(appServices.ui.searchQuery, equals(''));
      expect(find.text('existing search'), findsNothing);
    });

    testWidgets('debounces search input', (WidgetTester tester) async {
      int updateCount = 0;

      // Escuchar cambios en el stream
      appServices.ui.searchQueryStream.listen((_) {
        updateCount++;
      });

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(SearchBoxWidget()),
      );

      // Escribir rápidamente
      final searchField = find.byType(TextFormField);
      await tester.enterText(searchField, 'h');
      await tester.pump(Duration(milliseconds: 100));
      await tester.enterText(searchField, 'ho');
      await tester.pump(Duration(milliseconds: 100));
      await tester.enterText(searchField, 'hot');
      await tester.pump(Duration(milliseconds: 100));
      await tester.enterText(searchField, 'hote');
      await tester.pump(Duration(milliseconds: 100));
      await tester.enterText(searchField, 'hotel');

      // Esperar más que el debounce
      await tester.pump(Duration(milliseconds: 350));

      // Debería actualizar solo una vez debido al debounce
      expect(updateCount, lessThan(5));
      expect(appServices.ui.searchQuery, equals('hotel'));
    });

    testWidgets('syncs with global state changes', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(SearchBoxWidget()),
      );

      // Cambiar el estado global desde fuera
      appServices.ui.searchQuery = 'updated externally';
      await tester.pump();

      // El widget debería reflejar el cambio
      expect(find.text('updated externally'), findsOneWidget);
    });

    testWidgets('maintains focus when typing', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(SearchBoxWidget()),
      );

      // Dar foco al campo
      final searchField = find.byType(TextFormField);
      await tester.tap(searchField);
      await tester.pump();

      // Verificar que tiene foco
      final focusNode = tester.widget<TextFormField>(searchField).focusNode;
      expect(focusNode?.hasFocus ?? false, isTrue);

      // Escribir texto
      await tester.enterText(searchField, 'search text');
      await tester.pump();

      // Debería mantener el foco
      expect(focusNode?.hasFocus ?? false, isTrue);
    });

    testWidgets('handles empty search correctly', (WidgetTester tester) async {
      // Establecer valor inicial
      appServices.ui.searchQuery = 'initial value';

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(SearchBoxWidget()),
      );

      // Borrar todo el texto
      final searchField = find.byType(TextFormField);
      await tester.enterText(searchField, '');
      await tester.pump(Duration(milliseconds: 350));

      // Verificar que el estado es vacío
      expect(appServices.ui.searchQuery, equals(''));
    });

    testWidgets('shows search icon in correct position',
        (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(SearchBoxWidget()),
      );

      final textField =
          tester.widget<TextFormField>(find.byType(TextFormField));

      // Verificar que tiene icono de prefijo
      expect(textField.decoration?.prefixIcon, isNotNull);

      // Verificar que es el icono de búsqueda
      final prefixIcon = textField.decoration?.prefixIcon as Icon?;
      expect(prefixIcon?.icon, equals(Icons.search));
    });

    testWidgets('handles special characters in search',
        (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(SearchBoxWidget()),
      );

      // Ingresar caracteres especiales
      final searchField = find.byType(TextFormField);
      await tester.enterText(searchField, 'Cañón & Mar @2024');
      await tester.pump(Duration(milliseconds: 350));

      // Verificar que acepta caracteres especiales
      expect(appServices.ui.searchQuery, equals('Cañón & Mar @2024'));
    });
  });
}
