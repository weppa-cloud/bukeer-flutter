import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bukeer/bukeer/core/widgets/forms/currency_selector/currency_selector_widget.dart';
import 'package:bukeer/design_system/index.dart';

WidgetbookComponent getCurrencySelectorUseCases() {
  return WidgetbookComponent(
    name: 'CurrencySelector',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (context) => _CurrencySelectorWrapper(
          idItinerary: context.knobs.stringOrNull(
            label: 'Itinerary ID',
            initialValue: null,
          ),
          idItemProduct: context.knobs.stringOrNull(
            label: 'Product Item ID',
            initialValue: null,
          ),
          typeTransaction: context.knobs.list(
            label: 'Transaction Type',
            options: ['income', 'expense', 'transfer'],
            labelBuilder: (type) => _getTransactionTypeLabel(type as String),
            initialOption: 'income',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Itinerary',
        builder: (context) => _CurrencySelectorWrapper(
          idItinerary: 'ITN-2024-001',
          idItemProduct: null,
          typeTransaction: 'income',
        ),
      ),
      WidgetbookUseCase(
        name: 'With Product',
        builder: (context) => _CurrencySelectorWrapper(
          idItinerary: null,
          idItemProduct: 'PROD-HTL-001',
          typeTransaction: 'expense',
        ),
      ),
      WidgetbookUseCase(
        name: 'Transfer Transaction',
        builder: (context) => _CurrencySelectorWrapper(
          idItinerary: 'ITN-2024-002',
          idItemProduct: 'PROD-FLT-002',
          typeTransaction: 'transfer',
        ),
      ),
    ],
  );
}

String _getTransactionTypeLabel(String type) {
  switch (type) {
    case 'income':
      return 'Ingreso';
    case 'expense':
      return 'Gasto';
    case 'transfer':
      return 'Transferencia';
    default:
      return type;
  }
}

class _CurrencySelectorWrapper extends StatefulWidget {
  final String? idItinerary;
  final String? idItemProduct;
  final String? typeTransaction;

  const _CurrencySelectorWrapper({
    this.idItinerary,
    this.idItemProduct,
    this.typeTransaction,
  });

  @override
  State<_CurrencySelectorWrapper> createState() =>
      _CurrencySelectorWrapperState();
}

class _CurrencySelectorWrapperState extends State<_CurrencySelectorWrapper> {
  List<String> _transactionHistory = [];

  void _onSave() {
    setState(() {
      final transaction = 'Transacción guardada - '
          'Tipo: ${widget.typeTransaction ?? 'N/A'} '
          '(${DateTime.now().toString().substring(11, 19)})';
      _transactionHistory.insert(0, transaction);
      if (_transactionHistory.length > 5) {
        _transactionHistory.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Background content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Component Info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Parámetros del componente:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      if (widget.idItinerary != null)
                        Text('• ID Itinerario: ${widget.idItinerary}'),
                      if (widget.idItemProduct != null)
                        Text('• ID Producto: ${widget.idItemProduct}'),
                      if (widget.typeTransaction != null)
                        Text(
                            '• Tipo: ${_getTransactionTypeLabel(widget.typeTransaction!)}'),
                      if (widget.idItinerary == null &&
                          widget.idItemProduct == null &&
                          widget.typeTransaction == null)
                        Text(
                          'Sin parámetros',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Transaction History
                if (_transactionHistory.isNotEmpty) ...[
                  Text(
                    'Historial de transacciones:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...(_transactionHistory.map((transaction) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• $transaction',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ))),
                ],

                const Spacer(),

                // Info Note
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: Colors.orange[700],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Nota: Este componente muestra opciones de pago (Efectivo, Consignación, PSE) '
                          'en lugar de monedas. El nombre puede causar confusión.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.orange[700],
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Currency Selector Component
          CurrencySelectorWidget(
            idItinerary: widget.idItinerary,
            idItemProduct: widget.idItemProduct,
            typeTransaction: widget.typeTransaction,
          ),
        ],
      ),
    );
  }
}
