import '../../../../../../auth/supabase_auth/auth_util.dart';
import '../../../../../../backend/api_requests/api_calls.dart';
import '../../../../../../backend/supabase/supabase.dart';
import '../../../../../../bukeer/core/widgets/forms/place_picker/place_picker_widget.dart';
import '../details/modal_details_product_widget.dart';
import '../../../../../../flutter_flow/flutter_flow_animations.dart';
import '../../../../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../../design_system/index.dart';
import '../../../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../../../../flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'modal_add_product_model.dart';
import '../../../../../../services/ui_state_service.dart';
import '../../../../../../services/app_services.dart';
import '/design_system/tokens/index.dart';
export 'modal_add_product_model.dart';

class ModalAddProductWidget extends StatefulWidget {
  const ModalAddProductWidget({
    super.key,
    required this.idContact,
    this.dataActivity,
    required this.actionType,
  });

  final String? idContact;
  final dynamic dataActivity;
  final String? actionType;

  @override
  State<ModalAddProductWidget> createState() => _ModalAddProductWidgetState();
}

class _ModalAddProductWidgetState extends State<ModalAddProductWidget>
    with TickerProviderStateMixin {
  late ModalAddProductModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalAddProductModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      context.read<UiStateService>().selectedImageUrl = getJsonField(
        widget!.dataActivity,
        r'''$[:].main_image''',
      ).toString().toString();
      safeSetState(() {});
    });

    _model.nameActivityTextController ??= TextEditingController(
        text: getJsonField(
                  widget!.dataActivity,
                  r'''$[:].name''',
                ) !=
                null
            ? ((String name) {
                return name.replaceAll('\\n', '\n');
              }(getJsonField(
                widget!.dataActivity,
                r'''$[:].name''',
              ).toString().toString()))
            : '');
    _model.nameActivityFocusNode ??= FocusNode();

    _model.descriptionActivityTextController ??= TextEditingController(
        text: getJsonField(
                  widget!.dataActivity,
                  r'''$[:].description''',
                ) !=
                null
            ? ((String description) {
                return description.replaceAll('\\n', '\n');
              }(getJsonField(
                widget!.dataActivity,
                r'''$[:].description''',
              ).toString().toString()))
            : '');
    _model.descriptionActivityFocusNode ??= FocusNode();

    _model.descriptionShortActivityTextController ??= TextEditingController(
        text: getJsonField(
                  widget!.dataActivity,
                  r'''$[:].description_short''',
                ) !=
                null
            ? ((String description) {
                return description.replaceAll('\\n', '\n');
              }(getJsonField(
                widget!.dataActivity,
                r'''$[:].description_short''',
              ).toString().toString()))
            : '');
    _model.descriptionShortActivityFocusNode ??= FocusNode();

    _model.inclutionActivityTextController ??= TextEditingController(
        text: getJsonField(
                  widget!.dataActivity,
                  r'''$[:].inclutions''',
                ) !=
                null
            ? ((String inclutions) {
                return inclutions.replaceAll('\\n', '\n');
              }(getJsonField(
                widget!.dataActivity,
                r'''$[:].inclutions''',
              ).toString().toString()))
            : '');
    _model.inclutionActivityFocusNode ??= FocusNode();

    _model.notIcludeActivityTextController ??= TextEditingController(
        text: getJsonField(
                  widget!.dataActivity,
                  r'''$[:].exclutions''',
                ) !=
                null
            ? ((String exclutions) {
                return exclutions.replaceAll('\\n', '\n');
              }(getJsonField(
                widget!.dataActivity,
                r'''$[:].exclutions''',
              ).toString().toString()))
            : '');
    _model.notIcludeActivityFocusNode ??= FocusNode();

    _model.recomendationsActivityTextController ??= TextEditingController(
        text: getJsonField(
                  widget!.dataActivity,
                  r'''$[:].recommendations''',
                ) !=
                null
            ? ((String recommendations) {
                return recommendations.replaceAll('\\n', '\n');
              }(getJsonField(
                widget!.dataActivity,
                r'''$[:].recommendations''',
              ).toString().toString()))
            : '');
    _model.recomendationsActivityFocusNode ??= FocusNode();

    _model.instructionsActivityTextController ??= TextEditingController(
        text: getJsonField(
                  widget!.dataActivity,
                  r'''$[:].instructions''',
                ) !=
                null
            ? ((String instructions) {
                return instructions.replaceAll('\\n', '\n');
              }(getJsonField(
                widget!.dataActivity,
                r'''$[:].instructions''',
              ).toString().toString()))
            : '');
    _model.instructionsActivityFocusNode ??= FocusNode();

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
    // context.watch<FFAppState>(); // Removed - using services instead

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: BukeerColors.neutral400,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(BukeerSpacing.m),
            child: Container(
              height: MediaQuery.sizeOf(context).height * 1.0,
              constraints: BoxConstraints(
                maxWidth: 670.0,
                maxHeight: 900.0,
              ),
              decoration: BoxDecoration(
                color: BukeerColors.getBackground(context, secondary: true),
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
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Form(
                key: _model.formKey,
                autovalidateMode: AutovalidateMode.always,
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            BukeerIconButton(
                              icon: Icon(
                                Icons.close,
                                color: BukeerColors.primaryText,
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              size: BukeerIconButtonSize.small,
                              variant: BukeerIconButtonVariant.outlined,
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  ' Agregar o Editar Producto',
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
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 5.0, 0.0, 5.0),
                          child: Text(
                            'Información Básica',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .headlineMediumFamily,
                                  fontSize: BukeerTypography.bodyLargeSize,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .headlineMediumIsCustom,
                                ),
                          ),
                        ),
                      ),
                      Divider(
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: BukeerSpacing.s),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 24.0),
                                child: Wrap(
                                  spacing: 0.0,
                                  runSpacing: 0.0,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  direction: Axis.horizontal,
                                  runAlignment: WrapAlignment.start,
                                  verticalDirection: VerticalDirection.down,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 5.0, 24.0, 5.0),
                                      child: Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller:
                                              _model.nameActivityTextController,
                                          focusNode:
                                              _model.nameActivityFocusNode,
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Nombre',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
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
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
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
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 20.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          validator: _model
                                              .nameActivityTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 5.0, 0.0, 5.0),
                                      child: FlutterFlowDropDown<String>(
                                        controller: _model
                                                .typeActivityValueController ??=
                                            FormFieldController<String>(
                                          _model.typeActivityValue ??=
                                              getJsonField(
                                                        widget!.dataActivity,
                                                        r'''$[:].type''',
                                                      ) !=
                                                      null
                                                  ? getJsonField(
                                                      widget!.dataActivity,
                                                      r'''$[:].type''',
                                                    ).toString()
                                                  : '',
                                        ),
                                        options: ['Actividad', 'Paquete'],
                                        onChanged: (val) => safeSetState(() =>
                                            _model.typeActivityValue = val),
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
                                        searchTextStyle: TextStyle(),
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
                                        hintText: 'Categoria',
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
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                        borderWidth: 2.0,
                                        borderRadius: 12.0,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            20.0, 4.0, 16.0, 4.0),
                                        hidesUnderline: true,
                                        isSearchable: true,
                                        isMultiSelect: false,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 5.0, 24.0, 5.0),
                                      child: wrapWithModel(
                          model: _model.placePickerModel,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: PlacePickerWidget(
                                          location: valueOrDefault<String>(
                                            getJsonField(
                                              widget!.dataActivity,
                                              r'''$[:].city''',
                                            )?.toString(),
                                            'Seleccionar ubicación',
                                          ),
                                          locationName: getJsonField(
                                            widget!.dataActivity,
                                            r'''$[:].name_location''',
                                          ).toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 20.0,
                                thickness: 2.0,
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                              Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 5.0, 0.0, 5.0),
                                  child: Text(
                                    'Información de producto',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .headlineMediumFamily,
                                          fontSize:
                                              BukeerTypography.bodyLargeSize,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .headlineMediumIsCustom,
                                        ),
                                  ),
                                ),
                              ),
                              Divider(
                                height: 20.0,
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 24.0),
                                child: Wrap(
                                  spacing: 0.0,
                                  runSpacing: 0.0,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  direction: Axis.horizontal,
                                  runAlignment: WrapAlignment.start,
                                  verticalDirection: VerticalDirection.down,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 5.0, 24.0, 5.0),
                                      child: Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller: _model
                                              .descriptionActivityTextController,
                                          focusNode: _model
                                              .descriptionActivityFocusNode,
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Descripción',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
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
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
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
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 20.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          maxLines: null,
                                          minLines: 3,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          validator: _model
                                              .descriptionActivityTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 5.0, 24.0, 5.0),
                                      child: Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller: _model
                                              .descriptionShortActivityTextController,
                                          focusNode: _model
                                              .descriptionShortActivityFocusNode,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Descripción corta',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
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
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
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
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 20.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          maxLines: null,
                                          minLines: 3,
                                          maxLength: 500,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          validator: _model
                                              .descriptionShortActivityTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 5.0, 24.0, 5.0),
                                      child: Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller: _model
                                              .inclutionActivityTextController,
                                          focusNode:
                                              _model.inclutionActivityFocusNode,
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Incluye',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
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
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
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
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 20.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          maxLines: null,
                                          minLines: 3,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          validator: _model
                                              .inclutionActivityTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 5.0, 24.0, 5.0),
                                      child: Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller: _model
                                              .notIcludeActivityTextController,
                                          focusNode:
                                              _model.notIcludeActivityFocusNode,
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'No Incluye',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
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
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
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
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 20.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          maxLines: null,
                                          minLines: 3,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          validator: _model
                                              .notIcludeActivityTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 5.0, 24.0, 5.0),
                                      child: Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller: _model
                                              .recomendationsActivityTextController,
                                          focusNode: _model
                                              .recomendationsActivityFocusNode,
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Observaciones y recomendaciones',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
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
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
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
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 20.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          maxLines: null,
                                          minLines: 3,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          validator: _model
                                              .recomendationsActivityTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 5.0, 24.0, 5.0),
                                      child: Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller: _model
                                              .instructionsActivityTextController,
                                          focusNode: _model
                                              .instructionsActivityFocusNode,
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Instrucciones para el pasajero',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
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
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
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
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 20.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          maxLines: null,
                                          minLines: 3,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          validator: _model
                                              .instructionsActivityTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 2.0,
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 8.0, 24.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          context.safePop();
                                        },
                                        text: 'Cancel',
                                        options: FFButtonOptions(
                                          height: 44.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          elevation: 0.0,
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              BukeerSpacing.s),
                                          hoverColor:
                                              FlutterFlowTheme.of(context)
                                                  .alternate,
                                          hoverBorderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          hoverTextColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          hoverElevation: 3.0,
                                        ),
                                      ),
                                    ),
                                    if (widget!.actionType == 'edit')
                                      Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: FFButtonWidget(
                                          onPressed: () async {
                                            var _shouldSetState = false;
                                            _model.responseFormEditProduct =
                                                true;
                                            if (_model.formKey.currentState ==
                                                    null ||
                                                !_model.formKey.currentState!
                                                    .validate()) {
                                              _model.responseFormEditProduct =
                                                  false;
                                            }
                                            if (_model.typeActivityValue ==
                                                null) {
                                              _model.responseFormEditProduct =
                                                  false;
                                            }
                                            _shouldSetState = true;
                                            context
                                                    .read<UiStateService>()
                                                    .selectedLocationLatLng =
                                                _model.placePickerModel
                                                    .placePickerValue.latLng
                                                    .toString();
                                            context
                                                    .read<UiStateService>()
                                                    .selectedLocationName =
                                                _model.placePickerModel
                                                    .placePickerValue.name;
                                            context
                                                    .read<UiStateService>()
                                                    .selectedLocationAddress =
                                                _model.placePickerModel
                                                    .placePickerValue.address;
                                            context
                                                    .read<UiStateService>()
                                                    .selectedLocationCity =
                                                _model.placePickerModel
                                                    .placePickerValue.city;
                                            context
                                                    .read<UiStateService>()
                                                    .selectedLocationState =
                                                _model.placePickerModel
                                                    .placePickerValue.state;
                                            context
                                                    .read<UiStateService>()
                                                    .selectedLocationCountry =
                                                _model.placePickerModel
                                                    .placePickerValue.country;
                                            context
                                                    .read<UiStateService>()
                                                    .selectedLocationZipCode =
                                                _model.placePickerModel
                                                    .placePickerValue.zipCode;
                                            safeSetState(() {});
                                            if (_model
                                                .responseFormEditProduct!) {
                                              if (context
                                                      .read<UiStateService>()
                                                      .selectedProductType ==
                                                  'activities') {
                                                if (context
                                                        .read<UiStateService>()
                                                        .selectedLocationLatLng !=
                                                    'LatLng(lat: 0, lng: 0)') {
                                                  _model.apiResponseUpdateLocationActivities =
                                                      await UpdateLocationsCall
                                                          .call(
                                                    latlng: context
                                                        .read<UiStateService>()
                                                        .selectedLocationLatLng,
                                                    name: context
                                                        .read<UiStateService>()
                                                        .selectedLocationName,
                                                    address: context
                                                        .read<UiStateService>()
                                                        .selectedLocationAddress,
                                                    city: context
                                                        .read<UiStateService>()
                                                        .selectedLocationCity,
                                                    state: context
                                                        .read<UiStateService>()
                                                        .selectedLocationState,
                                                    country: context
                                                        .read<UiStateService>()
                                                        .selectedLocationCountry,
                                                    zipCode: context
                                                        .read<UiStateService>()
                                                        .selectedLocationZipCode,
                                                    id: getJsonField(
                                                      widget!.dataActivity,
                                                      r'''$[:].location''',
                                                    ).toString(),
                                                    authToken: currentJwtToken,
                                                  );

                                                  _shouldSetState = true;
                                                  if ((_model
                                                          .apiResponseUpdateLocationActivities
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model.responseInsertLocationState =
                                                        (_model.apiResponseUpdateLocationActivities
                                                                    ?.jsonBody ??
                                                                '')
                                                            .toString();
                                                    safeSetState(() {});
                                                  } else {
                                                    if ((_model.apiResponseUpdateLocationActivities
                                                                ?.exceptionMessage ??
                                                            '') ==
                                                        '${null}') {
                                                      _model.responseInsertLocation3 =
                                                          await InsertLocationsCall
                                                              .call(
                                                        authToken:
                                                            currentJwtToken,
                                                        latlng: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationLatLng,
                                                        name: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationName,
                                                        address: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationAddress,
                                                        city: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationCity,
                                                        state: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationState,
                                                        country: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationCountry,
                                                        zipCode: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationZipCode,
                                                        accountId: appServices
                                                            .account.accountId!,
                                                        typeEntity:
                                                            'activities',
                                                      );

                                                      _shouldSetState = true;
                                                      if ((_model
                                                              .responseInsertLocation3
                                                              ?.succeeded ??
                                                          true)) {
                                                        _model.apiResultreg =
                                                            await InsertLocationByTypeCall
                                                                .call(
                                                          authToken:
                                                              currentJwtToken,
                                                          locationId: (_model
                                                                      .responseInsertLocation3
                                                                      ?.jsonBody ??
                                                                  '')
                                                              .toString(),
                                                          searchId:
                                                              getJsonField(
                                                            widget!
                                                                .dataActivity,
                                                            r'''$[:].id''',
                                                          ).toString(),
                                                          type: 'activities',
                                                        );

                                                        _shouldSetState = true;
                                                        if (!(_model
                                                                .apiResultreg
                                                                ?.succeeded ??
                                                            true)) {
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (alertDialogContext) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Mensaje'),
                                                                content: Text(
                                                                    'Error al agregar ubicación'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            alertDialogContext),
                                                                    child: Text(
                                                                        'Ok'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                          if (_shouldSetState)
                                                            safeSetState(() {});
                                                          return;
                                                        }
                                                      } else {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Mensaje'),
                                                              content: Text(
                                                                  'Hubo un error al agregar la locación'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext),
                                                                  child: Text(
                                                                      'Ok'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        if (_shouldSetState)
                                                          safeSetState(() {});
                                                        return;
                                                      }
                                                    } else {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title:
                                                                Text('Mensaje'),
                                                            content: Text(
                                                                'Hubo un error al agregar la locación'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                      if (_shouldSetState)
                                                        safeSetState(() {});
                                                      return;
                                                    }
                                                  }
                                                } else {
                                                  if (!(getJsonField(
                                                        widget!.dataActivity,
                                                        r'''$[:].location''',
                                                      ) !=
                                                      null)) {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Mensaje'),
                                                          content: Text(
                                                              'La ubicación es obligatoria'),
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
                                                    if (_shouldSetState)
                                                      safeSetState(() {});
                                                    return;
                                                  }
                                                }

                                                _model.responseUpdateActivity =
                                                    await UpdateActivityCall
                                                        .call(
                                                  name: (String name) {
                                                    return name.replaceAll(
                                                        '\n', '\\n');
                                                  }(_model
                                                      .nameActivityTextController
                                                      .text),
                                                  description: (String
                                                      description) {
                                                    return description
                                                        .replaceAll(
                                                            '\n', '\\n');
                                                  }(_model
                                                      .descriptionActivityTextController
                                                      .text),
                                                  type:
                                                      _model.typeActivityValue,
                                                  inclutions: (String
                                                      inclutions) {
                                                    return inclutions
                                                        .replaceAll(
                                                            '\n', '\\n');
                                                  }(_model
                                                      .inclutionActivityTextController
                                                      .text),
                                                  exclutions: (String
                                                      exclutions) {
                                                    return exclutions
                                                        .replaceAll(
                                                            '\n', '\\n');
                                                  }(_model
                                                      .notIcludeActivityTextController
                                                      .text),
                                                  recomendations: (String
                                                      recomendations) {
                                                    return recomendations
                                                        .replaceAll(
                                                            '\n', '\\n');
                                                  }(_model
                                                      .recomendationsActivityTextController
                                                      .text),
                                                  instructions: (String
                                                      instructions) {
                                                    return instructions
                                                        .replaceAll(
                                                            '\n', '\\n');
                                                  }(_model
                                                      .instructionsActivityTextController
                                                      .text),
                                                  id: getJsonField(
                                                    widget!.dataActivity,
                                                    r'''$[:].id''',
                                                  ).toString(),
                                                  authToken: currentJwtToken,
                                                  descriptionShort: (String
                                                      description) {
                                                    return description
                                                        .replaceAll(
                                                            '\n', '\\n');
                                                  }(_model
                                                      .descriptionShortActivityTextController
                                                      .text),
                                                );

                                                _shouldSetState = true;
                                                if ((_model
                                                        .responseUpdateActivity
                                                        ?.succeeded ??
                                                    true)) {
                                                  context
                                                      .read<UiStateService>()
                                                      .selectedLocationLatLng = '';
                                                  context
                                                      .read<UiStateService>()
                                                      .selectedLocationName = '';
                                                  context
                                                      .read<UiStateService>()
                                                      .selectedLocationAddress = '';
                                                  context
                                                      .read<UiStateService>()
                                                      .selectedLocationCity = '';
                                                  context
                                                      .read<UiStateService>()
                                                      .selectedLocationState = '';
                                                  context
                                                      .read<UiStateService>()
                                                      .selectedLocationCountry = '';
                                                  context
                                                      .read<UiStateService>()
                                                      .selectedLocationZipCode = '';
                                                  safeSetState(() {});
                                                  _model.responseInsertLocationState =
                                                      null;
                                                  safeSetState(() {});
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text('Error'),
                                                        content: Text((_model
                                                                    .responseUpdateActivity
                                                                    ?.jsonBody ??
                                                                '')
                                                            .toString()),
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
                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                }
                                              } else {
                                                if (context
                                                        .read<UiStateService>()
                                                        .selectedProductType ==
                                                    'hotels') {
                                                  if (context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationLatLng !=
                                                      'LatLng(lat: 0, lng: 0)') {
                                                    _model.apiResponseUpdateLocationHotels =
                                                        await UpdateLocationsCall
                                                            .call(
                                                      latlng: context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationLatLng,
                                                      name: context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationName,
                                                      address: context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationAddress,
                                                      city: context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationCity,
                                                      state: context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationState,
                                                      country: context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationCountry,
                                                      zipCode: context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationZipCode,
                                                      id: getJsonField(
                                                        widget!.dataActivity,
                                                        r'''$[:].location''',
                                                      ).toString(),
                                                      authToken:
                                                          currentJwtToken,
                                                    );

                                                    _shouldSetState = true;
                                                    if ((_model
                                                            .apiResponseUpdateLocationHotels
                                                            ?.succeeded ??
                                                        true)) {
                                                      _model.responseInsertLocationState =
                                                          (_model.apiResponseUpdateLocationActivities
                                                                      ?.jsonBody ??
                                                                  '')
                                                              .toString();
                                                      safeSetState(() {});
                                                    } else {
                                                      if ((_model.apiResponseUpdateLocationHotels
                                                                  ?.exceptionMessage ??
                                                              '') ==
                                                          '${null}') {
                                                        _model.responseInsertLocationHotels =
                                                            await InsertLocationsCall
                                                                .call(
                                                          authToken:
                                                              currentJwtToken,
                                                          latlng: context
                                                              .read<
                                                                  UiStateService>()
                                                              .selectedLocationLatLng,
                                                          name: context
                                                              .read<
                                                                  UiStateService>()
                                                              .selectedLocationName,
                                                          address: context
                                                              .read<
                                                                  UiStateService>()
                                                              .selectedLocationAddress,
                                                          city: context
                                                              .read<
                                                                  UiStateService>()
                                                              .selectedLocationCity,
                                                          state: context
                                                              .read<
                                                                  UiStateService>()
                                                              .selectedLocationState,
                                                          country: context
                                                              .read<
                                                                  UiStateService>()
                                                              .selectedLocationCountry,
                                                          zipCode: context
                                                              .read<
                                                                  UiStateService>()
                                                              .selectedLocationZipCode,
                                                          accountId: appServices
                                                              .account
                                                              .accountId!,
                                                          typeEntity: 'hotels',
                                                        );

                                                        _shouldSetState = true;
                                                        if ((_model
                                                                .responseInsertLocationHotels
                                                                ?.succeeded ??
                                                            true)) {
                                                          _model.apiResponseInsertLocationHotels =
                                                              await InsertLocationByTypeCall
                                                                  .call(
                                                            authToken:
                                                                currentJwtToken,
                                                            locationId: (_model
                                                                        .responseInsertLocationHotels
                                                                        ?.jsonBody ??
                                                                    '')
                                                                .toString(),
                                                            searchId:
                                                                getJsonField(
                                                              widget!
                                                                  .dataActivity,
                                                              r'''$[:].id''',
                                                            ).toString(),
                                                            type: 'hotels',
                                                          );

                                                          _shouldSetState =
                                                              true;
                                                          if (!(_model
                                                                  .apiResponseInsertLocationHotels
                                                                  ?.succeeded ??
                                                              true)) {
                                                            await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (alertDialogContext) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Mensaje'),
                                                                  content: Text(
                                                                      'Error al agregar ubicación'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                      child: Text(
                                                                          'Ok'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                            if (_shouldSetState)
                                                              safeSetState(
                                                                  () {});
                                                            return;
                                                          }
                                                        } else {
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (alertDialogContext) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Mensaje'),
                                                                content: Text(
                                                                    'Error al agregar ubicación'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            alertDialogContext),
                                                                    child: Text(
                                                                        'Ok'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                          if (_shouldSetState)
                                                            safeSetState(() {});
                                                          return;
                                                        }
                                                      } else {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Mensaje'),
                                                              content: Text(
                                                                  'Hubo un error al agregar la locación'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext),
                                                                  child: Text(
                                                                      'Ok'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        if (_shouldSetState)
                                                          safeSetState(() {});
                                                        return;
                                                      }
                                                    }
                                                  } else {
                                                    if (!(getJsonField(
                                                          widget!.dataActivity,
                                                          r'''$[:].location''',
                                                        ) !=
                                                        null)) {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title:
                                                                Text('Mensaje'),
                                                            content: Text(
                                                                'La ubicación es obligatoria'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                      if (_shouldSetState)
                                                        safeSetState(() {});
                                                      return;
                                                    }
                                                  }

                                                  _model.responseUpdateHotel =
                                                      await UpdateHotelsCall
                                                          .call(
                                                    name: (String name) {
                                                      return name.replaceAll(
                                                          '\n', '\\n');
                                                    }(_model
                                                        .nameActivityTextController
                                                        .text),
                                                    description: (String
                                                        description) {
                                                      return description
                                                          .replaceAll(
                                                              '\n', '\\n');
                                                    }(_model
                                                        .descriptionActivityTextController
                                                        .text),
                                                    inclutions: (String
                                                        inclutions) {
                                                      return inclutions
                                                          .replaceAll(
                                                              '\n', '\\n');
                                                    }(_model
                                                        .inclutionActivityTextController
                                                        .text),
                                                    exclutions: (String
                                                        exclutions) {
                                                      return exclutions
                                                          .replaceAll(
                                                              '\n', '\\n');
                                                    }(_model
                                                        .notIcludeActivityTextController
                                                        .text),
                                                    recomendations: (String
                                                        recomendations) {
                                                      return recomendations
                                                          .replaceAll(
                                                              '\n', '\\n');
                                                    }(_model
                                                        .recomendationsActivityTextController
                                                        .text),
                                                    instructions: (String
                                                        instructions) {
                                                      return instructions
                                                          .replaceAll(
                                                              '\n', '\\n');
                                                    }(_model
                                                        .instructionsActivityTextController
                                                        .text),
                                                    id: getJsonField(
                                                      widget!.dataActivity,
                                                      r'''$[:].id''',
                                                    ).toString(),
                                                    authToken: currentJwtToken,
                                                    descriptionShort: (String
                                                        description) {
                                                      return description
                                                          .replaceAll(
                                                              '\n', '\\n');
                                                    }(_model
                                                        .descriptionShortActivityTextController
                                                        .text),
                                                  );

                                                  _shouldSetState = true;
                                                  if ((_model
                                                          .responseUpdateHotel
                                                          ?.succeeded ??
                                                      true)) {
                                                    context
                                                        .read<UiStateService>()
                                                        .selectedLocationLatLng = '';
                                                    context
                                                        .read<UiStateService>()
                                                        .selectedLocationName = '';
                                                    context
                                                        .read<UiStateService>()
                                                        .selectedLocationAddress = '';
                                                    context
                                                        .read<UiStateService>()
                                                        .selectedLocationCity = '';
                                                    context
                                                        .read<UiStateService>()
                                                        .selectedLocationState = '';
                                                    context
                                                        .read<UiStateService>()
                                                        .selectedLocationCountry = '';
                                                    context
                                                        .read<UiStateService>()
                                                        .selectedLocationZipCode = '';
                                                    safeSetState(() {});
                                                    _model.responseInsertLocationState =
                                                        null;
                                                    safeSetState(() {});
                                                  } else {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title: Text('Error'),
                                                          content: Text((_model
                                                                  .responseUpdateActivity
                                                                  ?.exceptionMessage ??
                                                              '')),
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
                                                    if (_shouldSetState)
                                                      safeSetState(() {});
                                                    return;
                                                  }
                                                } else {
                                                  if (context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedProductType ==
                                                      'transfers') {
                                                    if (context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationLatLng !=
                                                        'LatLng(lat: 0, lng: 0)') {
                                                      _model.apiResponseUpdateLocationTransfers =
                                                          await UpdateLocationsCall
                                                              .call(
                                                        latlng: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationLatLng,
                                                        name: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationName,
                                                        address: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationAddress,
                                                        city: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationCity,
                                                        state: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationState,
                                                        country: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationCountry,
                                                        zipCode: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationZipCode,
                                                        id: getJsonField(
                                                          widget!.dataActivity,
                                                          r'''$[:].location''',
                                                        ).toString(),
                                                        authToken:
                                                            currentJwtToken,
                                                      );

                                                      _shouldSetState = true;
                                                      if ((_model
                                                              .apiResponseUpdateLocationTransfers
                                                              ?.succeeded ??
                                                          true)) {
                                                        _model.responseInsertLocationState =
                                                            (_model.apiResponseUpdateLocationActivities
                                                                        ?.jsonBody ??
                                                                    '')
                                                                .toString();
                                                        safeSetState(() {});
                                                      } else {
                                                        if ((_model.apiResponseUpdateLocationTransfers
                                                                    ?.exceptionMessage ??
                                                                '') ==
                                                            '${null}') {
                                                          _model.responseInsertLocationTransfers =
                                                              await InsertLocationsCall
                                                                  .call(
                                                            authToken:
                                                                currentJwtToken,
                                                            latlng: context
                                                                .read<
                                                                    UiStateService>()
                                                                .selectedLocationLatLng,
                                                            name: context
                                                                .read<
                                                                    UiStateService>()
                                                                .selectedLocationName,
                                                            address: context
                                                                .read<
                                                                    UiStateService>()
                                                                .selectedLocationAddress,
                                                            city: context
                                                                .read<
                                                                    UiStateService>()
                                                                .selectedLocationCity,
                                                            state: context
                                                                .read<
                                                                    UiStateService>()
                                                                .selectedLocationState,
                                                            country: context
                                                                .read<
                                                                    UiStateService>()
                                                                .selectedLocationCountry,
                                                            zipCode: context
                                                                .read<
                                                                    UiStateService>()
                                                                .selectedLocationZipCode,
                                                            accountId:
                                                                appServices
                                                                    .account
                                                                    .accountId!,
                                                            typeEntity:
                                                                'transfers',
                                                          );

                                                          _shouldSetState =
                                                              true;
                                                          if ((_model
                                                                  .responseInsertLocationTransfers
                                                                  ?.succeeded ??
                                                              true)) {
                                                            _model.apiResponseInsertLocationTransfers =
                                                                await InsertLocationByTypeCall
                                                                    .call(
                                                              authToken:
                                                                  currentJwtToken,
                                                              locationId: (_model
                                                                          .responseInsertLocationTransfers
                                                                          ?.jsonBody ??
                                                                      '')
                                                                  .toString(),
                                                              searchId:
                                                                  getJsonField(
                                                                widget!
                                                                    .dataActivity,
                                                                r'''$[:].id''',
                                                              ).toString(),
                                                              type: 'transfers',
                                                            );

                                                            _shouldSetState =
                                                                true;
                                                            if (!(_model
                                                                    .apiResponseInsertLocationTransfers
                                                                    ?.succeeded ??
                                                                true)) {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (alertDialogContext) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Mensaje'),
                                                                    content: Text(
                                                                        'Error al agregar ubicación'),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(alertDialogContext),
                                                                        child: Text(
                                                                            'Ok'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                              if (_shouldSetState)
                                                                safeSetState(
                                                                    () {});
                                                              return;
                                                            }
                                                          } else {
                                                            await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (alertDialogContext) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Mensaje'),
                                                                  content: Text(
                                                                      'Error al agregar ubicación'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                      child: Text(
                                                                          'Ok'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                            if (_shouldSetState)
                                                              safeSetState(
                                                                  () {});
                                                            return;
                                                          }
                                                        } else {
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (alertDialogContext) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Mensaje'),
                                                                content: Text(
                                                                    'Hubo un error al agregar la locación'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            alertDialogContext),
                                                                    child: Text(
                                                                        'Ok'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                          if (_shouldSetState)
                                                            safeSetState(() {});
                                                          return;
                                                        }
                                                      }
                                                    } else {
                                                      if (!(getJsonField(
                                                            widget!
                                                                .dataActivity,
                                                            r'''$[:].location''',
                                                          ) !=
                                                          null)) {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Mensaje'),
                                                              content: Text(
                                                                  'La ubicación es obligatoria'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext),
                                                                  child: Text(
                                                                      'Ok'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        if (_shouldSetState)
                                                          safeSetState(() {});
                                                        return;
                                                      }
                                                    }

                                                    _model.resultUpdateTransfers =
                                                        await UpdateTransfersCall
                                                            .call(
                                                      id: getJsonField(
                                                        widget!.dataActivity,
                                                        r'''$[:].id''',
                                                      ).toString(),
                                                      name: (String name) {
                                                        return name.replaceAll(
                                                            '\n', '\\n');
                                                      }(_model
                                                          .nameActivityTextController
                                                          .text),
                                                      description: (String
                                                          description) {
                                                        return description
                                                            .replaceAll(
                                                                '\n', '\\n');
                                                      }(_model
                                                          .descriptionActivityTextController
                                                          .text),
                                                      inclutions: (String
                                                          inclutions) {
                                                        return inclutions
                                                            .replaceAll(
                                                                '\n', '\\n');
                                                      }(_model
                                                          .inclutionActivityTextController
                                                          .text),
                                                      exclutions: (String
                                                          exclutions) {
                                                        return exclutions
                                                            .replaceAll(
                                                                '\n', '\\n');
                                                      }(_model
                                                          .notIcludeActivityTextController
                                                          .text),
                                                      recomendations: (String
                                                          recomendations) {
                                                        return recomendations
                                                            .replaceAll(
                                                                '\n', '\\n');
                                                      }(_model
                                                          .recomendationsActivityTextController
                                                          .text),
                                                      instructions: (String
                                                          instructions) {
                                                        return instructions
                                                            .replaceAll(
                                                                '\n', '\\n');
                                                      }(_model
                                                          .instructionsActivityTextController
                                                          .text),
                                                      authToken:
                                                          currentJwtToken,
                                                      descriptionShort: (String
                                                          description) {
                                                        return description
                                                            .replaceAll(
                                                                '\n', '\\n');
                                                      }(_model
                                                          .descriptionShortActivityTextController
                                                          .text),
                                                    );

                                                    _shouldSetState = true;
                                                    if ((_model
                                                            .resultUpdateTransfers
                                                            ?.succeeded ??
                                                        true)) {
                                                      context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationLatLng = '';
                                                      context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationName = '';
                                                      context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationAddress = '';
                                                      context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationCity = '';
                                                      context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationState = '';
                                                      context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationCountry = '';
                                                      context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationZipCode = '';
                                                      safeSetState(() {});
                                                      _model.responseInsertLocationState =
                                                          null;
                                                      safeSetState(() {});
                                                    } else {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title:
                                                                Text('Mensaje'),
                                                            content: Text(
                                                                'Error al editar transfer'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                      if (_shouldSetState)
                                                        safeSetState(() {});
                                                      return;
                                                    }
                                                  } else {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title: Text('Error'),
                                                          content: Text(
                                                              'Se debe seleccionar un producto'),
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
                                                    if (_shouldSetState)
                                                      safeSetState(() {});
                                                    return;
                                                  }
                                                }
                                              }

                                              context.safePop();
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text('Mensaje'),
                                                    content: Text(
                                                        'Todos los campos son obligatorios'),
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
                                              if (_shouldSetState)
                                                safeSetState(() {});
                                              return;
                                            }

                                            if (_shouldSetState)
                                              safeSetState(() {});
                                          },
                                          text: 'Guardar',
                                          options: FFButtonOptions(
                                            height: 44.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    24.0, 0.0, 24.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallFamily,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallIsCustom,
                                                    ),
                                            elevation: 3.0,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                BukeerSpacing.s),
                                            hoverColor:
                                                FlutterFlowTheme.of(context)
                                                    .accent1,
                                            hoverBorderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 1.0,
                                            ),
                                            hoverTextColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            hoverElevation: 0.0,
                                          ),
                                        ),
                                      ),
                                    if (widget!.actionType == 'add')
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.05),
                                        child: FFButtonWidget(
                                          onPressed: () async {
                                            var _shouldSetState = false;
                                            _model.responseFormAddProduct =
                                                true;
                                            if (_model.formKey.currentState ==
                                                    null ||
                                                !_model.formKey.currentState!
                                                    .validate()) {
                                              _model.responseFormAddProduct =
                                                  false;
                                            }
                                            if (_model.typeActivityValue ==
                                                null) {
                                              _model.responseFormAddProduct =
                                                  false;
                                            }
                                            _shouldSetState = true;
                                            context
                                                    .read<UiStateService>()
                                                    .selectedLocationLatLng =
                                                _model.placePickerModel
                                                    .placePickerValue.latLng
                                                    .toString();
                                            context
                                                    .read<UiStateService>()
                                                    .selectedLocationName =
                                                _model.placePickerModel
                                                    .placePickerValue.name;
                                            context
                                                    .read<UiStateService>()
                                                    .selectedLocationAddress =
                                                _model.placePickerModel
                                                    .placePickerValue.address;
                                            context
                                                    .read<UiStateService>()
                                                    .selectedLocationCity =
                                                _model.placePickerModel
                                                    .placePickerValue.city;
                                            context
                                                    .read<UiStateService>()
                                                    .selectedLocationState =
                                                _model.placePickerModel
                                                    .placePickerValue.state;
                                            context
                                                    .read<UiStateService>()
                                                    .selectedLocationCountry =
                                                _model.placePickerModel
                                                    .placePickerValue.country;
                                            context
                                                    .read<UiStateService>()
                                                    .selectedLocationZipCode =
                                                _model.placePickerModel
                                                    .placePickerValue.zipCode;
                                            safeSetState(() {});
                                            if (_model
                                                .responseFormAddProduct!) {
                                              if (context
                                                      .read<UiStateService>()
                                                      .selectedProductType ==
                                                  'activities') {
                                                if (context
                                                        .read<UiStateService>()
                                                        .selectedLocationLatLng !=
                                                    'LatLng(lat: 0, lng: 0)') {
                                                  _model.apiResultAddLocationActivities =
                                                      await InsertLocationsCall
                                                          .call(
                                                    authToken: currentJwtToken,
                                                    latlng: context
                                                        .read<UiStateService>()
                                                        .selectedLocationLatLng,
                                                    name: context
                                                        .read<UiStateService>()
                                                        .selectedLocationName,
                                                    address: context
                                                        .read<UiStateService>()
                                                        .selectedLocationAddress,
                                                    city: context
                                                        .read<UiStateService>()
                                                        .selectedLocationCity,
                                                    state: context
                                                        .read<UiStateService>()
                                                        .selectedLocationState,
                                                    country: context
                                                        .read<UiStateService>()
                                                        .selectedLocationCountry,
                                                    zipCode: context
                                                        .read<UiStateService>()
                                                        .selectedLocationZipCode,
                                                    accountId: appServices
                                                        .account.accountId!,
                                                    typeEntity: 'activities',
                                                  );

                                                  _shouldSetState = true;
                                                  if (!(_model
                                                          .apiResultAddLocationActivities
                                                          ?.succeeded ??
                                                      true)) {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Mensaje'),
                                                          content: Text((_model
                                                                      .apiResultAddLocationActivities
                                                                      ?.jsonBody ??
                                                                  '')
                                                              .toString()),
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
                                                    if (_shouldSetState)
                                                      safeSetState(() {});
                                                    return;
                                                  }
                                                  _model.responseAddActivity =
                                                      await AddActivityCall
                                                          .call(
                                                    name: (String name) {
                                                      return name.replaceAll(
                                                          '\n', '\\n');
                                                    }(_model
                                                        .nameActivityTextController
                                                        .text),
                                                    description: (String
                                                        description) {
                                                      return description
                                                          .replaceAll(
                                                              '\n', '\\n');
                                                    }(_model
                                                        .descriptionActivityTextController
                                                        .text),
                                                    inclutions: (String
                                                        inclutions) {
                                                      return inclutions
                                                          .replaceAll(
                                                              '\n', '\\n');
                                                    }(_model
                                                        .inclutionActivityTextController
                                                        .text),
                                                    type: _model
                                                        .typeActivityValue,
                                                    exclutions: (String
                                                        exclutions) {
                                                      return exclutions
                                                          .replaceAll(
                                                              '\n', '\\n');
                                                    }(_model
                                                        .notIcludeActivityTextController
                                                        .text),
                                                    recomendations: (String
                                                        recomendations) {
                                                      return recomendations
                                                          .replaceAll(
                                                              '\n', '\\n');
                                                    }(_model
                                                        .recomendationsActivityTextController
                                                        .text),
                                                    instructions: (String
                                                        instructions) {
                                                      return instructions
                                                          .replaceAll(
                                                              '\n', '\\n');
                                                    }(_model
                                                        .instructionsActivityTextController
                                                        .text),
                                                    idContact:
                                                        widget!.idContact,
                                                    authToken: currentJwtToken,
                                                    accountId: appServices
                                                        .account.accountId!,
                                                    location: (_model
                                                                .apiResultAddLocationActivities
                                                                ?.jsonBody ??
                                                            '')
                                                        .toString(),
                                                    descriptionShort: (String
                                                        description) {
                                                      return description
                                                          .replaceAll(
                                                              '\n', '\\n');
                                                    }(_model
                                                        .descriptionShortActivityTextController
                                                        .text),
                                                  );

                                                  _shouldSetState = true;
                                                  if ((_model
                                                          .responseAddActivity
                                                          ?.succeeded ??
                                                      true)) {
                                                  } else {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Mensaje'),
                                                          content: Text((_model
                                                                      .responseAddActivity
                                                                      ?.jsonBody ??
                                                                  '')
                                                              .toString()),
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
                                                    if (_shouldSetState)
                                                      safeSetState(() {});
                                                    return;
                                                  }

                                                  context
                                                      .read<UiStateService>()
                                                      .selectedLocationLatLng = '';
                                                  context
                                                      .read<UiStateService>()
                                                      .selectedLocationName = '';
                                                  context
                                                      .read<UiStateService>()
                                                      .selectedLocationAddress = '';
                                                  context
                                                      .read<UiStateService>()
                                                      .selectedLocationCity = '';
                                                  context
                                                      .read<UiStateService>()
                                                      .selectedLocationState = '';
                                                  context
                                                      .read<UiStateService>()
                                                      .selectedLocationCountry = '';
                                                  context
                                                      .read<UiStateService>()
                                                      .selectedLocationZipCode = '';
                                                  safeSetState(() {});
                                                  context.safePop();
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child:
                                                            ModalDetailsProductWidget(
                                                          dataActivity: (_model
                                                                  .responseAddActivity
                                                                  ?.jsonBody ??
                                                              ''),
                                                          type: () {
                                                            switch (context
                                                                .read<
                                                                    UiStateService>()
                                                                .selectedProductType) {
                                                              case 1:
                                                                return 'flights';
                                                              case 2:
                                                                return 'hotels';
                                                              case 3:
                                                                return 'activities';
                                                              case 4:
                                                                return 'transfers';
                                                              default:
                                                                return 'activities';
                                                            }
                                                          }(),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));

                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text('Mensaje'),
                                                        content: Text(
                                                            'La ubicación es obligatoria'),
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
                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                }
                                              } else {
                                                if (context
                                                        .read<UiStateService>()
                                                        .selectedProductType ==
                                                    'hotels') {
                                                  if (context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationLatLng !=
                                                      'LatLng(lat: 0, lng: 0)') {
                                                    _model.apiResultAddLocationHotels =
                                                        await InsertLocationsCall
                                                            .call(
                                                      authToken:
                                                          currentJwtToken,
                                                      latlng: context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationLatLng,
                                                      name: context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationName,
                                                      address: context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationAddress,
                                                      city: context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationCity,
                                                      state: context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationState,
                                                      country: context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationCountry,
                                                      zipCode: context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationZipCode,
                                                      accountId: appServices
                                                          .account.accountId!,
                                                      typeEntity: 'hotels',
                                                    );

                                                    _shouldSetState = true;
                                                    if ((_model
                                                            .apiResultAddLocationHotels
                                                            ?.succeeded ??
                                                        true)) {
                                                    } else {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title:
                                                                Text('Mensaje'),
                                                            content: Text((_model
                                                                        .apiResultAddLocationHotels
                                                                        ?.jsonBody ??
                                                                    '')
                                                                .toString()),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                      if (_shouldSetState)
                                                        safeSetState(() {});
                                                      return;
                                                    }

                                                    _model.responseAddHotel =
                                                        await HotelsTable()
                                                            .insert({
                                                      'name': (String name) {
                                                        return name.replaceAll(
                                                            '\n', '\\n');
                                                      }(_model
                                                          .nameActivityTextController
                                                          .text),
                                                      'description': (String
                                                          description) {
                                                        return description
                                                            .replaceAll(
                                                                '\n', '\\n');
                                                      }(_model
                                                          .descriptionActivityTextController
                                                          .text),
                                                      'inclutions': (String
                                                          inclution) {
                                                        return inclution
                                                            .replaceAll(
                                                                '\n', '\\n');
                                                      }(_model
                                                          .inclutionActivityTextController
                                                          .text),
                                                      'exclutions': (String
                                                          exclutions) {
                                                        return exclutions
                                                            .replaceAll(
                                                                '\n', '\\n');
                                                      }(_model
                                                          .notIcludeActivityTextController
                                                          .text),
                                                      'recomendations': (String
                                                          recomendations) {
                                                        return recomendations
                                                            .replaceAll(
                                                                '\n', '\\n');
                                                      }(_model
                                                          .recomendationsActivityTextController
                                                          .text),
                                                      'instructions': (String
                                                          instructions) {
                                                        return instructions
                                                            .replaceAll(
                                                                '\n', '\\n');
                                                      }(_model
                                                          .instructionsActivityTextController
                                                          .text),
                                                      'id_contact':
                                                          widget!.idContact,
                                                      'location': (_model
                                                                  .apiResultAddLocationHotels
                                                                  ?.jsonBody ??
                                                              '')
                                                          .toString(),
                                                      'account_id': appServices
                                                          .account.accountId!,
                                                      'description_short': (String
                                                          description) {
                                                        return description
                                                            .replaceAll(
                                                                '\n', '\\n');
                                                      }(_model
                                                          .descriptionShortActivityTextController
                                                          .text),
                                                    });
                                                    _shouldSetState = true;
                                                    context
                                                        .read<UiStateService>()
                                                        .selectedLocationLatLng = '';
                                                    context
                                                        .read<UiStateService>()
                                                        .selectedLocationName = '';
                                                    context
                                                        .read<UiStateService>()
                                                        .selectedLocationAddress = '';
                                                    context
                                                        .read<UiStateService>()
                                                        .selectedLocationCity = '';
                                                    context
                                                        .read<UiStateService>()
                                                        .selectedLocationState = '';
                                                    context
                                                        .read<UiStateService>()
                                                        .selectedLocationCountry = '';
                                                    context
                                                        .read<UiStateService>()
                                                        .selectedLocationZipCode = '';
                                                    safeSetState(() {});
                                                    context.safePop();
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              ModalDetailsProductWidget(
                                                            dataActivity: <String,
                                                                dynamic>{
                                                              'id': _model
                                                                  .responseAddHotel
                                                                  ?.id,
                                                            },
                                                            type: () {
                                                              switch (context
                                                                  .read<
                                                                      UiStateService>()
                                                                  .selectedProductType) {
                                                                case 1:
                                                                  return 'flights';
                                                                case 2:
                                                                  return 'hotels';
                                                                case 3:
                                                                  return 'activities';
                                                                case 4:
                                                                  return 'transfers';
                                                                default:
                                                                  return 'activities';
                                                              }
                                                            }(),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  } else {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Mensaje'),
                                                          content: Text(
                                                              'La ubicación es obligatoria'),
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
                                                    if (_shouldSetState)
                                                      safeSetState(() {});
                                                    return;
                                                  }
                                                } else {
                                                  if (context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedProductType ==
                                                      'transfers') {
                                                    if (context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationLatLng !=
                                                        'LatLng(lat: 0, lng: 0)') {
                                                      _model.apiResultAddLocationTransfers =
                                                          await InsertLocationsCall
                                                              .call(
                                                        authToken:
                                                            currentJwtToken,
                                                        latlng: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationLatLng,
                                                        name: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationName,
                                                        address: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationAddress,
                                                        city: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationCity,
                                                        state: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationState,
                                                        country: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationCountry,
                                                        zipCode: context
                                                            .read<
                                                                UiStateService>()
                                                            .selectedLocationZipCode,
                                                        accountId: appServices
                                                            .account.accountId!,
                                                        typeEntity: 'transfers',
                                                      );

                                                      _shouldSetState = true;
                                                      if ((_model
                                                              .apiResultAddLocationTransfers
                                                              ?.succeeded ??
                                                          true)) {
                                                      } else {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Mensaje'),
                                                              content: Text((_model
                                                                          .apiResultAddLocationTransfers
                                                                          ?.jsonBody ??
                                                                      '')
                                                                  .toString()),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext),
                                                                  child: Text(
                                                                      'Ok'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        if (_shouldSetState)
                                                          safeSetState(() {});
                                                        return;
                                                      }

                                                      _model.responseAddTransfer =
                                                          await TransfersTable()
                                                              .insert({
                                                        'name': (String name) {
                                                          return name
                                                              .replaceAll(
                                                                  '\n', '\\n');
                                                        }(_model
                                                            .nameActivityTextController
                                                            .text),
                                                        'description': (String
                                                            description) {
                                                          return description
                                                              .replaceAll(
                                                                  '\n', '\\n');
                                                        }(_model
                                                            .descriptionActivityTextController
                                                            .text),
                                                        'inclutions': (String
                                                            inclutions) {
                                                          return inclutions
                                                              .replaceAll(
                                                                  '\n', '\\n');
                                                        }(_model
                                                            .inclutionActivityTextController
                                                            .text),
                                                        'exclutions': (String
                                                            exclutions) {
                                                          return exclutions
                                                              .replaceAll(
                                                                  '\n', '\\n');
                                                        }(_model
                                                            .notIcludeActivityTextController
                                                            .text),
                                                        'recomendations': (String
                                                            recomendations) {
                                                          return recomendations
                                                              .replaceAll(
                                                                  '\n', '\\n');
                                                        }(_model
                                                            .recomendationsActivityTextController
                                                            .text),
                                                        'instructions': (String
                                                            instructions) {
                                                          return instructions
                                                              .replaceAll(
                                                                  '\n', '\\n');
                                                        }(_model
                                                            .instructionsActivityTextController
                                                            .text),
                                                        'id_contact':
                                                            widget!.idContact,
                                                        'location': (_model
                                                                    .apiResultAddLocationTransfers
                                                                    ?.jsonBody ??
                                                                '')
                                                            .toString(),
                                                        'account_id':
                                                            appServices.account
                                                                .accountId!,
                                                        'description_short': (String
                                                            description) {
                                                          return description
                                                              .replaceAll(
                                                                  '\n', '\\n');
                                                        }(_model
                                                            .descriptionShortActivityTextController
                                                            .text),
                                                      });
                                                      _shouldSetState = true;
                                                      context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationLatLng = '';
                                                      context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationName = '';
                                                      context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationAddress = '';
                                                      context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationCity = '';
                                                      context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationState = '';
                                                      context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationCountry = '';
                                                      context
                                                          .read<
                                                              UiStateService>()
                                                          .selectedLocationZipCode = '';
                                                      safeSetState(() {});
                                                      context.safePop();
                                                      await showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        enableDrag: false,
                                                        context: context,
                                                        builder: (context) {
                                                          return Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                ModalDetailsProductWidget(
                                                              dataActivity: <String,
                                                                  dynamic>{
                                                                'id': _model
                                                                    .responseAddTransfer
                                                                    ?.id,
                                                              },
                                                              type: () {
                                                                switch (context
                                                                    .read<
                                                                        UiStateService>()
                                                                    .selectedProductType) {
                                                                  case 1:
                                                                    return 'flights';
                                                                  case 2:
                                                                    return 'hotels';
                                                                  case 3:
                                                                    return 'activities';
                                                                  case 4:
                                                                    return 'transfers';
                                                                  default:
                                                                    return 'activities';
                                                                }
                                                              }(),
                                                            ),
                                                          );
                                                        },
                                                      ).then((value) =>
                                                          safeSetState(() {}));
                                                    } else {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title:
                                                                Text('Mensaje'),
                                                            content: Text(
                                                                'La ubicación es obligatoria'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                      if (_shouldSetState)
                                                        safeSetState(() {});
                                                      return;
                                                    }
                                                  } else {
                                                    if (_shouldSetState)
                                                      safeSetState(() {});
                                                    return;
                                                  }

                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                }

                                                if (_shouldSetState)
                                                  safeSetState(() {});
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
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              if (_shouldSetState)
                                                safeSetState(() {});
                                              return;
                                            }

                                            if (_shouldSetState)
                                              safeSetState(() {});
                                          },
                                          text: 'Agregar',
                                          options: FFButtonOptions(
                                            height: 44.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    24.0, 0.0, 24.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallFamily,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallIsCustom,
                                                    ),
                                            elevation: 3.0,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                BukeerSpacing.s),
                                            hoverColor:
                                                FlutterFlowTheme.of(context)
                                                    .accent1,
                                            hoverBorderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 1.0,
                                            ),
                                            hoverTextColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            hoverElevation: 0.0,
                                          ),
                                        ),
                                      ),
                                  ].divide(SizedBox(width: 25.0)),
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
            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
          ),
        ],
      ),
    );
  }
}
