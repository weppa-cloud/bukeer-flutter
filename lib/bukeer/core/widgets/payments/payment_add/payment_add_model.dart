import '../../../../../auth/supabase_auth/auth_util.dart';
import '../../../../../backend/api_requests/api_calls.dart';
import '../../../../../backend/supabase/supabase.dart';
import '../../../../../flutter_flow/flutter_flow_animations.dart';
import '../../../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../../../flutter_flow/form_field_controller.dart';
import '../../../../../flutter_flow/upload_data.dart';
import 'dart:math';
import 'dart:ui';
import '../../../../../custom_code/actions/index.dart' as actions;
import '../../../../../flutter_flow/custom_functions.dart' as functions;
import 'payment_add_widget.dart' show PaymentAddWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentAddModel extends FlutterFlowModel<PaymentAddWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  DateTime? datePicked;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for TextFieldUnitCost widget.
  FocusNode? textFieldUnitCostFocusNode;
  TextEditingController? textFieldUnitCostTextController;
  String? Function(BuildContext, String?)?
      textFieldUnitCostTextControllerValidator;
  String? _textFieldUnitCostTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo requerido';
    }

    if (!RegExp('^([1-9]\\d*(\\.\\d+)?|0\\.\\d*[1-9]\\d*|\\.\\d*[1-9]\\d*)\$')
        .hasMatch(val)) {
      return 'Valor no válido';
    }
    return null;
  }

  // State field(s) for TextFieldReference widget.
  FocusNode? textFieldReferenceFocusNode;
  TextEditingController? textFieldReferenceTextController;
  String? Function(BuildContext, String?)?
      textFieldReferenceTextControllerValidator;
  bool isDataUploading_uploadVouchers = false;
  FFUploadedFile uploadedLocalFile_uploadVouchers =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadVouchers = '';

  // Stores action output result for [Validate Form] action in Copiar widget.
  bool? validateForm;
  // Stores action output result for [Custom Action - validategPaid] action in Copiar widget.
  bool? responseValidatePaidProvider;
  // Stores action output result for [Backend Call - Insert Row] action in Copiar widget.
  TransactionsRow? responseAddPaidProviders;
  // Stores action output result for [Backend Call - API (getPassengersItinerary)] action in Copiar widget.
  ApiCallResponse? responsePassengersItineraries;
  // Stores action output result for [Backend Call - Query Rows] action in Copiar widget.
  List<ItineraryItemsRow>? responseSaldoPendiente;
  // Stores action output result for [Backend Call - Query Rows] action in Copiar widget.
  List<AccountsRow>? accountResponse;
  // Stores action output result for [Backend Call - API (sendEmailPago)] action in Copiar widget.
  ApiCallResponse? responsePago;
  // Stores action output result for [Custom Action - validategPaid] action in Copiar widget.
  bool? responseValidatePaidIngreso;
  // Stores action output result for [Backend Call - Insert Row] action in Copiar widget.
  TransactionsRow? responseAddPaidIngreso;

  @override
  void initState(BuildContext context) {
    textFieldUnitCostTextControllerValidator =
        _textFieldUnitCostTextControllerValidator;
  }

  @override
  void dispose() {
    textFieldUnitCostFocusNode?.dispose();
    textFieldUnitCostTextController?.dispose();

    textFieldReferenceFocusNode?.dispose();
    textFieldReferenceTextController?.dispose();
  }
}
