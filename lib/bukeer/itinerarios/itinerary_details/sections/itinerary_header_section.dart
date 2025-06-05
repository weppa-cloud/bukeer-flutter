import 'package:flutter/material.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../../flutter_flow/flutter_flow_icon_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Header section for itinerary details
/// Contains title, status, basic info and action buttons
class ItineraryHeaderSection extends StatelessWidget {
  final dynamic itineraryData;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onPreviewPressed;
  final VoidCallback? onPdfPressed;

  const ItineraryHeaderSection({
    Key? key,
    required this.itineraryData,
    this.onEditPressed,
    this.onDeletePressed,
    this.onPreviewPressed,
    this.onPdfPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itineraryName = getJsonField(itineraryData, r'$[:].itinerary_name')?.toString() ?? 'Sin nombre';
    final clientName = getJsonField(itineraryData, r'$[:].client_name')?.toString() ?? 'Sin cliente';
    final startDate = getJsonField(itineraryData, r'$[:].start_date')?.toString() ?? '';
    final endDate = getJsonField(itineraryData, r'$[:].end_date')?.toString() ?? '';
    final status = getJsonField(itineraryData, r'$[:].status')?.toString() ?? 'draft';
    
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
            // Title and Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itineraryName,
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Cliente: $clientName',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(context, status),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Dates Row
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  '${_formatDate(startDate)} - ${_formatDate(endDate)}',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Action Buttons
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FFButtonWidget(
                  onPressed: onEditPressed,
                  text: 'Editar',
                  icon: Icon(
                    Icons.edit,
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
                FFButtonWidget(
                  onPressed: onPreviewPressed,
                  text: 'Preview',
                  icon: Icon(
                    Icons.visibility,
                    size: 18,
                  ),
                  options: FFButtonOptions(
                    height: 36,
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 14,
                    ),
                    elevation: 1,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                FFButtonWidget(
                  onPressed: onPdfPressed,
                  text: 'PDF',
                  icon: Icon(
                    Icons.picture_as_pdf,
                    size: 18,
                  ),
                  options: FFButtonOptions(
                    height: 36,
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                    color: FlutterFlowTheme.of(context).error,
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
                FlutterFlowIconButton(
                  borderColor: FlutterFlowTheme.of(context).error,
                  borderRadius: 8,
                  borderWidth: 1,
                  buttonSize: 36,
                  fillColor: Colors.transparent,
                  icon: FaIcon(
                    FontAwesomeIcons.trash,
                    color: FlutterFlowTheme.of(context).error,
                    size: 16,
                  ),
                  onPressed: onDeletePressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'confirmed':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        displayText = 'Confirmado';
        break;
      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        displayText = 'Pendiente';
        break;
      case 'cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        displayText = 'Cancelado';
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        displayText = 'Borrador';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        displayText,
        style: FlutterFlowTheme.of(context).bodySmall.override(
          fontFamily: 'Readex Pro',
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
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