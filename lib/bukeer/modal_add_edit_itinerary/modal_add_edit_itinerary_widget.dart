import '../../auth/supabase_auth/auth_util.dart';
import '../../backend/api_requests/api_calls.dart';
import '../itinerarios/dropdown_contactos/dropdown_contactos_widget.dart';
import '../itinerarios/dropdown_travel_planner/dropdown_travel_planner_widget.dart';
import '../../flutter_flow/flutter_flow_animations.dart';
import '../../flutter_flow/flutter_flow_count_controller.dart';
import '../../flutter_flow/flutter_flow_drop_down.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../design_system/index.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import '../../custom_code/actions/index.dart' as actions;
import '../../custom_code/widgets/index.dart' as custom_widgets;
import '../../index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'modal_add_edit_itinerary_model.dart';
import '../../services/ui_state_service.dart';
import '../../services/product_service.dart';
import '../../services/contact_service.dart';
import '../../services/itinerary_service.dart';
export 'modal_add_edit_itinerary_model.dart';

class ModalAddEditItineraryWidget extends StatefulWidget {
  const ModalAddEditItineraryWidget({
    super.key,
    bool? isEdit,
    this.allDataItinerary,
  }) : this.isEdit = isEdit ?? false;

  final bool isEdit;
  final dynamic allDataItinerary;

  @override
  State<ModalAddEditItineraryWidget> createState() =>
      _ModalAddEditItineraryWidgetState();
}

