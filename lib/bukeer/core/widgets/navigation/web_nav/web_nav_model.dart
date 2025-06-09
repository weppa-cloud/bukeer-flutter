import '../../../../../auth/supabase_auth/auth_util.dart';
import '../../../../../backend/api_requests/api_calls.dart';
import '../main_logo_small/main_logo_small_widget.dart';
import '../../forms/dropdowns/accounts/dropdown_accounts_widget.dart';
import '../../modals/product/details/modal_details_product_widget.dart';
import '../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '../../../../../index.dart';
import 'web_nav_widget.dart' show WebNavWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WebNavModel extends FlutterFlowModel<WebNavWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (getAgent)] action in webNav widget.
  ApiCallResponse? responseGetAgent;
  // Stores action output result for [Backend Call - API (getAllDataAccountWithLocation)] action in webNav widget.
  ApiCallResponse? apiResponseDataAccount;
  // Model for main_Logo_Small component.
  late MainLogoSmallModel mainLogoSmallModel;

  @override
  void initState(BuildContext context) {
    mainLogoSmallModel = createModel(context, () => MainLogoSmallModel());
  }

  @override
  void dispose() {
    mainLogoSmallModel.dispose();
  }
}
