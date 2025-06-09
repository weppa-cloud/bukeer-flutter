import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import 'package:bukeer/backend/api_requests/api_calls.dart';
import '../../../containers/activities/activities_container_widget.dart';
import '../../../containers/flights/flights_container_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_animations.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_drop_down.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'dropdown_products_widget.dart' show DropdownProductsWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class DropdownProductsModel extends FlutterFlowModel<DropdownProductsWidget> {
  ///  Local state fields for this component.

  int limit = 10;

  String? searchTerm;

  ///  State fields for stateful widgets in this component.

  // State field(s) for search_field widget.
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldTextController;
  String? Function(BuildContext, String?)? searchFieldTextControllerValidator;
  // State field(s) for DropDownLocation widget.
  String? dropDownLocationValue;
  FormFieldController<String>? dropDownLocationValueController;
  // State field(s) for ListViewProducts widget.

  PagingController<ApiPagingParams, dynamic>? listViewProductsPagingController;
  Function(ApiPagingParams nextPageMarker)? listViewProductsApiCall;

  // State field(s) for ListViewFlights widget.

  PagingController<ApiPagingParams, dynamic>? listViewFlightsPagingController;
  Function(ApiPagingParams nextPageMarker)? listViewFlightsApiCall;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFieldFocusNode?.dispose();
    searchFieldTextController?.dispose();

    listViewProductsPagingController?.dispose();
    listViewFlightsPagingController?.dispose();
  }

  /// Additional helper methods.
  Future waitForOnePageForListViewProducts({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete =
          (listViewProductsPagingController?.nextPageKey?.nextPageNumber ?? 0) >
              0;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }

  Future waitForOnePageForListViewFlights({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete =
          (listViewFlightsPagingController?.nextPageKey?.nextPageNumber ?? 0) >
              0;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }

  PagingController<ApiPagingParams, dynamic> setListViewProductsController(
    Function(ApiPagingParams) apiCall,
  ) {
    listViewProductsApiCall = apiCall;
    return listViewProductsPagingController ??=
        _createListViewProductsController(apiCall);
  }

  PagingController<ApiPagingParams, dynamic> _createListViewProductsController(
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
      ..addPageRequestListener(listViewProductsGetProductsFromViewsPage);
  }

  void listViewProductsGetProductsFromViewsPage(
          ApiPagingParams nextPageMarker) =>
      listViewProductsApiCall!(nextPageMarker)
          .then((listViewProductsGetProductsFromViewsResponse) {
        final pageItems =
            (listViewProductsGetProductsFromViewsResponse.jsonBody ?? [])
                .toList() as List;
        final newNumItems = nextPageMarker.numItems + pageItems.length;
        listViewProductsPagingController?.appendPage(
          pageItems,
          (pageItems.length > 0)
              ? ApiPagingParams(
                  nextPageNumber: nextPageMarker.nextPageNumber + 1,
                  numItems: newNumItems,
                  lastResponse: listViewProductsGetProductsFromViewsResponse,
                )
              : null,
        );
      });

  PagingController<ApiPagingParams, dynamic> setListViewFlightsController(
    Function(ApiPagingParams) apiCall,
  ) {
    listViewFlightsApiCall = apiCall;
    return listViewFlightsPagingController ??=
        _createListViewFlightsController(apiCall);
  }

  PagingController<ApiPagingParams, dynamic> _createListViewFlightsController(
    Function(ApiPagingParams) query,
  ) {
    final controller = PagingController<ApiPagingParams, dynamic>(
      firstPageKey: ApiPagingParams(
        nextPageNumber: 0,
        numItems: 0,
        lastResponse: null,
      ),
    );
    return controller..addPageRequestListener(listViewFlightsGetAirlinesPage);
  }

  void listViewFlightsGetAirlinesPage(ApiPagingParams nextPageMarker) =>
      listViewFlightsApiCall!(nextPageMarker)
          .then((listViewFlightsGetAirlinesResponse) {
        final pageItems = (listViewFlightsGetAirlinesResponse.jsonBody ?? [])
            .toList() as List;
        final newNumItems = nextPageMarker.numItems + pageItems.length;
        listViewFlightsPagingController?.appendPage(
          pageItems,
          (pageItems.length > 0)
              ? ApiPagingParams(
                  nextPageNumber: nextPageMarker.nextPageNumber + 1,
                  numItems: newNumItems,
                  lastResponse: listViewFlightsGetAirlinesResponse,
                )
              : null,
        );
      });
}
