import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_drop_down.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_count_controller.dart';
import 'package:bukeer/legacy/flutter_flow/form_field_controller.dart';
import 'package:bukeer/custom_code/widgets/index.dart' as custom_widgets;
import '../../../../forms/dropdowns/contacts/dropdown_contacts_widget.dart';
import '../../../../forms/dropdowns/travel_planner/dropdown_travel_planner_widget.dart';
import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import 'package:bukeer/services/ui_state_service.dart';
import 'package:bukeer/services/itinerary_service.dart';
import 'package:bukeer/services/app_services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BasicInfoSection extends StatelessWidget {
  final bool isEdit;
  final dynamic allDataItinerary;
  final TextEditingController nameController;
  final FocusNode nameFocusNode;
  final FormFieldValidator<String>? nameValidator;
  final String? languageValue;
  final ValueChanged<String?> onLanguageChanged;
  final int? countControllerValue;
  final ValueChanged<int> onCountChanged;
  final Future<dynamic> Function(String?) onTravelPlannerChanged;
  final String? currentTravelPlannerId;
  final Future<void> Function(String?, String?) onDateRangeSelected;
  final Future<void> Function(String?) onValidUntilSelected;
  final String? initialStartDate;
  final String? initialEndDate;
  final String? validUntilDate;

  const BasicInfoSection({
    super.key,
    required this.isEdit,
    this.allDataItinerary,
    required this.nameController,
    required this.nameFocusNode,
    this.nameValidator,
    required this.languageValue,
    required this.onLanguageChanged,
    required this.countControllerValue,
    required this.onCountChanged,
    required this.onTravelPlannerChanged,
    this.currentTravelPlannerId,
    required this.onDateRangeSelected,
    required this.onValidUntilSelected,
    this.initialStartDate,
    this.initialEndDate,
    this.validUntilDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name field
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          child: Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            child: TextFormField(
              controller: nameController,
              focusNode: nameFocusNode,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Nombre de itinerario',
                labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).labelMediumFamily,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).labelMediumIsCustom,
                    ),
                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).labelMediumFamily,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).labelMediumIsCustom,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: BukeerColors.primary,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: BukeerColors.error,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: BukeerColors.error,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                contentPadding: const EdgeInsetsDirectional.fromSTEB(
                    20.0, 24.0, 20.0, 24.0),
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
              cursorColor: BukeerColors.primary,
              validator: nameValidator,
            ),
          ),
        ),
        // Fields container
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
          child: Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.end,
            direction: Axis.horizontal,
            runAlignment: WrapAlignment.end,
            verticalDirection: VerticalDirection.down,
            clipBehavior: Clip.none,
            children: [
              // Contact selector
              _ContactSelector(
                  isEdit: isEdit, allDataItinerary: allDataItinerary),
              // Travel planner dropdown
              Container(
                width: 297.0,
                constraints: const BoxConstraints(
                  minHeight: 70.0,
                  maxWidth: 770.0,
                ),
                child: DropdownTravelPlannerWidget(
                  currentAgentId: currentTravelPlannerId,
                  onAgentChanged: onTravelPlannerChanged,
                ),
              ),
              // Date range picker
              Container(
                width: 297.0,
                height: 70.0,
                child: custom_widgets.CustomDatePickerWidget(
                  width: 297.0,
                  height: 70.0,
                  initialStartDate: initialStartDate ?? 'd/m/y',
                  initialEndDate: initialEndDate ?? 'd/m/y',
                  labelText: 'Fechas',
                  isRangePicker: true,
                  onRangeSelected: onDateRangeSelected,
                  onDateSelected: (date) async {},
                ),
              ),
              // Valid until date picker
              Container(
                width: 297.0,
                height: 70.0,
                child: custom_widgets.CustomDatePickerWidget(
                  width: 297.0,
                  height: 70.0,
                  initialStartDate: validUntilDate ?? '',
                  labelText: 'Valido hasta',
                  isRangePicker: false,
                  onRangeSelected: (startDateStr, endDateStr) async {},
                  onDateSelected: onValidUntilSelected,
                ),
              ),
              // Language dropdown
              FlutterFlowDropDown<String>(
                controller: FormFieldController<String>(languageValue),
                options: ['Español', 'Inglés', 'Francés', 'Portugués'],
                onChanged: onLanguageChanged,
                width: 297.0,
                height: 50.0,
                searchHintTextStyle:
                    FlutterFlowTheme.of(context).labelMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).labelMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                        ),
                searchTextStyle: const TextStyle(),
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
                hintText: 'Idioma',
                searchHintText: 'Search for an item...',
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                elevation: 2.0,
                borderColor: FlutterFlowTheme.of(context).alternate,
                borderWidth: 2.0,
                borderRadius: 12.0,
                margin:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 4.0, 16.0, 4.0),
                hidesUnderline: true,
                isSearchable: true,
                isMultiSelect: false,
              ),
              // Passenger count
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          12.0, 4.0, 12.0, 0.0),
                      child: Text(
                        'Pasajeros',
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelMediumFamily,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelMediumIsCustom,
                                ),
                      ),
                    ),
                    Container(
                      width: 144.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                      ),
                      child: FlutterFlowCountController(
                        decrementIconBuilder: (enabled) => FaIcon(
                          FontAwesomeIcons.minus,
                          color: enabled
                              ? FlutterFlowTheme.of(context).secondaryText
                              : FlutterFlowTheme.of(context).alternate,
                          size: 20.0,
                        ),
                        incrementIconBuilder: (enabled) => FaIcon(
                          FontAwesomeIcons.plus,
                          color: enabled
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).alternate,
                          size: 20.0,
                        ),
                        countBuilder: (count) => Text(
                          count.toString(),
                          style: FlutterFlowTheme.of(context)
                              .titleLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleLargeFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .titleLargeIsCustom,
                              ),
                        ),
                        count: countControllerValue ?? 1,
                        updateCount: onCountChanged,
                        stepSize: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 20.0,
          thickness: 1.0,
          color: FlutterFlowTheme.of(context).alternate,
        ),
      ],
    );
  }
}

