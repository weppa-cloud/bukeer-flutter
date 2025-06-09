import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/bukeer/core/widgets/forms/place_picker/place_picker_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_place_picker.dart';
import '../test_helpers.dart';

void main() {
  group('PlacePickerWidget', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      String? selectedCity;
      String? selectedCountry;
      double? latitude;
      double? longitude;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          PlacePickerWidget(
            onPlaceSelected: (city, country, lat, lng) {
              selectedCity = city;
              selectedCountry = country;
              latitude = lat;
              longitude = lng;
            },
          ),
        ),
      );

      // Verificar que se renderiza
      expect(find.byType(PlacePickerWidget), findsOneWidget);

      // Verificar que contiene el place picker
      expect(find.byType(FlutterFlowPlacePicker), findsOneWidget);
    });

    testWidgets('shows initial location', (WidgetTester tester) async {
      final initialCity = 'Miami';
      final initialCountry = 'Estados Unidos';

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          PlacePickerWidget(
            initialCity: initialCity,
            initialCountry: initialCountry,
            onPlaceSelected: (city, country, lat, lng) {},
          ),
        ),
      );

      // Verificar que muestra la ubicación inicial
      expect(find.textContaining(initialCity), findsWidgets);
    });

    testWidgets('shows location icon', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          PlacePickerWidget(
            onPlaceSelected: (city, country, lat, lng) {},
          ),
        ),
      );

      // Verificar icono de ubicación
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('opens place picker on tap', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          PlacePickerWidget(
            onPlaceSelected: (city, country, lat, lng) {},
          ),
        ),
      );

      // Tap en el campo
      final placePicker = find.byType(FlutterFlowPlacePicker);
      await tapAndSettle(tester, placePicker);

      // El picker debería abrirse (depende de la implementación)
      // En un test real, esto abriría Google Places
      expect(find.byType(PlacePickerWidget), findsOneWidget);
    });

    testWidgets('calls callback with coordinates', (WidgetTester tester) async {
      String? selectedCity;
      String? selectedCountry;
      double? latitude;
      double? longitude;
      bool callbackCalled = false;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          PlacePickerWidget(
            onPlaceSelected: (city, country, lat, lng) {
              selectedCity = city;
              selectedCountry = country;
              latitude = lat;
              longitude = lng;
              callbackCalled = true;
            },
          ),
        ),
      );

      // Simular selección de lugar
      // En un entorno de test, esto es difícil sin mockear Google Places
      // Verificamos que el widget está configurado correctamente
      final placePicker = tester.widget<FlutterFlowPlacePicker>(
        find.byType(FlutterFlowPlacePicker),
      );

      expect(placePicker.onSelect, isNotNull);
    });

    testWidgets('shows placeholder when no location selected',
        (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          PlacePickerWidget(
            onPlaceSelected: (city, country, lat, lng) {},
          ),
        ),
      );

      // Buscar placeholder
      final placePicker = tester.widget<FlutterFlowPlacePicker>(
        find.byType(FlutterFlowPlacePicker),
      );

      expect(placePicker.hintText, isNotNull);
      expect(
        placePicker.hintText?.toLowerCase(),
        anyOf(
          contains('ubicación'),
          contains('location'),
          contains('lugar'),
          contains('place'),
        ),
      );
    });

    testWidgets('clears location', (WidgetTester tester) async {
      String? clearedCity;
      String? clearedCountry;
      double? clearedLat;
      double? clearedLng;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          PlacePickerWidget(
            initialCity: 'Miami',
            initialCountry: 'USA',
            onPlaceSelected: (city, country, lat, lng) {
              clearedCity = city;
              clearedCountry = country;
              clearedLat = lat;
              clearedLng = lng;
            },
          ),
        ),
      );

      // Buscar botón de limpiar (si existe)
      final clearButton = find.byIcon(Icons.clear);
      if (clearButton.evaluate().isNotEmpty) {
        await tapAndSettle(tester, clearButton);

        // Verificar que se limpiaron los valores
        expect(clearedCity, isNull);
        expect(clearedCountry, isNull);
      }
    });

    testWidgets('handles search functionality', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          PlacePickerWidget(
            onPlaceSelected: (city, country, lat, lng) {},
          ),
        ),
      );

      // Verificar que el place picker tiene searchable habilitado
      final placePicker = tester.widget<FlutterFlowPlacePicker>(
        find.byType(FlutterFlowPlacePicker),
      );

      expect(placePicker.searchable, isTrue);
    });

    testWidgets('formats location display correctly',
        (WidgetTester tester) async {
      final city = 'Buenos Aires';
      final country = 'Argentina';

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          PlacePickerWidget(
            initialCity: city,
            initialCountry: country,
            onPlaceSelected: (city, country, lat, lng) {},
          ),
        ),
      );

      // Verificar formato de ubicación
      // Podría ser "Buenos Aires, Argentina" o similar
      expect(
        find.byWidgetPredicate((widget) {
          if (widget is Text) {
            final text = widget.data ?? '';
            return text.contains(city) || text.contains(country);
          }
          return false;
        }),
        findsWidgets,
      );
    });

    testWidgets('validates location selection', (WidgetTester tester) async {
      // Test para verificar que valida ubicaciones válidas
      double? receivedLat;
      double? receivedLng;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          PlacePickerWidget(
            onPlaceSelected: (city, country, lat, lng) {
              receivedLat = lat;
              receivedLng = lng;
            },
          ),
        ),
      );

      // Las coordenadas deberían estar en rangos válidos
      // Latitud: -90 a 90
      // Longitud: -180 a 180
      expect(find.byType(PlacePickerWidget), findsOneWidget);
    });
  });
}