class _ModalAddEditItineraryWidgetState
    extends State<ModalAddEditItineraryWidget> with TickerProviderStateMixin {
  late ModalAddEditItineraryModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalAddEditItineraryModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.responseGetImagesStorage = await actions.getImagesStorage();
      _model.images = _model.responseGetImagesStorage!.toList().cast<dynamic>();
      safeSetState(() {});
    });

    _model.nameItineraryTextController ??= TextEditingController(
        text: widget!.isEdit == true
            ? getJsonField(
                context.read<ItineraryService>().allDataItinerary,
                r'''$[:].name''',
              ).toString().toString()
            : '');
    _model.nameItineraryFocusNode ??= FocusNode();

    _model.messageActivityTextController ??= TextEditingController(text: () {
      if (widget!.isEdit == false) {
        return '';
      } else if ('${getJsonField(
                context.read<ProductService>().allDataHotel,
                r'''$.personalized_message''',
              ).toString().toString()}' !=
              null &&
          '${getJsonField(
                context.read<ProductService>().allDataHotel,
                r'''$.personalized_message''',
              ).toString().toString()}' !=
              '') {
        return getJsonField(
          context.read<ItineraryService>().allDataItinerary,
          r'''$[:].personalized_message''',
        ).toString().toString();
      } else {
        return '';
      }
    }());
    _model.messageActivityFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Form(
      key: _model.formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 670.0,
            maxHeight: 700.0,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 12.0,
                color: BukeerColors.overlay,
                offset: Offset(
                  0.0,
                  5.0,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget!.isEdit == false)
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'Agregar itinerario',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .headlineMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .headlineMediumIsCustom,
                                  ),
                            ),
                          ),
                        if (widget!.isEdit == true)
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'Editar itinerario',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .headlineMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .headlineMediumIsCustom,
                                  ),
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
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            child: TextFormField(
                              controller: _model.nameItineraryTextController,
                              focusNode: _model.nameItineraryFocusNode,
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Nombre de itinerario',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelMediumIsCustom,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelMediumIsCustom,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 2.0,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(BukeerSpacing.s),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(BukeerSpacing.s),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(BukeerSpacing.s),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(BukeerSpacing.s),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 24.0, 20.0, 24.0),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                              cursorColor: FlutterFlowTheme.of(context).primary,
                              validator: _model
                                  .nameItineraryTextControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 12.0),
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
                              InkWell(
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
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: DropdownContactosWidget(),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.easeInOut,
                                  width: 297.0,
                                  constraints: BoxConstraints(
                                    minHeight: 70.0,
                                    maxWidth: 770.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 3.0,
                                        color: BukeerColors.overlay,
                                        offset: Offset(
                                          0.0,
                                          1.0,
                                        ),
                                      )
                                    ],
                                    borderRadius:
                                        BorderRadius.circular(BukeerSpacing.s),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(BukeerSpacing.s),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 44.0,
                                          height: 44.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .accent1,
                                            borderRadius: BorderRadius.circular(
                                                BukeerSpacing.s),
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                BukeerSpacing.xs),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        12.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    () {
                                                      if (context
                                                              .watch<
                                                                  UiStateService>()
                                                              .isCreatedInItinerary ==
                                                          true) {
                                                        return valueOrDefault<
                                                            String>(
                                                          getJsonField(
                                                            context
                                                                .watch<
                                                                    UiStateService>()
                                                                .selectedContact,
                                                            r'''$[:].name''',
                                                          )?.toString(),
                                                          'Seleccionar',
                                                        );
                                                      } else if (context
                                                              .watch<
                                                                  UiStateService>()
                                                              .selectedContact !=
                                                          null) {
                                                        return getJsonField(
                                                          context
                                                              .watch<
                                                                  UiStateService>()
                                                              .selectedContact,
                                                          r'''$.name''',
                                                        ).toString();
                                                      } else if (widget!
                                                              .isEdit ==
                                                          true) {
                                                        return getJsonField(
                                                          FFAppState()
                                                              .allDataItinerary,
                                                          r'''$[:].contact_name''',
                                                        ).toString();
                                                      } else {
                                                        return valueOrDefault<
                                                            String>(
                                                          getJsonField(
                                                            context
                                                                .watch<
                                                                    UiStateService>()
                                                                .selectedContact,
                                                            r'''$.name''',
                                                          )?.toString(),
                                                          'Seleccionar',
                                                        );
                                                      }
                                                    }(),
                                                    'Seleccionar',
                                                  ),
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        12.0, 4.0, 0.0, 0.0),
                                                child: Text(
                                                  'Cliente',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          elevation: 1.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                BukeerSpacing.xs),
                                            child: Icon(
                                              Icons.chevron_right_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ).animateOnPageLoad(animationsMap[
                                  'containerOnPageLoadAnimation2']!),
                              Container(
                                width: 297.0,
                                constraints: BoxConstraints(
                                  minHeight: 70.0,
                                  maxWidth: 770.0,
                                ),
                                child: wrapWithModel(
                                  model: _model.dropdownTravelPlannerModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: DropdownTravelPlannerWidget(
                                    currentAgentId: widget!.isEdit == true
                                        ? getJsonField(
                                            context
                                                .read<ItineraryService>()
                                                .allDataItinerary,
                                            r'''$[:].agent''',
                                          )?.toString()
                                        : currentUserUid,
                                    onAgentChanged: (newAgentId) async {
                                      _model.selectedTravelPlannerId =
                                          newAgentId;
                                      safeSetState(() {});
                                    },
                                  ),
                                ),
                              ).animateOnPageLoad(animationsMap[
                                  'containerOnPageLoadAnimation3']!),
                              Container(
                                width: 297.0,
                                height: 70.0,
                                child: custom_widgets.CustomDatePickerWidget(
                                  width: 297.0,
                                  height: 70.0,
                                  initialStartDate: valueOrDefault<String>(
                                    getJsonField(
                                      context
                                          .read<ItineraryService>()
                                          .allDataItinerary,
                                      r'''$[:].start_date''',
                                    )?.toString(),
                                    'd/m/y',
                                  ),
                                  initialEndDate: valueOrDefault<String>(
                                    getJsonField(
                                      context
                                          .read<ItineraryService>()
                                          .allDataItinerary,
                                      r'''$[:].end_date''',
                                    )?.toString(),
                                    'd/m/y',
                                  ),
                                  labelText: 'Fechas',
                                  isRangePicker: true,
                                  onRangeSelected:
                                      (startDateStr, endDateStr) async {
                                    _model.initialStartDate = startDateStr;
                                    safeSetState(() {});
                                    _model.initialEndDate = endDateStr;
                                    safeSetState(() {});
                                  },
                                  onDateSelected: (date) async {},
                                ),
                              ),
                              Container(
                                width: 297.0,
                                height: 70.0,
                                child: custom_widgets.CustomDatePickerWidget(
                                  width: 297.0,
                                  height: 70.0,
                                  initialStartDate: getJsonField(
                                    context
                                        .read<ItineraryService>()
                                        .allDataItinerary,
                                    r'''$[:].valid_until''',
                                  ).toString(),
                                  labelText: 'Valido hasta',
                                  isRangePicker: false,
                                  onRangeSelected:
                                      (startDateStr, endDateStr) async {},
                                  onDateSelected: (date) async {
                                    _model.initialDate = date;
                                    safeSetState(() {});
                                  },
                                ),
                              ),
                              FlutterFlowDropDown<String>(
                                controller: _model.languageValueController ??=
                                    FormFieldController<String>(
                                  _model.languageValue ??=
                                      valueOrDefault<String>(
                                    widget!.isEdit == true
                                        ? getJsonField(
                                            context
                                                .read<ItineraryService>()
                                                .allDataItinerary,
                                            r'''$[:].language''',
                                          ).toString()
                                        : 'Español',
                                    'Español',
                                  ),
                                ),
                                options: [
                                  'Español',
                                  'Inglés',
                                  'Francés',
                                  'Portugués'
                                ],
                                onChanged: (val) => safeSetState(
                                    () => _model.languageValue = val),
                                width: 297.0,
                                height: 50.0,
                                searchHintTextStyle:
                                    FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .labelMediumFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .labelMediumIsCustom,
                                        ),
                                searchTextStyle: TextStyle(),
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                hintText: 'Idioma',
                                searchHintText: 'Search for an item...',
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 12.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: true,
                                isMultiSelect: false,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 4.0, 12.0, 0.0),
                                      child: Text(
                                        'Pasajeros',
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .labelMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      width: 144.0,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius: BorderRadius.circular(
                                            BukeerSpacing.s),
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: FlutterFlowCountController(
                                        decrementIconBuilder: (enabled) =>
                                            FaIcon(
                                          FontAwesomeIcons.minus,
                                          color: enabled
                                              ? FlutterFlowTheme.of(context)
                                                  .secondaryText
                                              : FlutterFlowTheme.of(context)
                                                  .alternate,
                                          size: 20.0,
                                        ),
                                        incrementIconBuilder: (enabled) =>
                                            FaIcon(
                                          FontAwesomeIcons.plus,
                                          color: enabled
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : FlutterFlowTheme.of(context)
                                                  .alternate,
                                          size: 20.0,
                                        ),
                                        countBuilder: (count) => Text(
                                          count.toString(),
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleLargeFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleLargeIsCustom,
                                              ),
                                        ),
                                        count: _model.countControllerValue ??=
                                            valueOrDefault<int>(
                                          widget!.isEdit == true
                                              ? getJsonField(
                                                  context
                                                      .read<ItineraryService>()
                                                      .allDataItinerary,
                                                  r'''$[:].passenger_count''',
                                                )
                                              : 1,
                                          1,
                                        ),
                                        updateCount: (count) => safeSetState(
                                            () => _model.countControllerValue =
                                                count),
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
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 24.0),
                          child: Wrap(
                            spacing: 12.0,
                            runSpacing: 12.0,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.horizontal,
                            runAlignment: WrapAlignment.start,
                            verticalDirection: VerticalDirection.down,
                            clipBehavior: Clip.none,
                            children: [
                              FlutterFlowDropDown<String>(
                                controller:
                                    _model.currencyTypeValueController ??=
                                        FormFieldController<String>(
                                  _model.currencyTypeValue ??=
                                      valueOrDefault<String>(
                                    widget!.isEdit == true
                                        ? getJsonField(
                                            context
                                                .read<ItineraryService>()
                                                .allDataItinerary,
                                            r'''$[:].currency_type''',
                                          ).toString()
                                        : getJsonField(
                                            FFAppState()
                                                .accountCurrency
                                                .firstOrNull,
                                            r'''$.name''',
                                          ).toString(),
                                    'USD',
                                  ),
                                ),
                                options: FFAppState()
                                    .accountCurrency
                                    .map((e) => getJsonField(
                                          e,
                                          r'''$.name''',
                                        ))
                                    .toList()
                                    .map((e) => e.toString())
                                    .toList(),
                                onChanged: (val) => safeSetState(
                                    () => _model.currencyTypeValue = val),
                                width: 297.0,
                                height: 50.0,
                                searchHintTextStyle:
                                    FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .labelMediumFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .labelMediumIsCustom,
                                        ),
                                searchTextStyle: TextStyle(),
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                hintText: 'Seleccionar  Moneda',
                                searchHintText: 'Search for an item...',
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 12.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: true,
                                isMultiSelect: false,
                              ),
                              FlutterFlowDropDown<String>(
                                controller:
                                    _model.requestTypeValueController ??=
                                        FormFieldController<String>(
                                  _model.requestTypeValue ??=
                                      valueOrDefault<String>(
                                    widget!.isEdit == true
                                        ? getJsonField(
                                            context
                                                .read<ItineraryService>()
                                                .allDataItinerary,
                                            r'''$[:].request_type''',
                                          ).toString()
                                        : 'Econo',
                                    'Econo',
                                  ),
                                ),
                                options: [
                                  'Econo',
                                  'Standar',
                                  'Premium',
                                  'Luxury'
                                ],
                                onChanged: (val) => safeSetState(
                                    () => _model.requestTypeValue = val),
                                width: 297.0,
                                height: 50.0,
                                searchHintTextStyle:
                                    FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .labelMediumFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .labelMediumIsCustom,
                                        ),
                                searchTextStyle: TextStyle(),
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                hintText: 'Tipo de solicitud',
                                searchHintText: 'Search for an item...',
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 12.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: true,
                                isMultiSelect: false,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 5.0, 24.0, 5.0),
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _model.messageActivityTextController,
                              focusNode: _model.messageActivityFocusNode,
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Mensaje destacado',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelMediumIsCustom,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelMediumIsCustom,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 2.0,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(BukeerSpacing.s),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(BukeerSpacing.s),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(BukeerSpacing.s),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(BukeerSpacing.s),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 24.0, 20.0, 24.0),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                              maxLines: null,
                              minLines: 3,
                              cursorColor: FlutterFlowTheme.of(context).primary,
                              validator: _model
                                  .messageActivityTextControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 16.0),
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.sizeOf(context).height * 1.0,
                            ),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(1.0, 0.0),
                                    child: Builder(
                                      builder: (context) {
                                        final imagesItem =
                                            _model.images.toList();

                                        return MasonryGridView.builder(
                                          gridDelegate:
                                              SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                          ),
                                          crossAxisSpacing: 2.0,
                                          mainAxisSpacing: 0.0,
                                          itemCount: imagesItem.length,
                                          itemBuilder:
                                              (context, imagesItemIndex) {
                                            final imagesItemItem =
                                                imagesItem[imagesItemIndex];
                                            return Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, -1.0),
                                              child: Stack(
                                                alignment: AlignmentDirectional(
                                                    1.0, -1.0),
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 0.0),
                                                    child: Hero(
                                                      tag: valueOrDefault<
                                                          String>(
                                                        getJsonField(
                                                          imagesItemItem,
                                                          r'''$.url''',
                                                        )?.toString(),
                                                        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg' +
                                                            '$imagesItemIndex',
                                                      ),
                                                      transitionOnUserGestures:
                                                          true,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.network(
                                                          valueOrDefault<
                                                              String>(
                                                            getJsonField(
                                                              imagesItemItem,
                                                              r'''$.url''',
                                                            )?.toString(),
                                                            'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg',
                                                          ),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if ('${getJsonField(
                                                        imagesItemItem,
                                                        r'''$.url''',
                                                      ).toString()}' !=
                                                      context
                                                          .watch<
                                                              UiStateService>()
                                                          .selectedImageUrl)
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              1.0, -1.0),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    15.0,
                                                                    15.0,
                                                                    0.0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            context
                                                                    .read<
                                                                        UiStateService>()
                                                                    .selectedImageUrl =
                                                                getJsonField(
                                                              imagesItemItem,
                                                              r'''$.url''',
                                                            ).toString();
                                                            safeSetState(() {});
                                                          },
                                                          child: Icon(
                                                            Icons.star_outline,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  if ('${getJsonField(
                                                        imagesItemItem,
                                                        r'''$.url''',
                                                      ).toString()}' ==
                                                      context
                                                          .watch<
                                                              UiStateService>()
                                                          .selectedImageUrl)
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              1.0, -1.0),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    15.0,
                                                                    15.0,
                                                                    0.0),
                                                        child: Icon(
                                                          Icons.star_outlined,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          size: 24.0,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Divider(
                    height: 20.0,
                    thickness: 1.0,
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.05),
                          child: FFButtonWidget(
                            onPressed: () async {
                              context.read<UiStateService>().selectedContact =
                                  null;
                              safeSetState(() {});
                              context.safePop();
                            },
                            text: 'Cancel',
                            options: FFButtonOptions(
                              height: 44.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                              borderRadius:
                                  BorderRadius.circular(BukeerSpacing.s),
                              hoverColor:
                                  FlutterFlowTheme.of(context).alternate,
                              hoverBorderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                              hoverTextColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              hoverElevation: 3.0,
                            ),
                          ),
                        ),
                        if (widget!.isEdit == false)
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.05),
                            child: FFButtonWidget(
                              onPressed: () async {
                                var _shouldSetState = false;
                                if ((_model.initialStartDate == null ||
                                        _model.initialStartDate == '') ||
                                    (_model.initialEndDate == null ||
                                        _model.initialEndDate == '') ||
                                    (_model.initialDate == null ||
                                        _model.initialDate == '')) {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title: Text('Mensaje'),
                                        content: Text(
                                            'Todos los campos son requeridos'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  _model.responseFormAddItinerary = true;
                                  if (_model.formKey.currentState == null ||
                                      !_model.formKey.currentState!
                                          .validate()) {
                                    _model.responseFormAddItinerary = false;
                                  }
                                  if (_model.languageValue == null) {
                                    _model.responseFormAddItinerary = false;
                                  }
                                  if (_model.currencyTypeValue == null) {
                                    _model.responseFormAddItinerary = false;
                                  }
                                  if (_model.requestTypeValue == null) {
                                    _model.responseFormAddItinerary = false;
                                  }
                                  _shouldSetState = true;
                                  if (_model.responseFormAddItinerary!) {
                                    _model.apiResponseCreateItineraryContact =
                                        await CreateItineraryForContactCall
                                            .call(
                                      name: _model
                                          .nameItineraryTextController.text,
                                      startDate: _model.initialStartDate,
                                      endDate: _model.initialEndDate,
                                      passengerCount:
                                          _model.countControllerValue,
                                      validUntil: _model.initialDate,
                                      currencyType: _model.currencyTypeValue,
                                      language: _model.languageValue,
                                      requestType: _model.requestTypeValue,
                                      idCreatedBy: currentUserUid,
                                      agent: _model.selectedTravelPlannerId ??
                                          currentUserUid,
                                      idContact: context
                                                  .watch<UiStateService>()
                                                  .isCreatedInItinerary ==
                                              true
                                          ? getJsonField(
                                              context
                                                  .watch<UiStateService>()
                                                  .selectedContact,
                                              r'''$[:].id''',
                                            ).toString()
                                          : getJsonField(
                                              context
                                                  .watch<UiStateService>()
                                                  .selectedContact,
                                              r'''$.id''',
                                            ).toString(),
                                      idFm: '${FFAppState().accountIdFm}-',
                                      accountId: FFAppState().accountId,
                                      authToken: currentJwtToken,
                                      currencyJson:
                                          FFAppState().accountCurrency,
                                      status: 'Presupuesto',
                                      typesIncreaseJson:
                                          FFAppState().accountTypesIncrease,
                                      personalizedMessage:
                                          (String personalizedMessage) {
                                        return personalizedMessage.replaceAll(
                                            '\n', '\\n');
                                      }(_model.messageActivityTextController
                                              .text),
                                      mainImage: context
                                                      .watch<UiStateService>()
                                                      .selectedImageUrl !=
                                                  null &&
                                              context
                                                      .watch<UiStateService>()
                                                      .selectedImageUrl !=
                                                  ''
                                          ? context
                                              .watch<UiStateService>()
                                              .selectedImageUrl
                                          : 'https://images.unsplash.com/photo-1533699224246-6dc3b3ed3304?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyfHxjb2xvbWJpYXxlbnwwfHx8fDE3Mzc0MjQxNzF8MA&ixlib=rb-4.0.3&q=80&w=1080',
                                    );

                                    _shouldSetState = true;
                                    if ((_model
                                            .apiResponseCreateItineraryContact
                                            ?.succeeded ??
                                        true)) {
                                      context
                                          .read<UiStateService>()
                                          .selectedContact = null;
                                      context
                                          .read<UiStateService>()
                                          .isCreatedInItinerary = false;
                                      context
                                              .read<ContactService>()
                                              .allDataContact =
                                          CreateItineraryForContactCall.all(
                                        (_model.apiResponseCreateItineraryContact
                                                ?.jsonBody ??
                                            ''),
                                      );
                                      safeSetState(() {});

                                      context.pushNamed(
                                        ItineraryDetailsWidget.routeName,
                                        pathParameters: {
                                          'id': serializeParam(
                                            getJsonField(
                                              (_model.apiResponseCreateItineraryContact
                                                      ?.jsonBody ??
                                                  ''),
                                              r'''$[:].itinerary_id''',
                                            ).toString(),
                                            ParamType.String,
                                          ),
                                        }.withoutNulls,
                                      );
                                    } else {
                                      await showDialog(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title: Text('Mensaje'),
                                            content: Text(
                                                'Todos los campos son requeridos'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext),
                                                child: Text('Ok'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (_shouldSetState) safeSetState(() {});
                                      return;
                                    }
                                  } else {
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          title: Text('Mensaje'),
                                          content: Text(
                                              'Todos los campos son requeridos.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  alertDialogContext),
                                              child: Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (_shouldSetState) safeSetState(() {});
                                    return;
                                  }
                                }

                                if (_shouldSetState) safeSetState(() {});
                              },
                              text: 'Agregar',
                              options: FFButtonOptions(
                                height: 44.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleSmallFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .titleSmallIsCustom,
                                    ),
                                elevation: 3.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius:
                                    BorderRadius.circular(BukeerSpacing.s),
                                hoverColor:
                                    FlutterFlowTheme.of(context).accent1,
                                hoverBorderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.0,
                                ),
                                hoverTextColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                hoverElevation: 0.0,
                              ),
                            ),
                          ),
                        if (widget!.isEdit == true)
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.05),
                            child: FFButtonWidget(
                              onPressed: () async {
                                var _shouldSetState = false;
                                _model.responseFormEditItinerary = true;
                                if (_model.formKey.currentState == null ||
                                    !_model.formKey.currentState!.validate()) {
                                  _model.responseFormEditItinerary = false;
                                }
                                if (_model.languageValue == null) {
                                  _model.responseFormEditItinerary = false;
                                }
                                if (_model.currencyTypeValue == null) {
                                  _model.responseFormEditItinerary = false;
                                }
                                if (_model.requestTypeValue == null) {
                                  _model.responseFormEditItinerary = false;
                                }
                                _shouldSetState = true;
                                if (_model.responseFormEditItinerary!) {
                                  _model.responseUpdateItinerary =
                                      await UpdateItineraryCall.call(
                                    authToken: currentJwtToken,
                                    name:
                                        _model.nameItineraryTextController.text,
                                    startDate:
                                        _model.initialStartDate != null &&
                                                _model.initialStartDate != ''
                                            ? _model.initialStartDate
                                            : getJsonField(
                                                context
                                                    .read<ItineraryService>()
                                                    .allDataItinerary,
                                                r'''$[:].start_date''',
                                              ).toString(),
                                    passengerCount: _model.countControllerValue,
                                    endDate: _model.initialEndDate != null &&
                                            _model.initialEndDate != ''
                                        ? _model.initialEndDate
                                        : getJsonField(
                                            context
                                                .read<ItineraryService>()
                                                .allDataItinerary,
                                            r'''$[:].end_date''',
                                          ).toString(),
                                    validUntil: _model.initialDate != null &&
                                            _model.initialDate != ''
                                        ? _model.initialDate
                                        : getJsonField(
                                            context
                                                .read<ItineraryService>()
                                                .allDataItinerary,
                                            r'''$[:].valid_until''',
                                          ).toString(),
                                    language: _model.languageValue,
                                    requestType: _model.requestTypeValue,
                                    agent: _model.selectedTravelPlannerId ??
                                        getJsonField(
                                          context
                                              .read<ItineraryService>()
                                              .allDataItinerary,
                                          r'''$[:].agent''',
                                        ).toString(),
                                    idCreatedBy: getJsonField(
                                      context
                                          .read<ItineraryService>()
                                          .allDataItinerary,
                                      r'''$[:].id_created_by''',
                                    ).toString(),
                                    idContact: () {
                                      if (context
                                              .read<UiStateService>()
                                              .isCreatedInItinerary ==
                                          true) {
                                        return getJsonField(
                                          context
                                              .read<UiStateService>()
                                              .selectedContact,
                                          r'''$[:].id''',
                                        ).toString();
                                      } else if (context
                                              .read<UiStateService>()
                                              .selectedContact !=
                                          null) {
                                        return getJsonField(
                                          context
                                              .read<UiStateService>()
                                              .selectedContact,
                                          r'''$.id''',
                                        ).toString();
                                      } else {
                                        return getJsonField(
                                          context
                                              .read<ItineraryService>()
                                              .allDataItinerary,
                                          r'''$[:].id_contact''',
                                        ).toString();
                                      }
                                    }(),
                                    id: getJsonField(
                                      context
                                          .read<ItineraryService>()
                                          .allDataItinerary,
                                      r'''$[:].id''',
                                    ).toString(),
                                    currencyType: _model.currencyTypeValue,
                                    personalizedMessage:
                                        (String personalizedMessage) {
                                      return personalizedMessage.replaceAll(
                                          '\n', '\\n');
                                    }(_model.messageActivityTextController
                                            .text),
                                    mainImage: context
                                        .watch<UiStateService>()
                                        .selectedImageUrl,
                                  );

                                  _shouldSetState = true;
                                  if ((_model
                                          .responseUpdateItinerary?.succeeded ??
                                      true)) {
                                    context
                                        .read<UiStateService>()
                                        .selectedContact = null;
                                    context
                                        .read<UiStateService>()
                                        .isCreatedInItinerary = false;
                                    safeSetState(() {});
                                    context.safePop();
                                  } else {
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          title: Text('Mensaje'),
                                          content: Text((_model
                                                      .responseUpdateItinerary
                                                      ?.jsonBody ??
                                                  '')
                                              .toString()),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  alertDialogContext),
                                              child: Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (_shouldSetState) safeSetState(() {});
                                    return;
                                  }
                                } else {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title: Text('Mensaje'),
                                        content: Text(
                                            'Todos los campos son requeridos'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (_shouldSetState) safeSetState(() {});
                                  return;
                                }

                                if (_shouldSetState) safeSetState(() {});
                              },
                              text: 'Guardar',
                              options: FFButtonOptions(
                                height: 44.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleSmallFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .titleSmallIsCustom,
                                    ),
                                elevation: 3.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius:
                                    BorderRadius.circular(BukeerSpacing.s),
                                hoverColor:
                                    FlutterFlowTheme.of(context).accent1,
                                hoverBorderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.0,
                                ),
                                hoverTextColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                hoverElevation: 0.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
      ),
    );
  }
}
