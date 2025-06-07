import 'package:flutter/material.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../../design_system/components/buttons/bukeer_icon_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Passengers section for itinerary details
/// Displays and manages passengers for the itinerary
class ItineraryPassengersSection extends StatelessWidget {
  final String itineraryId;
  final List<dynamic> passengers;
  final VoidCallback? onAddPassenger;
  final Function(dynamic passenger)? onEditPassenger;
  final Function(dynamic passenger)? onDeletePassenger;

  const ItineraryPassengersSection({
    Key? key,
    required this.itineraryId,
    required this.passengers,
    this.onAddPassenger,
    this.onEditPassenger,
    this.onDeletePassenger,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      Icons.people,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Pasajeros',
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${passengers.length}',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context).primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                if (onAddPassenger != null)
                  FFButtonWidget(
                    onPressed: onAddPassenger,
                    text: 'Agregar Pasajero',
                    icon: Icon(
                      Icons.person_add,
                      size: 18,
                    ),
                    options: FFButtonOptions(
                      height: 36,
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
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

            SizedBox(height: 20),

            // Passengers List
            if (passengers.isEmpty)
              _buildEmptyState(context)
            else
              ...passengers.asMap().entries.map((entry) {
                final index = entry.key;
                final passenger = entry.value;
                return _buildPassengerCard(context, passenger, index);
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32),
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
            Icons.people_outline,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            'No hay pasajeros agregados',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  fontFamily: 'Readex Pro',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 16,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'Agrega pasajeros para este itinerario',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 14,
                ),
          ),
          if (onAddPassenger != null) ...[
            SizedBox(height: 16),
            FFButtonWidget(
              onPressed: onAddPassenger,
              text: 'Agregar Primer Pasajero',
              icon: Icon(
                Icons.person_add,
                size: 18,
              ),
              options: FFButtonOptions(
                height: 40,
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
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
        ],
      ),
    );
  }

  Widget _buildPassengerCard(
      BuildContext context, dynamic passenger, int index) {
    final name = getJsonField(passenger, r'$.name')?.toString() ?? 'Sin nombre';
    final lastName = getJsonField(passenger, r'$.last_name')?.toString() ?? '';
    final documentType =
        getJsonField(passenger, r'$.document_type')?.toString() ?? '';
    final documentNumber =
        getJsonField(passenger, r'$.document_number')?.toString() ?? '';
    final birthDate =
        getJsonField(passenger, r'$.birth_date')?.toString() ?? '';
    final nationality =
        getJsonField(passenger, r'$.nationality')?.toString() ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Passenger Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${name.isNotEmpty ? name[0].toUpperCase() : 'P'}${lastName.isNotEmpty ? lastName[0].toUpperCase() : (index + 1).toString()}',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),

          SizedBox(width: 16),

          // Passenger Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name $lastName'.trim(),
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (documentType.isNotEmpty && documentNumber.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text(
                    '$documentType: $documentNumber',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 14,
                        ),
                  ),
                ],
                if (birthDate.isNotEmpty) ...[
                  SizedBox(height: 2),
                  Text(
                    'Nacimiento: ${_formatDate(birthDate)}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12,
                        ),
                  ),
                ],
                if (nationality.isNotEmpty) ...[
                  SizedBox(height: 2),
                  Text(
                    'Nacionalidad: $nationality',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12,
                        ),
                  ),
                ],
              ],
            ),
          ),

          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onEditPassenger != null)
                BukeerIconButton(
                  icon: Icon(
                    Icons.edit,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 16,
                  ),
                  onPressed: () => onEditPassenger!(passenger),
                  size: BukeerIconButtonSize.small,
                  variant: BukeerIconButtonVariant.ghost,
                ),
              if (onDeletePassenger != null) ...[
                SizedBox(width: 8),
                BukeerIconButton(
                  icon: Icon(
                    Icons.delete,
                    color: FlutterFlowTheme.of(context).error,
                    size: 16,
                  ),
                  onPressed: () => onDeletePassenger!(passenger),
                  size: BukeerIconButtonSize.small,
                  variant: BukeerIconButtonVariant.danger,
                ),
              ],
            ],
          ),
        ],
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
