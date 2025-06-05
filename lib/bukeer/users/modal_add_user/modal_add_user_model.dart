import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../backend/supabase/supabase.dart';
import '../../../flutter_flow/flutter_flow_animations.dart';
import '../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import 'modal_add_user_widget.dart' show ModalAddUserWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ModalAddUserModel extends FlutterFlowModel<ModalAddUserWidget> {
  ///  Local state fields for this component.

  int? photoNumber;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - Delete Row(s)] action in IconButton widget.
  List<ContactsRow>? responseContactsDeleted;
  // Stores action output result for [Backend Call - Delete Row(s)] action in IconButton widget.
  List<UserRolesRow>? responsUserRolDeleted;
  // State field(s) for nameAgent widget.
  FocusNode? nameAgentFocusNode;
  TextEditingController? nameAgentTextController;
  String? Function(BuildContext, String?)? nameAgentTextControllerValidator;
  String? _nameAgentTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Nombre es requerido';
    }

    return null;
  }

  // State field(s) for lastNameAgent widget.
  FocusNode? lastNameAgentFocusNode;
  TextEditingController? lastNameAgentTextController;
  String? Function(BuildContext, String?)? lastNameAgentTextControllerValidator;
  // State field(s) for mailAgent widget.
  FocusNode? mailAgentFocusNode;
  TextEditingController? mailAgentTextController;
  String? Function(BuildContext, String?)? mailAgentTextControllerValidator;
  String? _mailAgentTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Emailes requerido';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // State field(s) for passwordAgent widget.
  FocusNode? passwordAgentFocusNode;
  TextEditingController? passwordAgentTextController;
  late bool passwordAgentVisibility;
  String? Function(BuildContext, String?)? passwordAgentTextControllerValidator;
  String? _passwordAgentTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Contraseña es requerido';
    }

    return null;
  }

  // State field(s) for roleAgent widget.
  String? roleAgentValue;
  FormFieldController<String>? roleAgentValueController;
  // Stores action output result for [Backend Call - API (updateUserContact)] action in edit_contact widget.
  ApiCallResponse? apiResponseUpdateuserContact;
  // Stores action output result for [Validate Form] action in add_contact widget.
  bool? responseForm;
  // Stores action output result for [Backend Call - API (AddUser)] action in add_contact widget.
  ApiCallResponse? reponseUserAuth;
  // Stores action output result for [Backend Call - Insert Row] action in add_contact widget.
  UserRolesRow? responseAddUserRoles;
  // Stores action output result for [Backend Call - API (addUserContact)] action in add_contact widget.
  ApiCallResponse? responseUserContact;
  // Stores action output result for [Backend Call - API (getUserAuth)] action in add_contact widget.
  ApiCallResponse? apiResponseGetUserAuth;
  // Stores action output result for [Backend Call - Insert Row] action in add_contact widget.
  UserRolesRow? responseAddUserRoles2;
  // Stores action output result for [Backend Call - API (addUserContact)] action in add_contact widget.
  ApiCallResponse? responseUserContact2;

  @override
  void initState(BuildContext context) {
    nameAgentTextControllerValidator = _nameAgentTextControllerValidator;
    mailAgentTextControllerValidator = _mailAgentTextControllerValidator;
    passwordAgentVisibility = false;
    passwordAgentTextControllerValidator =
        _passwordAgentTextControllerValidator;
  }

  @override
  void dispose() {
    nameAgentFocusNode?.dispose();
    nameAgentTextController?.dispose();

    lastNameAgentFocusNode?.dispose();
    lastNameAgentTextController?.dispose();

    mailAgentFocusNode?.dispose();
    mailAgentTextController?.dispose();

    passwordAgentFocusNode?.dispose();
    passwordAgentTextController?.dispose();
  }
}
