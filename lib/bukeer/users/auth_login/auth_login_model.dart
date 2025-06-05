import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/supabase/supabase.dart';
import '../../componentes/main_logo_small/main_logo_small_widget.dart';
import '../../../flutter_flow/flutter_flow_animations.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '../../../index.dart';
import 'auth_login_widget.dart' show AuthLoginWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthLoginModel extends FlutterFlowModel<AuthLoginWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for main_Logo_Small component.
  late MainLogoSmallModel mainLogoSmallModel;
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // Stores action output result for [Backend Call - Query Rows] action in Button-Login widget.
  List<UserRolesRow>? responseAccount;
  // Stores action output result for [Backend Call - Query Rows] action in Button-Login widget.
  List<AccountsRow>? responseIdfm;

  @override
  void initState(BuildContext context) {
    mainLogoSmallModel = createModel(context, () => MainLogoSmallModel());
    passwordVisibility = false;
  }

  @override
  void dispose() {
    mainLogoSmallModel.dispose();
    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}
