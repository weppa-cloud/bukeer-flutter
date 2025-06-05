import '../../componentes/main_logo_small/main_logo_small_widget.dart';
import '../../../flutter_flow/flutter_flow_animations.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '../../../custom_code/actions/index.dart' as actions;
import '../../../index.dart';
import 'auth_reset_password_widget.dart' show AuthResetPasswordWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthResetPasswordModel extends FlutterFlowModel<AuthResetPasswordWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for main_Logo_Small component.
  late MainLogoSmallModel mainLogoSmallModel;
  // State field(s) for passwordResert widget.
  FocusNode? passwordResertFocusNode;
  TextEditingController? passwordResertTextController;
  late bool passwordResertVisibility;
  String? Function(BuildContext, String?)?
      passwordResertTextControllerValidator;
  // Stores action output result for [Custom Action - resetPassword] action in Button-Login widget.
  String? error;

  @override
  void initState(BuildContext context) {
    mainLogoSmallModel = createModel(context, () => MainLogoSmallModel());
    passwordResertVisibility = false;
  }

  @override
  void dispose() {
    mainLogoSmallModel.dispose();
    passwordResertFocusNode?.dispose();
    passwordResertTextController?.dispose();
  }
}
