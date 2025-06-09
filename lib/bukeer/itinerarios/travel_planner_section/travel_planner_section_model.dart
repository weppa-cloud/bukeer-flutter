import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../backend/supabase/supabase.dart';
import '../../core/widgets/forms/dropdowns/travel_planner/dropdown_travel_planner_widget.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../custom_code/actions/index.dart' as actions;
import 'travel_planner_section_widget.dart' show TravelPlannerSectionWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TravelPlannerSectionModel
    extends FlutterFlowModel<TravelPlannerSectionWidget> {
  ///  Local state fields for this component.

  bool isEditing = false;

  ///  State fields for stateful widgets in this component.

  // Model for DropdownTravelPlanner component.
  late DropdownTravelPlannerModel dropdownTravelPlannerModel;
  // Stores action output result for [Custom Action - updateTravelPlanner] action in DropdownTravelPlanner widget.
  bool? updateSuccess;

  @override
  void initState(BuildContext context) {
    dropdownTravelPlannerModel =
        createModel(context, () => DropdownTravelPlannerModel());
  }

  @override
  void dispose() {
    dropdownTravelPlannerModel.dispose();
  }
}
