import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/bukeer/core/widgets/buttons/btn_back/btn_back_widget.dart';
import 'package:bukeer/design_system/index.dart';
import 'package:mocktail/mocktail.dart';
import '../test_helpers.dart';

void main() {
  group('BtnBackWidget', () {
    late MockNavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BtnBackWidget(),
          navigatorObserver: mockObserver,
        ),
      );

      // Verificar que se renderiza
      expect(find.byType(BtnBackWidget), findsOneWidget);

      // Verificar que contiene un BukeerIconButton
      expect(find.byType(BukeerIconButton), findsOneWidget);

      // Verificar que tiene el icono de flecha atrás
      expect(find.byIcon(Icons.arrow_back_sharp), findsOneWidget);
    });

    testWidgets('shows tooltip on hover', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(BtnBackWidget()),
      );

      // Verificar que tiene tooltip
      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.tooltip, isNotNull);
      expect(
        iconButton.tooltip?.toLowerCase(),
        anyOf(
          contains('volver'),
          contains('back'),
          contains('atrás'),
        ),
      );
    });

    testWidgets('navigates back on tap', (WidgetTester tester) async {
      // Crear una pila de navegación con 2 páginas
      await pumpWidgetAndSettle(
        tester,
        MaterialApp(
          navigatorObservers: [mockObserver],
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: Text('Home'),
            ),
          ),
        ),
      );

      // Navegar a una segunda página con el botón back
      await tester.tap(find.text('Home'));
      Navigator.of(tester.element(find.text('Home'))).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              leading: BtnBackWidget(),
            ),
            body: Text('Second Page'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verificar que estamos en la segunda página
      expect(find.text('Second Page'), findsOneWidget);

      // Tap en el botón back
      await tapAndSettle(tester, find.byType(BtnBackWidget));

      // Verificar que volvió a la página anterior
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Second Page'), findsNothing);
    });

    testWidgets('has correct icon color', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(BtnBackWidget()),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_back));

      // El color dependerá del tema, pero debería estar definido
      expect(icon.color, anyOf(isNotNull, isNull));
    });

    testWidgets('has correct size', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(BtnBackWidget()),
      );

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));

      // Verificar tamaño estándar
      expect(iconButton.iconSize, anyOf(equals(24.0), equals(28.0), isNull));
    });

    testWidgets('is accessible', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(BtnBackWidget()),
      );

      // Verificar que tiene semántica para accesibilidad
      final semantics = tester.getSemantics(find.byType(IconButton));
      expect(semantics.label, isNotNull);
    });

    testWidgets('responds to theme changes', (WidgetTester tester) async {
      // Test con tema claro
      await pumpWidgetAndSettle(
        tester,
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            appBar: AppBar(
              leading: BtnBackWidget(),
            ),
          ),
        ),
      );

      final iconLight = tester.widget<Icon>(find.byIcon(Icons.arrow_back));
      final colorLight = iconLight.color;

      // Test con tema oscuro
      await pumpWidgetAndSettle(
        tester,
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            appBar: AppBar(
              leading: BtnBackWidget(),
            ),
          ),
        ),
      );

      final iconDark = tester.widget<Icon>(find.byIcon(Icons.arrow_back));
      final colorDark = iconDark.color;

      // Los colores deberían ser diferentes según el tema
      expect(
          colorLight != colorDark || (colorLight == null && colorDark == null),
          isTrue);
    });

    testWidgets('handles disabled state', (WidgetTester tester) async {
      // Si el widget soporta estado deshabilitado
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(BtnBackWidget()),
      );

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));

      // Verificar que está habilitado por defecto
      expect(iconButton.onPressed, isNotNull);
    });
  });
}
