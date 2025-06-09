import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import 'package:bukeer/backend/api_requests/api_calls.dart';
import 'package:bukeer/backend/supabase/supabase.dart';
import '../../../containers/accounts/accounts_container_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_animations.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'dart:math';
import 'dart:ui';
import 'package:bukeer/index.dart';
import 'dropdown_accounts_widget.dart' show DropdownAccountsWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DropdownAccountsModel extends FlutterFlowModel<DropdownAccountsWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for search_field widget.
  final searchFieldKey = GlobalKey();
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldTextController;
  String? searchFieldSelectedOption;
  String? Function(BuildContext, String?)? searchFieldTextControllerValidator;
  // Stores action output result for [Backend Call - Query Rows] action in accountsContainer widget.
  List<UserRolesRow>? responseAccount;
  // Stores action output result for [Backend Call - Query Rows] action in accountsContainer widget.
  List<AccountsRow>? responseIdFm;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFieldFocusNode?.dispose();
  }
}
