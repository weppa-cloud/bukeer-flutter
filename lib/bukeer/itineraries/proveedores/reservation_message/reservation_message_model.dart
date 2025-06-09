import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import '../../../../backend/api_requests/api_calls.dart';
import 'package:bukeer/backend/supabase/supabase.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '../../../../custom_code/actions/index.dart' as actions;
import 'reservation_message_widget.dart' show ReservationMessageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReservationMessageModel
    extends FlutterFlowModel<ReservationMessageWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for message widget.
  FocusNode? messageFocusNode;
  TextEditingController? messageTextController;
  String? Function(BuildContext, String?)? messageTextControllerValidator;
  // Stores action output result for [Backend Call - API (getPassengersItinerary)] action in Button widget.
  ApiCallResponse? responsePassengers;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<AccountsRow>? responseAccounts;
  // Stores action output result for [Backend Call - API (sendEmailReserva)] action in Button widget.
  ApiCallResponse? responseReservation;
  // Stores action output result for [Custom Action - setMessageReservation] action in Button widget.
  List<dynamic>? responseSetMessage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    messageFocusNode?.dispose();
    messageTextController?.dispose();
  }
}
