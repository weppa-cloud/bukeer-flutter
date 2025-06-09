import '../../../../../../auth/supabase_auth/auth_util.dart';
import '../../../../../../backend/api_requests/api_calls.dart';
import '../../../../../../backend/supabase/supabase.dart';
import '../../../../../../bukeer/core/widgets/containers/activities/activities_container_widget.dart';
import '../../../../../../bukeer/core/widgets/forms/place_picker/place_picker_widget.dart';
import '../../../../../../bukeer/core/widgets/containers/contacts/contacts_container_widget.dart';
import '../add_edit/modal_add_edit_contact_widget.dart';
import '../../../../../../bukeer/core/widgets/containers/itineraries/itineraries_container_widget.dart';
import '../../../../../../bukeer/core/widgets/containers/hotels/hotels_container_widget.dart';
import '../../../../../../bukeer/core/widgets/containers/transfers/transfers_container_widget.dart';
import '../../product/add/modal_add_product_widget.dart';
import '../../product/details/modal_details_product_widget.dart';
import '../../../../../../flutter_flow/flutter_flow_animations.dart';
import '../../../../../../flutter_flow/flutter_flow_button_tabbar.dart';
import '../../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../../design_system/index.dart';
import '../../../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'modal_details_contact_model.dart';
import '../../../../../../services/app_services.dart';
import '../../../../../../services/ui_state_service.dart';
import '../../../../../../services/contact_service.dart';
import '/design_system/tokens/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
export 'modal_details_contact_model.dart';

class ModalDetailsContactWidget extends StatefulWidget {
  const ModalDetailsContactWidget({
    super.key,
    this.idContact,
    this.dataContact,
    this.isProvider,
    this.isClient,
    this.isCompany,
  });

  final String? idContact;
  final dynamic dataContact;
  final bool? isProvider;
  final bool? isClient;
  final bool? isCompany;

  @override
  State<ModalDetailsContactWidget> createState() =>
      _ModalDetailsContactWidgetState();
}

