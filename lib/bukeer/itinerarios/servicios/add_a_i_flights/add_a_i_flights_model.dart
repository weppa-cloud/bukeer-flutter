import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../../backend/api_requests/api_calls.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'add_a_i_flights_widget.dart' show AddAIFlightsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddAIFlightsModel extends FlutterFlowModel<AddAIFlightsWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for text_flight widget.
  FocusNode? textFlightFocusNode;
  TextEditingController? textFlightTextController;
  String? Function(BuildContext, String?)? textFlightTextControllerValidator;
  // Stores action output result for [Backend Call - API (ProcessFlightExtraction)] action in Button widget.
  ApiCallResponse? apiResult92n;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFlightFocusNode?.dispose();
    textFlightTextController?.dispose();
  }
}
