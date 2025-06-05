import '../../../../../auth/supabase_auth/auth_util.dart';
import '../../../../../backend/api_requests/api_calls.dart';
import '../../../pagos/component_add_paid/component_add_paid_widget.dart';
import '../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'component_container_providers_widget.dart'
    show ComponentContainerProvidersWidget;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class ComponentContainerProvidersModel
    extends FlutterFlowModel<ComponentContainerProvidersWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for ListViewItemsItinerary widget.

  PagingController<ApiPagingParams, dynamic>?
      listViewItemsItineraryPagingController;
  Function(ApiPagingParams nextPageMarker)? listViewItemsItineraryApiCall;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    listViewItemsItineraryPagingController?.dispose();
  }

  /// Additional helper methods.
  PagingController<ApiPagingParams, dynamic>
      setListViewItemsItineraryController(
    Function(ApiPagingParams) apiCall,
  ) {
    listViewItemsItineraryApiCall = apiCall;
    return listViewItemsItineraryPagingController ??=
        _createListViewItemsItineraryController(apiCall);
  }

  PagingController<ApiPagingParams, dynamic>
      _createListViewItemsItineraryController(
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
      ..addPageRequestListener(listViewItemsItineraryGetAllItemsItineraryPage);
  }

  void listViewItemsItineraryGetAllItemsItineraryPage(
          ApiPagingParams nextPageMarker) =>
      listViewItemsItineraryApiCall!(nextPageMarker)
          .then((listViewItemsItineraryGetAllItemsItineraryResponse) {
        final pageItems =
            (listViewItemsItineraryGetAllItemsItineraryResponse.jsonBody ?? [])
                .toList() as List;
        final newNumItems = nextPageMarker.numItems + pageItems.length;
        listViewItemsItineraryPagingController?.appendPage(
          pageItems,
          (pageItems.length > 0)
              ? ApiPagingParams(
                  nextPageNumber: nextPageMarker.nextPageNumber + 1,
                  numItems: newNumItems,
                  lastResponse:
                      listViewItemsItineraryGetAllItemsItineraryResponse,
                )
              : null,
        );
      });

  Future waitForOnePageForListViewItemsItinerary({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = (listViewItemsItineraryPagingController
                  ?.nextPageKey?.nextPageNumber ??
              0) >
          0;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
