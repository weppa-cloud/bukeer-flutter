import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../core/widgets/buttons/btn_create/btn_create_widget.dart';
import '../../core/widgets/forms/search_box/search_box_widget.dart';
import '../../core/widgets/navigation/web_nav/web_nav_widget.dart';
import '../../core/widgets/modals/user/add/modal_add_user_widget.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'main_users_widget.dart' show MainUsersWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainUsersModel extends FlutterFlowModel<MainUsersWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for webNav component.
  late WebNavModel webNavModel;
  // Model for BtnCreate component.
  late BtnCreateModel btnCreateModel;
  // Model for search_box component.
  late SearchBoxModel searchBoxModel;

  @override
  void initState(BuildContext context) {
    webNavModel = createModel(context, () => WebNavModel());
    btnCreateModel = createModel(context, () => BtnCreateModel());
    searchBoxModel = createModel(context, () => SearchBoxModel());
  }

  @override
  void dispose() {
    webNavModel.dispose();
    btnCreateModel.dispose();
    searchBoxModel.dispose();
  }
}
