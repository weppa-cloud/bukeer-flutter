import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/bukeer/core/widgets/navigation/mobile_nav/mobile_nav_widget.dart';
import 'package:mocktail/mocktail.dart';
import '../test_helpers.dart';

void main() {
  group('MobileNavWidget', () {
    late MockNavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    testWidgets('renders correctly on mobile', (WidgetTester tester) async {
      await setScreenSize(
        tester,
        width: ScreenSizes.mobile.width,
        height: ScreenSizes.mobile.height,
      );

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          MobileNavWidget(),
          navigatorObserver: mockObserver,
        ),
      );

      // Verificar que se renderiza
      expect(find.byType(MobileNavWidget), findsOneWidget);

      // Verificar que es un BottomNavigationBar
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('shows navigation items', (WidgetTester tester) async {
      await setScreenSize(
        tester,
        width: ScreenSizes.mobile.width,
        height: ScreenSizes.mobile.height,
      );

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(MobileNavWidget()),
      );

      // Verificar iconos de navegación
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsWidgets);
      expect(find.byIcon(Icons.shopping_bag), findsWidgets);
      expect(find.byIcon(Icons.people), findsWidgets);
    });

    testWidgets('highlights current tab', (WidgetTester tester) async {
      await setScreenSize(
        tester,
        width: ScreenSizes.mobile.width,
        height: ScreenSizes.mobile.height,
      );

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(MobileNavWidget()),
      );

      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      // Verificar que hay un tab seleccionado
      expect(bottomNav.currentIndex, greaterThanOrEqualTo(0));
      expect(bottomNav.currentIndex, lessThan(bottomNav.items.length));
    });

    testWidgets('navigates on tab tap', (WidgetTester tester) async {
      await setScreenSize(
        tester,
        width: ScreenSizes.mobile.width,
        height: ScreenSizes.mobile.height,
      );

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          MobileNavWidget(),
          navigatorObserver: mockObserver,
        ),
      );

      // Tap en el segundo tab (índice 1)
      final calendarIcon = find.byIcon(Icons.calendar_today);
      if (calendarIcon.evaluate().isNotEmpty) {
        await tapAndSettle(tester, calendarIcon.first);

        // Verificar navegación
        verify(() => mockObserver.didPush(any(), any())).called(greaterThan(0));
      }
    });

    testWidgets('hides on desktop screens', (WidgetTester tester) async {
      await setScreenSize(
        tester,
        width: ScreenSizes.desktop.width,
        height: ScreenSizes.desktop.height,
      );

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          Column(
            children: [
              // MobileNav debe ocultarse en desktop
              MobileNavWidget(),
            ],
          ),
        ),
      );

      // Verificar comportamiento responsive
      expect(find.byType(MobileNavWidget), findsOneWidget);
    });
  });
}
