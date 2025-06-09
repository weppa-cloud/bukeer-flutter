import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/services/app_services.dart';
import 'package:bukeer/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/flutter_flow/flutter_flow_theme.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockBuildContext extends Mock implements BuildContext {}

/// Widget wrapper para tests que incluye los providers necesarios
class TestWrapper extends StatelessWidget {
  final Widget child;
  final NavigatorObserver? navigatorObserver;
  final String? initialRoute;

  const TestWrapper({
    Key? key,
    required this.child,
    this.navigatorObserver,
    this.initialRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C57B3),
          primary: const Color(0xFF7C57B3),
          secondary: const Color(0xFF102877),
        ),
        useMaterial3: true,
      ),
      initialRoute: initialRoute ?? '/',
      navigatorObservers: [
        if (navigatorObserver != null) navigatorObserver!,
      ],
      home: MultiProvider(
        providers: [
          Provider<AppServices>(
            create: (context) => AppServices(),
          ),
        ],
        child: Scaffold(
          body: child,
        ),
      ),
    );
  }
}

/// Helper para crear un widget testeable con todos los providers
Widget createTestableWidget(
  Widget widget, {
  NavigatorObserver? navigatorObserver,
  String? initialRoute,
}) {
  return TestWrapper(
    child: widget,
    navigatorObserver: navigatorObserver,
    initialRoute: initialRoute,
  );
}

/// Helper para pump widget y esperar animaciones
Future<void> pumpWidgetAndSettle(
  WidgetTester tester,
  Widget widget, {
  Duration? duration,
}) async {
  await tester.pumpWidget(widget);
  if (duration != null) {
    await tester.pumpAndSettle(duration);
  } else {
    await tester.pumpAndSettle();
  }
}

/// Helper para simular tap y esperar
Future<void> tapAndSettle(
  WidgetTester tester,
  Finder finder, {
  Duration? duration,
}) async {
  await tester.tap(finder);
  if (duration != null) {
    await tester.pumpAndSettle(duration);
  } else {
    await tester.pumpAndSettle();
  }
}

/// Helper para verificar navegación
void verifyNavigation(
  MockNavigatorObserver observer,
  String routeName,
) {
  verify(() => observer.didPush(any(), any()));
  // Aquí podrías agregar más verificaciones específicas
}

/// Helper para simular diferentes tamaños de pantalla
Future<void> setScreenSize(
  WidgetTester tester, {
  double width = 400,
  double height = 800,
}) async {
  await tester.binding.setSurfaceSize(Size(width, height));
  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });
}

/// Tamaños de pantalla predefinidos
class ScreenSizes {
  static const Size mobile = Size(375, 812); // iPhone X
  static const Size tablet = Size(768, 1024); // iPad
  static const Size desktop = Size(1440, 900); // MacBook
}

/// Helper para encontrar texto ignorando mayúsculas/minúsculas
Finder findTextIgnoreCase(String text) {
  return find.byWidgetPredicate(
    (widget) {
      if (widget is Text) {
        final widgetText = widget.data ?? widget.textSpan?.toPlainText() ?? '';
        return widgetText.toLowerCase().contains(text.toLowerCase());
      }
      return false;
    },
  );
}

/// Helper para verificar que un widget tiene cierto color
bool hasColor(Widget widget, Color expectedColor) {
  if (widget is Container) {
    return widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).color == expectedColor;
  }
  if (widget is Icon) {
    return widget.color == expectedColor;
  }
  return false;
}

/// Extension para facilitar el acceso a propiedades de widgets en tests
extension WidgetTesterExtensions on WidgetTester {
  T widget<T extends Widget>(Finder finder) {
    return finder.evaluate().single.widget as T;
  }

  bool hasWidget<T extends Widget>(Finder finder) {
    try {
      widget<T>(finder);
      return true;
    } catch (_) {
      return false;
    }
  }
}
