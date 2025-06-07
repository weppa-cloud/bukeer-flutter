import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../backend/supabase/supabase.dart';
import '../../../flutter_flow/flutter_flow_animations.dart';
import '../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'modal_add_user_model.dart';
import '../../../services/ui_state_service.dart';
import '../../../services/user_service.dart';
import '../../../services/app_services.dart';
export 'modal_add_user_model.dart';

class ModalAddUserWidget extends StatefulWidget {
  const ModalAddUserWidget({
    super.key,
    String? idContact,
    bool? isEdit,
  })  : this.idContact = idContact ?? '000047b1-0000-0000-0000-0000000047b1',
        this.isEdit = isEdit ?? false;

  final String idContact;
  final bool isEdit;

  @override
  State<ModalAddUserWidget> createState() => _ModalAddUserWidgetState();
}

class _ModalAddUserWidgetState extends State<ModalAddUserWidget>
    with TickerProviderStateMixin {
  late ModalAddUserModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalAddUserModel());

    _model.nameAgentTextController ??= TextEditingController(
        text: widget!.isEdit == true
            ? getJsonField(
                context.read<UserService>().allDataUser,
                r'''$.name''',
              ).toString().toString()
            : '');
    _model.nameAgentFocusNode ??= FocusNode();

    _model.lastNameAgentTextController ??= TextEditingController(
        text: widget!.isEdit == true
            ? getJsonField(
                context.read<UserService>().allDataUser,
                r'''$.last_name''',
              ).toString().toString()
            : '');
    _model.lastNameAgentFocusNode ??= FocusNode();

    _model.mailAgentTextController ??= TextEditingController();
    _model.mailAgentFocusNode ??= FocusNode();

    _model.passwordAgentTextController ??= TextEditingController();
    _model.passwordAgentFocusNode ??= FocusNode();

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
    context.watch<FFAppState>();

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: BukeerColors.neutral400,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 2.0, 0.0, 16.0),
            child: Container(
              height: MediaQuery.sizeOf(context).height * 1.0,
              constraints: BoxConstraints(
                maxWidth: 670.0,
              ),
              decoration: BoxDecoration(
                color: BukeerColors.secondaryBackground,
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
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(0.0),
                ),
              ),
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (widget!.isEdit == false)
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 60.0, 0.0, 40.0),
                              child: Text(
                                'Agregar Usuario',
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
                        if (widget!.isEdit == true)
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 60.0, 0.0, 40.0),
                              child: Text(
                                'Editar Usuario',
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
                        if (widget!.isEdit == true)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 60.0, 5.0, 40.0),
                            child: BukeerIconButton(
                              size: BukeerIconButtonSize.small,
                              variant: BukeerIconButtonVariant.outlined,
                              icon: FaIcon(
                                FontAwesomeIcons.trashAlt,
                                color: BukeerColors.primaryText,
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
                                  _model.responseContactsDeleted =
                                      await ContactsTable().delete(
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'id',
                                      getJsonField(
                                        context.read<UserService>().allDataUser,
                                        r'''$.id''',
                                      ).toString(),
                                    ),
                                    returnRows: true,
                                  );
                                  _model.responsUserRolDeleted =
                                      await UserRolesTable().delete(
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'id',
                                      getJsonField(
                                        context.read<UserService>().allDataUser,
                                        r'''$.id_user_rol''',
                                      ),
                                    ),
                                    returnRows: true,
                                  );
                                  context.read<UserService>().allDataUser =
                                      null;
                                  safeSetState(() {});
                                  Navigator.pop(context);
                                }

                                safeSetState(() {});
                              },
                            ),
                          ),
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(24.0, 5.0, 0.0, 5.0),
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
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 32.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Form(
                              key: _model.formKey,
                              autovalidateMode: AutovalidateMode.disabled,
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
                                        24.0, 5.0, 0.0, 5.0),
                                    child: Container(
                                      width: 297.0,
                                      child: TextFormField(
                                        controller:
                                            _model.nameAgentTextController,
                                        focusNode: _model.nameAgentFocusNode,
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Nombre',
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .labelMediumIsCustom,
                                              ),
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
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
                                            borderRadius: BorderRadius.circular(
                                                BukeerSpacing.s),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                BukeerSpacing.s),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
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
                                            borderRadius: BorderRadius.circular(
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
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        validator: _model
                                            .nameAgentTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 5.0, 24.0, 5.0),
                                    child: Container(
                                      width: 299.0,
                                      child: TextFormField(
                                        controller:
                                            _model.lastNameAgentTextController,
                                        focusNode:
                                            _model.lastNameAgentFocusNode,
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Apellido',
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .labelMediumIsCustom,
                                              ),
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
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
                                            borderRadius: BorderRadius.circular(
                                                BukeerSpacing.s),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                BukeerSpacing.s),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
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
                                            borderRadius: BorderRadius.circular(
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
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        validator: _model
                                            .lastNameAgentTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  if (widget!.isEdit == false)
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 5.0, 0.0, 5.0),
                                      child: Container(
                                        width: 297.0,
                                        child: TextFormField(
                                          controller:
                                              _model.mailAgentTextController,
                                          focusNode: _model.mailAgentFocusNode,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
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
                                          keyboardType: TextInputType.datetime,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          validator: _model
                                              .mailAgentTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                  if (widget!.isEdit == false)
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 5.0, 0.0, 5.0),
                                      child: Container(
                                        width: 297.0,
                                        child: TextFormField(
                                          controller: _model
                                              .passwordAgentTextController,
                                          focusNode:
                                              _model.passwordAgentFocusNode,
                                          autofocus: false,
                                          obscureText:
                                              !_model.passwordAgentVisibility,
                                          decoration: InputDecoration(
                                            labelText: 'Password',
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
                                            suffixIcon: InkWell(
                                              onTap: () => safeSetState(
                                                () => _model
                                                        .passwordAgentVisibility =
                                                    !_model
                                                        .passwordAgentVisibility,
                                              ),
                                              focusNode: FocusNode(
                                                  skipTraversal: true),
                                              child: Icon(
                                                _model.passwordAgentVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                size: 22,
                                              ),
                                            ),
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
                                          keyboardType: TextInputType.datetime,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          validator: _model
                                              .passwordAgentTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 5.0, 24.0, 5.0),
                                    child: FlutterFlowDropDown<String>(
                                      controller:
                                          _model.roleAgentValueController ??=
                                              FormFieldController<String>(
                                        _model.roleAgentValue ??=
                                            widget!.isEdit == true
                                                ? getJsonField(
                                                    context
                                                        .read<UserService>()
                                                        .allDataUser,
                                                    r'''$.user_rol''',
                                                  ).toString()
                                                : 'Seleccionar rol',
                                      ),
                                      options: ['Agente', 'Operaciones'],
                                      onChanged: (val) => safeSetState(
                                          () => _model.roleAgentValue = val),
                                      width: 250.0,
                                      height: 50.0,
                                      searchHintTextStyle: FlutterFlowTheme.of(
                                              context)
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
                                      hintText: 'Seleccionar rol',
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
                                      borderColor: FlutterFlowTheme.of(context)
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
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 8.0, 24.0, 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.05),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        context
                                            .read<UserService>()
                                            .allDataUser = null;
                                        safeSetState(() {});
                                        context.safePop();
                                      },
                                      text: 'Cancel',
                                      options: FFButtonOptions(
                                        height: 44.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
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
                                        elevation: 0.0,
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            BukeerSpacing.s),
                                        hoverColor: FlutterFlowTheme.of(context)
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
                                  if (widget!.isEdit == true)
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.0, 0.05),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          if ((_model.nameAgentTextController
                                                          .text !=
                                                      null &&
                                                  _model.nameAgentTextController
                                                          .text !=
                                                      '') &&
                                              (_model.roleAgentValue != null &&
                                                  _model.roleAgentValue !=
                                                      '')) {
                                            await UserRolesTable().update(
                                              data: {
                                                'role_id': () {
                                                  if (_model.roleAgentValue ==
                                                      'Agente') {
                                                    return 3;
                                                  } else if (_model
                                                          .roleAgentValue ==
                                                      'Operaciones') {
                                                    return 4;
                                                  } else {
                                                    return null;
                                                  }
                                                }(),
                                              },
                                              matchingRows: (rows) =>
                                                  rows.eqOrNull(
                                                'id',
                                                getJsonField(
                                                  context
                                                      .read<UserService>()
                                                      .allDataUser,
                                                  r'''$.id_user_rol''',
                                                ),
                                              ),
                                            );
                                            _model.apiResponseUpdateuserContact =
                                                await UpdateUserContactCall
                                                    .call(
                                              id: getJsonField(
                                                context
                                                    .read<UserService>()
                                                    .allDataUser,
                                                r'''$.id''',
                                              ).toString(),
                                              name: _model
                                                  .nameAgentTextController.text,
                                              lastName: _model
                                                  .lastNameAgentTextController
                                                  .text,
                                              userRol: _model.roleAgentValue,
                                              authToken: currentJwtToken,
                                            );

                                            if ((_model
                                                    .apiResponseUpdateuserContact
                                                    ?.succeeded ??
                                                true)) {
                                              context
                                                  .read<UserService>()
                                                  .allDataUser = null;
                                              safeSetState(() {});
                                              Navigator.pop(context);
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text('Mensaje'),
                                                    content: Text(
                                                        'Hubo un error inesperado.'),
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
                                                      'Algunos campos son obligatorios'),
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
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
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
                                            color: FlutterFlowTheme.of(context)
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
                                  if (widget!.isEdit == false)
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.0, 0.05),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          var _shouldSetState = false;
                                          _model.responseForm = true;
                                          if (_model.formKey.currentState ==
                                                  null ||
                                              !_model.formKey.currentState!
                                                  .validate()) {
                                            _model.responseForm = false;
                                          }
                                          if (_model.roleAgentValue == null) {
                                            _model.responseForm = false;
                                          }
                                          _shouldSetState = true;
                                          if (_model.responseForm!) {
                                            _model.reponseUserAuth =
                                                await AddUserCall.call(
                                              email: _model
                                                  .mailAgentTextController.text,
                                              password: _model
                                                  .passwordAgentTextController
                                                  .text,
                                            );

                                            _shouldSetState = true;
                                            if ((_model.reponseUserAuth
                                                    ?.succeeded ??
                                                true)) {
                                              _model.responseAddUserRoles =
                                                  await UserRolesTable()
                                                      .insert({
                                                'user_id': getJsonField(
                                                  (_model.reponseUserAuth
                                                          ?.jsonBody ??
                                                      ''),
                                                  r'''$.user.id''',
                                                ).toString(),
                                                'role_id': () {
                                                  if (_model.roleAgentValue ==
                                                      'Agente') {
                                                    return 3;
                                                  } else if (_model
                                                          .roleAgentValue ==
                                                      'Operaciones') {
                                                    return 4;
                                                  } else {
                                                    return null;
                                                  }
                                                }(),
                                                'account_id': context
                                                    .read<AppServices>()
                                                    .account
                                                    .accountId,
                                              });
                                              _shouldSetState = true;
                                              _model.responseUserContact =
                                                  await AddUserContactCall.call(
                                                name: _model
                                                    .nameAgentTextController
                                                    .text,
                                                lastName: _model
                                                    .lastNameAgentTextController
                                                    .text,
                                                email: _model
                                                    .mailAgentTextController
                                                    .text,
                                                userRole: _model.roleAgentValue,
                                                idUserAuth: getJsonField(
                                                  (_model.reponseUserAuth
                                                          ?.jsonBody ??
                                                      ''),
                                                  r'''$.user.id''',
                                                ).toString(),
                                                authToken: currentJwtToken,
                                                accountId: context
                                                    .read<AppServices>()
                                                    .account
                                                    .accountId,
                                              );

                                              _shouldSetState = true;
                                              if ((_model.responseUserContact
                                                      ?.succeeded ??
                                                  true)) {
                                                await showDialog(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: Text('Mensaje'),
                                                      content: Text(
                                                          'Usuario agregado correctamente'),
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
                                                  builder:
                                                      (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: Text('Mensaje'),
                                                      content: Text((_model
                                                                  .responseUserContact
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
                                              if ('${getJsonField(
                                                    (_model.reponseUserAuth
                                                            ?.jsonBody ??
                                                        ''),
                                                    r'''$.msg''',
                                                  ).toString()}' ==
                                                  'User already registered') {
                                                _model.apiResponseGetUserAuth =
                                                    await GetUserAuthCall.call(
                                                  authToken: currentJwtToken,
                                                  pEmail: _model
                                                      .mailAgentTextController
                                                      .text,
                                                );

                                                _shouldSetState = true;
                                                if ((_model
                                                        .apiResponseGetUserAuth
                                                        ?.succeeded ??
                                                    true)) {
                                                  _model.responseAddUserRoles2 =
                                                      await UserRolesTable()
                                                          .insert({
                                                    'user_id': getJsonField(
                                                      (_model.apiResponseGetUserAuth
                                                              ?.jsonBody ??
                                                          ''),
                                                      r'''$.id''',
                                                    ).toString(),
                                                    'role_id': () {
                                                      if (_model
                                                              .roleAgentValue ==
                                                          'Agente') {
                                                        return 3;
                                                      } else if (_model
                                                              .roleAgentValue ==
                                                          'Operaciones') {
                                                        return 4;
                                                      } else {
                                                        return null;
                                                      }
                                                    }(),
                                                    'account_id': context
                                                        .read<AppServices>()
                                                        .account
                                                        .accountId,
                                                  });
                                                  _shouldSetState = true;
                                                  _model.responseUserContact2 =
                                                      await AddUserContactCall
                                                          .call(
                                                    name: _model
                                                        .nameAgentTextController
                                                        .text,
                                                    lastName: _model
                                                        .lastNameAgentTextController
                                                        .text,
                                                    email: _model
                                                        .mailAgentTextController
                                                        .text,
                                                    userRole:
                                                        _model.roleAgentValue,
                                                    idUserAuth: getJsonField(
                                                      (_model.apiResponseGetUserAuth
                                                              ?.jsonBody ??
                                                          ''),
                                                      r'''$.id''',
                                                    ).toString(),
                                                    authToken: currentJwtToken,
                                                    accountId: context
                                                        .read<AppServices>()
                                                        .account
                                                        .accountId,
                                                  );

                                                  _shouldSetState = true;
                                                  if ((_model
                                                          .responseUserContact2
                                                          ?.succeeded ??
                                                      true)) {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Mensaje'),
                                                          content: Text(
                                                              'Usuario agregado correctamente'),
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
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Mensaje'),
                                                          content: Text((_model
                                                                      .responseUserContact
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
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text('Mensaje'),
                                                        content: Text(
                                                            'Hubo un error al crear el usuario.'),
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
                                                  builder:
                                                      (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: Text('Mensaje'),
                                                      content: Text((_model
                                                                  .reponseUserAuth
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
                                              }
                                            }
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: Text('Mensaje'),
                                                  content: Text(
                                                      'Algunos campos son obligatorios.'),
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
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
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
                                            color: FlutterFlowTheme.of(context)
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
          ),
        ],
      ),
    );
  }
}
