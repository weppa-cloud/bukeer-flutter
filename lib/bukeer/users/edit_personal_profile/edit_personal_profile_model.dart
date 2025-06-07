import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../backend/supabase/supabase.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../flutter_flow/upload_data.dart';
import 'dart:ui';
import '../../../index.dart';
import 'edit_personal_profile_widget.dart' show EditPersonalProfileWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditPersonalProfileModel
    extends FlutterFlowModel<EditPersonalProfileWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadPersonalPhoto = false;
  FFUploadedFile uploadedLocalFile_uploadPersonalPhoto =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadPersonalPhoto = '';

  // State field(s) for name widget.
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;
  // State field(s) for last_name widget.
  FocusNode? lastNameFocusNode;
  TextEditingController? lastNameTextController;
  String? Function(BuildContext, String?)? lastNameTextControllerValidator;
  // Stores action output result for [Backend Call - API (updatePersonalInformation)] action in Button widget.
  ApiCallResponse? apiResponseUpdatePersonal;
  // Stores action output result for [Backend Call - API (getAgent)] action in Button widget.
  ApiCallResponse? apiResponseGetAgent;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nameFocusNode?.dispose();
    nameTextController?.dispose();

    lastNameFocusNode?.dispose();
    lastNameTextController?.dispose();
  }
}
