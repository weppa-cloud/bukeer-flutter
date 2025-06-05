import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../componentes/boton_crear/boton_crear_widget.dart';
import '../../componentes/search_box/search_box_widget.dart';
import '../../componentes/web_nav/web_nav_widget.dart';
import '../modal_add_user/modal_add_user_widget.dart';
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
  // Model for BotonCrear component.
  late BotonCrearModel botonCrearModel;
  // Model for search_box component.
  late SearchBoxModel searchBoxModel;

  @override
  void initState(BuildContext context) {
    webNavModel = createModel(context, () => WebNavModel());
    botonCrearModel = createModel(context, () => BotonCrearModel());
    searchBoxModel = createModel(context, () => SearchBoxModel());
  }

  @override
  void dispose() {
    webNavModel.dispose();
    botonCrearModel.dispose();
    searchBoxModel.dispose();
  }
}
