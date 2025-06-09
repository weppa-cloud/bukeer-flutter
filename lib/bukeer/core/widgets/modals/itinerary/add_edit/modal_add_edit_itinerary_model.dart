import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import 'package:bukeer/backend/api_requests/api_calls.dart';
import '../../../forms/dropdowns/contacts/dropdown_contacts_widget.dart';
import '../../../forms/dropdowns/travel_planner/dropdown_travel_planner_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_animations.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_count_controller.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_drop_down.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:bukeer/legacy/flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import 'package:bukeer/custom_code/actions/index.dart' as actions;
import 'package:bukeer/custom_code/widgets/index.dart' as custom_widgets;
import 'package:bukeer/index.dart';
import 'modal_add_edit_itinerary_widget.dart' show ModalAddEditItineraryWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ModalAddEditItineraryModel
    extends FlutterFlowModel<ModalAddEditItineraryWidget> {
  ///  Local state fields for this component.

  int? photoNumber;

  List<dynamic> images = [];
  void addToImages(dynamic item) => images.add(item);
  void removeFromImages(dynamic item) => images.remove(item);
  void removeAtIndexFromImages(int index) => images.removeAt(index);
  void insertAtIndexInImages(int index, dynamic item) =>
      images.insert(index, item);
  void updateImagesAtIndex(int index, Function(dynamic) updateFn) =>
      images[index] = updateFn(images[index]);

  String? initialStartDate;

  String? initialEndDate;

  String? initialDate;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Custom Action - getImagesStorage] action in modal_add_edit_itinerary widget.
  List<dynamic>? responseGetImagesStorage;
  // State field(s) for nameItinerary widget.
  FocusNode? nameItineraryFocusNode;
  TextEditingController? nameItineraryTextController;
  String? Function(BuildContext, String?)? nameItineraryTextControllerValidator;
  String? _nameItineraryTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Nombre de itinerario is required';
    }

    return null;
  }

  // State field(s) for language widget.
  String? languageValue;
  FormFieldController<String>? languageValueController;
  // State field(s) for CountController widget.
  int? countControllerValue;
  // State field(s) for currency_type widget.
  String? currencyTypeValue;
  FormFieldController<String>? currencyTypeValueController;
  // State field(s) for request_type widget.
  String? requestTypeValue;
  FormFieldController<String>? requestTypeValueController;
  // Selected travel planner
  String? selectedTravelPlannerId;
  // Model for DropdownTravelPlanner component.
  late DropdownTravelPlannerModel dropdownTravelPlannerModel;
  // State field(s) for messageActivity widget.
  FocusNode? messageActivityFocusNode;
  TextEditingController? messageActivityTextController;
  String? Function(BuildContext, String?)?
      messageActivityTextControllerValidator;
  // Stores action output result for [Validate Form] action in add_itinerary widget.
  bool? responseFormAddItinerary;
  // Stores action output result for [Backend Call - API (createItineraryForContact)] action in add_itinerary widget.
  ApiCallResponse? apiResponseCreateItineraryContact;
  // Stores action output result for [Validate Form] action in edit_itinerary widget.
  bool? responseFormEditItinerary;
  // Stores action output result for [Backend Call - API (updateItinerary)] action in edit_itinerary widget.
  ApiCallResponse? responseUpdateItinerary;

  @override
  void initState(BuildContext context) {
    nameItineraryTextControllerValidator =
        _nameItineraryTextControllerValidator;
    dropdownTravelPlannerModel =
        createModel(context, () => DropdownTravelPlannerModel());
  }

  @override
  void dispose() {
    nameItineraryFocusNode?.dispose();
    nameItineraryTextController?.dispose();

    dropdownTravelPlannerModel.dispose();

    messageActivityFocusNode?.dispose();
    messageActivityTextController?.dispose();
  }
}
