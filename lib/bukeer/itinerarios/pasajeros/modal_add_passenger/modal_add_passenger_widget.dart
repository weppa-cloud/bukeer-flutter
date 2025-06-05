import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../../backend/api_requests/api_calls.dart';
import '../../../../backend/supabase/supabase.dart';
import '../../../../design_system/index.dart';
import '../../../componentes/component_birth_date/component_birth_date_widget.dart';
import '../../../../flutter_flow/flutter_flow_animations.dart';
import '../../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../../flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'modal_add_passenger_model.dart';
import '../../../../services/itinerary_service.dart';
export 'modal_add_passenger_model.dart';

class ModalAddPassengerWidget extends StatefulWidget {
  const ModalAddPassengerWidget({
    super.key,
    required this.itineraryId,
    this.accountId,
    this.passengers,
    bool? isEdit,
  }) : this.isEdit = isEdit ?? false;

  final String? itineraryId;
  final String? accountId;
  final int? passengers;
  final bool isEdit;

  @override
  State<ModalAddPassengerWidget> createState() =>
      _ModalAddPassengerWidgetState();
}

class _ModalAddPassengerWidgetState extends State<ModalAddPassengerWidget>
    with TickerProviderStateMixin {
  late ModalAddPassengerModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalAddPassengerModel());

    _model.namePassengerTextController ??= TextEditingController(
        text: widget!.isEdit == true
            ? getJsonField(
                context.read<ItineraryService>().allDataPassenger,
                r'''$.name''',
              ).toString().toString()
            : '');
    _model.namePassengerFocusNode ??= FocusNode();

    _model.lastNamePassengerTextController ??= TextEditingController(
        text: widget!.isEdit == true
            ? getJsonField(
                context.read<ItineraryService>().allDataPassenger,
                r'''$.last_name''',
              ).toString().toString()
            : '');
    _model.lastNamePassengerFocusNode ??= FocusNode();

    _model.numberIdPassengerTextController ??= TextEditingController(
        text: widget!.isEdit == true
            ? getJsonField(
                context.read<ItineraryService>().allDataPassenger,
                r'''$.number_id''',
              ).toString().toString()
            : '');
    _model.numberIdPassengerFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
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
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.s),
        child: Container(
          width: 690.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 12.0,
                color: Color(0x1E000000),
                offset: Offset(
                  0.0,
                  5.0,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
          ),
          child: Form(
            key: _model.formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: BukeerSpacing.s),
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2.0,
                          color: BukeerColors.overlay,
                          offset: Offset(
                            0.0,
                            2.0,
                          ),
                        )
                      ],
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'Registrar pasajero.',
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
                          if (widget!.isEdit)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 5.0, 0.0, 0.0),
                              child: FlutterFlowIconButton(
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderRadius: 12.0,
                                borderWidth: 2.0,
                                buttonSize: 40.0,
                                fillColor: FlutterFlowTheme.of(context).accent4,
                                icon: FaIcon(
                                  FontAwesomeIcons.trashAlt,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  var confirmDialogResponse =
                                      await showDialog<bool>(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Mensaje'),
                                                content: Text(
                                                    '¿Está seguro que desea borrar este ítem?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext,
                                                            false),
                                                    child: Text('Cancelar'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext,
                                                            true),
                                                    child: Text('Confirmar'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ) ??
                                          false;
                                  if (confirmDialogResponse) {
                                    _model.responseActivityDeleted =
                                        await PassengerTable().delete(
                                      matchingRows: (rows) => rows.eqOrNull(
                                        'id',
                                        getJsonField(
                                          context.read<ItineraryService>().allDataPassenger,
                                          r'''$.id''',
                                        ),
                                      ),
                                      returnRows: true,
                                    );
                                    Navigator.pop(context);
                                  }

                                  safeSetState(() {});
                                },
                              ),
                            ),
                        ].divide(SizedBox(width: BukeerSpacing.s)),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Wrap(
                            spacing: 12.0,
                            runSpacing: 12.0,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.horizontal,
                            runAlignment: WrapAlignment.start,
                            verticalDirection: VerticalDirection.down,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 260.0,
                                child: TextFormField(
                                  controller:
                                      _model.namePassengerTextController,
                                  focusNode: _model.namePassengerFocusNode,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Nombre',
                                    labelStyle: FlutterFlowTheme.of(context)
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
                                    hintStyle: FlutterFlowTheme.of(context)
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
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
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
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  validator: _model
                                      .namePassengerTextControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                              Container(
                                width: 260.0,
                                child: TextFormField(
                                  controller:
                                      _model.lastNamePassengerTextController,
                                  focusNode: _model.lastNamePassengerFocusNode,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Apellido',
                                    labelStyle: FlutterFlowTheme.of(context)
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
                                    hintStyle: FlutterFlowTheme.of(context)
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
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
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
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  validator: _model
                                      .lastNamePassengerTextControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 5.0, 0.0, 5.0),
                                child: FlutterFlowDropDown<String>(
                                  controller: _model
                                          .typeDocumentPassengerValueController ??=
                                      FormFieldController<String>(
                                    _model.typeDocumentPassengerValue ??=
                                        widget!.isEdit == true
                                            ? getJsonField(
                                                context.read<ItineraryService>().allDataPassenger,
                                                r'''$.type_id''',
                                              ).toString()
                                            : 'Cédula de ciudadanía',
                                  ),
                                  options: [
                                    'Cédula de ciudadanía',
                                    'Cédula de extranjería',
                                    'Tarjeta de identidad',
                                    'NIT',
                                    'Pasaporte',
                                    'DNI'
                                  ],
                                  onChanged: (val) => safeSetState(() =>
                                      _model.typeDocumentPassengerValue = val),
                                  width: 260.0,
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
                                  hintText:
                                      'Seleccionar tipo de identificación',
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
                                  borderWidth: 0.0,
                                  borderRadius: 8.0,
                                  margin: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 12.0, 0.0),
                                  hidesUnderline: true,
                                  isSearchable: true,
                                  isMultiSelect: false,
                                ),
                              ),
                              Container(
                                width: 260.0,
                                child: TextFormField(
                                  controller:
                                      _model.numberIdPassengerTextController,
                                  focusNode: _model.numberIdPassengerFocusNode,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Número de idenficación',
                                    labelStyle: FlutterFlowTheme.of(context)
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
                                    hintStyle: FlutterFlowTheme.of(context)
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
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
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
                                  keyboardType: TextInputType.datetime,
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  validator: _model
                                      .numberIdPassengerTextControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeInOut,
                                width: 260.0,
                                height: 60.0,
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
                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 5.0, 0.0, 5.0),
                                  child: FutureBuilder<ApiCallResponse>(
                                    future: GetNationalitiesCall.call(
                                      authToken: currentJwtToken,
                                    ),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: SizedBox(
                                            width: 50.0,
                                            height: 50.0,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      final nationalityPassengerGetNationalitiesResponse =
                                          snapshot.data!;

                                      return FlutterFlowDropDown<String>(
                                        controller: _model
                                                .nationalityPassengerValueController ??=
                                            FormFieldController<String>(
                                          _model.nationalityPassengerValue ??=
                                              widget!.isEdit == true
                                                  ? getJsonField(
                                                      context.read<ItineraryService>()
                                                          .allDataPassenger,
                                                      r'''$.nationality''',
                                                    ).toString()
                                                  : 'Colombiana',
                                        ),
                                        options: (getJsonField(
                                          nationalityPassengerGetNationalitiesResponse
                                              .jsonBody,
                                          r'''$[:].name''',
                                          true,
                                        ) as List)
                                            .map<String>((s) => s.toString())
                                            .toList()!,
                                        onChanged: (val) => safeSetState(() =>
                                            _model.nationalityPassengerValue =
                                                val),
                                        width: 299.0,
                                        height: 50.0,
                                        searchHintTextStyle: FlutterFlowTheme
                                                .of(context)
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
                                        searchTextStyle: FlutterFlowTheme.of(
                                                context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        hintText: 'Seleccionar nacionalidad',
                                        searchHintText: 'Buscar',
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        elevation: 2.0,
                                        borderColor: Colors.transparent,
                                        borderWidth: 0.0,
                                        borderRadius: 8.0,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 12.0, 0.0),
                                        hidesUnderline: true,
                                        isOverButton: false,
                                        isSearchable: true,
                                        isMultiSelect: false,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                width: 260.0,
                                decoration: BoxDecoration(),
                                child: wrapWithModel(
                                  model: _model.componentBirthDateModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: ComponentBirthDateWidget(
                                    date: widget!.isEdit == true
                                        ? getJsonField(
                                            context.read<ItineraryService>().allDataPassenger,
                                            r'''$.birth_date''',
                                          ).toString()
                                        : '',
                                    label: 'Fecha de nacimiento',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: BukeerSpacing.s),
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1.0,
                          color: BukeerColors.overlay,
                          offset: Offset(
                            0.0,
                            -1.0,
                          ),
                        )
                      ],
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 6.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.05),
                            child: FFButtonWidget(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              text: 'Cancelar',
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
                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
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
                                  _model.responseForm = true;
                                  if (_model.formKey.currentState == null ||
                                      !_model.formKey.currentState!
                                          .validate()) {
                                    _model.responseForm = false;
                                  }
                                  if (_model.typeDocumentPassengerValue ==
                                      null) {
                                    _model.responseForm = false;
                                  }
                                  if (_model.nationalityPassengerValue ==
                                      null) {
                                    _model.responseForm = false;
                                  }
                                  if (_model.responseForm!) {
                                    _model.apiResponseCountPassenger =
                                        await CountPassengersByItineraryCall
                                            .call(
                                      authToken: currentJwtToken,
                                      itineraryId: widget!.itineraryId,
                                    );

                                    if ((_model.apiResponseCountPassenger
                                            ?.succeeded ??
                                        true)) {
                                      if ((_model.apiResponseCountPassenger
                                                  ?.jsonBody ??
                                              '') <
                                          (widget!.passengers!)) {
                                        _model.apiResultAddPassenger =
                                            await AddPassengerItineraryCall
                                                .call(
                                          authToken: currentJwtToken,
                                          name: _model
                                              .namePassengerTextController.text,
                                          lastName: _model
                                              .lastNamePassengerTextController
                                              .text,
                                          typeId:
                                              _model.typeDocumentPassengerValue,
                                          numberId: _model
                                              .numberIdPassengerTextController
                                              .text,
                                          nationality:
                                              _model.nationalityPassengerValue,
                                          birthDate: _model
                                              .componentBirthDateModel
                                              .datePicked
                                              ?.toString(),
                                          itineraryId: widget!.itineraryId,
                                          accountId: widget!.accountId,
                                        );

                                        if ((_model.apiResultAddPassenger
                                                ?.succeeded ??
                                            true)) {
                                          safeSetState(() {
                                            _model.namePassengerTextController
                                                ?.clear();
                                            _model
                                                .numberIdPassengerTextController
                                                ?.clear();
                                            _model
                                                .lastNamePassengerTextController
                                                ?.clear();
                                          });
                                          safeSetState(() {
                                            _model
                                                .typeDocumentPassengerValueController
                                                ?.reset();
                                            _model
                                                .nationalityPassengerValueController
                                                ?.reset();
                                          });
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Resitro exitoso'),
                                                content: Text(
                                                    'El pasajero se ha registrado exitosamente en la reserva'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          Navigator.pop(context);
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Error'),
                                                content: Text(
                                                    'Hubo un error al agregar pasajeros'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      } else {
                                        await showDialog(
                                          context: context,
                                          builder: (alertDialogContext) {
                                            return AlertDialog(
                                              title: Text('Mensaje'),
                                              content: Text(
                                                  'No puede agregar más pasajeros.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          alertDialogContext),
                                                  child: Text('Ok'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    } else {
                                      await showDialog(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title: Text('Mensaje'),
                                            content: Text('Ocurrio un error'),
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
                                    }
                                  } else {
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          title: Text('Mensaje'),
                                          content: Text(
                                              _model.responseForm!.toString()),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  alertDialogContext),
                                              child: Text('ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }

                                  safeSetState(() {});
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
                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
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
                                  _model.responseForm2 = true;
                                  if (_model.formKey.currentState == null ||
                                      !_model.formKey.currentState!
                                          .validate()) {
                                    _model.responseForm2 = false;
                                  }
                                  if (_model.typeDocumentPassengerValue ==
                                      null) {
                                    _model.responseForm2 = false;
                                  }
                                  if (_model.nationalityPassengerValue ==
                                      null) {
                                    _model.responseForm2 = false;
                                  }
                                  if (_model.responseForm2!) {
                                    _model.apiResultEditPassenger =
                                        await UpdatePassengerItineraryCall.call(
                                      authToken: currentJwtToken,
                                      name: _model
                                          .namePassengerTextController.text,
                                      lastName: _model
                                          .lastNamePassengerTextController.text,
                                      typeId: _model.typeDocumentPassengerValue,
                                      numberId: _model
                                          .numberIdPassengerTextController.text,
                                      nationality:
                                          _model.nationalityPassengerValue,
                                      id: getJsonField(
                                        context.read<ItineraryService>().allDataPassenger,
                                        r'''$.id''',
                                      ).toString(),
                                      birthDate: _model.componentBirthDateModel
                                                  .datePicked !=
                                              null
                                          ? _model.componentBirthDateModel
                                              .datePicked
                                              ?.toString()
                                          : getJsonField(
                                              context.read<ItineraryService>().allDataPassenger,
                                              r'''$.birth_date''',
                                            ).toString(),
                                    );

                                    if ((_model.apiResultEditPassenger
                                            ?.succeeded ??
                                        true)) {
                                      safeSetState(() {
                                        _model.namePassengerTextController
                                            ?.clear();
                                        _model.numberIdPassengerTextController
                                            ?.clear();
                                        _model.lastNamePassengerTextController
                                            ?.clear();
                                      });
                                      safeSetState(() {
                                        _model
                                            .typeDocumentPassengerValueController
                                            ?.reset();
                                        _model
                                            .nationalityPassengerValueController
                                            ?.reset();
                                      });
                                      context.read<ItineraryService>().allDataPassenger = null;
                                      safeSetState(() {});
                                      await showDialog(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title: Text('Resitro exitoso'),
                                            content: Text(
                                                'El pasajero se ha registrado exitosamente en la reserva'),
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
                                      Navigator.pop(context);
                                    } else {
                                      await showDialog(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content: Text(
                                                'Hubo un error al agregar pasajeros'),
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
                                    }
                                  } else {
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          title: Text('Mensaje'),
                                          content: Text(
                                              'Todos los campos son obligatorios.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  alertDialogContext),
                                              child: Text('ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }

                                  safeSetState(() {});
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
                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
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
                  ),
                ),
              ].divide(SizedBox(height: BukeerSpacing.s)),
            ),
          ),
        ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
      ),
    );
  }
}
