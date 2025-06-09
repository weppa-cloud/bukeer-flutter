import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import '../../../../backend/api_requests/api_calls.dart';
import 'package:bukeer/backend/supabase/supabase.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/components/index.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:bukeer/legacy/flutter_flow/upload_data.dart';
import 'dart:ui';
import '../../../../index.dart';
import '../../../../services/app_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'edit_personal_profile_model.dart';
export 'edit_personal_profile_model.dart';

class EditPersonalProfileWidget extends StatefulWidget {
  const EditPersonalProfileWidget({super.key});

  static String routeName = 'edit_personal_profile';
  static String routePath = 'editPersonalProfile';

  @override
  State<EditPersonalProfileWidget> createState() =>
      _EditPersonalProfileWidgetState();
}

class _EditPersonalProfileWidgetState extends State<EditPersonalProfileWidget> {
  late EditPersonalProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditPersonalProfileModel());

    _model.nameTextController ??= TextEditingController(
        text: getJsonField(
      appServices.user.selectedUser ?? appServices.user.agentData,
      r'''$[:].name''',
    ).toString().toString());
    _model.nameFocusNode ??= FocusNode();

    _model.lastNameTextController ??= TextEditingController(
        text: getJsonField(
      appServices.user.selectedUser ?? appServices.user.agentData,
      r'''$[:].last_name''',
    ).toString().toString());
    _model.lastNameFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<FFAppState>(); // Removed - using services instead

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: BukeerColors.getBackground(context, secondary: true),
      appBar: responsiveVisibility(
        context: context,
        tablet: false,
        tabletLandscape: false,
        desktop: false,
      )
          ? AppBar(
              backgroundColor:
                  BukeerColors.getBackground(context, secondary: true),
              automaticallyImplyLeading: false,
              leading: BukeerIconButton(
                size: BukeerIconButtonSize.large,
                variant: BukeerIconButtonVariant.ghost,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: BukeerColors.primaryText,
                  size: 30.0,
                ),
                onPressed: () async {
                  context.pushNamed(MainProfileAccountWidget.routeName);
                },
              ),
              title: Text(
                'Edit Profile',
                style: FlutterFlowTheme.of(context).titleLarge.override(
                      fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).titleLargeIsCustom,
                    ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 0.0,
            )
          : null,
      body: SafeArea(
        top: true,
        child: Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 530.0,
            ),
            decoration: BoxDecoration(
              color: BukeerColors.getBackground(context, secondary: true),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: BukeerSpacing.s),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          color: BukeerColors.primaryAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: BukeerColors.primary,
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(BukeerSpacing.xs),
                          child: Container(
                            width: 90.0,
                            height: 90.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CachedNetworkImage(
                              fadeInDuration: Duration(milliseconds: 500),
                              fadeOutDuration: Duration(milliseconds: 500),
                              imageUrl: () {
                                if (_model.uploadedFileUrl_uploadPersonalPhoto !=
                                        null &&
                                    _model.uploadedFileUrl_uploadPersonalPhoto !=
                                        '') {
                                  return _model
                                      .uploadedFileUrl_uploadPersonalPhoto;
                                } else if (getJsonField(
                                      appServices.user.selectedUser ??
                                          appServices.user.agentData,
                                      r'''$[:].user_image''',
                                    ) !=
                                    null) {
                                  return getJsonField(
                                    appServices.user.selectedUser ??
                                        appServices.user.agentData,
                                    r'''$[:].user_image''',
                                  ).toString();
                                } else {
                                  return 'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/profile_default.png';
                                }
                              }(),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FFButtonWidget(
                        onPressed: () async {
                          final selectedMedia =
                              await selectMediaWithSourceBottomSheet(
                            context: context,
                            storageFolderPath:
                                '${appServices.account.accountId}/profiles',
                            allowPhoto: true,
                          );
                          if (selectedMedia != null &&
                              selectedMedia.every((m) =>
                                  validateFileFormat(m.storagePath, context))) {
                            safeSetState(() => _model
                                .isDataUploading_uploadPersonalPhoto = true);
                            var selectedUploadedFiles = <FFUploadedFile>[];

                            var downloadUrls = <String>[];
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

                              downloadUrls = await uploadSupabaseStorageFiles(
                                bucketName: 'images',
                                selectedFiles: selectedMedia,
                              );
                            } finally {
                              _model.isDataUploading_uploadPersonalPhoto =
                                  false;
                            }
                            if (selectedUploadedFiles.length ==
                                    selectedMedia.length &&
                                downloadUrls.length == selectedMedia.length) {
                              safeSetState(() {
                                _model.uploadedLocalFile_uploadPersonalPhoto =
                                    selectedUploadedFiles.first;
                                _model.uploadedFileUrl_uploadPersonalPhoto =
                                    downloadUrls.first;
                              });
                            } else {
                              safeSetState(() {});
                              return;
                            }
                          }
                        },
                        text: 'Cambiar foto',
                        options: FFButtonOptions(
                          height: 44.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: BukeerColors.getBackground(context,
                              secondary: true),
                          textStyle: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
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
                          hoverTextColor: BukeerColors.primaryText,
                          hoverElevation: 3.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  child: TextFormField(
                    controller: _model.nameTextController,
                    focusNode: _model.nameFocusNode,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: FlutterFlowTheme.of(context)
                          .labelMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).labelMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .labelMediumIsCustom,
                          ),
                      hintStyle: FlutterFlowTheme.of(context)
                          .labelMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).labelMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .labelMediumIsCustom,
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
                      fillColor:
                          BukeerColors.getBackground(context, secondary: true),
                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                          20.0, 24.0, 20.0, 24.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                    cursorColor: BukeerColors.primary,
                    validator:
                        _model.nameTextControllerValidator.asValidator(context),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  child: TextFormField(
                    controller: _model.lastNameTextController,
                    focusNode: _model.lastNameFocusNode,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Apellido',
                      labelStyle: FlutterFlowTheme.of(context)
                          .labelMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).labelMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .labelMediumIsCustom,
                          ),
                      hintStyle: FlutterFlowTheme.of(context)
                          .labelMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).labelMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .labelMediumIsCustom,
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
                      fillColor:
                          BukeerColors.getBackground(context, secondary: true),
                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                          20.0, 24.0, 20.0, 24.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                    cursorColor: BukeerColors.primary,
                    validator: _model.lastNameTextControllerValidator
                        .asValidator(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 0.0, 0.0),
                  child: SelectionArea(
                      child: Text(
                    'El correo electrónico asociado es:',
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).labelMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                        ),
                  )),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 0.0, 24.0),
                  child: SelectionArea(
                      child: Text(
                    valueOrDefault<String>(
                      getJsonField(
                        appServices.user.selectedUser ??
                            appServices.user.agentData,
                        r'''$[:].email''',
                      )?.toString(),
                      'Sin correo electrónico',
                    ),
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyLargeFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                        ),
                  )),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.05),
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.safePop();
                        },
                        text: 'Cancelar',
                        options: FFButtonOptions(
                          height: 52.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              44.0, 0.0, 44.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: BukeerColors.getBackground(context,
                              secondary: true),
                          textStyle: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: BukeerTypography.bodyLargeSize,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                          elevation: 3.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(BukeerSpacing.s),
                          hoverColor: FlutterFlowTheme.of(context).alternate,
                          hoverBorderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                          hoverTextColor: BukeerColors.primaryText,
                          hoverElevation: 3.0,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.05),
                      child: FFButtonWidget(
                        onPressed: () async {
                          _model.apiResponseUpdatePersonal =
                              await UpdatePersonalInformationCall.call(
                            id: getJsonField(
                              appServices.user.selectedUser ??
                                  appServices.user.agentData,
                              r'''$[:].id''',
                            ).toString(),
                            authToken: currentJwtToken,
                            userImage: _model
                                            .uploadedFileUrl_uploadPersonalPhoto !=
                                        null &&
                                    _model.uploadedFileUrl_uploadPersonalPhoto !=
                                        ''
                                ? _model.uploadedFileUrl_uploadPersonalPhoto
                                : getJsonField(
                                    appServices.user.selectedUser ??
                                        appServices.user.agentData,
                                    r'''$[:].user_image''',
                                  ).toString(),
                            name: _model.nameTextController.text,
                            lastName: _model.lastNameTextController.text,
                          );

                          if ((_model.apiResponseUpdatePersonal?.succeeded ??
                              true)) {
                            _model.apiResponseGetAgent =
                                await GetAgentCall.call(
                              authToken: currentJwtToken,
                              id: currentUserUid,
                              accountIdParam: appServices.account.accountId,
                            );

                            if ((_model.apiResponseGetAgent?.succeeded ??
                                true)) {
                              // Update user data in service
                              // TODO: Implement user data refresh after profile update
                              // await appServices.user.refreshUserData();
                              safeSetState(() {});

                              context
                                  .pushNamed(MainProfilePageWidget.routeName);
                            }
                          }

                          safeSetState(() {});
                        },
                        text: 'Guardar',
                        options: FFButtonOptions(
                          height: 52.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              44.0, 0.0, 44.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: BukeerColors.primary,
                          textStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleMediumFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .titleMediumIsCustom,
                              ),
                          elevation: 3.0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(BukeerSpacing.s),
                          hoverColor: BukeerColors.primaryAccent,
                          hoverBorderSide: BorderSide(
                            color: BukeerColors.primary,
                            width: 1.0,
                          ),
                          hoverTextColor: BukeerColors.primaryText,
                          hoverElevation: 0.0,
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
    );
  }
}
