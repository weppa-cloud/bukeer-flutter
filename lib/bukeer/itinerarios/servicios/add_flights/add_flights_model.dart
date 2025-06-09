import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../../backend/api_requests/api_calls.dart';
import '../../../../backend/supabase/supabase.dart';
import '../../../core/widgets/forms/dropdowns/airports/dropdown_airports_widget.dart';
import '../../../core/widgets/forms/dropdowns/products/dropdown_products_widget.dart';
import '../../../../flutter_flow/flutter_flow_animations.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '../../../../custom_code/actions/index.dart' as actions;
import '../../../../custom_code/widgets/index.dart' as custom_widgets;
import '../../../../flutter_flow/custom_functions.dart' as functions;
import 'add_flights_widget.dart' show AddFlightsWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class AddFlightsModel extends FlutterFlowModel<AddFlightsWidget> {
  ///  Local state fields for this page.

  dynamic itemsActivitiesRates;

  bool selectActivitiesRates = false;

  double profitActivities = 0.0;

  double unitCost = 0.0;

  double totalCost = 0.0;

  String? initialStartDate;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Delete Row(s)] action in IconButton widget.
  List<ItineraryItemsRow>? responseFlightDeleted;
  // Stores action output result for [Backend Call - API (duplicateItineraryItem)] action in IconCopyButton widget.
  ApiCallResponse? apiResponseDuplicateItemActivity;
  // State field(s) for quantity widget.
  FocusNode? quantityFocusNode;
  TextEditingController? quantityTextController;
  String? Function(BuildContext, String?)? quantityTextControllerValidator;
  // State field(s) for departureTime widget.
  FocusNode? departureTimeFocusNode;
  TextEditingController? departureTimeTextController;
  final departureTimeMask = MaskTextInputFormatter(mask: '##:##:##');
  String? Function(BuildContext, String?)? departureTimeTextControllerValidator;
  // State field(s) for arrivalTime widget.
  FocusNode? arrivalTimeFocusNode;
  TextEditingController? arrivalTimeTextController;
  final arrivalTimeMask = MaskTextInputFormatter(mask: '##:##:##');
  String? Function(BuildContext, String?)? arrivalTimeTextControllerValidator;
  // State field(s) for unitCost widget.
  FocusNode? unitCostFocusNode;
  TextEditingController? unitCostTextController;
  String? Function(BuildContext, String?)? unitCostTextControllerValidator;
  // Stores action output result for [Custom Action - calculateTotal] action in unitCost widget.
  String? responseTotal;
  // State field(s) for markup widget.
  FocusNode? markupFocusNode;
  TextEditingController? markupTextController;
  String? Function(BuildContext, String?)? markupTextControllerValidator;
  // Stores action output result for [Custom Action - calculateTotal] action in markup widget.
  String? responseTotal2;
  // State field(s) for totalCost widget.
  FocusNode? totalCostFocusNode;
  TextEditingController? totalCostTextController;
  String? Function(BuildContext, String?)? totalCostTextControllerValidator;
  // Stores action output result for [Custom Action - calculateProfit] action in totalCost widget.
  String? responseProfit2;
  // State field(s) for messageActivity widget.
  FocusNode? messageActivityFocusNode;
  TextEditingController? messageActivityTextController;
  String? Function(BuildContext, String?)?
      messageActivityTextControllerValidator;
  // Stores action output result for [Backend Call - API (addItineraryItemsFlights)] action in ButtonAdd widget.
  ApiCallResponse? apiResponseAddItineraryItemFlights;
  // Stores action output result for [Backend Call - API (updateItineraryItemsFlights)] action in ButtonEdit widget.
  ApiCallResponse? apiResponseEditItineraryItemFlights;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    quantityFocusNode?.dispose();
    quantityTextController?.dispose();

    departureTimeFocusNode?.dispose();
    departureTimeTextController?.dispose();

    arrivalTimeFocusNode?.dispose();
    arrivalTimeTextController?.dispose();

    unitCostFocusNode?.dispose();
    unitCostTextController?.dispose();

    markupFocusNode?.dispose();
    markupTextController?.dispose();

    totalCostFocusNode?.dispose();
    totalCostTextController?.dispose();

    messageActivityFocusNode?.dispose();
    messageActivityTextController?.dispose();
  }
}
