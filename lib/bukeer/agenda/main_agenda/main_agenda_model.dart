import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_animations.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '../../../index.dart';
import 'dart:async';
import 'main_agenda_widget.dart' show MainAgendaWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class MainAgendaModel extends FlutterFlowModel<MainAgendaWidget> {
  ///  Local state fields for this page.

  String isProviderClientState = 'provider';

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  final textFieldKey = GlobalKey();
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? textFieldSelectedOption;
  String? Function(BuildContext, String?)? textControllerValidator;
  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for ListViewAgenda widget.

  PagingController<ApiPagingParams, dynamic>? listViewAgendaPagingController;
  Function(ApiPagingParams nextPageMarker)? listViewAgendaApiCall;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();

    listViewAgendaPagingController?.dispose();
  }

  /// Additional helper methods.
  Future waitForOnePageForListViewAgenda({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete =
          (listViewAgendaPagingController?.nextPageKey?.nextPageNumber ?? 0) >
              0;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }

  PagingController<ApiPagingParams, dynamic> setListViewAgendaController(
    Function(ApiPagingParams) apiCall,
  ) {
    listViewAgendaApiCall = apiCall;
    return listViewAgendaPagingController ??=
        _createListViewAgendaController(apiCall);
  }

  PagingController<ApiPagingParams, dynamic> _createListViewAgendaController(
    Function(ApiPagingParams) query,
  ) {
    final controller = PagingController<ApiPagingParams, dynamic>(
      firstPageKey: ApiPagingParams(
        nextPageNumber: 0,
        numItems: 0,
        lastResponse: null,
      ),
    );
    return controller
      ..addPageRequestListener(listViewAgendaGetAgendaByDatePage);
  }

  void listViewAgendaGetAgendaByDatePage(ApiPagingParams nextPageMarker) =>
      listViewAgendaApiCall!(nextPageMarker)
          .then((listViewAgendaGetAgendaByDateResponse) {
        final pageItems = (listViewAgendaGetAgendaByDateResponse.jsonBody ?? [])
            .toList() as List;
        final newNumItems = nextPageMarker.numItems + pageItems.length;
        listViewAgendaPagingController?.appendPage(
          pageItems,
          (pageItems.length > 0)
              ? ApiPagingParams(
                  nextPageNumber: nextPageMarker.nextPageNumber + 1,
                  numItems: newNumItems,
                  lastResponse: listViewAgendaGetAgendaByDateResponse,
                )
              : null,
        );
      });
}
