import '../../../backend/api_requests/api_calls.dart';
import '../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/form_field_controller.dart';
import 'dropdown_travel_planner_widget.dart' show DropdownTravelPlannerWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DropdownTravelPlannerModel
    extends FlutterFlowModel<DropdownTravelPlannerWidget> {
  ///  Local state fields for this component.

  List<dynamic> users = [];

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (getUsers)] action in DropdownTravelPlanner widget.
  ApiCallResponse? apiResponseUsers;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}