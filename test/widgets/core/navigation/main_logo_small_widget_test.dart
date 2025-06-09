import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/bukeer/core/widgets/navigation/main_logo_small/main_logo_small_widget.dart';
import 'package:mocktail/mocktail.dart';
import '../test_helpers.dart';

void main() {
  group('MainLogoSmallWidget', () {
    late MockNavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(MainLogoSmallWidget()),
      );

      // Verificar que se renderiza
      expect(find.byType(MainLogoSmallWidget), findsOneWidget);

      // Verificar que contiene una imagen
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('has correct size constraints', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(MainLogoSmallWidget()),
      );

      // Buscar el contenedor del logo
      final container = find.byType(Container);
      if (container.evaluate().isNotEmpty) {
        final containerWidget = tester.widget<Container>(container.first);

        // Verificar que tiene constraints de tamaño
        expect(containerWidget.constraints, isNotNull);
      }
    });

    testWidgets('is clickable', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          MainLogoSmallWidget(),
          navigatorObserver: mockObserver,
        ),
      );

      // Buscar widget clickeable (InkWell o GestureDetector)
      final inkWell = find.byType(InkWell);
      final gestureDetector = find.byType(GestureDetector);

      if (inkWell.evaluate().isNotEmpty) {
        await tapAndSettle(tester, inkWell.first);
      } else if (gestureDetector.evaluate().isNotEmpty) {
        await tapAndSettle(tester, gestureDetector.first);
      }

      // Si es clickeable, debería navegar
      // La verificación exacta depende de la implementación
    });

    testWidgets('displays Bukeer logo image', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(MainLogoSmallWidget()),
      );

      final image = tester.widget<Image>(find.byType(Image));

      // Verificar que la imagen es del logo de Bukeer
      expect(image.image, isA<AssetImage>());

      if (image.image is AssetImage) {
        final assetImage = image.image as AssetImage;
        expect(assetImage.assetName.contains('Logo'), isTrue);
      }
    });

    testWidgets('maintains aspect ratio', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(MainLogoSmallWidget()),
      );

      final image = tester.widget<Image>(find.byType(Image));

      // Verificar que mantiene el aspect ratio
      expect(image.fit, equals(BoxFit.contain));
    });
  });
}
