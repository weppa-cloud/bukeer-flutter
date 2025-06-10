import 'package:flutter/material.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/components/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Header section for itinerary details
/// Contains title, status, basic info and action buttons
class ItineraryHeaderSection extends StatefulWidget {
  final dynamic itineraryData;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onPreviewPressed;
  final VoidCallback? onPdfPressed;
  final Function(bool)? onStatusChanged;

  const ItineraryHeaderSection({
    Key? key,
    required this.itineraryData,
    this.onEditPressed,
    this.onDeletePressed,
    this.onPreviewPressed,
    this.onPdfPressed,
    this.onStatusChanged,
  }) : super(key: key);

  @override
  State<ItineraryHeaderSection> createState() => _ItineraryHeaderSectionState();
}

class _ItineraryHeaderSectionState extends State<ItineraryHeaderSection> {
  late bool isConfirmed;

  @override
  void initState() {
    super.initState();
    final status =
        getJsonField(widget.itineraryData, r'$[:].status')?.toString() ??
            'draft';
    isConfirmed = status.toLowerCase() == 'confirmed';
  }

  @override
  Widget build(BuildContext context) {
    final itineraryName =
        getJsonField(widget.itineraryData, r'$[:].itinerary_name')
                ?.toString() ??
            'Sin nombre';
    final clientName =
        getJsonField(widget.itineraryData, r'$[:].client_name')?.toString() ??
            'Sin cliente';
    final startDate =
        getJsonField(widget.itineraryData, r'$[:].start_date')?.toString() ??
            '';
    final endDate =
        getJsonField(widget.itineraryData, r'$[:].end_date')?.toString() ?? '';
    final status =
        getJsonField(widget.itineraryData, r'$[:].status')?.toString() ??
            'draft';

    // Travel planner info
    final travelPlannerName =
        getJsonField(widget.itineraryData, r'$[:].travel_planner_name')
                ?.toString() ??
            'Sin asignar';
    final travelPlannerAvatar =
        getJsonField(widget.itineraryData, r'$[:].travel_planner_avatar')
                ?.toString() ??
            '';

    // Totals
    final totalNet =
        getJsonField(widget.itineraryData, r'$[:].total_net')?.toString() ??
            '0';
    final totalMargin =
        getJsonField(widget.itineraryData, r'$[:].total_margin')?.toString() ??
            '0';
    final totalPrice =
        getJsonField(widget.itineraryData, r'$[:].total_price')?.toString() ??
            '0';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x1A000000),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button and title row
            Row(
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    context.safePop();
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    itineraryName,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 24,
                          letterSpacing: 0,
                        ),
                  ),
                ),
                // Confirm button with switch
                Container(
                  decoration: BoxDecoration(
                    color: isConfirmed
                        ? FlutterFlowTheme.of(context).success
                        : FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isConfirmed
                          ? FlutterFlowTheme.of(context).success
                          : FlutterFlowTheme.of(context).alternate,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isConfirmed ? 'Confirmado' : 'Presupuesto',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Readex Pro',
                                color: isConfirmed
                                    ? Colors.white
                                    : FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0,
                              ),
                        ),
                        SizedBox(width: 8),
                        Switch.adaptive(
                          value: isConfirmed,
                          onChanged: (newValue) {
                            setState(() {
                              isConfirmed = newValue;
                            });
                            widget.onStatusChanged?.call(newValue);
                          },
                          activeColor: Colors.white,
                          activeTrackColor: Color(0xFF4CAF50),
                          inactiveTrackColor:
                              FlutterFlowTheme.of(context).alternate,
                          inactiveThumbColor:
                              FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Client and status row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cliente: $clientName',
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 16,
                        letterSpacing: 0,
                      ),
                ),
                _buildStatusChip(context, status),
              ],
            ),

            SizedBox(height: 16),

            // Action buttons row
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      BukeerIconButton(
                        icon: Icon(
                          Icons.edit,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 20,
                        ),
                        onPressed: widget.onEditPressed,
                        size: BukeerIconButtonSize.small,
                        variant: BukeerIconButtonVariant.outlined,
                      ),
                      SizedBox(width: 8),
                      BukeerIconButton(
                        icon: Icon(
                          Icons.content_copy,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 20,
                        ),
                        onPressed: () {
                          // TODO: Implement duplicate functionality
                        },
                        size: BukeerIconButtonSize.small,
                        variant: BukeerIconButtonVariant.outlined,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Divider(
              height: 32,
              thickness: 1,
              color: FlutterFlowTheme.of(context).alternate,
            ),

            // Travel planner info
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: travelPlannerAvatar.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            travelPlannerAvatar,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 24,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 24,
                        ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Travel Planner',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12,
                              letterSpacing: 0,
                            ),
                      ),
                      Text(
                        travelPlannerName,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Dates row
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  '${_formatDate(startDate)} - ${_formatDate(endDate)}',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 14,
                        letterSpacing: 0,
                      ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Totals section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0x0D4B39EF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Neto',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 12,
                                    letterSpacing: 0,
                                  ),
                            ),
                            Text(
                              '\$$totalNet',
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0,
                                  ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Margen',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 12,
                                    letterSpacing: 0,
                                  ),
                            ),
                            Text(
                              '$totalMargin%',
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).success,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0,
                                  ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Total',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 12,
                                    letterSpacing: 0,
                                  ),
                            ),
                            Text(
                              '\$$totalPrice',
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
        borderRadius: BorderRadius.circular(BukeerSpacing.m),
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
