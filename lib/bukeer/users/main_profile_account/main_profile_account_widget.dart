import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../backend/supabase/supabase.dart';
import '../../componentes/component_place/component_place_widget.dart';
import '../../componentes/web_nav/web_nav_widget.dart';
import '../../../flutter_flow/flutter_flow_animations.dart';
import '../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../flutter_flow/form_field_controller.dart';
import '../../../flutter_flow/upload_data.dart';
import 'dart:math';
import 'dart:ui';
import '../../../flutter_flow/custom_functions.dart' as functions;
import '../../../index.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'main_profile_account_model.dart';
export 'main_profile_account_model.dart';

class MainProfileAccountWidget extends StatefulWidget {
  const MainProfileAccountWidget({super.key});

  static String routeName = 'Main_profileAccount';
  static String routePath = 'mainProfileAccount';

  @override
  State<MainProfileAccountWidget> createState() =>
      _MainProfileAccountWidgetState();
}

class _MainProfileAccountWidgetState extends State<MainProfileAccountWidget>
    with TickerProviderStateMixin {
  late MainProfileAccountModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainProfileAccountModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.apiResponseDataAccount =
          await GetAllDataAccountWithLocationCall.call(
        authToken: currentJwtToken,
        accountId: FFAppState().accountId,
      );

      if ((_model.apiResponseDataAccount?.succeeded ?? true)) {
        FFAppState().allDataAccount =
            (_model.apiResponseDataAccount?.jsonBody ?? '');
        safeSetState(() {});
        FFAppState().accountCurrency = getJsonField(
          (_model.apiResponseDataAccount?.jsonBody ?? ''),
          r'''$[:].currency''',
          true,
        )!
            .toList()
            .cast<dynamic>();
        FFAppState().accountTypesIncrease = getJsonField(
          (_model.apiResponseDataAccount?.jsonBody ?? ''),
          r'''$[:].types_increase''',
          true,
        )!
            .toList()
            .cast<dynamic>();
        FFAppState().accountPaymentMethods = getJsonField(
          (_model.apiResponseDataAccount?.jsonBody ?? ''),
          r'''$[:].payment_methods''',
          true,
        )!
            .toList()
            .cast<dynamic>();
        safeSetState(() {});
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Mensaje'),
              content: Text('Error al cargar información de la cuenta'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 5,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.nameContactFocusNode ??= FocusNode();

    _model.phoneContactFocusNode ??= FocusNode();

    _model.phone2ContactFocusNode ??= FocusNode();

    _model.mailContactFocusNode ??= FocusNode();

    _model.numberIdContactFocusNode ??= FocusNode();

    _model.websiteContactFocusNode ??= FocusNode();

    _model.cancellationPolicyContactFocusNode ??= FocusNode();

    _model.privacyPolicyContactFocusNode ??= FocusNode();

    _model.termsConditionsContactFocusNode ??= FocusNode();

    _model.textFieldRateTextController ??= TextEditingController();
    _model.textFieldRateFocusNode ??= FocusNode();

    _model.textFieldPercentagesTextController ??= TextEditingController();
    _model.textFieldPercentagesFocusNode ??= FocusNode();

    _model.textFieldNamesTextController ??= TextEditingController();
    _model.textFieldNamesFocusNode ??= FocusNode();

    animationsMap.addAll({
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
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
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 400.ms),
          FadeEffect(
            curve: Curves.bounceOut,
            delay: 400.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 400.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 400.ms),
          FadeEffect(
            curve: Curves.bounceOut,
            delay: 400.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 400.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 400.ms),
          FadeEffect(
            curve: Curves.bounceOut,
            delay: 400.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 400.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, 20.0),
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
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return FutureBuilder<ApiCallResponse>(
      future: (_model.apiRequestCompleter ??= Completer<ApiCallResponse>()
            ..complete(GetAllDataAccountWithLocationCall.call(
              authToken: currentJwtToken,
              accountId: FFAppState().accountId,
            )))
          .future,
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        final mainProfileAccountGetAllDataAccountWithLocationResponse =
            snapshot.data!;

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (responsiveVisibility(
                      context: context,
                      phone: false,
                      tablet: false,
                    ))
                      wrapWithModel(
                        model: _model.webNavModel,
                        updateCallback: () => safeSetState(() {}),
                        child: WebNavWidget(
                          selectedNav: 7,
                        ),
                      ),
                    Expanded(
                      child: Container(
                        width: 100.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(BukeerSpacing.s),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, -1.0),
                          child: SingleChildScrollView(
                            primary: false,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          constraints: BoxConstraints(
                                            maxWidth: 852.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          alignment:
                                              AlignmentDirectional(-1.0, 0.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 16.0, 16.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 0.0, 8.0),
                                                  child: Text(
                                                    'Ajustes',
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .displayMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .displayMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .displayMediumIsCustom,
                                                        ),
                                                  ).animateOnPageLoad(animationsMap[
                                                      'textOnPageLoadAnimation1']!),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 16.0, 0.0, 0.0),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 852.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    ),
                                    child: Form(
                                      key: _model.formKey,
                                      autovalidateMode: AutovalidateMode.always,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 4.0),
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: 852.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(0.0),
                                              bottomRight: Radius.circular(0.0),
                                              topLeft: Radius.circular(12.0),
                                              topRight: Radius.circular(12.0),
                                            ),
                                          ),
                                          child: SingleChildScrollView(
                                            primary: false,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Material(
                                                  color: Colors.transparent,
                                                  elevation: 2.0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    constraints: BoxConstraints(
                                                      maxHeight: 600.0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment(
                                                              -1.0, 0),
                                                          child: TabBar(
                                                            isScrollable: true,
                                                            tabAlignment:
                                                                TabAlignment
                                                                    .start,
                                                            labelColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            unselectedLabelColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                            labelPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        20.0,
                                                                        0.0,
                                                                        20.0,
                                                                        0.0),
                                                            labelStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .titleMediumFamily,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .titleMediumIsCustom,
                                                                    ),
                                                            unselectedLabelStyle:
                                                                TextStyle(),
                                                            indicatorColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                            tabs: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            6.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .business_center,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                                  ),
                                                                  Tab(
                                                                    text:
                                                                        'Negocio',
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            6.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .link,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                                  ),
                                                                  Tab(
                                                                    text:
                                                                        'Links',
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            6.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .currency_exchange,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                                  ),
                                                                  Tab(
                                                                    text:
                                                                        'Monedas',
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            6.0),
                                                                    child:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .moneyBill,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                                  ),
                                                                  Tab(
                                                                    text:
                                                                        'Tarifas',
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            6.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .paid,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                                  ),
                                                                  Tab(
                                                                    text:
                                                                        'Metodos de pago',
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                            controller: _model
                                                                .tabBarController,
                                                            onTap: (i) async {
                                                              [
                                                                () async {},
                                                                () async {},
                                                                () async {},
                                                                () async {},
                                                                () async {}
                                                              ][i]();
                                                            },
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: TabBarView(
                                                            controller: _model
                                                                .tabBarController,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            children: [
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        AnimatedContainer(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              150),
                                                                      curve: Curves
                                                                          .easeInOut,
                                                                      width:
                                                                          240.0,
                                                                      height:
                                                                          80.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .accent1,
                                                                        borderRadius:
                                                                            BorderRadius.circular(BukeerSpacing.s),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(BukeerSpacing.s),
                                                                        child: Image
                                                                            .network(
                                                                          getJsonField(
                                                                                    mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                    r'''$[:].logo_image''',
                                                                                  ) !=
                                                                                  null
                                                                              ? getJsonField(
                                                                                  mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                  r'''$[:].logo_image''',
                                                                                ).toString()
                                                                              : 'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/BukeerSinFondo.png',
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        final selectedMedia =
                                                                            await selectMediaWithSourceBottomSheet(
                                                                          context:
                                                                              context,
                                                                          storageFolderPath:
                                                                              '${FFAppState().accountId}/brand',
                                                                          allowPhoto:
                                                                              true,
                                                                        );
                                                                        if (selectedMedia !=
                                                                                null &&
                                                                            selectedMedia.every((m) =>
                                                                                validateFileFormat(m.storagePath, context))) {
                                                                          safeSetState(() =>
                                                                              _model.isDataUploading_uploadBrandPhoto = true);
                                                                          var selectedUploadedFiles =
                                                                              <FFUploadedFile>[];

                                                                          var downloadUrls =
                                                                              <String>[];
                                                                          try {
                                                                            selectedUploadedFiles = selectedMedia
                                                                                .map((m) => FFUploadedFile(
                                                                                      name: m.storagePath.split('/').last,
                                                                                      bytes: m.bytes,
                                                                                      height: m.dimensions?.height,
                                                                                      width: m.dimensions?.width,
                                                                                      blurHash: m.blurHash,
                                                                                    ))
                                                                                .toList();

                                                                            downloadUrls =
                                                                                await uploadSupabaseStorageFiles(
                                                                              bucketName: 'images',
                                                                              selectedFiles: selectedMedia,
                                                                            );
                                                                          } finally {
                                                                            _model.isDataUploading_uploadBrandPhoto =
                                                                                false;
                                                                          }
                                                                          if (selectedUploadedFiles.length == selectedMedia.length &&
                                                                              downloadUrls.length == selectedMedia.length) {
                                                                            safeSetState(() {
                                                                              _model.uploadedLocalFile_uploadBrandPhoto = selectedUploadedFiles.first;
                                                                              _model.uploadedFileUrl_uploadBrandPhoto = downloadUrls.first;
                                                                            });
                                                                          } else {
                                                                            safeSetState(() {});
                                                                            return;
                                                                          }
                                                                        }
                                                                      },
                                                                      text:
                                                                          'Cambiar logo',
                                                                      options:
                                                                          FFButtonOptions(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            16.0,
                                                                            0.0,
                                                                            16.0,
                                                                            0.0),
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        elevation:
                                                                            0.0,
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(BukeerSpacing.s),
                                                                        hoverColor:
                                                                            FlutterFlowTheme.of(context).alternate,
                                                                        hoverBorderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        hoverTextColor:
                                                                            FlutterFlowTheme.of(context).primaryText,
                                                                        hoverElevation:
                                                                            3.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            12.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          620.0,
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _model.nameContactTextController ??=
                                                                                TextEditingController(
                                                                          text: getJsonField(
                                                                                    mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                    r'''$[:].name''',
                                                                                  ) !=
                                                                                  null
                                                                              ? getJsonField(
                                                                                  mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                  r'''$[:].name''',
                                                                                ).toString()
                                                                              : '',
                                                                        ),
                                                                        focusNode:
                                                                            _model.nameContactFocusNode,
                                                                        autofocus:
                                                                            false,
                                                                        obscureText:
                                                                            false,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              'Nombre',
                                                                          labelStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                              ),
                                                                          hintStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                              ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).alternate,
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(BukeerSpacing.s),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(BukeerSpacing.s),
                                                                          ),
                                                                          errorBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(BukeerSpacing.s),
                                                                          ),
                                                                          focusedErrorBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(BukeerSpacing.s),
                                                                          ),
                                                                          filled:
                                                                              true,
                                                                          fillColor:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          contentPadding: EdgeInsetsDirectional.fromSTEB(
                                                                              20.0,
                                                                              24.0,
                                                                              20.0,
                                                                              24.0),
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        cursorColor:
                                                                            FlutterFlowTheme.of(context).primary,
                                                                        validator: _model
                                                                            .nameContactTextControllerValidator
                                                                            .asValidator(context),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Wrap(
                                                                    spacing:
                                                                        0.0,
                                                                    runSpacing:
                                                                        0.0,
                                                                    alignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        WrapCrossAlignment
                                                                            .start,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    runAlignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    verticalDirection:
                                                                        VerticalDirection
                                                                            .down,
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            24.0,
                                                                            0.0,
                                                                            24.0),
                                                                        child:
                                                                            Wrap(
                                                                          spacing:
                                                                              12.0,
                                                                          runSpacing:
                                                                              12.0,
                                                                          alignment:
                                                                              WrapAlignment.start,
                                                                          crossAxisAlignment:
                                                                              WrapCrossAlignment.start,
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          runAlignment:
                                                                              WrapAlignment.start,
                                                                          verticalDirection:
                                                                              VerticalDirection.down,
                                                                          clipBehavior:
                                                                              Clip.none,
                                                                          children: [
                                                                            Container(
                                                                              width: 299.0,
                                                                              child: TextFormField(
                                                                                controller: _model.phoneContactTextController ??= TextEditingController(
                                                                                  text: getJsonField(
                                                                                            mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                            r'''$[:].phone''',
                                                                                          ) !=
                                                                                          null
                                                                                      ? getJsonField(
                                                                                          mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                          r'''$[:].phone''',
                                                                                        ).toString()
                                                                                      : '',
                                                                                ),
                                                                                focusNode: _model.phoneContactFocusNode,
                                                                                autofocus: false,
                                                                                obscureText: false,
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'Celular',
                                                                                  labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                      ),
                                                                                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
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
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  ),
                                                                                  errorBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  ),
                                                                                  focusedErrorBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  ),
                                                                                  filled: true,
                                                                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                  contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                                keyboardType: TextInputType.phone,
                                                                                cursorColor: FlutterFlowTheme.of(context).primary,
                                                                                validator: _model.phoneContactTextControllerValidator.asValidator(context),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              width: 299.0,
                                                                              child: TextFormField(
                                                                                controller: _model.phone2ContactTextController ??= TextEditingController(
                                                                                  text: getJsonField(
                                                                                            mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                            r'''$[:].phone2''',
                                                                                          ) !=
                                                                                          null
                                                                                      ? getJsonField(
                                                                                          mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                          r'''$[:].phone2''',
                                                                                        ).toString()
                                                                                      : '',
                                                                                ),
                                                                                focusNode: _model.phone2ContactFocusNode,
                                                                                autofocus: false,
                                                                                obscureText: false,
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'Celular 2',
                                                                                  labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                      ),
                                                                                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
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
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  ),
                                                                                  errorBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  ),
                                                                                  focusedErrorBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  ),
                                                                                  filled: true,
                                                                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                  contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                                keyboardType: TextInputType.phone,
                                                                                cursorColor: FlutterFlowTheme.of(context).primary,
                                                                                validator: _model.phone2ContactTextControllerValidator.asValidator(context),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              width: 297.0,
                                                                              child: TextFormField(
                                                                                controller: _model.mailContactTextController ??= TextEditingController(
                                                                                  text: getJsonField(
                                                                                            mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                            r'''$[:].mail''',
                                                                                          ) !=
                                                                                          null
                                                                                      ? getJsonField(
                                                                                          mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                          r'''$[:].mail''',
                                                                                        ).toString()
                                                                                      : '',
                                                                                ),
                                                                                focusNode: _model.mailContactFocusNode,
                                                                                autofocus: false,
                                                                                obscureText: false,
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'Email',
                                                                                  labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                      ),
                                                                                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
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
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  ),
                                                                                  errorBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  ),
                                                                                  focusedErrorBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  ),
                                                                                  filled: true,
                                                                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                  contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                                keyboardType: TextInputType.emailAddress,
                                                                                cursorColor: FlutterFlowTheme.of(context).primary,
                                                                                validator: _model.mailContactTextControllerValidator.asValidator(context),
                                                                              ),
                                                                            ),
                                                                            wrapWithModel(
                                                                              model: _model.componentPlaceModel,
                                                                              updateCallback: () => safeSetState(() {}),
                                                                              child: ComponentPlaceWidget(
                                                                                location: getJsonField(
                                                                                  mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                  r'''$[:].address''',
                                                                                ).toString(),
                                                                              ),
                                                                            ),
                                                                            FlutterFlowDropDown<String>(
                                                                              controller: _model.typeDocumentContactValueController ??= FormFieldController<String>(
                                                                                _model.typeDocumentContactValue ??= getJsonField(
                                                                                          mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                          r'''$[:].type_id''',
                                                                                        ) !=
                                                                                        null
                                                                                    ? getJsonField(
                                                                                        mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                        r'''$[:].type_id''',
                                                                                      ).toString()
                                                                                    : 'NIT',
                                                                              ),
                                                                              options: [
                                                                                'Cédula de ciudadanía',
                                                                                'Cédula de extranjería',
                                                                                'Tarjeta de identidad',
                                                                                'NIT',
                                                                                'Pasaporte',
                                                                                'DNI'
                                                                              ],
                                                                              onChanged: (val) => safeSetState(() => _model.typeDocumentContactValue = val),
                                                                              width: 299.0,
                                                                              height: 50.0,
                                                                              searchHintTextStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                  ),
                                                                              searchTextStyle: TextStyle(),
                                                                              textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                  ),
                                                                              hintText: 'Seleccionar tipo de identificación',
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
                                                                              margin: EdgeInsetsDirectional.fromSTEB(20.0, 4.0, 16.0, 4.0),
                                                                              hidesUnderline: true,
                                                                              isSearchable: true,
                                                                              isMultiSelect: false,
                                                                            ),
                                                                            Container(
                                                                              width: 299.0,
                                                                              child: TextFormField(
                                                                                controller: _model.numberIdContactTextController ??= TextEditingController(
                                                                                  text: getJsonField(
                                                                                            mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                            r'''$[:].number_id''',
                                                                                          ) !=
                                                                                          null
                                                                                      ? getJsonField(
                                                                                          mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                          r'''$[:].number_id''',
                                                                                        ).toString()
                                                                                      : '',
                                                                                ),
                                                                                focusNode: _model.numberIdContactFocusNode,
                                                                                autofocus: false,
                                                                                obscureText: false,
                                                                                decoration: InputDecoration(
                                                                                  labelText: 'Número de identificación',
                                                                                  labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                      ),
                                                                                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
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
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  ),
                                                                                  errorBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  ),
                                                                                  focusedErrorBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                  ),
                                                                                  filled: true,
                                                                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                  contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                                keyboardType: TextInputType.number,
                                                                                cursorColor: FlutterFlowTheme.of(context).primary,
                                                                                validator: _model.numberIdContactTextControllerValidator.asValidator(context),
                                                                                inputFormatters: [
                                                                                  _model.numberIdContactMask
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]
                                                                    .divide(SizedBox(
                                                                        height:
                                                                            12.0))
                                                                    .addToStart(
                                                                        SizedBox(
                                                                            height:
                                                                                12.0)),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          24.0,
                                                                          0.0,
                                                                          24.0),
                                                                  child: Wrap(
                                                                    spacing:
                                                                        0.0,
                                                                    runSpacing:
                                                                        0.0,
                                                                    alignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        WrapCrossAlignment
                                                                            .start,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    runAlignment:
                                                                        WrapAlignment
                                                                            .start,
                                                                    verticalDirection:
                                                                        VerticalDirection
                                                                            .down,
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            24.0,
                                                                            5.0,
                                                                            24.0,
                                                                            5.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              620.0,
                                                                          child:
                                                                              TextFormField(
                                                                            controller: _model.websiteContactTextController ??=
                                                                                TextEditingController(
                                                                              text: getJsonField(
                                                                                        mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                        r'''$[:].website''',
                                                                                      ) !=
                                                                                      null
                                                                                  ? getJsonField(
                                                                                      mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                      r'''$[:].website''',
                                                                                    ).toString()
                                                                                  : '',
                                                                            ),
                                                                            focusNode:
                                                                                _model.websiteContactFocusNode,
                                                                            autofocus:
                                                                                false,
                                                                            obscureText:
                                                                                false,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              labelText: 'Pagina Web',
                                                                              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                  ),
                                                                              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
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
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                              ),
                                                                              errorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                              ),
                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                              ),
                                                                              filled: true,
                                                                              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                            keyboardType:
                                                                                TextInputType.url,
                                                                            cursorColor:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            validator:
                                                                                _model.websiteContactTextControllerValidator.asValidator(context),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            24.0,
                                                                            5.0,
                                                                            24.0,
                                                                            5.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              620.0,
                                                                          child:
                                                                              TextFormField(
                                                                            controller: _model.cancellationPolicyContactTextController ??=
                                                                                TextEditingController(
                                                                              text: getJsonField(
                                                                                        mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                        r'''$[:].cancellation_policy''',
                                                                                      ) !=
                                                                                      null
                                                                                  ? getJsonField(
                                                                                      mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                      r'''$[:].cancellation_policy''',
                                                                                    ).toString()
                                                                                  : '',
                                                                            ),
                                                                            focusNode:
                                                                                _model.cancellationPolicyContactFocusNode,
                                                                            autofocus:
                                                                                false,
                                                                            obscureText:
                                                                                false,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              labelText: 'URL Política de cancelacón',
                                                                              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                  ),
                                                                              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
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
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                              ),
                                                                              errorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                              ),
                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                              ),
                                                                              filled: true,
                                                                              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                            keyboardType:
                                                                                TextInputType.url,
                                                                            cursorColor:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            validator:
                                                                                _model.cancellationPolicyContactTextControllerValidator.asValidator(context),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            24.0,
                                                                            5.0,
                                                                            24.0,
                                                                            5.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              620.0,
                                                                          child:
                                                                              TextFormField(
                                                                            controller: _model.privacyPolicyContactTextController ??=
                                                                                TextEditingController(
                                                                              text: getJsonField(
                                                                                        mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                        r'''$[:].privacy_policy''',
                                                                                      ) !=
                                                                                      null
                                                                                  ? getJsonField(
                                                                                      mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                      r'''$[:].privacy_policy''',
                                                                                    ).toString()
                                                                                  : '',
                                                                            ),
                                                                            focusNode:
                                                                                _model.privacyPolicyContactFocusNode,
                                                                            autofocus:
                                                                                false,
                                                                            obscureText:
                                                                                false,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              labelText: 'URL Política de privacidad',
                                                                              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                  ),
                                                                              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
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
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                              ),
                                                                              errorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                              ),
                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                              ),
                                                                              filled: true,
                                                                              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                            keyboardType:
                                                                                TextInputType.url,
                                                                            cursorColor:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            validator:
                                                                                _model.privacyPolicyContactTextControllerValidator.asValidator(context),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            24.0,
                                                                            5.0,
                                                                            24.0,
                                                                            5.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              620.0,
                                                                          child:
                                                                              TextFormField(
                                                                            controller: _model.termsConditionsContactTextController ??=
                                                                                TextEditingController(
                                                                              text: getJsonField(
                                                                                        mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                        r'''$[:].terms_conditions''',
                                                                                      ) !=
                                                                                      null
                                                                                  ? getJsonField(
                                                                                      mainProfileAccountGetAllDataAccountWithLocationResponse.jsonBody,
                                                                                      r'''$[:].terms_conditions''',
                                                                                    ).toString()
                                                                                  : '',
                                                                            ),
                                                                            focusNode:
                                                                                _model.termsConditionsContactFocusNode,
                                                                            autofocus:
                                                                                false,
                                                                            obscureText:
                                                                                false,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              labelText: 'URL Términos y condiciones',
                                                                              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                  ),
                                                                              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
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
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                              ),
                                                                              errorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                              ),
                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                              ),
                                                                              filled: true,
                                                                              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                            keyboardType:
                                                                                TextInputType.url,
                                                                            cursorColor:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            validator:
                                                                                _model.termsConditionsContactTextControllerValidator.asValidator(context),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.9,
                                                                constraints:
                                                                    BoxConstraints(
                                                                  maxWidth:
                                                                      852.0,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                ),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  primary:
                                                                      false,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            20.0,
                                                                            0.0,
                                                                            16.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children:
                                                                              [
                                                                            FlutterFlowDropDown<String>(
                                                                              controller: _model.dropDownBaseCurrencyValueController ??= FormFieldController<String>(
                                                                                _model.dropDownBaseCurrencyValue ??= valueOrDefault<String>(
                                                                                  getJsonField(
                                                                                    FFAppState().accountCurrency.firstOrNull,
                                                                                    r'''$.name''',
                                                                                  )?.toString(),
                                                                                  'Moneda base',
                                                                                ),
                                                                              ),
                                                                              options: [
                                                                                'COP',
                                                                                'USD',
                                                                                'EUR',
                                                                                'AUD',
                                                                                'CAD',
                                                                                'CHF',
                                                                                'GBP'
                                                                              ],
                                                                              onChanged: (val) => safeSetState(() => _model.dropDownBaseCurrencyValue = val),
                                                                              width: 200.0,
                                                                              height: 50.0,
                                                                              textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                  ),
                                                                              hintText: 'Moneda base',
                                                                              icon: Icon(
                                                                                Icons.keyboard_arrow_down_rounded,
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                size: 24.0,
                                                                              ),
                                                                              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              elevation: 2.0,
                                                                              borderColor: FlutterFlowTheme.of(context).alternate,
                                                                              borderWidth: 2.0,
                                                                              borderRadius: 8.0,
                                                                              margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                                                              hidesUnderline: true,
                                                                              isOverButton: false,
                                                                              isSearchable: false,
                                                                              isMultiSelect: false,
                                                                            ),
                                                                            FFButtonWidget(
                                                                              onPressed: () async {
                                                                                var confirmDialogResponse = await showDialog<bool>(
                                                                                      context: context,
                                                                                      builder: (alertDialogContext) {
                                                                                        return AlertDialog(
                                                                                          title: Text('Mensaje'),
                                                                                          content: Text('¿Estas seguro que desea cambiar la moneda base?'),
                                                                                          actions: [
                                                                                            TextButton(
                                                                                              onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                              child: Text('Cancelar'),
                                                                                            ),
                                                                                            TextButton(
                                                                                              onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                              child: Text('Confirmar'),
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    ) ??
                                                                                    false;
                                                                                if (confirmDialogResponse) {
                                                                                  FFAppState().accountCurrency = functions.accountCurrencyJsonCopy(_model.dropDownBaseCurrencyValue, FFAppState().accountCurrency.toList())!.toList().cast<dynamic>();
                                                                                  safeSetState(() {});
                                                                                }
                                                                              },
                                                                              text: 'Cambiar',
                                                                              options: FFButtonOptions(
                                                                                height: 40.0,
                                                                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                      color: Colors.white,
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                                    ),
                                                                                elevation: 0.0,
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                              ),
                                                                            ),
                                                                          ].divide(SizedBox(width: BukeerSpacing.s)),
                                                                        ),
                                                                      ),
                                                                      if (_model
                                                                              .addCurrency ==
                                                                          true)
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(BukeerSpacing.xs),
                                                                            child:
                                                                                Container(
                                                                              width: 350.0,
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    blurRadius: 4.0,
                                                                                    color: BukeerColors.overlay,
                                                                                    offset: Offset(
                                                                                      0.0,
                                                                                      2.0,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.xs),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.all(BukeerSpacing.s),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Align(
                                                                                      alignment: AlignmentDirectional(0.0, 0.0),
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(bottom: BukeerSpacing.s),
                                                                                        child: Text(
                                                                                          'Agregar monedas',
                                                                                          textAlign: TextAlign.center,
                                                                                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                                fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                letterSpacing: 0.0,
                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                                              ),
                                                                                        ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation2']!),
                                                                                      ),
                                                                                    ),
                                                                                    FlutterFlowDropDown<String>(
                                                                                      controller: _model.dropDownOtherCurrencyValueController ??= FormFieldController<String>(null),
                                                                                      options: [
                                                                                        'COP',
                                                                                        'USD',
                                                                                        'EUR',
                                                                                        'AUD',
                                                                                        'CAD',
                                                                                        'CHF',
                                                                                        'GBP'
                                                                                      ],
                                                                                      onChanged: (val) => safeSetState(() => _model.dropDownOtherCurrencyValue = val),
                                                                                      width: 200.0,
                                                                                      height: 50.0,
                                                                                      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            letterSpacing: 0.0,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                          ),
                                                                                      hintText: 'Otras monedas',
                                                                                      icon: Icon(
                                                                                        Icons.keyboard_arrow_down_rounded,
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        size: 24.0,
                                                                                      ),
                                                                                      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                      elevation: 2.0,
                                                                                      borderColor: FlutterFlowTheme.of(context).alternate,
                                                                                      borderWidth: 2.0,
                                                                                      borderRadius: 8.0,
                                                                                      margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                                                                      hidesUnderline: true,
                                                                                      isOverButton: false,
                                                                                      isSearchable: false,
                                                                                      isMultiSelect: false,
                                                                                    ),
                                                                                    Container(
                                                                                      width: 200.0,
                                                                                      height: 50.0,
                                                                                      decoration: BoxDecoration(),
                                                                                      child: Container(
                                                                                        width: 200.0,
                                                                                        child: TextFormField(
                                                                                          controller: _model.textFieldRateTextController,
                                                                                          focusNode: _model.textFieldRateFocusNode,
                                                                                          autofocus: false,
                                                                                          obscureText: false,
                                                                                          decoration: InputDecoration(
                                                                                            labelText: 'Tasa',
                                                                                            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                                ),
                                                                                            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
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
                                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                                width: 2.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                            ),
                                                                                            errorBorder: OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                                width: 2.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                            ),
                                                                                            focusedErrorBorder: OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                                width: 2.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                            ),
                                                                                            filled: true,
                                                                                            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                            contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                letterSpacing: 0.0,
                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                              ),
                                                                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                                                          cursorColor: FlutterFlowTheme.of(context).primary,
                                                                                          validator: _model.textFieldRateTextControllerValidator.asValidator(context),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        FFButtonWidget(
                                                                                          onPressed: () async {
                                                                                            safeSetState(() {
                                                                                              _model.dropDownOtherCurrencyValueController?.reset();
                                                                                            });
                                                                                            safeSetState(() {
                                                                                              _model.textFieldRateTextController?.clear();
                                                                                            });
                                                                                            _model.addCurrency = false;
                                                                                            safeSetState(() {});
                                                                                          },
                                                                                          text: 'Cerrar',
                                                                                          options: FFButtonOptions(
                                                                                            height: 35.0,
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                                                                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                ),
                                                                                            elevation: 0.0,
                                                                                            borderSide: BorderSide(
                                                                                              color: FlutterFlowTheme.of(context).alternate,
                                                                                              width: 2.0,
                                                                                            ),
                                                                                            borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                            hoverColor: FlutterFlowTheme.of(context).alternate,
                                                                                            hoverBorderSide: BorderSide(
                                                                                              color: FlutterFlowTheme.of(context).alternate,
                                                                                              width: 2.0,
                                                                                            ),
                                                                                            hoverTextColor: FlutterFlowTheme.of(context).primaryText,
                                                                                            hoverElevation: 3.0,
                                                                                          ),
                                                                                        ),
                                                                                        FFButtonWidget(
                                                                                          onPressed: () async {
                                                                                            if ((_model.dropDownOtherCurrencyValue != null && _model.dropDownOtherCurrencyValue != '') && (_model.textFieldRateTextController.text != null && _model.textFieldRateTextController.text != '')) {
                                                                                              if (_model.dropDownBaseCurrencyValue != _model.dropDownOtherCurrencyValue) {
                                                                                                FFAppState().accountCurrency = functions.accountCurrencyJson(_model.dropDownBaseCurrencyValue, _model.dropDownOtherCurrencyValue, double.tryParse(_model.textFieldRateTextController.text), FFAppState().accountCurrency.toList())!.toList().cast<dynamic>();
                                                                                                safeSetState(() {});
                                                                                                safeSetState(() {
                                                                                                  _model.dropDownOtherCurrencyValueController?.reset();
                                                                                                });
                                                                                                safeSetState(() {
                                                                                                  _model.textFieldRateTextController?.clear();
                                                                                                });
                                                                                              } else {
                                                                                                safeSetState(() {
                                                                                                  _model.dropDownOtherCurrencyValueController?.reset();
                                                                                                });
                                                                                                safeSetState(() {
                                                                                                  _model.textFieldRateTextController?.clear();
                                                                                                });
                                                                                                await showDialog(
                                                                                                  context: context,
                                                                                                  builder: (alertDialogContext) {
                                                                                                    return AlertDialog(
                                                                                                      title: Text('Mensaje'),
                                                                                                      content: Text('No se puede cambiar el valor de la moneda base.'),
                                                                                                      actions: [
                                                                                                        TextButton(
                                                                                                          onPressed: () => Navigator.pop(alertDialogContext),
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
                                                                                                    content: Text('Ambos campos son obligatorios'),
                                                                                                    actions: [
                                                                                                      TextButton(
                                                                                                        onPressed: () => Navigator.pop(alertDialogContext),
                                                                                                        child: Text('Ok'),
                                                                                                      ),
                                                                                                    ],
                                                                                                  );
                                                                                                },
                                                                                              );
                                                                                            }
                                                                                          },
                                                                                          text: 'Agregar',
                                                                                          options: FFButtonOptions(
                                                                                            height: 35.0,
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                                                                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                            color: FlutterFlowTheme.of(context).primary,
                                                                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                                                ),
                                                                                            elevation: 3.0,
                                                                                            borderSide: BorderSide(
                                                                                              color: Colors.transparent,
                                                                                              width: 1.0,
                                                                                            ),
                                                                                            borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                            hoverColor: FlutterFlowTheme.of(context).accent1,
                                                                                            hoverBorderSide: BorderSide(
                                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                                              width: 1.0,
                                                                                            ),
                                                                                            hoverTextColor: FlutterFlowTheme.of(context).primaryText,
                                                                                            hoverElevation: 0.0,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ].divide(SizedBox(height: BukeerSpacing.s)).addToStart(SizedBox(height: BukeerSpacing.s)).addToEnd(SizedBox(height: BukeerSpacing.s)),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            12.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              Colors.transparent,
                                                                          elevation:
                                                                              2.0,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                500.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 4.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(left: BukeerSpacing.s),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              valueOrDefault<String>(
                                                                                                'Monedas opcionales:',
                                                                                                '0',
                                                                                              ),
                                                                                              style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                                    fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                                    fontSize: BukeerTypography.bodyMediumSize,
                                                                                                    letterSpacing: 0.0,
                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                                  ),
                                                                                            ),
                                                                                          ].divide(SizedBox(width: 50.0)),
                                                                                        ),
                                                                                        Align(
                                                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                                                          child: Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(4.0, 8.0, 8.0, 8.0),
                                                                                            child: FFButtonWidget(
                                                                                              onPressed: () async {
                                                                                                _model.addCurrency = true;
                                                                                                safeSetState(() {});
                                                                                              },
                                                                                              text: 'Agregar monedas',
                                                                                              icon: Icon(
                                                                                                Icons.add_sharp,
                                                                                                size: 24.0,
                                                                                              ),
                                                                                              options: FFButtonOptions(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 8.0, 12.0),
                                                                                                iconAlignment: IconAlignment.end,
                                                                                                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                      color: FlutterFlowTheme.of(context).info,
                                                                                                      letterSpacing: 0.0,
                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                    ),
                                                                                                elevation: 3.0,
                                                                                                borderSide: BorderSide(
                                                                                                  color: Colors.transparent,
                                                                                                  width: 1.0,
                                                                                                ),
                                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                hoverColor: FlutterFlowTheme.of(context).accent1,
                                                                                                hoverBorderSide: BorderSide(
                                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                                  width: 1.0,
                                                                                                ),
                                                                                                hoverTextColor: FlutterFlowTheme.of(context).primaryText,
                                                                                                hoverElevation: 0.0,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(top: BukeerSpacing.m),
                                                                                    child: Container(
                                                                                      width: double.infinity,
                                                                                      height: 40.0,
                                                                                      decoration: BoxDecoration(
                                                                                        color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                        borderRadius: BorderRadius.only(
                                                                                          bottomLeft: Radius.circular(0.0),
                                                                                          bottomRight: Radius.circular(0.0),
                                                                                          topLeft: Radius.circular(8.0),
                                                                                          topRight: Radius.circular(8.0),
                                                                                        ),
                                                                                        border: Border.all(
                                                                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                        ),
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              flex: 3,
                                                                                              child: Row(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    'Nombre',
                                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                          letterSpacing: 0.0,
                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                        ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            if (responsiveVisibility(
                                                                                              context: context,
                                                                                              phone: false,
                                                                                              tablet: false,
                                                                                            ))
                                                                                              Expanded(
                                                                                                flex: 2,
                                                                                                child: Text(
                                                                                                  'Tipo',
                                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                        letterSpacing: 0.0,
                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                      ),
                                                                                                ),
                                                                                              ),
                                                                                            Expanded(
                                                                                              flex: 2,
                                                                                              child: Text(
                                                                                                'Tasa',
                                                                                                textAlign: TextAlign.end,
                                                                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                      letterSpacing: 0.0,
                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Builder(
                                                                                    builder: (context) {
                                                                                      final currencyItem = FFAppState().accountCurrency.toList();

                                                                                      return ListView.separated(
                                                                                        padding: EdgeInsets.fromLTRB(
                                                                                          0,
                                                                                          8.0,
                                                                                          0,
                                                                                          0,
                                                                                        ),
                                                                                        shrinkWrap: true,
                                                                                        scrollDirection: Axis.vertical,
                                                                                        itemCount: currencyItem.length,
                                                                                        separatorBuilder: (_, __) => SizedBox(height: BukeerSpacing.s),
                                                                                        itemBuilder: (context, currencyItemIndex) {
                                                                                          final currencyItemItem = currencyItem[currencyItemIndex];
                                                                                          return Visibility(
                                                                                            visible: currencyItemIndex != 0,
                                                                                            child: Padding(
                                                                                              padding: EdgeInsets.only(bottom: BukeerSpacing.xs),
                                                                                              child: Container(
                                                                                                width: 100.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                  boxShadow: [
                                                                                                    BoxShadow(
                                                                                                      blurRadius: 0.0,
                                                                                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                      offset: Offset(
                                                                                                        0.0,
                                                                                                        1.0,
                                                                                                      ),
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                                  child: Row(
                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        flex: 3,
                                                                                                        child: Padding(
                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 12.0, 8.0),
                                                                                                          child: Row(
                                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                getJsonField(
                                                                                                                  currencyItemItem,
                                                                                                                  r'''$.name''',
                                                                                                                ).toString().maybeHandleOverflow(
                                                                                                                      maxChars: 20,
                                                                                                                      replacement: '…',
                                                                                                                    ),
                                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                      letterSpacing: 0.0,
                                                                                                                      fontWeight: FontWeight.bold,
                                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                    ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      if (responsiveVisibility(
                                                                                                        context: context,
                                                                                                        phone: false,
                                                                                                        tablet: false,
                                                                                                      ))
                                                                                                        Expanded(
                                                                                                          flex: 2,
                                                                                                          child: Text(
                                                                                                            getJsonField(
                                                                                                              currencyItemItem,
                                                                                                              r'''$.type''',
                                                                                                            ).toString().maybeHandleOverflow(
                                                                                                                  maxChars: 16,
                                                                                                                  replacement: '…',
                                                                                                                ),
                                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                  letterSpacing: 0.0,
                                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      Expanded(
                                                                                                        flex: 2,
                                                                                                        child: Row(
                                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              getJsonField(
                                                                                                                currencyItemItem,
                                                                                                                r'''$.rate''',
                                                                                                              ).toString(),
                                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                  ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ].divide(SizedBox(height: BukeerSpacing.s)),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.9,
                                                                constraints:
                                                                    BoxConstraints(
                                                                  maxWidth:
                                                                      852.0,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                ),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  primary:
                                                                      false,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      if (_model
                                                                              .addTypeIncrease ==
                                                                          true)
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              -1.0),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                16.0,
                                                                                16.0,
                                                                                16.0,
                                                                                16.0),
                                                                            child:
                                                                                Container(
                                                                              width: 344.0,
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    blurRadius: 4.0,
                                                                                    color: BukeerColors.overlay,
                                                                                    offset: Offset(
                                                                                      0.0,
                                                                                      2.0,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.xs),
                                                                              ),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      Flexible(
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.all(30.0),
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 15.0),
                                                                                                child: Column(
                                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Padding(
                                                                                                      padding: EdgeInsets.only(bottom: BukeerSpacing.s),
                                                                                                      child: Row(
                                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [
                                                                                                          Align(
                                                                                                            alignment: AlignmentDirectional(-1.0, 0.0),
                                                                                                            child: Padding(
                                                                                                              padding: EdgeInsets.only(left: BukeerSpacing.s),
                                                                                                              child: Text(
                                                                                                                'Cambiar porcentajes',
                                                                                                                textAlign: TextAlign.start,
                                                                                                                style: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                                                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                      letterSpacing: 0.0,
                                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                                                                    ),
                                                                                                              ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation3']!),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 15.0),
                                                                                                child: Column(
                                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  children: [
                                                                                                    FlutterFlowDropDown<String>(
                                                                                                      controller: _model.dropDownPercentagesValueController ??= FormFieldController<String>(null),
                                                                                                      options: [
                                                                                                        'Econo',
                                                                                                        'Standar',
                                                                                                        'Premium',
                                                                                                        'Luxury'
                                                                                                      ],
                                                                                                      onChanged: (val) => safeSetState(() => _model.dropDownPercentagesValue = val),
                                                                                                      width: 200.0,
                                                                                                      height: 50.0,
                                                                                                      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                            letterSpacing: 0.0,
                                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                          ),
                                                                                                      hintText: 'Opciones',
                                                                                                      icon: Icon(
                                                                                                        Icons.keyboard_arrow_down_rounded,
                                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                        size: 24.0,
                                                                                                      ),
                                                                                                      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                      elevation: 2.0,
                                                                                                      borderColor: FlutterFlowTheme.of(context).alternate,
                                                                                                      borderWidth: 2.0,
                                                                                                      borderRadius: 8.0,
                                                                                                      margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                                                                                      hidesUnderline: true,
                                                                                                      isOverButton: false,
                                                                                                      isSearchable: false,
                                                                                                      isMultiSelect: false,
                                                                                                    ),
                                                                                                    Row(
                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Flexible(
                                                                                                          child: Container(
                                                                                                            width: 200.0,
                                                                                                            height: 50.0,
                                                                                                            decoration: BoxDecoration(
                                                                                                              borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                            ),
                                                                                                            child: TextFormField(
                                                                                                              controller: _model.textFieldPercentagesTextController,
                                                                                                              focusNode: _model.textFieldPercentagesFocusNode,
                                                                                                              autofocus: false,
                                                                                                              obscureText: false,
                                                                                                              decoration: InputDecoration(
                                                                                                                labelText: 'Valor',
                                                                                                                labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                                      fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                                      letterSpacing: 0.0,
                                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                                                    ),
                                                                                                                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                                      fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                                      letterSpacing: 0.0,
                                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
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
                                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                                    width: 2.0,
                                                                                                                  ),
                                                                                                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                                ),
                                                                                                                errorBorder: OutlineInputBorder(
                                                                                                                  borderSide: BorderSide(
                                                                                                                    color: FlutterFlowTheme.of(context).error,
                                                                                                                    width: 2.0,
                                                                                                                  ),
                                                                                                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                                ),
                                                                                                                focusedErrorBorder: OutlineInputBorder(
                                                                                                                  borderSide: BorderSide(
                                                                                                                    color: FlutterFlowTheme.of(context).error,
                                                                                                                    width: 2.0,
                                                                                                                  ),
                                                                                                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                                ),
                                                                                                                filled: true,
                                                                                                                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                                contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                                                                                              ),
                                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                  ),
                                                                                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                                                                              cursorColor: FlutterFlowTheme.of(context).primary,
                                                                                                              validator: _model.textFieldPercentagesTextControllerValidator.asValidator(context),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                    ),
                                                                                                  ].divide(SizedBox(height: 20.0)),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 8.0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        FFButtonWidget(
                                                                                          onPressed: () async {
                                                                                            safeSetState(() {
                                                                                              _model.dropDownPercentagesValueController?.reset();
                                                                                            });
                                                                                            safeSetState(() {
                                                                                              _model.textFieldPercentagesTextController?.clear();
                                                                                            });
                                                                                            _model.addTypeIncrease = false;
                                                                                            safeSetState(() {});
                                                                                          },
                                                                                          text: 'Cerrar',
                                                                                          options: FFButtonOptions(
                                                                                            height: 40.0,
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                            color: FlutterFlowTheme.of(context).primary,
                                                                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                                  color: Colors.white,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                                                ),
                                                                                            elevation: 0.0,
                                                                                            borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                          ),
                                                                                        ),
                                                                                        FFButtonWidget(
                                                                                          onPressed: () async {
                                                                                            if ((_model.dropDownPercentagesValue != null && _model.dropDownPercentagesValue != '') && (_model.textFieldPercentagesTextController.text != null && _model.textFieldPercentagesTextController.text != '')) {
                                                                                              if ((_model.textFieldPercentagesTextController.text != null && _model.textFieldPercentagesTextController.text != '') && (_model.dropDownPercentagesValue != null && _model.dropDownPercentagesValue != '')) {
                                                                                                FFAppState().accountTypesIncrease = functions.accountTypesIncreaseJson(FFAppState().accountTypesIncrease.toList(), _model.dropDownPercentagesValue, double.tryParse(_model.textFieldPercentagesTextController.text))!.toList().cast<dynamic>();
                                                                                                safeSetState(() {});
                                                                                                safeSetState(() {
                                                                                                  _model.dropDownPercentagesValueController?.reset();
                                                                                                });
                                                                                                safeSetState(() {
                                                                                                  _model.textFieldPercentagesTextController?.clear();
                                                                                                });
                                                                                              } else {
                                                                                                await showDialog(
                                                                                                  context: context,
                                                                                                  builder: (alertDialogContext) {
                                                                                                    return AlertDialog(
                                                                                                      title: Text('Mensaje'),
                                                                                                      content: Text('No se puede cambiar el valor de la moneda base.'),
                                                                                                      actions: [
                                                                                                        TextButton(
                                                                                                          onPressed: () => Navigator.pop(alertDialogContext),
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
                                                                                                    content: Text('Ambos campos son obligatorios'),
                                                                                                    actions: [
                                                                                                      TextButton(
                                                                                                        onPressed: () => Navigator.pop(alertDialogContext),
                                                                                                        child: Text('Ok'),
                                                                                                      ),
                                                                                                    ],
                                                                                                  );
                                                                                                },
                                                                                              );
                                                                                            }
                                                                                          },
                                                                                          text: 'Agregar',
                                                                                          options: FFButtonOptions(
                                                                                            height: 40.0,
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                            color: FlutterFlowTheme.of(context).primary,
                                                                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                                  color: Colors.white,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                                                ),
                                                                                            elevation: 0.0,
                                                                                            borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              8.0),
                                                                          child:
                                                                              Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            elevation:
                                                                                2.0,
                                                                            child:
                                                                                Container(
                                                                              width: 450.0,
                                                                              constraints: BoxConstraints(
                                                                                maxWidth: 852.0,
                                                                              ),
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              ),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 4.0),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsets.only(left: BukeerSpacing.s),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Row(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                valueOrDefault<String>(
                                                                                                  'Tipos de incremento: ',
                                                                                                  '0',
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                                      fontSize: BukeerTypography.bodyMediumSize,
                                                                                                      letterSpacing: 0.0,
                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                                    ),
                                                                                              ),
                                                                                            ].divide(SizedBox(width: 50.0)),
                                                                                          ),
                                                                                          Align(
                                                                                            alignment: AlignmentDirectional(0.0, 0.0),
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(4.0, 8.0, 8.0, 8.0),
                                                                                              child: FFButtonWidget(
                                                                                                onPressed: () async {
                                                                                                  _model.addTypeIncrease = true;
                                                                                                  safeSetState(() {});
                                                                                                },
                                                                                                text: 'Cambiar porcentajes',
                                                                                                icon: Icon(
                                                                                                  Icons.add_sharp,
                                                                                                  size: 24.0,
                                                                                                ),
                                                                                                options: FFButtonOptions(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 8.0, 12.0),
                                                                                                  iconAlignment: IconAlignment.end,
                                                                                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                        color: FlutterFlowTheme.of(context).info,
                                                                                                        letterSpacing: 0.0,
                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                      ),
                                                                                                  elevation: 3.0,
                                                                                                  borderSide: BorderSide(
                                                                                                    color: Colors.transparent,
                                                                                                    width: 1.0,
                                                                                                  ),
                                                                                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                  hoverColor: FlutterFlowTheme.of(context).accent1,
                                                                                                  hoverBorderSide: BorderSide(
                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                    width: 1.0,
                                                                                                  ),
                                                                                                  hoverTextColor: FlutterFlowTheme.of(context).primaryText,
                                                                                                  hoverElevation: 0.0,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.only(top: BukeerSpacing.m),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        height: 40.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                          borderRadius: BorderRadius.only(
                                                                                            bottomLeft: Radius.circular(0.0),
                                                                                            bottomRight: Radius.circular(0.0),
                                                                                            topLeft: Radius.circular(8.0),
                                                                                            topRight: Radius.circular(8.0),
                                                                                          ),
                                                                                          border: Border.all(
                                                                                            color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                          ),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                          child: Row(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            children: [
                                                                                              Expanded(
                                                                                                flex: 3,
                                                                                                child: Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      'Nombre',
                                                                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                            letterSpacing: 0.0,
                                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                flex: 2,
                                                                                                child: Text(
                                                                                                  'Tasa %',
                                                                                                  textAlign: TextAlign.end,
                                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                        letterSpacing: 0.0,
                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                      ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Builder(
                                                                                      builder: (context) {
                                                                                        final currencyItem = FFAppState().accountTypesIncrease.toList();

                                                                                        return ListView.separated(
                                                                                          padding: EdgeInsets.fromLTRB(
                                                                                            0,
                                                                                            8.0,
                                                                                            0,
                                                                                            0,
                                                                                          ),
                                                                                          shrinkWrap: true,
                                                                                          scrollDirection: Axis.vertical,
                                                                                          itemCount: currencyItem.length,
                                                                                          separatorBuilder: (_, __) => SizedBox(height: BukeerSpacing.s),
                                                                                          itemBuilder: (context, currencyItemIndex) {
                                                                                            final currencyItemItem = currencyItem[currencyItemIndex];
                                                                                            return Padding(
                                                                                              padding: EdgeInsets.only(bottom: BukeerSpacing.xs),
                                                                                              child: Container(
                                                                                                width: 100.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                  boxShadow: [
                                                                                                    BoxShadow(
                                                                                                      blurRadius: 0.0,
                                                                                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                      offset: Offset(
                                                                                                        0.0,
                                                                                                        1.0,
                                                                                                      ),
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                                  child: Row(
                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        flex: 3,
                                                                                                        child: Padding(
                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 12.0, 8.0),
                                                                                                          child: Row(
                                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                getJsonField(
                                                                                                                  currencyItemItem,
                                                                                                                  r'''$.name''',
                                                                                                                ).toString().maybeHandleOverflow(
                                                                                                                      maxChars: 20,
                                                                                                                      replacement: '…',
                                                                                                                    ),
                                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                      letterSpacing: 0.0,
                                                                                                                      fontWeight: FontWeight.bold,
                                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                    ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      Expanded(
                                                                                                        flex: 2,
                                                                                                        child: Row(
                                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              '${getJsonField(
                                                                                                                currencyItemItem,
                                                                                                                r'''$.rate''',
                                                                                                              ).toString()}%',
                                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                  ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ].divide(SizedBox(height: BukeerSpacing.s)),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.9,
                                                                constraints:
                                                                    BoxConstraints(
                                                                  maxWidth:
                                                                      852.0,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                ),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  primary:
                                                                      false,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      if (_model
                                                                              .addPaymentMethods ==
                                                                          true)
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              -1.0),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                16.0,
                                                                                16.0,
                                                                                16.0,
                                                                                16.0),
                                                                            child:
                                                                                Container(
                                                                              width: 344.0,
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    blurRadius: 4.0,
                                                                                    color: BukeerColors.overlay,
                                                                                    offset: Offset(
                                                                                      0.0,
                                                                                      2.0,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                                borderRadius: BorderRadius.circular(BukeerSpacing.xs),
                                                                              ),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      Flexible(
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.all(30.0),
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 15.0),
                                                                                                child: Column(
                                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Padding(
                                                                                                      padding: EdgeInsets.only(bottom: BukeerSpacing.s),
                                                                                                      child: Row(
                                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [
                                                                                                          Align(
                                                                                                            alignment: AlignmentDirectional(-1.0, 0.0),
                                                                                                            child: Padding(
                                                                                                              padding: EdgeInsets.only(left: BukeerSpacing.s),
                                                                                                              child: Text(
                                                                                                                'Metodos de pago',
                                                                                                                textAlign: TextAlign.start,
                                                                                                                style: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                                                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                      letterSpacing: 0.0,
                                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                                                                    ),
                                                                                                              ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation4']!),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 15.0),
                                                                                                child: Column(
                                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Row(
                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Flexible(
                                                                                                          child: Container(
                                                                                                            width: 200.0,
                                                                                                            height: 50.0,
                                                                                                            decoration: BoxDecoration(
                                                                                                              borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                            ),
                                                                                                            child: TextFormField(
                                                                                                              controller: _model.textFieldNamesTextController,
                                                                                                              focusNode: _model.textFieldNamesFocusNode,
                                                                                                              autofocus: false,
                                                                                                              obscureText: false,
                                                                                                              decoration: InputDecoration(
                                                                                                                labelText: 'Nombre',
                                                                                                                labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                                      fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                                      letterSpacing: 0.0,
                                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                                                    ),
                                                                                                                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                                      fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                                      letterSpacing: 0.0,
                                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
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
                                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                                    width: 2.0,
                                                                                                                  ),
                                                                                                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                                ),
                                                                                                                errorBorder: OutlineInputBorder(
                                                                                                                  borderSide: BorderSide(
                                                                                                                    color: FlutterFlowTheme.of(context).error,
                                                                                                                    width: 2.0,
                                                                                                                  ),
                                                                                                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                                ),
                                                                                                                focusedErrorBorder: OutlineInputBorder(
                                                                                                                  borderSide: BorderSide(
                                                                                                                    color: FlutterFlowTheme.of(context).error,
                                                                                                                    width: 2.0,
                                                                                                                  ),
                                                                                                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                                ),
                                                                                                                filled: true,
                                                                                                                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                                contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                                                                                              ),
                                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                  ),
                                                                                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                                                                              cursorColor: FlutterFlowTheme.of(context).primary,
                                                                                                              validator: _model.textFieldNamesTextControllerValidator.asValidator(context),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ].divide(SizedBox(width: BukeerSpacing.xs)),
                                                                                                    ),
                                                                                                  ].divide(SizedBox(height: 20.0)),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 8.0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        FFButtonWidget(
                                                                                          onPressed: () async {
                                                                                            safeSetState(() {
                                                                                              _model.textFieldNamesTextController?.clear();
                                                                                            });
                                                                                            _model.addPaymentMethods = false;
                                                                                            safeSetState(() {});
                                                                                          },
                                                                                          text: 'Cerrar',
                                                                                          options: FFButtonOptions(
                                                                                            height: 40.0,
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                            color: FlutterFlowTheme.of(context).primary,
                                                                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                                  color: Colors.white,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                                                ),
                                                                                            elevation: 0.0,
                                                                                            borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                          ),
                                                                                        ),
                                                                                        FFButtonWidget(
                                                                                          onPressed: () async {
                                                                                            if (_model.textFieldNamesTextController.text != null && _model.textFieldNamesTextController.text != '') {
                                                                                              FFAppState().accountPaymentMethods = functions.addPaymentMethod(FFAppState().accountPaymentMethods.toList(), _model.textFieldNamesTextController.text)!.toList().cast<dynamic>();
                                                                                              safeSetState(() {});
                                                                                              safeSetState(() {
                                                                                                _model.textFieldNamesTextController?.clear();
                                                                                              });
                                                                                            } else {
                                                                                              await showDialog(
                                                                                                context: context,
                                                                                                builder: (alertDialogContext) {
                                                                                                  return AlertDialog(
                                                                                                    title: Text('Mensaje'),
                                                                                                    content: Text('Los campos son obligatorios.'),
                                                                                                    actions: [
                                                                                                      TextButton(
                                                                                                        onPressed: () => Navigator.pop(alertDialogContext),
                                                                                                        child: Text('Ok'),
                                                                                                      ),
                                                                                                    ],
                                                                                                  );
                                                                                                },
                                                                                              );
                                                                                            }
                                                                                          },
                                                                                          text: 'Agregar',
                                                                                          options: FFButtonOptions(
                                                                                            height: 40.0,
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                            color: FlutterFlowTheme.of(context).primary,
                                                                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                                  color: Colors.white,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                                                ),
                                                                                            elevation: 0.0,
                                                                                            borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              8.0),
                                                                          child:
                                                                              Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            elevation:
                                                                                2.0,
                                                                            child:
                                                                                Container(
                                                                              width: 450.0,
                                                                              constraints: BoxConstraints(
                                                                                maxWidth: 852.0,
                                                                              ),
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              ),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 4.0),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsets.only(left: BukeerSpacing.s),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Row(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                valueOrDefault<String>(
                                                                                                  'Metodos: ',
                                                                                                  '0',
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                                      fontSize: BukeerTypography.bodyMediumSize,
                                                                                                      letterSpacing: 0.0,
                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                                    ),
                                                                                              ),
                                                                                            ].divide(SizedBox(width: 50.0)),
                                                                                          ),
                                                                                          Align(
                                                                                            alignment: AlignmentDirectional(0.0, 0.0),
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(4.0, 8.0, 8.0, 8.0),
                                                                                              child: FFButtonWidget(
                                                                                                onPressed: () async {
                                                                                                  _model.addPaymentMethods = true;
                                                                                                  safeSetState(() {});
                                                                                                },
                                                                                                text: 'Agregar  metodo de pago',
                                                                                                icon: Icon(
                                                                                                  Icons.add_sharp,
                                                                                                  size: 24.0,
                                                                                                ),
                                                                                                options: FFButtonOptions(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 8.0, 12.0),
                                                                                                  iconAlignment: IconAlignment.end,
                                                                                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                        color: FlutterFlowTheme.of(context).info,
                                                                                                        letterSpacing: 0.0,
                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                      ),
                                                                                                  elevation: 3.0,
                                                                                                  borderSide: BorderSide(
                                                                                                    color: Colors.transparent,
                                                                                                    width: 1.0,
                                                                                                  ),
                                                                                                  borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                                                                                  hoverColor: FlutterFlowTheme.of(context).accent1,
                                                                                                  hoverBorderSide: BorderSide(
                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                    width: 1.0,
                                                                                                  ),
                                                                                                  hoverTextColor: FlutterFlowTheme.of(context).primaryText,
                                                                                                  hoverElevation: 0.0,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.only(top: BukeerSpacing.m),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        height: 40.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                          borderRadius: BorderRadius.only(
                                                                                            bottomLeft: Radius.circular(0.0),
                                                                                            bottomRight: Radius.circular(0.0),
                                                                                            topLeft: Radius.circular(8.0),
                                                                                            topRight: Radius.circular(8.0),
                                                                                          ),
                                                                                          border: Border.all(
                                                                                            color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                          ),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                          child: Row(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            children: [
                                                                                              Expanded(
                                                                                                flex: 3,
                                                                                                child: Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      'Nombre',
                                                                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                            letterSpacing: 0.0,
                                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Builder(
                                                                                      builder: (context) {
                                                                                        final paymentMethodsItem = FFAppState().accountPaymentMethods.toList();

                                                                                        return ListView.separated(
                                                                                          padding: EdgeInsets.fromLTRB(
                                                                                            0,
                                                                                            8.0,
                                                                                            0,
                                                                                            0,
                                                                                          ),
                                                                                          shrinkWrap: true,
                                                                                          scrollDirection: Axis.vertical,
                                                                                          itemCount: paymentMethodsItem.length,
                                                                                          separatorBuilder: (_, __) => SizedBox(height: BukeerSpacing.s),
                                                                                          itemBuilder: (context, paymentMethodsItemIndex) {
                                                                                            final paymentMethodsItemItem = paymentMethodsItem[paymentMethodsItemIndex];
                                                                                            return Padding(
                                                                                              padding: EdgeInsets.only(bottom: BukeerSpacing.xs),
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                focusColor: Colors.transparent,
                                                                                                hoverColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                onTap: () async {
                                                                                                  FFAppState().namePaymentMethods = paymentMethodsItemItem;
                                                                                                  safeSetState(() {});

                                                                                                  context.pushNamed(EditPaymentMethodsWidget.routeName);
                                                                                                },
                                                                                                child: Container(
                                                                                                  width: 100.0,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                    boxShadow: [
                                                                                                      BoxShadow(
                                                                                                        blurRadius: 0.0,
                                                                                                        color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                        offset: Offset(
                                                                                                          0.0,
                                                                                                          1.0,
                                                                                                        ),
                                                                                                      )
                                                                                                    ],
                                                                                                  ),
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                                    child: Row(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      children: [
                                                                                                        Expanded(
                                                                                                          flex: 3,
                                                                                                          child: Padding(
                                                                                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 12.0, 8.0),
                                                                                                            child: Row(
                                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                                              children: [
                                                                                                                Text(
                                                                                                                  getJsonField(
                                                                                                                    paymentMethodsItemItem,
                                                                                                                    r'''$.name''',
                                                                                                                  ).toString().maybeHandleOverflow(
                                                                                                                        maxChars: 20,
                                                                                                                        replacement: '…',
                                                                                                                      ),
                                                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                        letterSpacing: 0.0,
                                                                                                                        fontWeight: FontWeight.bold,
                                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                                                            );
                                                                                          },
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ].divide(SizedBox(height: BukeerSpacing.s)),
                                                                                ),
                                                                              ),
                                                                            ),
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
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          24.0, 8.0, 24.0, 8.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.05),
                                                        child: FFButtonWidget(
                                                          onPressed: () async {
                                                            var _shouldSetState =
                                                                false;
                                                            _model.responseValidateForm =
                                                                true;
                                                            if (_model.formKey
                                                                        .currentState ==
                                                                    null ||
                                                                !_model.formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                              _model.responseValidateForm =
                                                                  false;
                                                            }
                                                            _shouldSetState =
                                                                true;
                                                            FFAppState()
                                                                    .latlngLocation =
                                                                _model
                                                                    .componentPlaceModel
                                                                    .placePickerValue
                                                                    .latLng
                                                                    .toString();
                                                            FFAppState()
                                                                    .nameLocation =
                                                                _model
                                                                    .componentPlaceModel
                                                                    .placePickerValue
                                                                    .name;
                                                            FFAppState()
                                                                    .addressLocation =
                                                                _model
                                                                    .componentPlaceModel
                                                                    .placePickerValue
                                                                    .address;
                                                            FFAppState()
                                                                    .cityLocation =
                                                                _model
                                                                    .componentPlaceModel
                                                                    .placePickerValue
                                                                    .city;
                                                            FFAppState()
                                                                    .stateLocation =
                                                                _model
                                                                    .componentPlaceModel
                                                                    .placePickerValue
                                                                    .state;
                                                            FFAppState()
                                                                    .countryLocation =
                                                                _model
                                                                    .componentPlaceModel
                                                                    .placePickerValue
                                                                    .country;
                                                            FFAppState()
                                                                    .zipCodeLocation =
                                                                _model
                                                                    .componentPlaceModel
                                                                    .placePickerValue
                                                                    .zipCode;
                                                            safeSetState(() {});
                                                            if (_model
                                                                .responseValidateForm!) {
                                                              if (FFAppState()
                                                                      .latlngLocation !=
                                                                  'LatLng(lat: 0, lng: 0)') {
                                                                _model.responseInsertLocation2 =
                                                                    await UpdateLocationsCall
                                                                        .call(
                                                                  latlng: FFAppState()
                                                                      .latlngLocation,
                                                                  name: FFAppState()
                                                                      .nameLocation,
                                                                  address:
                                                                      FFAppState()
                                                                          .addressLocation,
                                                                  city: FFAppState()
                                                                      .cityLocation,
                                                                  state: FFAppState()
                                                                      .stateLocation,
                                                                  country:
                                                                      FFAppState()
                                                                          .countryLocation,
                                                                  zipCode:
                                                                      FFAppState()
                                                                          .zipCodeLocation,
                                                                  authToken:
                                                                      currentJwtToken,
                                                                  id: getJsonField(
                                                                    FFAppState()
                                                                        .allDataAccount,
                                                                    r'''$[:].location''',
                                                                  ).toString(),
                                                                );

                                                                _shouldSetState =
                                                                    true;
                                                                if ((_model
                                                                        .responseInsertLocation2
                                                                        ?.succeeded ??
                                                                    true)) {
                                                                } else {
                                                                  if ((_model.responseInsertLocation2
                                                                              ?.exceptionMessage ??
                                                                          '') ==
                                                                      '${null}') {
                                                                    _model.responseInsertLocation3 =
                                                                        await InsertLocationsCall
                                                                            .call(
                                                                      authToken:
                                                                          currentJwtToken,
                                                                      latlng: FFAppState()
                                                                          .latlngLocation,
                                                                      name: FFAppState()
                                                                          .nameLocation,
                                                                      address:
                                                                          FFAppState()
                                                                              .addressLocation,
                                                                      city: FFAppState()
                                                                          .cityLocation,
                                                                      state: FFAppState()
                                                                          .stateLocation,
                                                                      country:
                                                                          FFAppState()
                                                                              .countryLocation,
                                                                      zipCode:
                                                                          FFAppState()
                                                                              .zipCodeLocation,
                                                                      accountId:
                                                                          FFAppState()
                                                                              .accountId,
                                                                      typeEntity:
                                                                          'accounts',
                                                                    );

                                                                    _shouldSetState =
                                                                        true;
                                                                    if ((_model
                                                                            .responseInsertLocation3
                                                                            ?.succeeded ??
                                                                        true)) {
                                                                      _model.apiResultreg =
                                                                          await InsertLocationByTypeCall
                                                                              .call(
                                                                        authToken:
                                                                            currentJwtToken,
                                                                        locationId:
                                                                            (_model.responseInsertLocation3?.jsonBody ?? '').toString(),
                                                                        searchId:
                                                                            getJsonField(
                                                                          FFAppState()
                                                                              .allDataAccount,
                                                                          r'''$[:].id''',
                                                                        ).toString(),
                                                                        type:
                                                                            'accounts',
                                                                      );

                                                                      _shouldSetState =
                                                                          true;
                                                                      if (!(_model
                                                                              .apiResultreg
                                                                              ?.succeeded ??
                                                                          true)) {
                                                                        await showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (alertDialogContext) {
                                                                            return AlertDialog(
                                                                              title: Text('Mensaje'),
                                                                              content: Text('Error al agregar ubicación'),
                                                                              actions: [
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.pop(alertDialogContext),
                                                                                  child: Text('Ok'),
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
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (alertDialogContext) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text('Mensaje'),
                                                                            content:
                                                                                Text('Hubo un error al agregar la locación'),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () => Navigator.pop(alertDialogContext),
                                                                                child: Text('Ok'),
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
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Mensaje'),
                                                                          content:
                                                                              Text('Hubo un error al agregar la locación'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
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
                                                                }
                                                              } else {
                                                                if (!(getJsonField(
                                                                      FFAppState()
                                                                          .allDataAccount,
                                                                      r'''$[:].address''',
                                                                    ) !=
                                                                    null)) {
                                                                  await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (alertDialogContext) {
                                                                      return AlertDialog(
                                                                        title: Text(
                                                                            'Mensaje'),
                                                                        content:
                                                                            Text('La dirección es obligatoria'),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(alertDialogContext),
                                                                            child:
                                                                                Text('Ok'),
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
                                                              }

                                                              _model.apiResulty9y =
                                                                  await UpdateAllDataAccountCall
                                                                      .call(
                                                                authToken:
                                                                    currentJwtToken,
                                                                id: getJsonField(
                                                                  FFAppState()
                                                                      .allDataAccount,
                                                                  r'''$[:].id''',
                                                                ).toString(),
                                                                logoImage: _model.uploadedFileUrl_uploadBrandPhoto !=
                                                                            null &&
                                                                        _model.uploadedFileUrl_uploadBrandPhoto !=
                                                                            ''
                                                                    ? _model
                                                                        .uploadedFileUrl_uploadBrandPhoto
                                                                    : getJsonField(
                                                                        mainProfileAccountGetAllDataAccountWithLocationResponse
                                                                            .jsonBody,
                                                                        r'''$[:].logo_image''',
                                                                      ).toString(),
                                                                name: _model
                                                                    .nameContactTextController
                                                                    .text,
                                                                typeId: _model
                                                                    .typeDocumentContactValue,
                                                                numberId: _model
                                                                    .numberIdContactTextController
                                                                    .text,
                                                                phone: _model
                                                                    .phoneContactTextController
                                                                    .text,
                                                                phone2: _model
                                                                    .phone2ContactTextController
                                                                    .text,
                                                                mail: _model
                                                                    .mailContactTextController
                                                                    .text,
                                                                website: _model
                                                                    .websiteContactTextController
                                                                    .text,
                                                                cancellationPolicy:
                                                                    _model
                                                                        .cancellationPolicyContactTextController
                                                                        .text,
                                                                privacyPolicy:
                                                                    _model
                                                                        .privacyPolicyContactTextController
                                                                        .text,
                                                                termsConditions:
                                                                    _model
                                                                        .termsConditionsContactTextController
                                                                        .text,
                                                                currencyJson:
                                                                    FFAppState()
                                                                        .accountCurrency,
                                                                typesIncreaseJson:
                                                                    FFAppState()
                                                                        .accountTypesIncrease,
                                                                paymentMethodsJson:
                                                                    FFAppState()
                                                                        .accountPaymentMethods,
                                                              );

                                                              _shouldSetState =
                                                                  true;
                                                              if ((_model
                                                                      .apiResulty9y
                                                                      ?.succeeded ??
                                                                  true)) {
                                                                FFAppState()
                                                                    .latlngLocation = '';
                                                                FFAppState()
                                                                    .nameLocation = '';
                                                                FFAppState()
                                                                    .addressLocation = '';
                                                                FFAppState()
                                                                    .cityLocation = '';
                                                                FFAppState()
                                                                    .stateLocation = '';
                                                                FFAppState()
                                                                    .countryLocation = '';
                                                                FFAppState()
                                                                    .zipCodeLocation = '';
                                                                safeSetState(
                                                                    () {});
                                                                await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (alertDialogContext) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'Mensaje'),
                                                                      content: Text(
                                                                          'Información actualizada'),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                          child:
                                                                              Text('Ok'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                                safeSetState(() =>
                                                                    _model.apiRequestCompleter =
                                                                        null);
                                                                await _model
                                                                    .waitForApiRequestCompleted();
                                                              } else {
                                                                await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (alertDialogContext) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'Mensaje'),
                                                                      content: Text((_model.apiResulty9y?.jsonBody ??
                                                                              '')
                                                                          .toString()),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(alertDialogContext),
                                                                          child:
                                                                              Text('Ok'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            } else {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (alertDialogContext) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Mensaje'),
                                                                    content: Text(
                                                                        'Algunos campos son obligatorios'),
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

                                                            if (_shouldSetState)
                                                              safeSetState(
                                                                  () {});
                                                          },
                                                          text: 'Guardar',
                                                          options:
                                                              FFButtonOptions(
                                                            height: 44.0,
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        24.0,
                                                                        0.0,
                                                                        24.0,
                                                                        0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            textStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .titleSmallFamily,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .titleSmallIsCustom,
                                                                    ),
                                                            elevation: 3.0,
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                            hoverColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .accent1,
                                                            hoverBorderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              width: 1.0,
                                                            ),
                                                            hoverTextColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
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
                                        ).animateOnPageLoad(animationsMap[
                                            'containerOnPageLoadAnimation']!),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