class _ContactSelector extends StatelessWidget {
  final bool isEdit;
  final dynamic allDataItinerary;

  const _ContactSelector({
    required this.isEdit,
    this.allDataItinerary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          enableDrag: false,
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.viewInsetsOf(context),
              child: const DropdownContactsWidget(),
            );
          },
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: 297.0,
        constraints: const BoxConstraints(
          minHeight: 70.0,
          maxWidth: 770.0,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 3.0,
              color: BukeerColors.overlay,
              offset: const Offset(0.0, 1.0),
            )
          ],
          borderRadius: BorderRadius.circular(BukeerSpacing.s),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(BukeerSpacing.s),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).accent1,
                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(BukeerSpacing.xs),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxN3x8dXNlciUyMHByb2ZpbGV8ZW58MHx8fHwxNzMwNDE3MDE3fDA&ixlib=rb-4.0.3&q=80&w=1080',
                      width: 60.0,
                      height: 60.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          12.0, 0.0, 0.0, 0.0),
                      child: Text(
                        _getContactName(context),
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyLargeFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyLargeIsCustom,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          12.0, 4.0, 0.0, 0.0),
                      child: Text(
                        'Cliente',
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelMediumFamily,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelMediumIsCustom,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: FlutterFlowTheme.of(context).primaryBackground,
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(BukeerSpacing.xs),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getContactName(BuildContext context) {
    final uiService = context.watch<UiStateService>();

    if (uiService.isCreatedInItinerary == true) {
      return valueOrDefault<String>(
        getJsonField(uiService.selectedContact, r'''$[:].name''')?.toString(),
        'Seleccionar',
      );
    } else if (uiService.selectedContact != null) {
      return getJsonField(uiService.selectedContact, r'''$.name''').toString();
    } else if (isEdit == true) {
      return getJsonField(
        appServices.itinerary.selectedItinerary ?? {},
        r'''$[:].contact_name''',
      ).toString();
    } else {
      return valueOrDefault<String>(
        getJsonField(uiService.selectedContact, r'''$.name''')?.toString(),
        'Seleccionar',
      );
    }
  }
}
