import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../core/widgets/modals/passenger/add/modal_add_passenger_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:bukeer/legacy/flutter_flow/custom_functions.dart' as functions;
import '../../../index.dart';
import 'add_passengers_itinerary_widget.dart' show AddPassengersItineraryWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddPassengersItineraryModel
    extends FlutterFlowModel<AddPassengersItineraryWidget> {
  ///  Local state fields for this page.

  int? typeProduct = 4;

  String? idHotelSelected;

  String botonCopyURL = 'Copiar URL';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
