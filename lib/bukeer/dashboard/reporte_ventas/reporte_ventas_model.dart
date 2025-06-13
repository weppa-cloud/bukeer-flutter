import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_animations.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'reporte_ventas_widget.dart' show ReporteVentasWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReporteVentasModel extends FlutterFlowModel<ReporteVentasWidget> {
  ///  Local state fields for this page.

  String isProviderClientState = 'provider';

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  // GlobalKey removed to prevent duplicate key errors
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? textFieldSelectedOption;
  String? Function(BuildContext, String?)? textControllerValidator;
  Completer<ApiCallResponse>? apiRequestCompleter;
  DateTime? datePicked1;
  DateTime? datePicked2;

  @override
  void initState(BuildContext context) {
    // Initialize date range to last 30 days by default
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    datePicked2 = today;
    datePicked1 = today.subtract(Duration(days: 29));
  }

  @override
  void dispose() {
    // Don't dispose textFieldFocusNode here as it's managed by Autocomplete widget
    textController?.dispose();
  }

  /// Handle date range change from DateRangePickerWithPresets
  Future<void> onDateRangeChanged(
      DateTime? startDate, DateTime? endDate) async {
    datePicked1 = startDate;
    datePicked2 = endDate;
    // Clear the completer to trigger API refresh
    apiRequestCompleter = null;
    // Wait for API request to complete to prevent navigation issues
    await waitForApiRequestCompleted();
  }

  /// Additional helper methods.
  Future waitForApiRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
