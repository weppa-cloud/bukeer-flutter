import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import 'package:bukeer/backend/api_requests/api_calls.dart';
import 'package:bukeer/backend/supabase/supabase.dart';
import '../../../forms/birth_date_picker/birth_date_picker_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_animations.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_drop_down.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:bukeer/legacy/flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import 'modal_add_passenger_widget.dart' show ModalAddPassengerWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ModalAddPassengerModel extends FlutterFlowModel<ModalAddPassengerWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - Delete Row(s)] action in IconButton widget.
  List<PassengerRow>? responseActivityDeleted;
  // State field(s) for namePassenger widget.
  FocusNode? namePassengerFocusNode;
  TextEditingController? namePassengerTextController;
  String? Function(BuildContext, String?)? namePassengerTextControllerValidator;
  String? _namePassengerTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 3) {
      return 'Requires at least 3 characters.';
    }

    return null;
  }

  // State field(s) for lastNamePassenger widget.
  FocusNode? lastNamePassengerFocusNode;
  TextEditingController? lastNamePassengerTextController;
  String? Function(BuildContext, String?)?
      lastNamePassengerTextControllerValidator;
  String? _lastNamePassengerTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for typeDocumentPassenger widget.
  String? typeDocumentPassengerValue;
  FormFieldController<String>? typeDocumentPassengerValueController;
  // State field(s) for numberIdPassenger widget.
  FocusNode? numberIdPassengerFocusNode;
  TextEditingController? numberIdPassengerTextController;
  String? Function(BuildContext, String?)?
      numberIdPassengerTextControllerValidator;
  String? _numberIdPassengerTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 5) {
      return 'Requires at least 5 characters.';
    }

    return null;
  }

  // State field(s) for nationalityPassenger widget.
  String? nationalityPassengerValue;
  FormFieldController<String>? nationalityPassengerValueController;
  // Model for birth_date_picker component.
  late BirthDatePickerModel birthDatePickerModel;
  // Stores action output result for [Validate Form] action in addPassenger widget.
  bool? responseForm;
  // Stores action output result for [Backend Call - API (countPassengersByItinerary)] action in addPassenger widget.
  ApiCallResponse? apiResponseCountPassenger;
  // Stores action output result for [Backend Call - API (addPassengerItinerary)] action in addPassenger widget.
  ApiCallResponse? apiResultAddPassenger;
  // Stores action output result for [Validate Form] action in editPassenger widget.
  bool? responseForm2;
  // Stores action output result for [Backend Call - API (updatePassengerItinerary)] action in editPassenger widget.
  ApiCallResponse? apiResultEditPassenger;

  @override
  void initState(BuildContext context) {
    namePassengerTextControllerValidator =
        _namePassengerTextControllerValidator;
    lastNamePassengerTextControllerValidator =
        _lastNamePassengerTextControllerValidator;
    numberIdPassengerTextControllerValidator =
        _numberIdPassengerTextControllerValidator;
    birthDatePickerModel = createModel(context, () => BirthDatePickerModel());
  }

  @override
  void dispose() {
    namePassengerFocusNode?.dispose();
    namePassengerTextController?.dispose();

    lastNamePassengerFocusNode?.dispose();
    lastNamePassengerTextController?.dispose();

    numberIdPassengerFocusNode?.dispose();
    numberIdPassengerTextController?.dispose();

    birthDatePickerModel.dispose();
  }
}
