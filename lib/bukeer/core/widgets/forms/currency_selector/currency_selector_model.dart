import '../../../../../flutter_flow/flutter_flow_animations.dart';
import '../../../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../../../flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import 'currency_selector_widget.dart' show CurrencySelectorWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CurrencySelectorModel
    extends FlutterFlowModel<CurrencySelectorWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for TextFieldUnitCost widget.
  FocusNode? textFieldUnitCostFocusNode1;
  TextEditingController? textFieldUnitCostTextController1;
  String? Function(BuildContext, String?)?
      textFieldUnitCostTextController1Validator;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  // State field(s) for TextFieldUnitCost widget.
  FocusNode? textFieldUnitCostFocusNode2;
  TextEditingController? textFieldUnitCostTextController2;
  String? Function(BuildContext, String?)?
      textFieldUnitCostTextController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldUnitCostFocusNode1?.dispose();
    textFieldUnitCostTextController1?.dispose();

    textFieldUnitCostFocusNode2?.dispose();
    textFieldUnitCostTextController2?.dispose();
  }
}
