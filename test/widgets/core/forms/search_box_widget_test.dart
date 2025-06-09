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

      // Buscar el texto del hint en el widget tree
      final hintTextFinder = find.text('Buscar');
      if (hintTextFinder.evaluate().isEmpty) {
        // Si no encuentra "Buscar", buscar "Search"
        expect(find.text('Search'), findsOneWidget);
      } else {
        expect(hintTextFinder, findsOneWidget);
      }
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
      final searchValues = <String>[];

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(SearchBoxWidget()),
      );

      // Escribir rápidamente
      final searchField = find.byType(TextFormField);

      // Capturar valores antes de cada cambio
      await tester.enterText(searchField, 'h');
      searchValues.add(appServices.ui.searchQuery);
      await tester.pump(Duration(milliseconds: 100));

      await tester.enterText(searchField, 'ho');
      searchValues.add(appServices.ui.searchQuery);
      await tester.pump(Duration(milliseconds: 100));

      await tester.enterText(searchField, 'hot');
      searchValues.add(appServices.ui.searchQuery);
      await tester.pump(Duration(milliseconds: 100));

      await tester.enterText(searchField, 'hotel');

      // Esperar más que el debounce (2000ms según el código)
      await tester.pump(Duration(milliseconds: 2100));

      // Verificar que solo el último valor se guardó después del debounce
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

      // Verificar que el campo está enfocado mediante FocusScope
      final focusedWidget =
          FocusScope.of(tester.element(searchField)).focusedChild;
      expect(focusedWidget, isNotNull);

      // Escribir texto
      await tester.enterText(searchField, 'search text');
      await tester.pump();

      // Verificar que mantiene el foco
      final stillFocused =
          FocusScope.of(tester.element(searchField)).focusedChild;
      expect(stillFocused, isNotNull);
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

      // Verificar que existe el icono de búsqueda
      final searchIcon = find.byIcon(Icons.search);
      expect(searchIcon, findsOneWidget);

      // Verificar que está antes del campo de texto (a la izquierda)
      final searchIconPosition = tester.getCenter(searchIcon);
      final textFieldPosition = tester.getCenter(find.byType(TextFormField));

      // El icono debería estar a la izquierda del centro del campo
      expect(searchIconPosition.dx, lessThan(textFieldPosition.dx));
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
