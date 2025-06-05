import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../backend/supabase/supabase.dart';
import '../../componentes/main_logo_small/main_logo_small_widget.dart';
import '../../../flutter_flow/flutter_flow_animations.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '../../../index.dart';
import 'auth_create_widget.dart' show AuthCreateWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthCreateModel extends FlutterFlowModel<AuthCreateWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for main_Logo_Small component.
  late MainLogoSmallModel mainLogoSmallModel;
  // State field(s) for nameAccount widget.
  FocusNode? nameAccountFocusNode;
  TextEditingController? nameAccountTextController;
  String? Function(BuildContext, String?)? nameAccountTextControllerValidator;
  String? _nameAccountTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Este campo es requerido';
    }

    return null;
  }

  // State field(s) for name widget.
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;
  String? _nameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Este campo es requerido';
    }

    return null;
  }

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;
  String? _emailAddressTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Este campo es requerido';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  String? _passwordTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Este campo es requerido';
    }

    return null;
  }

  // State field(s) for passwordConfirm widget.
  FocusNode? passwordConfirmFocusNode;
  TextEditingController? passwordConfirmTextController;
  late bool passwordConfirmVisibility;
  String? Function(BuildContext, String?)?
      passwordConfirmTextControllerValidator;
  String? _passwordConfirmTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Este campo es requerido';
    }

    return null;
  }

  // Stores action output result for [Validate Form] action in Button-Create widget.
  bool? validateFormAuthCreate;
  // Stores action output result for [Backend Call - API (AddUser)] action in Button-Create widget.
  ApiCallResponse? apiResponseAddUser;
  // Stores action output result for [Backend Call - API (addAccounts)] action in Button-Create widget.
  ApiCallResponse? apiResponseAddAccounts;
  // Stores action output result for [Backend Call - API (addUserContact)] action in Button-Create widget.
  ApiCallResponse? apiResponseAddUserContact;
  // Stores action output result for [Backend Call - Query Rows] action in Button-Create widget.
  List<UserRolesRow>? responseAccount;
  // Stores action output result for [Backend Call - Query Rows] action in Button-Create widget.
  List<AccountsRow>? responseIdfm;

  @override
  void initState(BuildContext context) {
    mainLogoSmallModel = createModel(context, () => MainLogoSmallModel());
    nameAccountTextControllerValidator = _nameAccountTextControllerValidator;
    nameTextControllerValidator = _nameTextControllerValidator;
    emailAddressTextControllerValidator = _emailAddressTextControllerValidator;
    passwordVisibility = false;
    passwordTextControllerValidator = _passwordTextControllerValidator;
    passwordConfirmVisibility = false;
    passwordConfirmTextControllerValidator =
        _passwordConfirmTextControllerValidator;
  }

  @override
  void dispose() {
    mainLogoSmallModel.dispose();
    nameAccountFocusNode?.dispose();
    nameAccountTextController?.dispose();

    nameFocusNode?.dispose();
    nameTextController?.dispose();

    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();

    passwordConfirmFocusNode?.dispose();
    passwordConfirmTextController?.dispose();
  }
}
