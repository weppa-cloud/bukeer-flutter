import '../../../../backend/supabase/supabase.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:bukeer/legacy/flutter_flow/upload_data.dart';
import 'dart:ui';
import '../../../custom_code/actions/index.dart' as actions;
import 'component_add_schedule_activity_widget.dart'
    show ComponentAddScheduleActivityWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ComponentAddScheduleActivityModel
    extends FlutterFlowModel<ComponentAddScheduleActivityWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextFieldTitle widget.
  FocusNode? textFieldTitleFocusNode;
  TextEditingController? textFieldTitleTextController;
  String? Function(BuildContext, String?)?
      textFieldTitleTextControllerValidator;
  // State field(s) for TextFieldDescription widget.
  FocusNode? textFieldDescriptionFocusNode;
  TextEditingController? textFieldDescriptionTextController;
  String? Function(BuildContext, String?)?
      textFieldDescriptionTextControllerValidator;
  bool isDataUploading_uploadImageItineraryActivity = false;
  FFUploadedFile uploadedLocalFile_uploadImageItineraryActivity =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadImageItineraryActivity = '';

  // Stores action output result for [Custom Action - addScheduleActivity] action in Button widget.
  bool? responseAddItemActivity;
  // Stores action output result for [Custom Action - editScheduleActivity] action in Button widget.
  bool? responseEditItemActivity;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldTitleFocusNode?.dispose();
    textFieldTitleTextController?.dispose();

    textFieldDescriptionFocusNode?.dispose();
    textFieldDescriptionTextController?.dispose();
  }
}
