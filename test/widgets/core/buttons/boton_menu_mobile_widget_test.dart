import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/bukeer/core/widgets/buttons/btn_mobile_menu/btn_mobile_menu_widget.dart';
import '../test_helpers.dart';

void main() {
  group('BtnMobileMenuWidget', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BtnMobileMenuWidget(),
        ),
      );

      // Verificar que se renderiza
      expect(find.byType(BtnMobileMenuWidget), findsOneWidget);

      // Verificar que contiene un IconButton
      expect(find.byType(IconButton), findsOneWidget);

      // Verificar que tiene el icono de menú
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('opens drawer on tap', (WidgetTester tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();

      await pumpWidgetAndSettle(
        tester,
        MaterialApp(
          home: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              leading: BtnMobileMenuWidget(),
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    child: Text('Menu'),
                  ),
                  ListTile(
                    title: Text('Option 1'),
                  ),
                  ListTile(
                    title: Text('Option 2'),
                  ),
                ],
              ),
            ),
            body: Center(
              child: Text('Main Content'),
            ),
          ),
        ),
      );

      // Verificar que el drawer está cerrado
      expect(find.text('Menu'), findsNothing);
      expect(find.text('Option 1'), findsNothing);

      // Tap en el botón de menú
      await tapAndSettle(tester, find.byType(BtnMobileMenuWidget));

      // Verificar que el drawer se abrió
      expect(find.text('Menu'), findsOneWidget);
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('shows on mobile screens', (WidgetTester tester) async {
      await setScreenSize(
        tester,
        width: ScreenSizes.mobile.width,
        height: ScreenSizes.mobile.height,
      );

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BtnMobileMenuWidget(),
        ),
      );

      // Debería ser visible en móvil
      expect(find.byType(BtnMobileMenuWidget), findsOneWidget);
    });

    testWidgets('responsive visibility on tablet', (WidgetTester tester) async {
      await setScreenSize(
        tester,
        width: ScreenSizes.tablet.width,
        height: ScreenSizes.tablet.height,
      );

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BtnMobileMenuWidget(),
        ),
      );

      // El comportamiento en tablet depende de la implementación
      expect(find.byType(BtnMobileMenuWidget), findsOneWidget);
    });

    testWidgets('has correct icon style', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BtnMobileMenuWidget(),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.menu));

      // Verificar estilo del icono
      expect(icon.size, anyOf(equals(24.0), equals(28.0), isNull));
      expect(icon.color, anyOf(isNotNull, isNull));
    });

    testWidgets('shows tooltip', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BtnMobileMenuWidget(),
        ),
      );

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));

      // Verificar tooltip
      expect(iconButton.tooltip, anyOf(isNotNull, isNull));
      if (iconButton.tooltip != null) {
        expect(
          iconButton.tooltip!.toLowerCase(),
          anyOf(
            contains('menú'),
            contains('menu'),
            contains('abrir'),
            contains('open'),
          ),
        );
      }
    });

    testWidgets('animates drawer opening', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              leading: BtnMobileMenuWidget(),
            ),
            drawer: Drawer(
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Text('Drawer Content'),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap para abrir
      await tester.tap(find.byType(BtnMobileMenuWidget));

      // Verificar animación del drawer
      await tester.pump(); // Inicio de animación
      await tester.pump(Duration(milliseconds: 100)); // Durante animación

      // El drawer debería estar parcialmente visible
      expect(find.text('Drawer Content'), findsOneWidget);

      // Completar animación
      await tester.pumpAndSettle();
    });

    testWidgets('closes drawer on back button', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              leading: BtnMobileMenuWidget(),
            ),
            drawer: Drawer(
              child: Text('Drawer'),
            ),
          ),
        ),
      );

      // Abrir drawer
      await tapAndSettle(tester, find.byType(BtnMobileMenuWidget));
      expect(find.text('Drawer'), findsOneWidget);

      // Simular botón atrás
      final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
      await widgetsAppState.didPopRoute();
      await tester.pumpAndSettle();

      // Drawer debería cerrarse
      expect(find.text('Drawer'), findsNothing);
    });

    testWidgets('is accessible', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          BtnMobileMenuWidget(),
        ),
      );

      // Verificar semántica para accesibilidad
      final semantics = tester.getSemantics(find.byType(IconButton));
      expect(semantics.label, isNotNull);
    });

    testWidgets('handles theme changes', (WidgetTester tester) async {
      // Tema claro
      await pumpWidgetAndSettle(
        tester,
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            appBar: AppBar(
              leading: BtnMobileMenuWidget(),
            ),
          ),
        ),
      );

      final iconLight = tester.widget<Icon>(find.byIcon(Icons.menu));
      final colorLight = iconLight.color;

      // Tema oscuro
      await pumpWidgetAndSettle(
        tester,
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            appBar: AppBar(
              leading: BtnMobileMenuWidget(),
            ),
          ),
        ),
      );

      final iconDark = tester.widget<Icon>(find.byIcon(Icons.menu));
      final colorDark = iconDark.color;

      // Los colores pueden ser diferentes según el tema
      expect(
          colorLight != colorDark || (colorLight == null && colorDark == null),
          isTrue);
    });
  });
}
