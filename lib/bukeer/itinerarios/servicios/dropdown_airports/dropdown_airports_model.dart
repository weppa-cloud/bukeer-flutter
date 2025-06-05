import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../../backend/api_requests/api_calls.dart';
import '../../../../flutter_flow/flutter_flow_animations.dart';
import '../../../../flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '../../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'dropdown_airports_widget.dart' show DropdownAirportsWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class DropdownAirportsModel extends FlutterFlowModel<DropdownAirportsWidget> {
  ///  Local state fields for this component.

  int limit = 10;

  String? searchTerm;

  ///  State fields for stateful widgets in this component.

  // State field(s) for search_field widget.
  final searchFieldKey = GlobalKey();
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldTextController;
  String? searchFieldSelectedOption;
  String? Function(BuildContext, String?)? searchFieldTextControllerValidator;
  // State field(s) for ListViewAirports widget.

  PagingController<ApiPagingParams, dynamic>? listViewAirportsPagingController;
  Function(ApiPagingParams nextPageMarker)? listViewAirportsApiCall;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFieldFocusNode?.dispose();

    listViewAirportsPagingController?.dispose();
  }

  /// Additional helper methods.
  Future waitForOnePageForListViewAirports({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete =
          (listViewAirportsPagingController?.nextPageKey?.nextPageNumber ?? 0) >
              0;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }

  PagingController<ApiPagingParams, dynamic> setListViewAirportsController(
    Function(ApiPagingParams) apiCall,
  ) {
    listViewAirportsApiCall = apiCall;
    return listViewAirportsPagingController ??=
        _createListViewAirportsController(apiCall);
  }

  PagingController<ApiPagingParams, dynamic> _createListViewAirportsController(
    Function(ApiPagingParams) query,
  ) {
    final controller = PagingController<ApiPagingParams, dynamic>(
      firstPageKey: ApiPagingParams(
        nextPageNumber: 0,
        numItems: 0,
        lastResponse: null,
      ),
    );
    return controller..addPageRequestListener(listViewAirportsGetAirportsPage);
  }

  void listViewAirportsGetAirportsPage(ApiPagingParams nextPageMarker) =>
      listViewAirportsApiCall!(nextPageMarker)
          .then((listViewAirportsGetAirportsResponse) {
        final pageItems = (listViewAirportsGetAirportsResponse.jsonBody ?? [])
            .toList() as List;
        final newNumItems = nextPageMarker.numItems + pageItems.length;
        listViewAirportsPagingController?.appendPage(
          pageItems,
          (pageItems.length > 0)
              ? ApiPagingParams(
                  nextPageNumber: nextPageMarker.nextPageNumber + 1,
                  numItems: newNumItems,
                  lastResponse: listViewAirportsGetAirportsResponse,
                )
              : null,
        );
      });
}
