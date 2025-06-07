import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../backend/supabase/supabase.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '../../../custom_code/actions/index.dart' as actions;
import 'add_edit_tarifa_widget.dart' show AddEditTarifaWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddEditTarifaModel extends FlutterFlowModel<AddEditTarifaWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - Delete Row(s)] action in IconButton widget.
  List<ActivitiesRatesRow>? responseActivitiesDeleted;
  // Stores action output result for [Backend Call - Delete Row(s)] action in IconButton widget.
  List<HotelRatesRow>? responseHotelsDeleted;
  // Stores action output result for [Backend Call - Delete Row(s)] action in IconButton widget.
  List<TransferRatesRow>? responseTrnsfersDeleted;
  // State field(s) for NameInput widget.
  FocusNode? nameInputFocusNode;
  TextEditingController? nameInputTextController;
  String? Function(BuildContext, String?)? nameInputTextControllerValidator;
  String? _nameInputTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Nombre es requerido';
    }

    return null;
  }

  // State field(s) for CostoInput widget.
  FocusNode? costoInputFocusNode;
  TextEditingController? costoInputTextController;
  String? Function(BuildContext, String?)? costoInputTextControllerValidator;
  String? _costoInputTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Costo es requerido';
    }

    return null;
  }

  // Stores action output result for [Custom Action - calculateTotal] action in CostoInput widget.
  String? responseTotal;
  // State field(s) for ProfitInput widget.
  FocusNode? profitInputFocusNode;
  TextEditingController? profitInputTextController;
  String? Function(BuildContext, String?)? profitInputTextControllerValidator;
  String? _profitInputTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Margen es requerido';
    }

    return null;
  }

  // Stores action output result for [Custom Action - calculateTotal] action in ProfitInput widget.
  String? responseTotal2;
  // State field(s) for TotalInput widget.
  FocusNode? totalInputFocusNode;
  TextEditingController? totalInputTextController;
  String? Function(BuildContext, String?)? totalInputTextControllerValidator;
  String? _totalInputTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Total es requerido';
    }

    return null;
  }

  // Stores action output result for [Custom Action - calculateProfit] action in TotalInput widget.
  String? reponseProfit2;
  // Stores action output result for [Validate Form] action in Button widget.
  bool? responseForm;
  // Stores action output result for [Backend Call - API (addOrEditRateProduct)] action in Button widget.
  ApiCallResponse? responseAddRate;
  // Stores action output result for [Backend Call - API (addOrEditRateProduct)] action in Button widget.
  ApiCallResponse? responseEditRate;

  @override
  void initState(BuildContext context) {
    nameInputTextControllerValidator = _nameInputTextControllerValidator;
    costoInputTextControllerValidator = _costoInputTextControllerValidator;
    profitInputTextControllerValidator = _profitInputTextControllerValidator;
    totalInputTextControllerValidator = _totalInputTextControllerValidator;
  }

  @override
  void dispose() {
    nameInputFocusNode?.dispose();
    nameInputTextController?.dispose();

    costoInputFocusNode?.dispose();
    costoInputTextController?.dispose();

    profitInputFocusNode?.dispose();
    profitInputTextController?.dispose();

    totalInputFocusNode?.dispose();
    totalInputTextController?.dispose();
  }
}
