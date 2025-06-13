import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import '../../../../backend/api_requests/api_calls.dart';
import 'package:bukeer/backend/supabase/supabase.dart';
import '../../../core/widgets/forms/place_picker/place_picker_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_animations.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_drop_down.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'package:bukeer/legacy/flutter_flow/form_field_controller.dart';
import 'package:bukeer/legacy/flutter_flow/upload_data.dart';
import 'dart:math';
import 'dart:ui';
import 'package:bukeer/legacy/flutter_flow/custom_functions.dart' as functions;
import '../../../../index.dart';
import 'dart:async';
import 'main_profile_account_widget.dart' show MainProfileAccountWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class MainProfileAccountModel
    extends FlutterFlowModel<MainProfileAccountWidget> {
  ///  Local state fields for this page.

  bool addCurrency = false;

  bool addTypeIncrease = false;

  bool addPaymentMethods = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - API (getAllDataAccountWithLocation)] action in Main_profileAccount widget.
  ApiCallResponse? apiResponseDataAccount;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  bool isDataUploading_uploadBrandPhoto = false;
  FFUploadedFile uploadedLocalFile_uploadBrandPhoto =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadBrandPhoto = '';

  // State field(s) for nameContact widget.
  FocusNode? nameContactFocusNode;
  TextEditingController? nameContactTextController;
  String? Function(BuildContext, String?)? nameContactTextControllerValidator;
  // State field(s) for phoneContact widget.
  FocusNode? phoneContactFocusNode;
  TextEditingController? phoneContactTextController;
  String? Function(BuildContext, String?)? phoneContactTextControllerValidator;
  // State field(s) for phone2Contact widget.
  FocusNode? phone2ContactFocusNode;
  TextEditingController? phone2ContactTextController;
  String? Function(BuildContext, String?)? phone2ContactTextControllerValidator;
  // State field(s) for mailContact widget.
  FocusNode? mailContactFocusNode;
  TextEditingController? mailContactTextController;
  String? Function(BuildContext, String?)? mailContactTextControllerValidator;
  // Model for place_picker component.
  late PlacePickerModel placePickerModel;
  // State field(s) for typeDocumentContact widget.
  String? typeDocumentContactValue;
  FormFieldController<String>? typeDocumentContactValueController;
  // State field(s) for numberIdContact widget.
  FocusNode? numberIdContactFocusNode;
  TextEditingController? numberIdContactTextController;
  final numberIdContactMask = MaskTextInputFormatter(mask: '###############');
  String? Function(BuildContext, String?)?
      numberIdContactTextControllerValidator;
  // State field(s) for websiteContact widget.
  FocusNode? websiteContactFocusNode;
  TextEditingController? websiteContactTextController;
  String? Function(BuildContext, String?)?
      websiteContactTextControllerValidator;
  // State field(s) for cancellationPolicyContact widget.
  FocusNode? cancellationPolicyContactFocusNode;
  TextEditingController? cancellationPolicyContactTextController;
  String? Function(BuildContext, String?)?
      cancellationPolicyContactTextControllerValidator;
  // State field(s) for privacyPolicyContact widget.
  FocusNode? privacyPolicyContactFocusNode;
  TextEditingController? privacyPolicyContactTextController;
  String? Function(BuildContext, String?)?
      privacyPolicyContactTextControllerValidator;
  // State field(s) for termsConditionsContact widget.
  FocusNode? termsConditionsContactFocusNode;
  TextEditingController? termsConditionsContactTextController;
  String? Function(BuildContext, String?)?
      termsConditionsContactTextControllerValidator;
  // State field(s) for DropDownBaseCurrency widget.
  String? dropDownBaseCurrencyValue;
  FormFieldController<String>? dropDownBaseCurrencyValueController;
  // State field(s) for DropDownOtherCurrency widget.
  String? dropDownOtherCurrencyValue;
  FormFieldController<String>? dropDownOtherCurrencyValueController;
  // State field(s) for TextFieldRate widget.
  FocusNode? textFieldRateFocusNode;
  TextEditingController? textFieldRateTextController;
  String? Function(BuildContext, String?)? textFieldRateTextControllerValidator;
  // State field(s) for DropDownPercentages widget.
  String? dropDownPercentagesValue;
  FormFieldController<String>? dropDownPercentagesValueController;
  // State field(s) for TextFieldPercentages widget.
  FocusNode? textFieldPercentagesFocusNode;
  TextEditingController? textFieldPercentagesTextController;
  String? Function(BuildContext, String?)?
      textFieldPercentagesTextControllerValidator;
  // State field(s) for TextFieldNames widget.
  FocusNode? textFieldNamesFocusNode;
  TextEditingController? textFieldNamesTextController;
  String? Function(BuildContext, String?)?
      textFieldNamesTextControllerValidator;
  // Stores action output result for [Validate Form] action in edit_contact widget.
  bool? responseValidateForm;
  // Stores action output result for [Backend Call - API (updateLocations)] action in edit_contact widget.
  ApiCallResponse? responseInsertLocation2;
  // Stores action output result for [Backend Call - API (insertLocations)] action in edit_contact widget.
  ApiCallResponse? responseInsertLocation3;
  // Stores action output result for [Backend Call - API (insertLocationByType)] action in edit_contact widget.
  ApiCallResponse? apiResultreg;
  // Stores action output result for [Backend Call - API (updateAllDataAccount)] action in edit_contact widget.
  ApiCallResponse? apiResulty9y;
  Completer<ApiCallResponse>? apiRequestCompleter;

  @override
  void initState(BuildContext context) {
    placePickerModel = createModel(context, () => PlacePickerModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    nameContactFocusNode?.dispose();
    nameContactTextController?.dispose();

    phoneContactFocusNode?.dispose();
    phoneContactTextController?.dispose();

    phone2ContactFocusNode?.dispose();
    phone2ContactTextController?.dispose();

    mailContactFocusNode?.dispose();
    mailContactTextController?.dispose();

    placePickerModel.dispose();
    numberIdContactFocusNode?.dispose();
    numberIdContactTextController?.dispose();

    websiteContactFocusNode?.dispose();
    websiteContactTextController?.dispose();

    cancellationPolicyContactFocusNode?.dispose();
    cancellationPolicyContactTextController?.dispose();

    privacyPolicyContactFocusNode?.dispose();
    privacyPolicyContactTextController?.dispose();

    termsConditionsContactFocusNode?.dispose();
    termsConditionsContactTextController?.dispose();

    textFieldRateFocusNode?.dispose();
    textFieldRateTextController?.dispose();

    textFieldPercentagesFocusNode?.dispose();
    textFieldPercentagesTextController?.dispose();

    textFieldNamesFocusNode?.dispose();
    textFieldNamesTextController?.dispose();
  }

  /// Additional helper methods.
  Future waitForApiRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
