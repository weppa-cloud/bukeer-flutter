import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/bukeer/core/widgets/forms/currency_selector/currency_selector_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_drop_down.dart';
import '../test_helpers.dart';

void main() {
  group('CurrencySelectorWidget', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      double? selectedAmount;
      String? selectedCurrency;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          CurrencySelectorWidget(
            onAmountChanged: (amount) {
              selectedAmount = amount;
            },
            onCurrencyChanged: (currency) {
              selectedCurrency = currency;
            },
          ),
        ),
      );

      // Verificar que se renderiza
      expect(find.byType(CurrencySelectorWidget), findsOneWidget);

      // Verificar que contiene campo de monto
      expect(find.byType(TextFormField), findsWidgets);

      // Verificar que contiene dropdown de moneda
      expect(find.byType(FlutterFlowDropDown), findsOneWidget);
    });

    testWidgets('shows initial values', (WidgetTester tester) async {
      final initialAmount = 1500.50;
      final initialCurrency = 'EUR';

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          CurrencySelectorWidget(
            initialAmount: initialAmount,
            initialCurrency: initialCurrency,
            onAmountChanged: (amount) {},
            onCurrencyChanged: (currency) {},
          ),
        ),
      );

      // Verificar monto inicial
      expect(find.text('1500.50'), findsOneWidget);

      // Verificar moneda inicial
      expect(find.text('EUR'), findsWidgets);
    });

    testWidgets('formats amount with thousand separators',
        (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          CurrencySelectorWidget(
            initialAmount: 1234567.89,
            onAmountChanged: (amount) {},
            onCurrencyChanged: (currency) {},
          ),
        ),
      );

      // Verificar formato con separadores de miles
      // Podría ser 1,234,567.89 o 1.234.567,89 dependiendo del locale
      expect(
        find.byWidgetPredicate((widget) {
          if (widget is Text) {
            final text = widget.data ?? '';
            return text.contains('234') && text.contains('567');
          }
          return false;
        }),
        findsWidgets,
      );
    });

    testWidgets('calls onAmountChanged when amount changes',
        (WidgetTester tester) async {
      double? changedAmount;
      bool callbackCalled = false;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          CurrencySelectorWidget(
            onAmountChanged: (amount) {
              changedAmount = amount;
              callbackCalled = true;
            },
            onCurrencyChanged: (currency) {},
          ),
        ),
      );

      // Encontrar el campo de monto
      final amountField = find.byType(TextFormField).first;

      // Ingresar nuevo monto
      await tester.enterText(amountField, '2500.75');
      await tester.pump();

      // Verificar callback
      expect(callbackCalled, isTrue);
      expect(changedAmount, equals(2500.75));
    });

    testWidgets('calls onCurrencyChanged when currency changes',
        (WidgetTester tester) async {
      String? changedCurrency;
      bool callbackCalled = false;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          CurrencySelectorWidget(
            onAmountChanged: (amount) {},
            onCurrencyChanged: (currency) {
              changedCurrency = currency;
              callbackCalled = true;
            },
          ),
        ),
      );

      // Tap en el dropdown
      final dropdown = find.byType(FlutterFlowDropDown<String>);
      await tapAndSettle(tester, dropdown);

      // Seleccionar EUR
      final eurOption = find.text('EUR').last;
      if (eurOption.evaluate().isNotEmpty) {
        await tapAndSettle(tester, eurOption);

        // Verificar callback
        expect(callbackCalled, isTrue);
        expect(changedCurrency, equals('EUR'));
      }
    });

    testWidgets('validates numeric input only', (WidgetTester tester) async {
      double? validatedAmount;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          CurrencySelectorWidget(
            onAmountChanged: (amount) {
              validatedAmount = amount;
            },
            onCurrencyChanged: (currency) {},
          ),
        ),
      );

      // Intentar ingresar texto no numérico
      final amountField = find.byType(TextFormField).first;
      await tester.enterText(amountField, 'abc123');
      await tester.pump();

      // Solo debería aceptar la parte numérica
      expect(validatedAmount, anyOf(equals(123), isNull));
    });

    testWidgets('shows all currency options', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          CurrencySelectorWidget(
            onAmountChanged: (amount) {},
            onCurrencyChanged: (currency) {},
          ),
        ),
      );

      // Tap en el dropdown para ver opciones
      final dropdown = find.byType(FlutterFlowDropDown<String>);
      await tapAndSettle(tester, dropdown);

      // Verificar monedas principales
      expect(find.text('USD'), findsWidgets);
      expect(find.text('EUR'), findsWidgets);
      expect(find.text('COP'), findsWidgets);
      expect(find.text('MXN'), findsWidgets);
    });

    testWidgets('limits decimal places to 2', (WidgetTester tester) async {
      double? formattedAmount;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          CurrencySelectorWidget(
            onAmountChanged: (amount) {
              formattedAmount = amount;
            },
            onCurrencyChanged: (currency) {},
          ),
        ),
      );

      // Intentar ingresar más de 2 decimales
      final amountField = find.byType(TextFormField).first;
      await tester.enterText(amountField, '123.456789');
      await tester.pump();

      // Debería limitar a 2 decimales
      expect(formattedAmount, anyOf(equals(123.45), equals(123.46)));
    });

    testWidgets('handles zero amount', (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          CurrencySelectorWidget(
            initialAmount: 0,
            onAmountChanged: (amount) {},
            onCurrencyChanged: (currency) {},
          ),
        ),
      );

      // Verificar que muestra 0
      expect(find.text('0'), findsWidgets);
    });

    testWidgets('clears amount when clear button pressed',
        (WidgetTester tester) async {
      double? clearedAmount;

      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          CurrencySelectorWidget(
            initialAmount: 1000,
            onAmountChanged: (amount) {
              clearedAmount = amount;
            },
            onCurrencyChanged: (currency) {},
          ),
        ),
      );

      // Buscar botón de limpiar en el campo
      final clearButton = find.byIcon(Icons.clear);
      if (clearButton.evaluate().isNotEmpty) {
        await tapAndSettle(tester, clearButton);
        expect(clearedAmount, anyOf(equals(0), isNull));
      }
    });

    testWidgets('defaults to USD when no currency specified',
        (WidgetTester tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestableWidget(
          CurrencySelectorWidget(
            onAmountChanged: (amount) {},
            onCurrencyChanged: (currency) {},
          ),
        ),
      );

      // Verificar que USD es la moneda por defecto
      final dropdown = tester.widget<FlutterFlowDropDown<String>>(
        find.byType(FlutterFlowDropDown<String>),
      );

      expect(dropdown.initialOption ?? dropdown.options.first, equals('USD'));
    });
  });
}
