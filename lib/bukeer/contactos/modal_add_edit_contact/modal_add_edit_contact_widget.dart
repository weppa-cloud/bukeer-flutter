import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../backend/supabase/supabase.dart';
import '../../componentes/component_birth_date/component_birth_date_widget.dart';
import '../../componentes/component_place/component_place_widget.dart';
import '../modal_details_contact/modal_details_contact_widget.dart';
import '../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../flutter_flow/form_field_controller.dart';
import '../../../flutter_flow/upload_data.dart';
import 'dart:ui';
import '../../../custom_code/widgets/index.dart' as custom_widgets;
import '../../../index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'modal_add_edit_contact_model.dart';
import '../../../services/ui_state_service.dart';
import '../../../services/contact_service.dart';
export 'modal_add_edit_contact_model.dart';

class ModalAddEditContactWidget extends StatefulWidget {
  const ModalAddEditContactWidget({
    super.key,
    this.isEdit,
  });

  final bool? isEdit;

  @override
  State<ModalAddEditContactWidget> createState() =>
      _ModalAddEditContactWidgetState();
}

class _ModalAddEditContactWidgetState extends State<ModalAddEditContactWidget> {
  late ModalAddEditContactModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalAddEditContactModel());

    _model.nameContactFocusNode ??= FocusNode();

    _model.lastNameContactFocusNode ??= FocusNode();

    _model.numberIdContactFocusNode ??= FocusNode();

    _model.mailContactFocusNode ??= FocusNode();

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

    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsets.all(BukeerSpacing.m),
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
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
              );
            }
            final overlayGetContactWithLocationResponse = snapshot.data!;

            return Container(
              width: 700.0,
              height: 1000.0,
              constraints: BoxConstraints(
                maxWidth: 650.0,
              ),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(BukeerSpacing.s),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                child: Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
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
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 6.0, 12.0, 12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget!.isEdit == false)
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    'Agregar contacto',
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
                                  ),
                                ),
                              if (widget!.isEdit == true)
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    'Editar contacto',
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
                                  ),
                                ),
                            ].divide(SizedBox(width: BukeerSpacing.s)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 5.0, 0.0, 0.0),
                                    child: Text(
                                      'Información Básica',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .headlineMediumFamily,
                                            fontSize: BukeerTypography.bodyLargeSize,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .headlineMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 24.0,
                                  thickness: 1.0,
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                                Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent1,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      final selectedMedia =
                                          await selectMediaWithSourceBottomSheet(
                                        context: context,
                                        storageFolderPath:
                                            '${FFAppState().accountId}/profiles',
                                        allowPhoto: true,
                                      );
                                      if (selectedMedia != null &&
                                          selectedMedia.every((m) =>
                                              validateFileFormat(
                                                  m.storagePath, context))) {
                                        safeSetState(() => _model
                                                .isDataUploading_uploadProfilePhoto =
                                            true);
                                        var selectedUploadedFiles =
                                            <FFUploadedFile>[];

                                        var downloadUrls = <String>[];
                                        try {
                                          selectedUploadedFiles = selectedMedia
                                              .map((m) => FFUploadedFile(
                                                    name: m.storagePath
                                                        .split('/')
                                                        .last,
                                                    bytes: m.bytes,
                                                    height:
                                                        m.dimensions?.height,
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
                                          _model.isDataUploading_uploadProfilePhoto =
                                              false;
                                        }
                                        if (selectedUploadedFiles.length ==
                                                selectedMedia.length &&
                                            downloadUrls.length ==
                                                selectedMedia.length) {
                                          safeSetState(() {
                                            _model.uploadedLocalFile_uploadProfilePhoto =
                                                selectedUploadedFiles.first;
                                            _model.uploadedFileUrl_uploadProfilePhoto =
                                                downloadUrls.first;
                                          });
                                        } else {
                                          safeSetState(() {});
                                          return;
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: 200.0,
                                      height: 200.0,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.network(
                                        valueOrDefault<String>(
                                          _model.uploadedFileUrl_uploadProfilePhoto !=
                                                      null &&
                                                  _model.uploadedFileUrl_uploadProfilePhoto !=
                                                      ''
                                              ? _model
                                                  .uploadedFileUrl_uploadProfilePhoto
                                              : valueOrDefault<String>(
                                                  getJsonField(
                                                    overlayGetContactWithLocationResponse
                                                        .jsonBody,
                                                    r'''$[:].contact_user_image''',
                                                  )?.toString(),
                                                  'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/imagenes/userProfile/photo_default.png',
                                                ),
                                          'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/imagenes/userProfile/photo_default.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 5.0, 24.0, 5.0),
                                  child: Wrap(
                                    spacing: 12.0,
                                    runSpacing: 0.0,
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    direction: Axis.horizontal,
                                    runAlignment: WrapAlignment.center,
                                    verticalDirection: VerticalDirection.down,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Es cliente',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(4.0, 0.0, 0.0, 0.0),
                                              child: Switch.adaptive(
                                                value: _model
                                                        .switchIsClientValue ??=
                                                    getJsonField(
                                                              overlayGetContactWithLocationResponse
                                                                  .jsonBody,
                                                              r'''$[:].contact_is_client''',
                                                            ) !=
                                                            null
                                                        ? getJsonField(
                                                            overlayGetContactWithLocationResponse
                                                                .jsonBody,
                                                            r'''$[:].contact_is_client''',
                                                          )
                                                        : true,
                                                onChanged: (newValue) async {
                                                  safeSetState(() => _model
                                                          .switchIsClientValue =
                                                      newValue!);
                                                },
                                                activeColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                activeTrackColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                inactiveTrackColor:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                inactiveThumbColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Es compañia',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(4.0, 0.0, 0.0, 0.0),
                                              child: Switch.adaptive(
                                                value: _model
                                                        .switchIsCompanyValue ??=
                                                    getJsonField(
                                                              overlayGetContactWithLocationResponse
                                                                  .jsonBody,
                                                              r'''$[:].contact_is_company''',
                                                            ) !=
                                                            null
                                                        ? getJsonField(
                                                            overlayGetContactWithLocationResponse
                                                                .jsonBody,
                                                            r'''$[:].contact_is_company''',
                                                          )
                                                        : false,
                                                onChanged: (newValue) async {
                                                  safeSetState(() => _model
                                                          .switchIsCompanyValue =
                                                      newValue!);
                                                },
                                                activeColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                activeTrackColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                inactiveTrackColor:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                inactiveThumbColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Es proveedor',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(4.0, 0.0, 0.0, 0.0),
                                              child: Switch.adaptive(
                                                value: _model
                                                        .switchIsProviderValue ??=
                                                    getJsonField(
                                                              overlayGetContactWithLocationResponse
                                                                  .jsonBody,
                                                              r'''$[:].contact_is_provider''',
                                                            ) !=
                                                            null
                                                        ? getJsonField(
                                                            overlayGetContactWithLocationResponse
                                                                .jsonBody,
                                                            r'''$[:].contact_is_provider''',
                                                          )
                                                        : false,
                                                onChanged: (newValue) async {
                                                  safeSetState(() => _model
                                                          .switchIsProviderValue =
                                                      newValue!);
                                                },
                                                activeColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                activeTrackColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                inactiveTrackColor:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                inactiveThumbColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 20.0, 0.0, 20.0),
                                  child: Wrap(
                                    spacing: 6.0,
                                    runSpacing: 6.0,
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    direction: Axis.horizontal,
                                    runAlignment: WrapAlignment.start,
                                    verticalDirection: VerticalDirection.down,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 260.0,
                                        child: TextFormField(
                                          controller: _model
                                                  .nameContactTextController ??=
                                              TextEditingController(
                                            text: getJsonField(
                                                      overlayGetContactWithLocationResponse
                                                          .jsonBody,
                                                      r'''$[:].contact_name''',
                                                    ) !=
                                                    null
                                                ? getJsonField(
                                                    overlayGetContactWithLocationResponse
                                                        .jsonBody,
                                                    r'''$[:].contact_name''',
                                                  ).toString()
                                                : '',
                                          ),
                                          focusNode:
                                              _model.nameContactFocusNode,
                                          autofocus: false,
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
                                                  BorderRadius.circular(BukeerSpacing.s),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(BukeerSpacing.s),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(BukeerSpacing.s),
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
                                                  BorderRadius.circular(BukeerSpacing.s),
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
                                              .nameContactTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                      if (_model.switchIsCompanyValue == false)
                                        Container(
                                          width: 260.0,
                                          child: TextFormField(
                                            controller: _model
                                                    .lastNameContactTextController ??=
                                                TextEditingController(
                                              text: getJsonField(
                                                        overlayGetContactWithLocationResponse
                                                            .jsonBody,
                                                        r'''$[:].contact_last_name''',
                                                      ) !=
                                                      null
                                                  ? getJsonField(
                                                      overlayGetContactWithLocationResponse
                                                          .jsonBody,
                                                      r'''$[:].contact_last_name''',
                                                    ).toString()
                                                  : '',
                                            ),
                                            focusNode:
                                                _model.lastNameContactFocusNode,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Apellido',
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
                                                            !FlutterFlowTheme
                                                                    .of(context)
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
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMediumIsCustom,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(BukeerSpacing.s),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(BukeerSpacing.s),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(BukeerSpacing.s),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(BukeerSpacing.s),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              contentPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(20.0, 24.0,
                                                          20.0, 24.0),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
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
                                                .lastNameContactTextControllerValidator
                                                .asValidator(context),
                                          ),
                                        ),
                                      FlutterFlowDropDown<String>(
                                        controller: _model
                                                .typeDocumentContactValueController ??=
                                            FormFieldController<String>(
                                          _model.typeDocumentContactValue ??=
                                              getJsonField(
                                                        overlayGetContactWithLocationResponse
                                                            .jsonBody,
                                                        r'''$[:].contact_type_id''',
                                                      ) !=
                                                      null
                                                  ? getJsonField(
                                                      overlayGetContactWithLocationResponse
                                                          .jsonBody,
                                                      r'''$[:].contact_type_id''',
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
                                            _model.typeDocumentContactValue =
                                                val),
                                        width: 260.0,
                                        height: 60.0,
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
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                        borderWidth: 2.0,
                                        borderRadius: 12.0,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            20.0, 2.0, 16.0, 4.0),
                                        hidesUnderline: true,
                                        isSearchable: true,
                                        isMultiSelect: false,
                                      ),
                                      Container(
                                        width: 260.0,
                                        child: TextFormField(
                                          controller: _model
                                                  .numberIdContactTextController ??=
                                              TextEditingController(
                                            text: getJsonField(
                                                      overlayGetContactWithLocationResponse
                                                          .jsonBody,
                                                      r'''$[:].contact_number_id''',
                                                    ) !=
                                                    null
                                                ? getJsonField(
                                                    overlayGetContactWithLocationResponse
                                                        .jsonBody,
                                                    r'''$[:].contact_number_id''',
                                                  ).toString()
                                                : '',
                                          ),
                                          focusNode:
                                              _model.numberIdContactFocusNode,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Número de identificación',
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
                                                  BorderRadius.circular(BukeerSpacing.s),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(BukeerSpacing.s),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(BukeerSpacing.s),
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
                                                  BorderRadius.circular(BukeerSpacing.s),
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
                                          keyboardType: TextInputType.number,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          validator: _model
                                              .numberIdContactTextControllerValidator
                                              .asValidator(context),
                                          inputFormatters: [
                                            _model.numberIdContactMask
                                          ],
                                        ),
                                      ),
                                      FutureBuilder<ApiCallResponse>(
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
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          final nationalyContactGetNationalitiesResponse =
                                              snapshot.data!;

                                          return FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .nationalyContactValueController ??=
                                                FormFieldController<String>(
                                              _model.nationalyContactValue ??=
                                                  getJsonField(
                                                            overlayGetContactWithLocationResponse
                                                                .jsonBody,
                                                            r'''$[:].contact_nationality''',
                                                          ) !=
                                                          null
                                                      ? getJsonField(
                                                          overlayGetContactWithLocationResponse
                                                              .jsonBody,
                                                          r'''$[:].contact_nationality''',
                                                        ).toString()
                                                      : 'Colombiana',
                                            ),
                                            options: (getJsonField(
                                              nationalyContactGetNationalitiesResponse
                                                  .jsonBody,
                                              r'''$[:].name''',
                                              true,
                                            ) as List)
                                                .map<String>(
                                                    (s) => s.toString())
                                                .toList()!,
                                            onChanged: (val) => safeSetState(
                                                () => _model
                                                        .nationalyContactValue =
                                                    val),
                                            width: 260.0,
                                            height: 60.0,
                                            searchHintTextStyle:
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
                                            searchTextStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                            hintText: 'Nacionalidad',
                                            searchHintText: 'Buscar...',
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            elevation: 2.0,
                                            borderColor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                            borderWidth: 2.0,
                                            borderRadius: 12.0,
                                            margin:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 4.0, 16.0, 4.0),
                                            hidesUnderline: true,
                                            isOverButton: true,
                                            isSearchable: true,
                                            isMultiSelect: false,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 20.0,
                                  thickness: 1.0,
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Información de contacto',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .headlineMediumFamily,
                                            fontSize: BukeerTypography.bodyLargeSize,
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
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    direction: Axis.horizontal,
                                    runAlignment: WrapAlignment.start,
                                    verticalDirection: VerticalDirection.down,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 260.0,
                                        height: 70.0,
                                        child: custom_widgets
                                            .InternationalPhoneInput(
                                          width: 260.0,
                                          height: 70.0,
                                          initialValue: widget!.isEdit!
                                              ? getJsonField(
                                                  overlayGetContactWithLocationResponse
                                                      .jsonBody,
                                                  r'''$[:].contact_phone''',
                                                ).toString()
                                              : '',
                                          labelText: 'Celular',
                                          onPhoneNumberChanged:
                                              (phoneNumberE164) async {
                                            _model.phoneNumberE164 =
                                                phoneNumberE164;
                                            safeSetState(() {});
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 260.0,
                                        height: 70.0,
                                        child: custom_widgets
                                            .InternationalPhoneInput(
                                          width: 260.0,
                                          height: 70.0,
                                          initialValue: widget!.isEdit!
                                              ? getJsonField(
                                                  overlayGetContactWithLocationResponse
                                                      .jsonBody,
                                                  r'''$[:].contact_phone2''',
                                                ).toString()
                                              : '',
                                          labelText: 'Celular 2',
                                          onPhoneNumberChanged:
                                              (phoneNumberE164) async {
                                            _model.phoneNumber2E164 =
                                                phoneNumberE164;
                                            safeSetState(() {});
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 260.0,
                                        child: TextFormField(
                                          controller: _model
                                                  .mailContactTextController ??=
                                              TextEditingController(
                                            text: getJsonField(
                                                      overlayGetContactWithLocationResponse
                                                          .jsonBody,
                                                      r'''$[:].contact_email''',
                                                    ) !=
                                                    null
                                                ? getJsonField(
                                                    overlayGetContactWithLocationResponse
                                                        .jsonBody,
                                                    r'''$[:].contact_email''',
                                                  ).toString()
                                                : '',
                                          ),
                                          focusNode:
                                              _model.mailContactFocusNode,
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
                                                  BorderRadius.circular(BukeerSpacing.s),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(BukeerSpacing.s),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(BukeerSpacing.s),
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
                                                  BorderRadius.circular(BukeerSpacing.s),
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
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          validator: _model
                                              .mailContactTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                      Container(
                                        width: 260.0,
                                        decoration: BoxDecoration(),
                                        child: wrapWithModel(
                                          model: _model.componentPlaceModel,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: ComponentPlaceWidget(
                                            location: getJsonField(
                                              overlayGetContactWithLocationResponse
                                                  .jsonBody,
                                              r'''$[:].location_address''',
                                            ).toString(),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 260.0,
                                        decoration: BoxDecoration(),
                                        child: Visibility(
                                          visible: (_model
                                                      .switchIsCompanyValue ==
                                                  false) &&
                                              (_model.switchIsProviderValue ==
                                                  false),
                                          child: wrapWithModel(
                                            model:
                                                _model.componentBirthDateModel,
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: ComponentBirthDateWidget(
                                              date: valueOrDefault<String>(
                                                getJsonField(
                                                          overlayGetContactWithLocationResponse
                                                              .jsonBody,
                                                          r'''$[:].contact_birth_date''',
                                                        ) !=
                                                        null
                                                    ? getJsonField(
                                                        overlayGetContactWithLocationResponse
                                                            .jsonBody,
                                                        r'''$[:].contact_birth_date''',
                                                      ).toString()
                                                    : 'd/m/y',
                                                'd/m/y',
                                              ),
                                              label: 'Fecha de nacimiento',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ].divide(SizedBox(height: BukeerSpacing.xs)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
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
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 12.0, 24.0, 6.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.05),
                                child: FFButtonWidget(
                                  onPressed: () async {
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
                                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                                    hoverColor:
                                        FlutterFlowTheme.of(context).alternate,
                                    hoverBorderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 2.0,
                                    ),
                                    hoverTextColor: FlutterFlowTheme.of(context)
                                        .primaryText,
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
                                      if (_model.switchIsCompanyValue == true) {
                                        safeSetState(() {
                                          _model.lastNameContactTextController
                                              ?.text = '';
                                        });
                                      }
                                      _model.responseFormAddContact = true;
                                      if (_model.formKey.currentState == null ||
                                          !_model.formKey.currentState!
                                              .validate()) {
                                        _model.responseFormAddContact = false;
                                      }
                                      if (_model.typeDocumentContactValue ==
                                          null) {
                                        _model.responseFormAddContact = false;
                                      }
                                      if (_model.nationalyContactValue ==
                                          null) {
                                        _model.responseFormAddContact = false;
                                      }
                                      _shouldSetState = true;
                                      context.read<UiStateService>().selectedLocationLatLng = _model
                                          .componentPlaceModel
                                          .placePickerValue
                                          .latLng
                                          .toString();
                                      context.read<UiStateService>().selectedLocationName = _model
                                          .componentPlaceModel
                                          .placePickerValue
                                          .name;
                                      context.read<UiStateService>().selectedLocationAddress = _model
                                          .componentPlaceModel
                                          .placePickerValue
                                          .address;
                                      context.read<UiStateService>().selectedLocationCity = _model
                                          .componentPlaceModel
                                          .placePickerValue
                                          .city;
                                      context.read<UiStateService>().selectedLocationState = _model
                                          .componentPlaceModel
                                          .placePickerValue
                                          .state;
                                      context.read<UiStateService>().selectedLocationCountry = _model
                                          .componentPlaceModel
                                          .placePickerValue
                                          .country;
                                      context.read<UiStateService>().selectedLocationZipCode = _model
                                          .componentPlaceModel
                                          .placePickerValue
                                          .zipCode;
                                      safeSetState(() {});
                                      if (_model.responseFormAddContact!) {
                                        if (context.read<UiStateService>().selectedLocationLatLng !=
                                            'LatLng(lat: 0, lng: 0)') {
                                          _model.responseInsertLocation =
                                              await InsertLocationsCall.call(
                                            authToken: currentJwtToken,
                                            latlng: context.read<UiStateService>().selectedLocationLatLng,
                                            name: context.read<UiStateService>().selectedLocationName,
                                            address:
                                                context.read<UiStateService>().selectedLocationAddress,
                                            city: context.read<UiStateService>().selectedLocationCity,
                                            state: context.read<UiStateService>().selectedLocationState,
                                            country:
                                                context.read<UiStateService>().selectedLocationCountry,
                                            zipCode:
                                                context.read<UiStateService>().selectedLocationZipCode,
                                            accountId: FFAppState().accountId,
                                            typeEntity: 'contacts',
                                          );

                                          _shouldSetState = true;
                                          if ((_model.responseInsertLocation
                                                  ?.succeeded ??
                                              true)) {
                                            _model.apiResponseInsertContact =
                                                await InsertContactCall.call(
                                              phone: _model.phoneNumberE164,
                                              nationality:
                                                  _model.nationalyContactValue,
                                              name: _model
                                                  .nameContactTextController
                                                  .text,
                                              email: _model
                                                  .mailContactTextController
                                                  .text,
                                              typeId: _model
                                                  .typeDocumentContactValue,
                                              numberId: _model
                                                  .numberIdContactTextController
                                                  .text,
                                              isCompany:
                                                  _model.switchIsCompanyValue,
                                              phone2: _model.phoneNumber2E164,
                                              isClient:
                                                  _model.switchIsClientValue,
                                              userImage: _model
                                                  .uploadedFileUrl_uploadProfilePhoto,
                                              authToken: currentJwtToken,
                                              lastName: _model
                                                          .switchIsCompanyValue ==
                                                      true
                                                  ? ''
                                                  : _model
                                                      .lastNameContactTextController
                                                      .text,
                                              isProvider:
                                                  _model.switchIsProviderValue,
                                              birthDate: (_model
                                                              .switchIsCompanyValue ==
                                                          true) ||
                                                      (_model.switchIsProviderValue ==
                                                          true)
                                                  ? '0001-01-01'
                                                  : _model
                                                      .componentBirthDateModel
                                                      .datePicked
                                                      ?.toString(),
                                              location:
                                                  (_model.responseInsertLocation
                                                              ?.jsonBody ??
                                                          '')
                                                      .toString(),
                                              accountId: FFAppState().accountId,
                                            );

                                            _shouldSetState = true;
                                            if ((_model.apiResponseInsertContact
                                                    ?.succeeded ??
                                                true)) {
                                              context.read<UiStateService>().selectedLocationLatLng = '';
                                              context.read<UiStateService>().selectedLocationName = '';
                                              context.read<UiStateService>().selectedLocationAddress = '';
                                              context.read<UiStateService>().selectedLocationCity = '';
                                              context.read<UiStateService>().selectedLocationState = '';
                                              context.read<UiStateService>().selectedLocationCountry = '';
                                              context.read<UiStateService>().selectedLocationZipCode = '';
                                              context.read<ContactService>().allDataContact =
                                                  InsertContactCall.all(
                                                (_model.apiResponseInsertContact
                                                        ?.jsonBody ??
                                                    ''),
                                              );
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
                                                    padding:
                                                        MediaQuery.viewInsetsOf(
                                                            context),
                                                    child:
                                                        ModalDetailsContactWidget(),
                                                  );
                                                },
                                              ).then((value) =>
                                                  safeSetState(() {}));
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text('Mensaje'),
                                                    content: Text(
                                                        'Error al agregar contacto todos los campos son obligatorios'),
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
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: Text('Mensaje'),
                                                  content: Text(
                                                      'Error al agregar ubicación'),
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
                                            builder: (alertDialogContext) {
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

                                      context.pushNamed(
                                          MainContactsWidget.routeName);

                                      if (_shouldSetState) safeSetState(() {});
                                    },
                                    text: 'Agregar',
                                    options: FFButtonOptions(
                                      height: 44.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
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
                              if (widget!.isEdit == true)
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.05),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      var _shouldSetState = false;
                                      if (_model.switchIsCompanyValue == true) {
                                        safeSetState(() {
                                          _model.lastNameContactTextController
                                              ?.text = '';
                                        });
                                      }
                                      _model.responseFormUpdateContact = true;
                                      if (_model.formKey.currentState == null ||
                                          !_model.formKey.currentState!
                                              .validate()) {
                                        _model.responseFormUpdateContact =
                                            false;
                                      }
                                      if (_model.typeDocumentContactValue ==
                                          null) {
                                        _model.responseFormUpdateContact =
                                            false;
                                      }
                                      if (_model.nationalyContactValue ==
                                          null) {
                                        _model.responseFormUpdateContact =
                                            false;
                                      }
                                      _shouldSetState = true;
                                      context.read<UiStateService>().selectedLocationLatLng = _model
                                          .componentPlaceModel
                                          .placePickerValue
                                          .latLng
                                          .toString();
                                      context.read<UiStateService>().selectedLocationName = _model
                                          .componentPlaceModel
                                          .placePickerValue
                                          .name;
                                      context.read<UiStateService>().selectedLocationAddress = _model
                                          .componentPlaceModel
                                          .placePickerValue
                                          .address;
                                      context.read<UiStateService>().selectedLocationCity = _model
                                          .componentPlaceModel
                                          .placePickerValue
                                          .city;
                                      context.read<UiStateService>().selectedLocationState = _model
                                          .componentPlaceModel
                                          .placePickerValue
                                          .state;
                                      context.read<UiStateService>().selectedLocationCountry = _model
                                          .componentPlaceModel
                                          .placePickerValue
                                          .country;
                                      context.read<UiStateService>().selectedLocationZipCode = _model
                                          .componentPlaceModel
                                          .placePickerValue
                                          .zipCode;
                                      safeSetState(() {});
                                      if (_model.responseFormUpdateContact!) {
                                        if (context.read<UiStateService>().selectedLocationLatLng !=
                                            'LatLng(lat: 0, lng: 0)') {
                                          _model.responseInsertLocation2 =
                                              await UpdateLocationsCall.call(
                                            latlng: context.read<UiStateService>().selectedLocationLatLng,
                                            name: context.read<UiStateService>().selectedLocationName,
                                            address:
                                                context.read<UiStateService>().selectedLocationAddress,
                                            city: context.read<UiStateService>().selectedLocationCity,
                                            state: context.read<UiStateService>().selectedLocationState,
                                            country:
                                                context.read<UiStateService>().selectedLocationCountry,
                                            zipCode:
                                                context.read<UiStateService>().selectedLocationZipCode,
                                            authToken: currentJwtToken,
                                            id: getJsonField(
                                              overlayGetContactWithLocationResponse
                                                  .jsonBody,
                                              r'''$[:].location_id''',
                                            ).toString(),
                                          );

                                          _shouldSetState = true;
                                          if ((_model.responseInsertLocation2
                                                  ?.succeeded ??
                                              true)) {
                                            _model.responseInsertLocationState =
                                                (_model.responseInsertLocation2
                                                            ?.jsonBody ??
                                                        '')
                                                    .toString();
                                            safeSetState(() {});
                                          } else {
                                            if ((_model.responseInsertLocation2
                                                        ?.exceptionMessage ??
                                                    '') ==
                                                '${null}') {
                                              _model.responseInsertLocation3 =
                                                  await InsertLocationsCall
                                                      .call(
                                                authToken: currentJwtToken,
                                                latlng:
                                                    context.read<UiStateService>().selectedLocationLatLng,
                                                name: context.read<UiStateService>().selectedLocationName,
                                                address: FFAppState()
                                                    .addressLocation,
                                                city: context.read<UiStateService>().selectedLocationCity,
                                                state:
                                                    context.read<UiStateService>().selectedLocationState,
                                                country: FFAppState()
                                                    .countryLocation,
                                                zipCode: FFAppState()
                                                    .zipCodeLocation,
                                                accountId:
                                                    FFAppState().accountId,
                                                typeEntity: 'contacts',
                                              );

                                              _shouldSetState = true;
                                              if ((_model
                                                      .responseInsertLocation3
                                                      ?.succeeded ??
                                                  true)) {
                                                _model.apiResultreg =
                                                    await InsertLocationByTypeCall
                                                        .call(
                                                  authToken: currentJwtToken,
                                                  locationId:
                                                      (_model.responseInsertLocation3
                                                                  ?.jsonBody ??
                                                              '')
                                                          .toString(),
                                                  searchId: getJsonField(
                                                    overlayGetContactWithLocationResponse
                                                        .jsonBody,
                                                    r'''$[:].contact_id''',
                                                  ).toString(),
                                                  type: 'contacts',
                                                );

                                                _shouldSetState = true;
                                                if (!(_model.apiResultreg
                                                        ?.succeeded ??
                                                    true)) {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text('Mensaje'),
                                                        content: Text(
                                                            'Error al agregar ubicación'),
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
                                                          'Hubo un error al agregar la locación'),
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
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text('Mensaje'),
                                                    content: Text(
                                                        'Hubo un error al agregar la locación'),
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
                                        } else {
                                          if (!(getJsonField(
                                                overlayGetContactWithLocationResponse
                                                    .jsonBody,
                                                r'''$[:].location_address''',
                                              ) !=
                                              null)) {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
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
                                        }

                                        _model.apiResult4b0 =
                                            await UpdateContactCall.call(
                                          id: getJsonField(
                                            overlayGetContactWithLocationResponse
                                                .jsonBody,
                                            r'''$[:].contact_id''',
                                          ).toString(),
                                          authToken: currentJwtToken,
                                          isClient: _model.switchIsClientValue,
                                          isCompany:
                                              _model.switchIsCompanyValue,
                                          isProvider:
                                              _model.switchIsProviderValue,
                                          name: _model
                                              .nameContactTextController.text,
                                          lastName: _model
                                                      .switchIsCompanyValue ==
                                                  true
                                              ? ''
                                              : _model
                                                  .lastNameContactTextController
                                                  .text,
                                          phone: _model.phoneNumberE164 !=
                                                      null &&
                                                  _model.phoneNumberE164 != ''
                                              ? _model.phoneNumberE164
                                              : getJsonField(
                                                  context.read<ContactService>().allDataContact,
                                                  r'''$.phone''',
                                                ).toString(),
                                          phone2: _model.phoneNumber2E164 !=
                                                      null &&
                                                  _model.phoneNumber2E164 != ''
                                              ? _model.phoneNumber2E164
                                              : getJsonField(
                                                  overlayGetContactWithLocationResponse
                                                      .jsonBody,
                                                  r'''$[:].contact_phone2''',
                                                ).toString(),
                                          email: _model
                                              .mailContactTextController.text,
                                          typeId:
                                              _model.typeDocumentContactValue,
                                          numberId: _model
                                              .numberIdContactTextController
                                              .text,
                                          nationality:
                                              _model.nationalyContactValue,
                                          birthDate: () {
                                            if (_model.switchIsCompanyValue ==
                                                true) {
                                              return '0001-01-01';
                                            } else if (_model
                                                    .componentBirthDateModel
                                                    .datePicked !=
                                                null) {
                                              return _model
                                                  .componentBirthDateModel
                                                  .datePicked
                                                  ?.toString();
                                            } else {
                                              return getJsonField(
                                                overlayGetContactWithLocationResponse
                                                    .jsonBody,
                                                r'''$[:].contact_birth_date''',
                                              ).toString();
                                            }
                                          }(),
                                          userImage: _model
                                                          .uploadedFileUrl_uploadProfilePhoto !=
                                                      null &&
                                                  _model.uploadedFileUrl_uploadProfilePhoto !=
                                                      ''
                                              ? _model
                                                  .uploadedFileUrl_uploadProfilePhoto
                                              : getJsonField(
                                                  overlayGetContactWithLocationResponse
                                                      .jsonBody,
                                                  r'''$[:].contact_user_image''',
                                                ).toString(),
                                        );

                                        _shouldSetState = true;
                                        if ((_model.apiResult4b0?.succeeded ??
                                            true)) {
                                          context.read<UiStateService>().selectedLocationLatLng = '';
                                          context.read<UiStateService>().selectedLocationName = '';
                                          context.read<UiStateService>().selectedLocationAddress = '';
                                          context.read<UiStateService>().selectedLocationCity = '';
                                          context.read<UiStateService>().selectedLocationState = '';
                                          context.read<UiStateService>().selectedLocationCountry = '';
                                          context.read<UiStateService>().selectedLocationZipCode = '';
                                          safeSetState(() {});
                                          _model.responseInsertLocationState =
                                              null;
                                          safeSetState(() {});
                                          Navigator.pop(context);
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Mensaje'),
                                                content: Text(
                                                    'Error al editar usuario.'),
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

                                      if (_shouldSetState) safeSetState(() {});
                                    },
                                    text: 'Guardar',
                                    options: FFButtonOptions(
                                      height: 44.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
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
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
