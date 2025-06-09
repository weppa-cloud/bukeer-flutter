import '../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '../../../../../flutter_flow/custom_functions.dart' as functions;
import 'edit_payment_methods_widget.dart' show EditPaymentMethodsWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditPaymentMethodsModel
    extends FlutterFlowModel<EditPaymentMethodsWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
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

  // Stores action output result for [Validate Form] action in Button widget.
  bool? responseForm;

  @override
  void initState(BuildContext context) {
    nameInputTextControllerValidator = _nameInputTextControllerValidator;
  }

  @override
  void dispose() {
    nameInputFocusNode?.dispose();
    nameInputTextController?.dispose();
  }
}
