import '../../../../../../auth/supabase_auth/auth_util.dart';
import '../../../../../../backend/api_requests/api_calls.dart';
import '../../../../../../backend/supabase/supabase.dart';
import '../../../../../../bukeer/core/widgets/forms/place_picker/place_picker_widget.dart';
import '../details/modal_details_product_widget.dart';
import '../../../../../../flutter_flow/flutter_flow_animations.dart';
import '../../../../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../../../../flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import 'modal_add_product_widget.dart' show ModalAddProductWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ModalAddProductModel extends FlutterFlowModel<ModalAddProductWidget> {
  ///  Local state fields for this component.

  int? photoNumber;

  String? responseInsertLocationState;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for nameActivity widget.
  FocusNode? nameActivityFocusNode;
  TextEditingController? nameActivityTextController;
  String? Function(BuildContext, String?)? nameActivityTextControllerValidator;
  String? _nameActivityTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Nombre is required';
    }

    return null;
  }

  // State field(s) for typeActivity widget.
  String? typeActivityValue;
  FormFieldController<String>? typeActivityValueController;
  // Model for place_picker component.
  late PlacePickerModel placePickerModel;
  // State field(s) for descriptionActivity widget.
  FocusNode? descriptionActivityFocusNode;
  TextEditingController? descriptionActivityTextController;
  String? Function(BuildContext, String?)?
      descriptionActivityTextControllerValidator;
  String? _descriptionActivityTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Descripción is required';
    }

    return null;
  }

  // State field(s) for descriptionShortActivity widget.
  FocusNode? descriptionShortActivityFocusNode;
  TextEditingController? descriptionShortActivityTextController;
  String? Function(BuildContext, String?)?
      descriptionShortActivityTextControllerValidator;
  String? _descriptionShortActivityTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Descripción corta is required';
    }

    if (val.length > 500) {
      return 'Supero el limite permitido';
    }

    return null;
  }

  // State field(s) for inclutionActivity widget.
  FocusNode? inclutionActivityFocusNode;
  TextEditingController? inclutionActivityTextController;
  String? Function(BuildContext, String?)?
      inclutionActivityTextControllerValidator;
  String? _inclutionActivityTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Incluye is required';
    }

    return null;
  }

  // State field(s) for notIcludeActivity widget.
  FocusNode? notIcludeActivityFocusNode;
  TextEditingController? notIcludeActivityTextController;
  String? Function(BuildContext, String?)?
      notIcludeActivityTextControllerValidator;
  String? _notIcludeActivityTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'No Incluye is required';
    }

    return null;
  }

  // State field(s) for recomendationsActivity widget.
  FocusNode? recomendationsActivityFocusNode;
  TextEditingController? recomendationsActivityTextController;
  String? Function(BuildContext, String?)?
      recomendationsActivityTextControllerValidator;
  String? _recomendationsActivityTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Observaciones y recomendaciones is required';
    }

    return null;
  }

  // State field(s) for instructionsActivity widget.
  FocusNode? instructionsActivityFocusNode;
  TextEditingController? instructionsActivityTextController;
  String? Function(BuildContext, String?)?
      instructionsActivityTextControllerValidator;
  String? _instructionsActivityTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Instruciónes para el pasajero is required';
    }

    return null;
  }

  // Stores action output result for [Validate Form] action in edit_activity widget.
  bool? responseFormEditProduct;
  // Stores action output result for [Backend Call - API (updateLocations)] action in edit_activity widget.
  ApiCallResponse? apiResponseUpdateLocationActivities;
  // Stores action output result for [Backend Call - API (insertLocations)] action in edit_activity widget.
  ApiCallResponse? responseInsertLocation3;
  // Stores action output result for [Backend Call - API (insertLocationByType)] action in edit_activity widget.
  ApiCallResponse? apiResultreg;
  // Stores action output result for [Backend Call - API (updateActivity)] action in edit_activity widget.
  ApiCallResponse? responseUpdateActivity;
  // Stores action output result for [Backend Call - API (updateLocations)] action in edit_activity widget.
  ApiCallResponse? apiResponseUpdateLocationHotels;
  // Stores action output result for [Backend Call - API (insertLocations)] action in edit_activity widget.
  ApiCallResponse? responseInsertLocationHotels;
  // Stores action output result for [Backend Call - API (insertLocationByType)] action in edit_activity widget.
  ApiCallResponse? apiResponseInsertLocationHotels;
  // Stores action output result for [Backend Call - API (updateHotels)] action in edit_activity widget.
  ApiCallResponse? responseUpdateHotel;
  // Stores action output result for [Backend Call - API (updateLocations)] action in edit_activity widget.
  ApiCallResponse? apiResponseUpdateLocationTransfers;
  // Stores action output result for [Backend Call - API (insertLocations)] action in edit_activity widget.
  ApiCallResponse? responseInsertLocationTransfers;
  // Stores action output result for [Backend Call - API (insertLocationByType)] action in edit_activity widget.
  ApiCallResponse? apiResponseInsertLocationTransfers;
  // Stores action output result for [Backend Call - API (updateTransfers)] action in edit_activity widget.
  ApiCallResponse? resultUpdateTransfers;
  // Stores action output result for [Validate Form] action in add_activity widget.
  bool? responseFormAddProduct;
  // Stores action output result for [Backend Call - API (insertLocations)] action in add_activity widget.
  ApiCallResponse? apiResultAddLocationActivities;
  // Stores action output result for [Backend Call - API (addActivity)] action in add_activity widget.
  ApiCallResponse? responseAddActivity;
  // Stores action output result for [Backend Call - API (insertLocations)] action in add_activity widget.
  ApiCallResponse? apiResultAddLocationHotels;
  // Stores action output result for [Backend Call - Insert Row] action in add_activity widget.
  HotelsRow? responseAddHotel;
  // Stores action output result for [Backend Call - API (insertLocations)] action in add_activity widget.
  ApiCallResponse? apiResultAddLocationTransfers;
  // Stores action output result for [Backend Call - Insert Row] action in add_activity widget.
  TransfersRow? responseAddTransfer;

  @override
  void initState(BuildContext context) {
    nameActivityTextControllerValidator = _nameActivityTextControllerValidator;
    placePickerModel = createModel(context, () => PlacePickerModel());
    descriptionActivityTextControllerValidator =
        _descriptionActivityTextControllerValidator;
    descriptionShortActivityTextControllerValidator =
        _descriptionShortActivityTextControllerValidator;
    inclutionActivityTextControllerValidator =
        _inclutionActivityTextControllerValidator;
    notIcludeActivityTextControllerValidator =
        _notIcludeActivityTextControllerValidator;
    recomendationsActivityTextControllerValidator =
        _recomendationsActivityTextControllerValidator;
    instructionsActivityTextControllerValidator =
        _instructionsActivityTextControllerValidator;
  }

  @override
  void dispose() {
    nameActivityFocusNode?.dispose();
    nameActivityTextController?.dispose();

    placePickerModel.dispose();
    descriptionActivityFocusNode?.dispose();
    descriptionActivityTextController?.dispose();

    descriptionShortActivityFocusNode?.dispose();
    descriptionShortActivityTextController?.dispose();

    inclutionActivityFocusNode?.dispose();
    inclutionActivityTextController?.dispose();

    notIcludeActivityFocusNode?.dispose();
    notIcludeActivityTextController?.dispose();

    recomendationsActivityFocusNode?.dispose();
    recomendationsActivityTextController?.dispose();

    instructionsActivityFocusNode?.dispose();
    instructionsActivityTextController?.dispose();
  }
}