class _ModalDetailsContactWidgetState extends State<ModalDetailsContactWidget>
    with TickerProviderStateMixin {
  late ModalDetailsContactModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalDetailsContactModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.nameContactTextController ??= TextEditingController();
    _model.nameContactFocusNode ??= FocusNode();

    _model.lastNameContactTextController ??= TextEditingController();
    _model.lastNameContactFocusNode ??= FocusNode();

    _model.phoneContactTextController ??= TextEditingController();
    _model.phoneContactFocusNode ??= FocusNode();

    _model.phone2ContactTextController ??= TextEditingController();
    _model.phone2ContactFocusNode ??= FocusNode();

    _model.mailContactTextController ??= TextEditingController();
    _model.mailContactFocusNode ??= FocusNode();

    _model.positionContactTextController ??= TextEditingController();
    _model.positionContactFocusNode ??= FocusNode();

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
      'textOnPageLoadAnimation1': AnimationInfo(
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
            begin: Offset(0.0, 10.0),
            end: Offset(0.0, 0.0),
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
            begin: Offset(0.0, 10.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
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
            begin: Offset(0.0, -30.0),
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
      'textOnPageLoadAnimation5': AnimationInfo(
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
      'textOnPageLoadAnimation6': AnimationInfo(
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
      'textOnPageLoadAnimation7': AnimationInfo(
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
      'textOnPageLoadAnimation8': AnimationInfo(
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
      'textOnPageLoadAnimation9': AnimationInfo(
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
      'textOnPageLoadAnimation10': AnimationInfo(
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
      child: FutureBuilder<ApiCallResponse>(
        future: GetContactWithLocationCall.call(
          authToken: currentJwtToken,
          inputContactId: getJsonField(
            context.read<ContactService>().allDataContact,
            r'''$.id''',
          ).toString(),
        ),
        builder: (context, snapshot) {
          // Customize what your widget looks like when it's loading.
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    BukeerColors.primary,
                  ),
                ),
              ),
            );
          }
          final columnGetContactWithLocationResponse = snapshot.data!;

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 2.0, 0.0, 16.0),
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
                      bottomRight: Radius.circular(0.0),
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(0.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              4.0, 12.0, 16.0, 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 0.0, 0.0),
                                child: BukeerIconButton(
                                  size: BukeerIconButtonSize.medium,
                                  variant: BukeerIconButtonVariant.filled,
                                  icon: Icon(
                                    Icons.arrow_back_outlined,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                  onPressed: () async {
                                    context
                                        .read<ContactService>()
                                        .allDataContact = null;
                                    safeSetState(() {});
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              if (getJsonField(
                                    columnGetContactWithLocationResponse
                                        .jsonBody,
                                    r'''$[:].contact_name''',
                                  ) !=
                                  null)
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      getJsonField(
                                        columnGetContactWithLocationResponse
                                            .jsonBody,
                                        r'''$[:].contact_name''',
                                      ).toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .headlineMediumFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .headlineMediumIsCustom,
                                          ),
                                    ).animateOnPageLoad(animationsMap[
                                        'textOnPageLoadAnimation1']!),
                                  ),
                                ),
                              if ((getJsonField(
                                        columnGetContactWithLocationResponse
                                            .jsonBody,
                                        r'''$[:].contact_last_name''',
                                      ) !=
                                      null) &&
                                  (GetContactWithLocationCall.isCompany(
                                        columnGetContactWithLocationResponse
                                            .jsonBody,
                                      ) ==
                                      false))
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        3.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      getJsonField(
                                        columnGetContactWithLocationResponse
                                            .jsonBody,
                                        r'''$[:].contact_last_name''',
                                      ).toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .headlineMediumFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .headlineMediumIsCustom,
                                          ),
                                    ).animateOnPageLoad(animationsMap[
                                        'textOnPageLoadAnimation2']!),
                                  ),
                                ),
                              if (GetContactWithLocationCall.isCompany(
                                    columnGetContactWithLocationResponse
                                        .jsonBody,
                                  ) ==
                                  true)
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        7.0, 0.0, 0.0, 0.0),
                                    child: Icon(
                                      Icons.business,
                                      color: BukeerColors.primary,
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x2C000000),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(0.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 8.0, 8.0, 12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: AnimatedContainer(
                                          duration: UiConstants.animationDurationFast,
                                          curve: Curves.easeInOut,
                                          width: 90.0,
                                          height: 90.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .accent1,
                                            borderRadius: BorderRadius.circular(
                                                BukeerSpacing.s),
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
                                                  BorderRadius.circular(10.0),
                                              child: Image.network(
                                                valueOrDefault<String>(
                                                  getJsonField(
                                                    columnGetContactWithLocationResponse
                                                        .jsonBody,
                                                    r'''$[:].contact_user_image''',
                                                  )?.toString(),
                                                  'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8dXNlcnN8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                                                ),
                                                width: 64.0,
                                                height: 64.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 0.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 8.0),
                                                child: Wrap(
                                                  spacing: 0.0,
                                                  runSpacing: 0.0,
                                                  alignment:
                                                      WrapAlignment.start,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.start,
                                                  direction: Axis.horizontal,
                                                  runAlignment:
                                                      WrapAlignment.start,
                                                  verticalDirection:
                                                      VerticalDirection.down,
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    if (getJsonField(
                                                          columnGetContactWithLocationResponse
                                                              .jsonBody,
                                                          r'''$[:].contact_type_id''',
                                                        ) !=
                                                        null)
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .idCard,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 18.0,
                                                          ),
                                                          Flexible(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          12.0,
                                                                          0.0),
                                                              child: Text(
                                                                getJsonField(
                                                                  columnGetContactWithLocationResponse
                                                                      .jsonBody,
                                                                  r'''$[:].contact_type_id''',
                                                                ).toString(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyLargeFamily,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyLargeIsCustom,
                                                                    ),
                                                              ).animateOnPageLoad(
                                                                  animationsMap[
                                                                      'textOnPageLoadAnimation3']!),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    if (getJsonField(
                                                          columnGetContactWithLocationResponse
                                                              .jsonBody,
                                                          r'''$[:].contact_number_id''',
                                                        ) !=
                                                        null)
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.grid_3x3,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 18.0,
                                                          ),
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          4.0,
                                                                          0.0,
                                                                          12.0,
                                                                          0.0),
                                                              child: Text(
                                                                getJsonField(
                                                                  columnGetContactWithLocationResponse
                                                                      .jsonBody,
                                                                  r'''$[:].contact_number_id''',
                                                                ).toString(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyLargeFamily,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyLargeIsCustom,
                                                                    ),
                                                              ).animateOnPageLoad(
                                                                  animationsMap[
                                                                      'textOnPageLoadAnimation4']!),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Wrap(
                                                    spacing: 0.0,
                                                    runSpacing: 0.0,
                                                    alignment:
                                                        WrapAlignment.start,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .start,
                                                    direction: Axis.horizontal,
                                                    runAlignment:
                                                        WrapAlignment.center,
                                                    verticalDirection:
                                                        VerticalDirection.down,
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      if (GetContactWithLocationCall
                                                              .isProvider(
                                                            columnGetContactWithLocationResponse
                                                                .jsonBody,
                                                          ) ==
                                                          true)
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      8.0,
                                                                      0.0),
                                                          child: Container(
                                                            height: 32.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .accent1,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16.0,
                                                                          0.0,
                                                                          16.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Proveedor',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      if (GetContactWithLocationCall
                                                              .isClient(
                                                            columnGetContactWithLocationResponse
                                                                .jsonBody,
                                                          ) ==
                                                          true)
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      8.0,
                                                                      0.0),
                                                          child:
                                                              AnimatedContainer(
                                                            duration: UiConstants.animationDurationFast,
                                                            curve: Curves
                                                                .easeInOut,
                                                            height: 32.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .accent2,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child: Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        0.0,
                                                                        16.0,
                                                                        0.0),
                                                                child: Text(
                                                                  'Cliente',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
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
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: BukeerIconButton(
                                              size: BukeerIconButtonSize.small,
                                              variant: BukeerIconButtonVariant
                                                  .outlined,
                                              icon: Icon(
                                                Icons.edit_outlined,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 24.0,
                                              ),
                                              onPressed: () async {
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
                                                          ModalAddEditContactWidget(
                                                        isEdit: true,
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 5.0, 0.0, 0.0),
                                            child: BukeerIconButton(
                                              size: BukeerIconButtonSize.small,
                                              variant: BukeerIconButtonVariant
                                                  .outlined,
                                              icon: FaIcon(
                                                FontAwesomeIcons.trashAlt,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 24.0,
                                              ),
                                              onPressed: () async {
                                                var confirmDialogResponse =
                                                    await showDialog<bool>(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Mensaje'),
                                                              content: Text(
                                                                  '¿Está seguro que desea borrar este contacto?'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext,
                                                                          false),
                                                                  child: Text(
                                                                      'Cancelar'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext,
                                                                          true),
                                                                  child: Text(
                                                                      'Confirmar'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ) ??
                                                        false;
                                                if (confirmDialogResponse) {
                                                  _model.apiResponseValidateDeleteContact =
                                                      await ValidateDeleteContactCall
                                                          .call(
                                                    authToken: currentJwtToken,
                                                    id: getJsonField(
                                                      columnGetContactWithLocationResponse
                                                          .jsonBody,
                                                      r'''$[:].contact_id''',
                                                    ).toString(),
                                                    isProvider: getJsonField(
                                                      columnGetContactWithLocationResponse
                                                          .jsonBody,
                                                      r'''$[:].contact_is_provider''',
                                                    ),
                                                    isClient: getJsonField(
                                                      columnGetContactWithLocationResponse
                                                          .jsonBody,
                                                      r'''$[:].contact_is_client''',
                                                    ),
                                                  );

                                                  if ((_model
                                                          .apiResponseValidateDeleteContact
                                                          ?.succeeded ??
                                                      true)) {
                                                    if ((_model.apiResponseValidateDeleteContact
                                                                ?.bodyText ??
                                                            '') ==
                                                        '200') {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title:
                                                                Text('Mensaje'),
                                                            content: Text(
                                                                'Este contacto no puede ser borrado porque tiene items asociados'),
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
                                                    } else {
                                                      await ContactsTable()
                                                          .delete(
                                                        matchingRows: (rows) =>
                                                            rows.eqOrNull(
                                                          'id',
                                                          getJsonField(
                                                            columnGetContactWithLocationResponse
                                                                .jsonBody,
                                                            r'''$[:].contact_id''',
                                                          ).toString(),
                                                        ),
                                                      );
                                                      await LocationsTable()
                                                          .delete(
                                                        matchingRows: (rows) =>
                                                            rows.eqOrNull(
                                                          'id',
                                                          getJsonField(
                                                            columnGetContactWithLocationResponse
                                                                .jsonBody,
                                                            r'''$[:].location_id''',
                                                          ).toString(),
                                                        ),
                                                      );
                                                      Navigator.pop(context);
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
                                                              'Hubo un error al borrar el contacto'),
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

                                                safeSetState(() {});
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 12.0),
                                  child: Text(
                                    'Información de contacto',
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .labelLargeFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .labelLargeIsCustom,
                                        ),
                                  ).animateOnPageLoad(animationsMap[
                                      'textOnPageLoadAnimation5']!),
                                ),
                                Wrap(
                                  spacing: 0.0,
                                  runSpacing: 0.0,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  direction: Axis.horizontal,
                                  runAlignment: WrapAlignment.start,
                                  verticalDirection: VerticalDirection.down,
                                  clipBehavior: Clip.none,
                                  children: [
                                    if (getJsonField(
                                          columnGetContactWithLocationResponse
                                              .jsonBody,
                                          r'''$[:].contact_phone''',
                                        ) !=
                                        null)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 18.0,
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 0.0, 12.0, 0.0),
                                                child: Text(
                                                  getJsonField(
                                                    columnGetContactWithLocationResponse
                                                        .jsonBody,
                                                    r'''$[:].contact_phone''',
                                                  ).toString(),
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
                                                ).animateOnPageLoad(animationsMap[
                                                    'textOnPageLoadAnimation6']!),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (getJsonField(
                                          columnGetContactWithLocationResponse
                                              .jsonBody,
                                          r'''$[:].contact_phone2''',
                                        ) !=
                                        null)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 18.0,
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 0.0, 12.0, 0.0),
                                                child: Text(
                                                  getJsonField(
                                                    columnGetContactWithLocationResponse
                                                        .jsonBody,
                                                    r'''$[:].contact_phone2''',
                                                  ).toString(),
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
                                                ).animateOnPageLoad(animationsMap[
                                                    'textOnPageLoadAnimation7']!),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (getJsonField(
                                          columnGetContactWithLocationResponse
                                              .jsonBody,
                                          r'''$[:].contact_email''',
                                        ) !=
                                        null)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.email,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 18.0,
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 0.0, 12.0, 0.0),
                                                child: Text(
                                                  getJsonField(
                                                    columnGetContactWithLocationResponse
                                                        .jsonBody,
                                                    r'''$[:].contact_email''',
                                                  ).toString(),
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
                                                ).animateOnPageLoad(animationsMap[
                                                    'textOnPageLoadAnimation8']!),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (getJsonField(
                                          columnGetContactWithLocationResponse
                                              .jsonBody,
                                          r'''$[:].location_name''',
                                        ) !=
                                        null)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.mapMarkerAlt,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 18.0,
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 0.0, 12.0, 0.0),
                                                child: Text(
                                                  getJsonField(
                                                    columnGetContactWithLocationResponse
                                                        .jsonBody,
                                                    r'''$[:].location_name''',
                                                  ).toString(),
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
                                                ).animateOnPageLoad(animationsMap[
                                                    'textOnPageLoadAnimation9']!),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (getJsonField(
                                          columnGetContactWithLocationResponse
                                              .jsonBody,
                                          r'''$[:].contact_website''',
                                        ) !=
                                        null)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.link,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 18.0,
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 0.0, 12.0, 0.0),
                                                child: Text(
                                                  getJsonField(
                                                    columnGetContactWithLocationResponse
                                                        .jsonBody,
                                                    r'''$[:].contact_website''',
                                                  ).toString(),
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
                                                ).animateOnPageLoad(animationsMap[
                                                    'textOnPageLoadAnimation10']!),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation2']!),
                        Container(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          decoration: BoxDecoration(
                            color: BukeerColors.getBackground(context),
                            borderRadius:
                                BorderRadius.circular(BukeerSpacing.s),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (GetContactWithLocationCall.isClient(
                                      columnGetContactWithLocationResponse
                                          .jsonBody,
                                    ) ==
                                    true)
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      _model.activeTab = 1;
                                      safeSetState(() {});
                                    },
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.list,
                                            color: _model.activeTab == 1
                                                ? FlutterFlowTheme.of(context)
                                                    .primary
                                                : FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            size: 20.0,
                                          ),
                                          Text(
                                            'Itinerarios',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  color: _model.activeTab == 1
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryText,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ].divide(
                                            SizedBox(width: BukeerSpacing.s)),
                                      ),
                                    ),
                                  ),
                                if (GetContactWithLocationCall.isProvider(
                                      columnGetContactWithLocationResponse
                                          .jsonBody,
                                    ) ==
                                    true)
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      _model.activeTab = 2;
                                      safeSetState(() {});
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.grid_view,
                                          color: _model.activeTab == 2
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                          size: 20.0,
                                        ),
                                        Text(
                                          'Productos',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: _model.activeTab == 2
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .primary
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ].divide(
                                          SizedBox(width: BukeerSpacing.s)),
                                    ),
                                  ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _model.activeTab = 3;
                                    safeSetState(() {});
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        Icons.grid_view,
                                        color: _model.activeTab == 3
                                            ? FlutterFlowTheme.of(context)
                                                .primary
                                            : FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        size: 20.0,
                                      ),
                                      Text(
                                        'Contactos',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: _model.activeTab == 3
                                                  ? FlutterFlowTheme.of(context)
                                                      .primary
                                                  : FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ].divide(SizedBox(width: BukeerSpacing.s)),
                                  ),
                                ),
                              ].divide(SizedBox(width: BukeerSpacing.l)),
                            ),
                          ),
                        ),
                        if ((_model.activeTab == 1) &&
                            (GetContactWithLocationCall.isClient(
                                  columnGetContactWithLocationResponse.jsonBody,
                                ) ==
                                true))
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 16.0),
                            child: Container(
                              width: 700.0,
                              height: 700.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: FutureBuilder<ApiCallResponse>(
                                future: GetItinerariesByContactCall.call(
                                  id: getJsonField(
                                    columnGetContactWithLocationResponse
                                        .jsonBody,
                                    r'''$[:].contact_id''',
                                  ).toString(),
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
                                  final staggeredViewGetItinerariesByContactResponse =
                                      snapshot.data!;

                                  return Builder(
                                    builder: (context) {
                                      final itineraryItem =
                                          staggeredViewGetItinerariesByContactResponse
                                              .jsonBody
                                              .toList();

                                      return MasonryGridView.builder(
                                        gridDelegate:
                                            SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                        ),
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        itemCount: itineraryItem.length,
                                        itemBuilder:
                                            (context, itineraryItemIndex) {
                                          final itineraryItemItem =
                                              itineraryItem[itineraryItemIndex];
                                          return ItinerariesContainerWidget(
                                            key: Key(
                                                'Keyw7q_${itineraryItemIndex}_of_${itineraryItem.length}'),
                                            name: getJsonField(
                                              itineraryItemItem,
                                              r'''$.name''',
                                            ).toString(),
                                            passengerCount: getJsonField(
                                              itineraryItemItem,
                                              r'''$.passenger_count''',
                                            ),
                                            agent: getJsonField(
                                              itineraryItemItem,
                                              r'''$.agent''',
                                            ).toString(),
                                            startDate: getJsonField(
                                              itineraryItemItem,
                                              r'''$.start_date''',
                                            ).toString(),
                                            endDate: getJsonField(
                                              itineraryItemItem,
                                              r'''$.end_date''',
                                            ).toString(),
                                            idFm: getJsonField(
                                              itineraryItemItem,
                                              r'''$.id_fm''',
                                            ).toString(),
                                            totalCost: getJsonField(
                                              itineraryItemItem,
                                              r'''$.total_cost''',
                                            ),
                                            totalAmount: getJsonField(
                                              itineraryItemItem,
                                              r'''$.total_amount''',
                                            ),
                                            status: getJsonField(
                                              itineraryItemItem,
                                              r'''$.status''',
                                            ).toString(),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        if ((_model.activeTab == 2) &&
                            (GetContactWithLocationCall.isProvider(
                                  columnGetContactWithLocationResponse.jsonBody,
                                ) ==
                                true))
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 16.0),
                            child: Container(
                              width: 700.0,
                              height: 700.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 6.7,
                                height: 600.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment(-1.0, 0),
                                        child: FlutterFlowButtonTabBar(
                                          useToggleButtonStyle: true,
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMediumFamily,
                                                fontSize: BukeerTypography
                                                    .bodySmallSize,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleMediumIsCustom,
                                              ),
                                          unselectedLabelStyle: TextStyle(),
                                          labelColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          unselectedLabelColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .accent1,
                                          unselectedBackgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .alternate,
                                          unselectedBorderColor:
                                              FlutterFlowTheme.of(context)
                                                  .alternate,
                                          borderWidth: 2.0,
                                          borderRadius: 0.0,
                                          elevation: 0.0,
                                          buttonMargin:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 0.0, 8.0, 0.0),
                                          tabs: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                      BukeerSpacing.xs),
                                                  child: Icon(
                                                    Icons
                                                        .local_activity_outlined,
                                                    size: 20.0,
                                                  ),
                                                ),
                                                Tab(
                                                  text: 'Actividades',
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                      BukeerSpacing.xs),
                                                  child: Icon(
                                                    Icons
                                                        .local_activity_outlined,
                                                    size: 20.0,
                                                  ),
                                                ),
                                                Tab(
                                                  text: 'Hoteles',
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                      BukeerSpacing.xs),
                                                  child: Icon(
                                                    Icons.directions_car,
                                                    size: 20.0,
                                                  ),
                                                ),
                                                Tab(
                                                  text: 'Transfer',
                                                ),
                                              ],
                                            ),
                                          ],
                                          controller: _model.tabBarController,
                                          onTap: (i) async {
                                            [
                                              () async {
                                                context
                                                        .read<UiStateService>()
                                                        .selectedProductType =
                                                    'activities';
                                                safeSetState(() {});
                                              },
                                              () async {
                                                context
                                                        .read<UiStateService>()
                                                        .selectedProductType =
                                                    'hotels';
                                                safeSetState(() {});
                                              },
                                              () async {
                                                context
                                                        .read<UiStateService>()
                                                        .selectedProductType =
                                                    'transfers';
                                                safeSetState(() {});
                                              }
                                            ][i]();
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          controller: _model.tabBarController,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              1.0, 0.0),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            BukeerSpacing.s),
                                                        child: FFButtonWidget(
                                                          onPressed: () async {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Padding(
                                                                  padding: MediaQuery
                                                                      .viewInsetsOf(
                                                                          context),
                                                                  child:
                                                                      ModalAddProductWidget(
                                                                    idContact:
                                                                        getJsonField(
                                                                      columnGetContactWithLocationResponse
                                                                          .jsonBody,
                                                                      r'''$[:].contact_id''',
                                                                    ).toString(),
                                                                    actionType:
                                                                        'add',
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));
                                                          },
                                                          text:
                                                              'Agregar actividad',
                                                          icon: Icon(
                                                            Icons.add,
                                                            size: 15.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            padding:
                                                                EdgeInsets.all(BukeerSpacing.s),
                                                            iconAlignment:
                                                                IconAlignment
                                                                    .end,
                                                            iconPadding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            textStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .info,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
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
                                                    ),
                                                    FutureBuilder<
                                                        ApiCallResponse>(
                                                      future: GetActivitiesCall
                                                          .call(
                                                        id: getJsonField(
                                                          columnGetContactWithLocationResponse
                                                              .jsonBody,
                                                          r'''$[:].contact_id''',
                                                        ).toString(),
                                                        authToken:
                                                            currentJwtToken,
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
                                                        // Customize what your widget looks like when it's loading.
                                                        if (!snapshot.hasData) {
                                                          return Center(
                                                            child: SizedBox(
                                                              width: 50.0,
                                                              height: 50.0,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        final listViewGetActivitiesResponse =
                                                            snapshot.data!;

                                                        return Builder(
                                                          builder: (context) {
                                                            final activityItem =
                                                                listViewGetActivitiesResponse
                                                                    .jsonBody
                                                                    .toList();

                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              primary: false,
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount:
                                                                  activityItem
                                                                      .length,
                                                              itemBuilder: (context,
                                                                  activityItemIndex) {
                                                                final activityItemItem =
                                                                    activityItem[
                                                                        activityItemIndex];
                                                                return InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              ModalDetailsProductWidget(
                                                                            dataActivity:
                                                                                activityItemItem,
                                                                            type:
                                                                                context.read<UiStateService>().selectedProductType,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  child:
                                                                      ActivitiesContainerWidget(
                                                                    key: Key(
                                                                        'Key1b9_${activityItemIndex}_of_${activityItem.length}'),
                                                                    name: valueOrDefault<
                                                                        String>(
                                                                      getJsonField(
                                                                        activityItemItem,
                                                                        r'''$.name''',
                                                                      )?.toString(),
                                                                      'Sin nombre',
                                                                    ),
                                                                    location:
                                                                        valueOrDefault<
                                                                            String>(
                                                                      getJsonField(
                                                                        activityItemItem,
                                                                        r'''$.city''',
                                                                      )?.toString(),
                                                                      'Sin ubicación',
                                                                    ),
                                                                    descriptionShort:
                                                                        valueOrDefault<
                                                                            String>(
                                                                      getJsonField(
                                                                        activityItemItem,
                                                                        r'''$.description''',
                                                                      )?.toString(),
                                                                      'Sin descripción',
                                                                    ),
                                                                    image: valueOrDefault<
                                                                        String>(
                                                                      getJsonField(
                                                                        activityItemItem,
                                                                        r'''$.main_image''',
                                                                      )?.toString(),
                                                                      'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg',
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              1.0, 0.0),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            BukeerSpacing.s),
                                                        child: FFButtonWidget(
                                                          onPressed: () async {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Padding(
                                                                  padding: MediaQuery
                                                                      .viewInsetsOf(
                                                                          context),
                                                                  child:
                                                                      ModalAddProductWidget(
                                                                    idContact:
                                                                        getJsonField(
                                                                      columnGetContactWithLocationResponse
                                                                          .jsonBody,
                                                                      r'''$[:].contact_id''',
                                                                    ).toString(),
                                                                    actionType:
                                                                        'add',
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));
                                                          },
                                                          text: 'Agregar hotel',
                                                          icon: Icon(
                                                            Icons.add,
                                                            size: 15.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            padding:
                                                                EdgeInsets.all(BukeerSpacing.s),
                                                            iconAlignment:
                                                                IconAlignment
                                                                    .end,
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
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .info,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
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
                                                    ),
                                                    FutureBuilder<
                                                        ApiCallResponse>(
                                                      future:
                                                          GetHotelsByIdProviderCall
                                                              .call(
                                                        id: getJsonField(
                                                          columnGetContactWithLocationResponse
                                                              .jsonBody,
                                                          r'''$[:].contact_id''',
                                                        ).toString(),
                                                        authToken:
                                                            currentJwtToken,
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
                                                        // Customize what your widget looks like when it's loading.
                                                        if (!snapshot.hasData) {
                                                          return Center(
                                                            child: SizedBox(
                                                              width: 50.0,
                                                              height: 50.0,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        final listViewGetHotelsByIdProviderResponse =
                                                            snapshot.data!;

                                                        return Builder(
                                                          builder: (context) {
                                                            final itemHotels =
                                                                listViewGetHotelsByIdProviderResponse
                                                                    .jsonBody
                                                                    .toList();

                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              primary: false,
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount:
                                                                  itemHotels
                                                                      .length,
                                                              itemBuilder: (context,
                                                                  itemHotelsIndex) {
                                                                final itemHotelsItem =
                                                                    itemHotels[
                                                                        itemHotelsIndex];
                                                                return InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              ModalDetailsProductWidget(
                                                                            dataActivity:
                                                                                itemHotelsItem,
                                                                            type:
                                                                                context.read<UiStateService>().selectedProductType,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  child:
                                                                      HotelsContainerWidget(
                                                                    key: Key(
                                                                        'Key9jq_${itemHotelsIndex}_of_${itemHotels.length}'),
                                                                    name: valueOrDefault<
                                                                        String>(
                                                                      getJsonField(
                                                                        itemHotelsItem,
                                                                        r'''$.name''',
                                                                      )?.toString(),
                                                                      'Sin nombre',
                                                                    ),
                                                                    location:
                                                                        valueOrDefault<
                                                                            String>(
                                                                      getJsonField(
                                                                        itemHotelsItem,
                                                                        r'''$.city''',
                                                                      )?.toString(),
                                                                      'Sin ubicación',
                                                                    ),
                                                                    descriptionShort:
                                                                        valueOrDefault<
                                                                            String>(
                                                                      getJsonField(
                                                                        itemHotelsItem,
                                                                        r'''$.description''',
                                                                      )?.toString(),
                                                                      'Sin descripción',
                                                                    ),
                                                                    image: valueOrDefault<
                                                                        String>(
                                                                      getJsonField(
                                                                        itemHotelsItem,
                                                                        r'''$.main_image''',
                                                                      )?.toString(),
                                                                      'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg',
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              1.0, 0.0),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            BukeerSpacing.s),
                                                        child: FFButtonWidget(
                                                          onPressed: () async {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Padding(
                                                                  padding: MediaQuery
                                                                      .viewInsetsOf(
                                                                          context),
                                                                  child:
                                                                      ModalAddProductWidget(
                                                                    idContact:
                                                                        getJsonField(
                                                                      columnGetContactWithLocationResponse
                                                                          .jsonBody,
                                                                      r'''$[:].contact_id''',
                                                                    ).toString(),
                                                                    actionType:
                                                                        'add',
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));
                                                          },
                                                          text:
                                                              'Agregar transfer',
                                                          icon: Icon(
                                                            Icons.add,
                                                            size: 15.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            padding:
                                                                EdgeInsets.all(BukeerSpacing.s),
                                                            iconAlignment:
                                                                IconAlignment
                                                                    .end,
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
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .info,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
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
                                                    ),
                                                    FutureBuilder<
                                                        ApiCallResponse>(
                                                      future:
                                                          GetTransfersByIdProviderCall
                                                              .call(
                                                        id: getJsonField(
                                                          columnGetContactWithLocationResponse
                                                              .jsonBody,
                                                          r'''$[:].contact_id''',
                                                        ).toString(),
                                                        authToken:
                                                            currentJwtToken,
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
                                                        // Customize what your widget looks like when it's loading.
                                                        if (!snapshot.hasData) {
                                                          return Center(
                                                            child: SizedBox(
                                                              width: 50.0,
                                                              height: 50.0,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        final listViewGetTransfersByIdProviderResponse =
                                                            snapshot.data!;

                                                        return Builder(
                                                          builder: (context) {
                                                            final itemTransfers =
                                                                listViewGetTransfersByIdProviderResponse
                                                                    .jsonBody
                                                                    .toList();

                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              primary: false,
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount:
                                                                  itemTransfers
                                                                      .length,
                                                              itemBuilder: (context,
                                                                  itemTransfersIndex) {
                                                                final itemTransfersItem =
                                                                    itemTransfers[
                                                                        itemTransfersIndex];
                                                                return InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              ModalDetailsProductWidget(
                                                                            dataActivity:
                                                                                itemTransfersItem,
                                                                            type:
                                                                                context.read<UiStateService>().selectedProductType,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then((value) =>
                                                                        safeSetState(
                                                                            () {}));
                                                                  },
                                                                  child:
                                                                      TransfersContainerWidget(
                                                                    key: Key(
                                                                        'Key98g_${itemTransfersIndex}_of_${itemTransfers.length}'),
                                                                    name: valueOrDefault<
                                                                        String>(
                                                                      getJsonField(
                                                                        itemTransfersItem,
                                                                        r'''$.name''',
                                                                      )?.toString(),
                                                                      'Sin nombre',
                                                                    ),
                                                                    location:
                                                                        valueOrDefault<
                                                                            String>(
                                                                      getJsonField(
                                                                        itemTransfersItem,
                                                                        r'''$.city''',
                                                                      )?.toString(),
                                                                      'Desconocida',
                                                                    ),
                                                                    descriptionShort:
                                                                        valueOrDefault<
                                                                            String>(
                                                                      getJsonField(
                                                                        itemTransfersItem,
                                                                        r'''$.description''',
                                                                      )?.toString(),
                                                                      'Sin descripción',
                                                                    ),
                                                                    image: valueOrDefault<
                                                                        String>(
                                                                      getJsonField(
                                                                        itemTransfersItem,
                                                                        r'''$.main_image''',
                                                                      )?.toString(),
                                                                      'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg',
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        );
                                                      },
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
                            ),
                          ),
                        if (_model.activeTab == 3)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 16.0),
                            child: Container(
                              width: 700.0,
                              height: 700.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: SingleChildScrollView(
                                primary: false,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 4.0),
                                      child: SingleChildScrollView(
                                        primary: false,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 16.0, 8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(4.0, 8.0,
                                                                8.0, 8.0),
                                                    child: FFButtonWidget(
                                                      onPressed: () async {
                                                        _model.createContact =
                                                            true;
                                                        safeSetState(() {});
                                                      },
                                                      text: 'Agregar contactos',
                                                      icon: Icon(
                                                        Icons.add_sharp,
                                                        size: 24.0,
                                                      ),
                                                      options: FFButtonOptions(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    12.0,
                                                                    12.0,
                                                                    8.0,
                                                                    12.0),
                                                        iconAlignment:
                                                            IconAlignment.end,
                                                        iconPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .info,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                        elevation: 3.0,
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
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
                                            Divider(
                                              height: 1.0,
                                              thickness: 1.0,
                                              indent: 0.0,
                                              endIndent: 0.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            SingleChildScrollView(
                                              primary: false,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Form(
                                                    key: _model.formKey,
                                                    autovalidateMode:
                                                        AutovalidateMode.always,
                                                    child: Visibility(
                                                      visible: _model
                                                              .createContact ==
                                                          true,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    -1.0, 0.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          24.0,
                                                                          5.0,
                                                                          0.0,
                                                                          5.0),
                                                              child: Text(
                                                                'Nuevo contacto relacionado',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .headlineMediumFamily,
                                                                      fontSize:
                                                                          18.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .headlineMediumIsCustom,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          Divider(
                                                            thickness: 2.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                          ),
                                                          Wrap(
                                                            spacing: 8.0,
                                                            runSpacing: 8.0,
                                                            alignment:
                                                                WrapAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .start,
                                                            direction:
                                                                Axis.horizontal,
                                                            runAlignment:
                                                                WrapAlignment
                                                                    .start,
                                                            verticalDirection:
                                                                VerticalDirection
                                                                    .down,
                                                            clipBehavior:
                                                                Clip.none,
                                                            children: [
                                                              Container(
                                                                width: 297.0,
                                                                child:
                                                                    TextFormField(
                                                                  controller: _model
                                                                      .nameContactTextController,
                                                                  focusNode: _model
                                                                      .nameContactFocusNode,
                                                                  autofocus:
                                                                      false,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Nombre',
                                                                    labelStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).labelMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                        ),
                                                                    hintStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).labelMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                        ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    errorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    filled:
                                                                        true,
                                                                    fillColor: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    contentPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            20.0,
                                                                            24.0,
                                                                            20.0,
                                                                            24.0),
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                  cursorColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                  validator: _model
                                                                      .nameContactTextControllerValidator
                                                                      .asValidator(
                                                                          context),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 299.0,
                                                                child:
                                                                    TextFormField(
                                                                  controller: _model
                                                                      .lastNameContactTextController,
                                                                  focusNode: _model
                                                                      .lastNameContactFocusNode,
                                                                  autofocus:
                                                                      false,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Apellido',
                                                                    labelStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).labelMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                        ),
                                                                    hintStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).labelMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                        ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    errorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    filled:
                                                                        true,
                                                                    fillColor: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    contentPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            20.0,
                                                                            24.0,
                                                                            20.0,
                                                                            24.0),
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                  cursorColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                  validator: _model
                                                                      .lastNameContactTextControllerValidator
                                                                      .asValidator(
                                                                          context),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 299.0,
                                                                child:
                                                                    TextFormField(
                                                                  controller: _model
                                                                      .phoneContactTextController,
                                                                  focusNode: _model
                                                                      .phoneContactFocusNode,
                                                                  autofocus:
                                                                      false,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Celular',
                                                                    labelStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).labelMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                        ),
                                                                    hintStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).labelMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                        ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    errorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    filled:
                                                                        true,
                                                                    fillColor: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    contentPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            20.0,
                                                                            24.0,
                                                                            20.0,
                                                                            24.0),
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                  cursorColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                  validator: _model
                                                                      .phoneContactTextControllerValidator
                                                                      .asValidator(
                                                                          context),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 299.0,
                                                                child:
                                                                    TextFormField(
                                                                  controller: _model
                                                                      .phone2ContactTextController,
                                                                  focusNode: _model
                                                                      .phone2ContactFocusNode,
                                                                  autofocus:
                                                                      false,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Celular 2',
                                                                    labelStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).labelMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                        ),
                                                                    hintStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).labelMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                        ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    errorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    filled:
                                                                        true,
                                                                    fillColor: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    contentPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            20.0,
                                                                            24.0,
                                                                            20.0,
                                                                            24.0),
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                  cursorColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                  validator: _model
                                                                      .phone2ContactTextControllerValidator
                                                                      .asValidator(
                                                                          context),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 297.0,
                                                                child:
                                                                    TextFormField(
                                                                  controller: _model
                                                                      .mailContactTextController,
                                                                  focusNode: _model
                                                                      .mailContactFocusNode,
                                                                  autofocus:
                                                                      false,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Email',
                                                                    labelStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).labelMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                        ),
                                                                    hintStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).labelMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                        ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    errorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                    ),
                                                                    filled:
                                                                        true,
                                                                    fillColor: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    contentPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            20.0,
                                                                            24.0,
                                                                            20.0,
                                                                            24.0),
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .datetime,
                                                                  cursorColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                  validator: _model
                                                                      .mailContactTextControllerValidator
                                                                      .asValidator(
                                                                          context),
                                                                ),
                                                              ),
                                                              if (widget!
                                                                      .isProvider ==
                                                                  true)
                                                                Container(
                                                                  width: 297.0,
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _model
                                                                            .positionContactTextController,
                                                                    focusNode:
                                                                        _model
                                                                            .positionContactFocusNode,
                                                                    autofocus:
                                                                        false,
                                                                    obscureText:
                                                                        false,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Cargo',
                                                                      labelStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelMediumFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                          ),
                                                                      hintStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelMediumFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                          ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(BukeerSpacing.s),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              BukeerColors.primary,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(BukeerSpacing.s),
                                                                      ),
                                                                      errorBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              BukeerColors.error,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(BukeerSpacing.s),
                                                                      ),
                                                                      focusedErrorBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              BukeerColors.error,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(BukeerSpacing.s),
                                                                      ),
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondaryBackground,
                                                                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          20.0,
                                                                          24.0,
                                                                          20.0,
                                                                          24.0),
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .datetime,
                                                                    cursorColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                    validator: _model
                                                                        .positionContactTextControllerValidator
                                                                        .asValidator(
                                                                            context),
                                                                  ),
                                                                ),
                                                              wrapWithModel(
                                                                model: _model
                                                                    .placePickerModel,
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child:
                                                                    PlacePickerWidget(),
                                                              ),
                                                              if (widget!
                                                                      .isProvider ==
                                                                  true)
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          10.0,
                                                                          0.0,
                                                                          20.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            10.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          'Notificar',
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                fontSize: 17.0,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                      Theme(
                                                                        data:
                                                                            ThemeData(
                                                                          checkboxTheme:
                                                                              CheckboxThemeData(
                                                                            visualDensity:
                                                                                VisualDensity.compact,
                                                                            materialTapTargetSize:
                                                                                MaterialTapTargetSize.shrinkWrap,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(BukeerSpacing.xs),
                                                                            ),
                                                                          ),
                                                                          unselectedWidgetColor:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                        ),
                                                                        child:
                                                                            Checkbox(
                                                                          value: _model.notifyValue ??=
                                                                              false,
                                                                          onChanged:
                                                                              (newValue) async {
                                                                            safeSetState(() =>
                                                                                _model.notifyValue = newValue!);
                                                                          },
                                                                          side: (FlutterFlowTheme.of(context).alternate != null)
                                                                              ? BorderSide(
                                                                                  width: 2,
                                                                                  color: FlutterFlowTheme.of(context).alternate!,
                                                                                )
                                                                              : null,
                                                                          activeColor:
                                                                              BukeerColors.primary,
                                                                          checkColor:
                                                                              BukeerColors.info,
                                                                        ),
                                                                      ),
                                                                    ].addToEnd(
                                                                        SizedBox(
                                                                            width:
                                                                                50.0)),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                          Divider(
                                                            thickness: 2.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        24.0,
                                                                        8.0,
                                                                        24.0,
                                                                        8.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.05),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      _model.createContact =
                                                                          false;
                                                                      safeSetState(
                                                                          () {});
                                                                    },
                                                                    text:
                                                                        'Cancel',
                                                                    options:
                                                                        FFButtonOptions(
                                                                      height:
                                                                          44.0,
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          24.0,
                                                                          0.0,
                                                                          24.0,
                                                                          0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                      elevation:
                                                                          0.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                      hoverColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .alternate,
                                                                      hoverBorderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      hoverTextColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .primaryText,
                                                                      hoverElevation:
                                                                          3.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.05),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      var _shouldSetState =
                                                                          false;
                                                                      _model.responseFormAddContact =
                                                                          true;
                                                                      if (_model.formKey.currentState ==
                                                                              null ||
                                                                          !_model
                                                                              .formKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                        _model.responseFormAddContact =
                                                                            false;
                                                                      }
                                                                      _shouldSetState =
                                                                          true;
                                                                      context.read<UiStateService>().selectedLocationLatLng = _model
                                                                          .placePickerModel
                                                                          .placePickerValue
                                                                          .latLng
                                                                          .toString();
                                                                      context.read<UiStateService>().selectedLocationName = _model
                                                                          .placePickerModel
                                                                          .placePickerValue
                                                                          .name;
                                                                      context.read<UiStateService>().selectedLocationAddress = _model
                                                                          .placePickerModel
                                                                          .placePickerValue
                                                                          .address;
                                                                      context.read<UiStateService>().selectedLocationCity = _model
                                                                          .placePickerModel
                                                                          .placePickerValue
                                                                          .city;
                                                                      context.read<UiStateService>().selectedLocationState = _model
                                                                          .placePickerModel
                                                                          .placePickerValue
                                                                          .state;
                                                                      context.read<UiStateService>().selectedLocationCountry = _model
                                                                          .placePickerModel
                                                                          .placePickerValue
                                                                          .country;
                                                                      context.read<UiStateService>().selectedLocationZipCode = _model
                                                                          .placePickerModel
                                                                          .placePickerValue
                                                                          .zipCode;
                                                                      safeSetState(
                                                                          () {});
                                                                      if (_model
                                                                          .responseFormAddContact!) {
                                                                        if (context.read<UiStateService>().selectedLocationLatLng !=
                                                                            'LatLng(lat: 0, lng: 0)') {
                                                                          _model.responseInsertLocation =
                                                                              await InsertLocationsCall.call(
                                                                            authToken:
                                                                                currentJwtToken,
                                                                            latlng:
                                                                                context.read<UiStateService>().selectedLocationLatLng,
                                                                            name:
                                                                                context.read<UiStateService>().selectedLocationName,
                                                                            address:
                                                                                context.read<UiStateService>().selectedLocationAddress,
                                                                            city:
                                                                                context.read<UiStateService>().selectedLocationCity,
                                                                            state:
                                                                                context.read<UiStateService>().selectedLocationState,
                                                                            country:
                                                                                context.read<UiStateService>().selectedLocationCountry,
                                                                            zipCode:
                                                                                context.read<UiStateService>().selectedLocationZipCode,
                                                                            accountId:
                                                                                appServices.account.accountId!,
                                                                            typeEntity:
                                                                                'contacts',
                                                                          );

                                                                          _shouldSetState =
                                                                              true;
                                                                          if ((_model.responseInsertLocation?.succeeded ??
                                                                              true)) {
                                                                            _model.insertContactApiResponse =
                                                                                await InsertRelatedContactCall.call(
                                                                              name: _model.nameContactTextController.text,
                                                                              lastName: _model.lastNameContactTextController.text,
                                                                              phone: _model.phoneContactTextController.text,
                                                                              email: _model.mailContactTextController.text,
                                                                              phone2: _model.phone2ContactTextController.text,
                                                                              isClient: true,
                                                                              isCompany: false,
                                                                              isProvider: false,
                                                                              authToken: currentJwtToken,
                                                                              birthDate: '0001-01-01',
                                                                              accountId: appServices.account.accountId!,
                                                                              location: (_model.responseInsertLocation?.jsonBody ?? '').toString(),
                                                                              idRelatedContact: getJsonField(
                                                                                columnGetContactWithLocationResponse.jsonBody,
                                                                                r'''$[:].contact_id''',
                                                                              ).toString(),
                                                                              position: _model.positionContactTextController.text,
                                                                              notify: _model.notifyValue,
                                                                            );

                                                                            _shouldSetState =
                                                                                true;
                                                                            if ((_model.insertContactApiResponse?.succeeded ??
                                                                                true)) {
                                                                              context.read<UiStateService>().selectedLocationLatLng = '';
                                                                              context.read<UiStateService>().selectedLocationName = '';
                                                                              context.read<UiStateService>().selectedLocationAddress = '';
                                                                              context.read<UiStateService>().selectedLocationCity = '';
                                                                              context.read<UiStateService>().selectedLocationState = '';
                                                                              context.read<UiStateService>().selectedLocationCountry = '';
                                                                              context.read<UiStateService>().selectedLocationZipCode = '';
                                                                              safeSetState(() {});
                                                                              safeSetState(() {
                                                                                _model.nameContactTextController?.clear();
                                                                                _model.phoneContactTextController?.clear();
                                                                                _model.mailContactTextController?.clear();
                                                                                _model.phone2ContactTextController?.clear();
                                                                                _model.lastNameContactTextController?.clear();
                                                                              });
                                                                              safeSetState(() => _model.listViewContactsPagingController?.refresh());
                                                                              await _model.waitForOnePageForListViewContacts();
                                                                            } else {
                                                                              await showDialog(
                                                                                context: context,
                                                                                builder: (alertDialogContext) {
                                                                                  return AlertDialog(
                                                                                    title: Text('Error'),
                                                                                    content: Text((_model.insertContactApiResponse?.jsonBody ?? '').toString()),
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
                                                                                safeSetState(() {});
                                                                              return;
                                                                            }
                                                                          } else {
                                                                            await showDialog(
                                                                              context: context,
                                                                              builder: (alertDialogContext) {
                                                                                return AlertDialog(
                                                                                  title: Text('Mensaje'),
                                                                                  content: Text('Hubo un error al crear la locación'),
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
                                                                              safeSetState(() {});
                                                                            return;
                                                                          }
                                                                        } else {
                                                                          await showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (alertDialogContext) {
                                                                              return AlertDialog(
                                                                                title: Text('Mensaje'),
                                                                                content: Text('La ubicación es obligatoria'),
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
                                                                            safeSetState(() {});
                                                                          return;
                                                                        }
                                                                      } else {
                                                                        await showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (alertDialogContext) {
                                                                            return AlertDialog(
                                                                              title: Text('Mensaje'),
                                                                              content: Text('Algunos campos son obligatorios '),
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

                                                                      if (_shouldSetState)
                                                                        safeSetState(
                                                                            () {});
                                                                    },
                                                                    text:
                                                                        'Agregar',
                                                                    options:
                                                                        FFButtonOptions(
                                                                      height:
                                                                          44.0,
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          24.0,
                                                                          0.0,
                                                                          24.0,
                                                                          0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).titleSmallFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(BukeerSpacing.sm),
                                                                      hoverColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .accent1,
                                                                      hoverBorderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      hoverTextColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .primaryText,
                                                                      hoverElevation:
                                                                          0.0,
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
                                                  PagedListView<ApiPagingParams,
                                                      dynamic>(
                                                    pagingController: _model
                                                        .setListViewContactsController(
                                                      (nextPageMarker) =>
                                                          GetRelatedContactCall
                                                              .call(
                                                        contactId: getJsonField(
                                                          columnGetContactWithLocationResponse
                                                              .jsonBody,
                                                          r'''$[:].contact_id''',
                                                        ).toString(),
                                                        authToken:
                                                            currentJwtToken,
                                                        pageNumber:
                                                            nextPageMarker
                                                                .nextPageNumber,
                                                        pageSize: 10,
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    reverse: false,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    builderDelegate:
                                                        PagedChildBuilderDelegate<
                                                            dynamic>(
                                                      // Customize what your widget looks like when it's loading the first page.
                                                      firstPageProgressIndicatorBuilder:
                                                          (_) => Center(
                                                        child: SizedBox(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                    Color>(
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primary,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // Customize what your widget looks like when it's loading another page.
                                                      newPageProgressIndicatorBuilder:
                                                          (_) => Center(
                                                        child: SizedBox(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                    Color>(
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primary,
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      itemBuilder: (context, _,
                                                          contactItemIndex) {
                                                        final contactItemItem =
                                                            _model.listViewContactsPagingController!
                                                                    .itemList![
                                                                contactItemIndex];
                                                        return ContactsContainerWidget(
                                                          key: Key(
                                                              'Keynib_${contactItemIndex}_of_${_model.listViewContactsPagingController!.itemList!.length}'),
                                                          name: getJsonField(
                                                            contactItemItem,
                                                            r'''$.name''',
                                                          ).toString(),
                                                          email: getJsonField(
                                                            contactItemItem,
                                                            r'''$.email''',
                                                          ).toString(),
                                                          phone: getJsonField(
                                                            contactItemItem,
                                                            r'''$.phone''',
                                                          ).toString(),
                                                          phone2: getJsonField(
                                                            contactItemItem,
                                                            r'''$.phone2''',
                                                          ).toString(),
                                                        );
                                                      },
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
                            ),
                          ),
                      ],
                    ),
                  ),
                ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation1']!),
              ),
            ],
          );
        },
      ),
    );
  }
}
