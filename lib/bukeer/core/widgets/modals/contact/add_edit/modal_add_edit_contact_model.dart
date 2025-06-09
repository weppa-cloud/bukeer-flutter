import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import 'package:bukeer/backend/api_requests/api_calls.dart';
import 'package:bukeer/backend/supabase/supabase.dart';
import 'package:bukeer/bukeer/core/widgets/forms/birth_date_picker/birth_date_picker_widget.dart';
import 'package:bukeer/bukeer/core/widgets/forms/place_picker/place_picker_widget.dart';
import '../details/modal_details_contact_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_drop_down.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:bukeer/legacy/flutter_flow/form_field_controller.dart';
import 'package:bukeer/legacy/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'package:bukeer/custom_code/widgets/index.dart' as custom_widgets;
import 'package:bukeer/index.dart';
import 'modal_add_edit_contact_widget.dart' show ModalAddEditContactWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class ModalAddEditContactModel
    extends FlutterFlowModel<ModalAddEditContactWidget> {
  ///  Local state fields for this component.

  int? photoNumber;

  String? responseInsertLocationState;

  String? phoneNumberE164;

  String? phoneNumber2E164;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_uploadProfilePhoto = false;
  FFUploadedFile uploadedLocalFile_uploadProfilePhoto =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadProfilePhoto = '';

  // State field(s) for SwitchIsClient widget.
  bool? switchIsClientValue;
  // State field(s) for SwitchIsCompany widget.
  bool? switchIsCompanyValue;
  // State field(s) for SwitchIsProvider widget.
  bool? switchIsProviderValue;
  // State field(s) for nameContact widget.
  FocusNode? nameContactFocusNode;
  TextEditingController? nameContactTextController;
  String? Function(BuildContext, String?)? nameContactTextControllerValidator;
  String? _nameContactTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for lastNameContact widget.
  FocusNode? lastNameContactFocusNode;
  TextEditingController? lastNameContactTextController;
  String? Function(BuildContext, String?)?
      lastNameContactTextControllerValidator;
  String? _lastNameContactTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for typeDocumentContact widget.
  String? typeDocumentContactValue;
  FormFieldController<String>? typeDocumentContactValueController;
  // State field(s) for numberIdContact widget.
  FocusNode? numberIdContactFocusNode;
  TextEditingController? numberIdContactTextController;
  final numberIdContactMask = MaskTextInputFormatter(mask: '###############');
  String? Function(BuildContext, String?)?
      numberIdContactTextControllerValidator;
  String? _numberIdContactTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for nationalyContact widget.
  String? nationalyContactValue;
  FormFieldController<String>? nationalyContactValueController;
  // State field(s) for mailContact widget.
  FocusNode? mailContactFocusNode;
  TextEditingController? mailContactTextController;
  String? Function(BuildContext, String?)? mailContactTextControllerValidator;
  String? _mailContactTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // Model for place_picker component.
  late PlacePickerModel placePickerModel;
  // Model for birth_date_picker component.
  late BirthDatePickerModel birthDatePickerModel;
  // Stores action output result for [Validate Form] action in add_contact widget.
  bool? responseFormAddContact;
  // Stores action output result for [Backend Call - API (insertLocations)] action in add_contact widget.
  ApiCallResponse? responseInsertLocation;
  // Stores action output result for [Backend Call - API (insertContact)] action in add_contact widget.
  ApiCallResponse? apiResponseInsertContact;
  // Stores action output result for [Validate Form] action in edit_contact widget.
  bool? responseFormUpdateContact;
  // Stores action output result for [Backend Call - API (updateLocations)] action in edit_contact widget.
  ApiCallResponse? responseInsertLocation2;
  // Stores action output result for [Backend Call - API (insertLocations)] action in edit_contact widget.
  ApiCallResponse? responseInsertLocation3;
  // Stores action output result for [Backend Call - API (insertLocationByType)] action in edit_contact widget.
  ApiCallResponse? apiResultreg;
  // Stores action output result for [Backend Call - API (updateContact)] action in edit_contact widget.
  ApiCallResponse? apiResult4b0;

  @override
  void initState(BuildContext context) {
    nameContactTextControllerValidator = _nameContactTextControllerValidator;
    lastNameContactTextControllerValidator =
        _lastNameContactTextControllerValidator;
    numberIdContactTextControllerValidator =
        _numberIdContactTextControllerValidator;
    mailContactTextControllerValidator = _mailContactTextControllerValidator;
    placePickerModel = createModel(context, () => PlacePickerModel());
    birthDatePickerModel = createModel(context, () => BirthDatePickerModel());
  }

  @override
  void dispose() {
    nameContactFocusNode?.dispose();
    nameContactTextController?.dispose();

    lastNameContactFocusNode?.dispose();
    lastNameContactTextController?.dispose();

    numberIdContactFocusNode?.dispose();
    numberIdContactTextController?.dispose();

    mailContactFocusNode?.dispose();
    mailContactTextController?.dispose();

    placePickerModel.dispose();
    birthDatePickerModel.dispose();
  }
}
