import 'package:flutter/material.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../../flutter_flow/flutter_flow_icon_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Payments section for itinerary details
/// Displays financial summary and payment tracking
class ItineraryPaymentsSection extends StatelessWidget {
  final String itineraryId;
  final dynamic itineraryData;
  final List<dynamic> transactions;
  final VoidCallback? onAddPayment;
  final Function(dynamic transaction)? onEditTransaction;

  const ItineraryPaymentsSection({
    Key? key,
    required this.itineraryId,
    required this.itineraryData,
    required this.transactions,
    this.onAddPayment,
    this.onEditTransaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalCost = _getDoubleValue(itineraryData, r'$[:].total_cost') ?? 0.0;
    final totalPrice = _getDoubleValue(itineraryData, r'$[:].total_price') ?? 0.0;
    final totalProfit = totalPrice - totalCost;
    final totalPaid = _calculateTotalPaid();
    final totalPending = totalPrice - totalPaid;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x1A000000),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Resumen Financiero',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (onAddPayment != null)
                  FFButtonWidget(
                    onPressed: onAddPayment,
                    text: 'Registrar Pago',
                    icon: Icon(
                      Icons.add,
                      size: 18,
                    ),
                    options: FFButtonOptions(
                      height: 36,
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      elevation: 2,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Financial Summary Cards
            Row(
              children: [
                Expanded(child: _buildFinancialCard(
                  context,
                  'Costo Total',
                  totalCost,
                  Icons.trending_down,
                  Colors.orange,
                )),
                SizedBox(width: 12),
                Expanded(child: _buildFinancialCard(
                  context,
                  'Precio Total',
                  totalPrice,
                  Icons.trending_up,
                  Colors.blue,
                )),
                SizedBox(width: 12),
                Expanded(child: _buildFinancialCard(
                  context,
                  'Ganancia',
                  totalProfit,
                  Icons.stars,
                  totalProfit >= 0 ? Colors.green : Colors.red,
                )),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Payment Status Cards
            Row(
              children: [
                Expanded(child: _buildFinancialCard(
                  context,
                  'Pagado',
                  totalPaid,
                  Icons.check_circle,
                  Colors.green,
                )),
                SizedBox(width: 12),
                Expanded(child: _buildFinancialCard(
                  context,
                  'Pendiente',
                  totalPending,
                  Icons.schedule,
                  totalPending > 0 ? Colors.red : Colors.green,
                )),
                SizedBox(width: 12),
                Expanded(child: _buildProgressCard(context, totalPaid, totalPrice)),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Transactions List
            if (transactions.isNotEmpty) ...[
              Text(
                'Historial de Pagos',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Readex Pro',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              ...transactions.map((transaction) => _buildTransactionItem(context, transaction)).toList(),
            ] else
              _buildEmptyTransactions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard(
    BuildContext context,
    String title,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: FlutterFlowTheme.of(context).titleLarge.override(
              fontFamily: 'Outfit',
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, double paid, double total) {
    final percentage = total > 0 ? (paid / total).clamp(0.0, 1.0) : 0.0;
    final color = percentage >= 1.0 ? Colors.green : 
                  percentage >= 0.5 ? Colors.orange : Colors.red;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pie_chart,
                color: color,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Progreso',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${(percentage * 100).toStringAsFixed(0)}%',
            style: FlutterFlowTheme.of(context).titleLarge.override(
              fontFamily: 'Outfit',
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, dynamic transaction) {
    final amount = _getDoubleValue(transaction, r'$.amount') ?? 0.0;
    final date = getJsonField(transaction, r'$.date')?.toString() ?? '';
    final description = getJsonField(transaction, r'$.description')?.toString() ?? 'Pago';
    final type = getJsonField(transaction, r'$.type')?.toString() ?? 'income';

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: type == 'income' ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
              color: type == 'income' ? Colors.green : Colors.red,
              size: 18,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (date.isNotEmpty)
                  Text(
                    _formatDate(date),
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '${type == 'income' ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
            style: FlutterFlowTheme.of(context).titleMedium.override(
              fontFamily: 'Readex Pro',
              color: type == 'income' ? Colors.green : Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (onEditTransaction != null) ...[
            SizedBox(width: 8),
            FlutterFlowIconButton(
              borderRadius: 6,
              borderWidth: 1,
              buttonSize: 32,
              fillColor: Colors.transparent,
              icon: Icon(
                Icons.edit,
                color: FlutterFlowTheme.of(context).primary,
                size: 14,
              ),
              onPressed: () => onEditTransaction!(transaction),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyTransactions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            'No hay pagos registrados',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
              fontFamily: 'Readex Pro',
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Registra el primer pago para este itinerario',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Readex Pro',
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  double? _getDoubleValue(dynamic data, String path) {
    try {
      final value = getJsonField(data, path);
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    } catch (e) {
      return null;
    }
  }

  double _calculateTotalPaid() {
    double total = 0.0;
    for (final transaction in transactions) {
      final type = getJsonField(transaction, r'$.type')?.toString() ?? 'income';
      final amount = _getDoubleValue(transaction, r'$.amount') ?? 0.0;
      if (type == 'income') {
        total += amount;
      }
    }
    return total;
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Sin fecha';
    
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}