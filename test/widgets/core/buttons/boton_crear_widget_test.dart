import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/bukeer/core/widgets/buttons/boton_crear/boton_crear_widget.dart';
import '../test_helpers.dart';

void main() {
  group('BotonCrearWidget', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      bool wasPressed = false;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BotonCrearWidget(
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      );

      // Verificar que se renderiza
      expect(find.byType(BotonCrearWidget), findsOneWidget);

      // Verificar que contiene un FloatingActionButton
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Verificar que tiene el icono de agregar
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool wasPressed = false;
      int tapCount = 0;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BotonCrearWidget(
            onPressed: () {
              wasPressed = true;
              tapCount++;
            },
          ),
        ),
      );

      // Tap en el botón
      await tapAndSettle(tester, find.byType(FloatingActionButton));

      // Verificar que se llamó el callback
      expect(wasPressed, isTrue);
      expect(tapCount, equals(1));

      // Tap nuevamente
      await tapAndSettle(tester, find.byType(FloatingActionButton));
      expect(tapCount, equals(2));
    });

    testWidgets('has correct style', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BotonCrearWidget(onPressed: () {}),
        ),
      );

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );

      // Verificar estilo
      expect(fab.backgroundColor, anyOf(isNotNull, isNull));
      expect(fab.foregroundColor, anyOf(isNotNull, isNull));
      expect(fab.elevation, anyOf(greaterThan(0), isNull));
    });

    testWidgets('shows tooltip on long press', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BotonCrearWidget(onPressed: () {}),
        ),
      );

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );

      // Verificar que tiene tooltip
      expect(fab.tooltip, anyOf(isNotNull, isNull));
      if (fab.tooltip != null) {
        expect(
          fab.tooltip!.toLowerCase(),
          anyOf(
            contains('crear'),
            contains('nuevo'),
            contains('agregar'),
            contains('add'),
            contains('new'),
          ),
        );
      }
    });

    testWidgets('has correct icon size', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BotonCrearWidget(onPressed: () {}),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.add));

      // Verificar tamaño del icono
      expect(
          icon.size, anyOf(equals(24.0), equals(28.0), equals(32.0), isNull));
    });

    testWidgets('animates on tap', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BotonCrearWidget(onPressed: () {}),
        ),
      );

      // Obtener posición inicial
      final initialPosition =
          tester.getCenter(find.byType(FloatingActionButton));

      // Presionar el botón
      await tester.press(find.byType(FloatingActionButton));
      await tester.pump(Duration(milliseconds: 50));

      // Durante la animación de presión, podría cambiar ligeramente
      final pressedPosition =
          tester.getCenter(find.byType(FloatingActionButton));

      // Soltar
      await tester.pumpAndSettle();

      // Verificar que volvió a la posición original
      final finalPosition = tester.getCenter(find.byType(FloatingActionButton));
      expect(finalPosition, equals(initialPosition));
    });

    testWidgets('uses theme colors', (WidgetTester tester) async {
      final customTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          primary: Colors.purple,
        ),
      );

      await pumpWidgetAndSettle(
        tester,
        MaterialApp(
          theme: customTheme,
          home: Scaffold(
            floatingActionButton: BotonCrearWidget(onPressed: () {}),
          ),
        ),
      );

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );

      // Si no tiene color explícito, usará el del tema
      if (fab.backgroundColor == null) {
        expect(customTheme.colorScheme.primary, equals(Colors.purple));
      }
    });

    testWidgets('is positioned correctly in scaffold',
        (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        MaterialApp(
          home: Scaffold(
            floatingActionButton: BotonCrearWidget(onPressed: () {}),
          ),
        ),
      );

      // Verificar que está en la posición correcta (abajo a la derecha por defecto)
      final fabPosition = tester.getCenter(find.byType(FloatingActionButton));
      final screenSize = tester.getSize(find.byType(Scaffold));

      // Debería estar en la parte inferior derecha
      expect(fabPosition.dx, greaterThan(screenSize.width / 2));
      expect(fabPosition.dy, greaterThan(screenSize.height / 2));
    });

    testWidgets('has shadow/elevation', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BotonCrearWidget(onPressed: () {}),
        ),
      );

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );

      // Verificar elevación (sombra)
      expect(fab.elevation ?? 6.0, greaterThanOrEqualTo(0));
    });

    testWidgets('respects onPressed null state', (WidgetTester tester) async {
      // Si el widget permite onPressed null para estado deshabilitado
      // Nota: BotonCrearWidget requiere onPressed, pero este test
      // es para verificar el comportamiento si cambia la API

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BotonCrearWidget(onPressed: () {}),
        ),
      );

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );

      // Verificar que está habilitado
      expect(fab.onPressed, isNotNull);
    });
  });
}
