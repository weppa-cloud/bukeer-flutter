import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../componentes/boton_crear/boton_crear_widget.dart';
import '../../componentes/web_nav/web_nav_widget.dart';
import '../../modal_add_edit_itinerary/modal_add_edit_itinerary_widget.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '../../../index.dart';
import 'dart:async';
import 'main_itineraries_widget.dart' show MainItinerariesWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class MainItinerariesModel extends FlutterFlowModel<MainItinerariesWidget> {
  ///  Local state fields for this page.

  int? typeProduct = 1;

  bool confirmados = false;

  ///  State fields for stateful widgets in this page.

  // Model for webNav component.
  late WebNavModel webNavModel;
  // Model for BotonCrear component.
  late BotonCrearModel botonCrearModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for ListViewItineraries widget.

  PagingController<ApiPagingParams, dynamic>?
      listViewItinerariesPagingController;
  Function(ApiPagingParams nextPageMarker)? listViewItinerariesApiCall;

  @override
  void initState(BuildContext context) {
    webNavModel = createModel(context, () => WebNavModel());
    botonCrearModel = createModel(context, () => BotonCrearModel());
  }

  @override
  void dispose() {
    webNavModel.dispose();
    botonCrearModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    listViewItinerariesPagingController?.dispose();
  }

  /// Additional helper methods.
  Future waitForOnePageForListViewItineraries({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete =
          (listViewItinerariesPagingController?.nextPageKey?.nextPageNumber ??
                  0) >
              0;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }

  PagingController<ApiPagingParams, dynamic> setListViewItinerariesController(
    Function(ApiPagingParams) apiCall,
  ) {
    listViewItinerariesApiCall = apiCall;
    return listViewItinerariesPagingController ??=
        _createListViewItinerariesController(apiCall);
  }

  PagingController<ApiPagingParams, dynamic>
      _createListViewItinerariesController(
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
      ..addPageRequestListener(
          listViewItinerariesGetItinerariesWithDataContactSearchPage);
  }

  void listViewItinerariesGetItinerariesWithDataContactSearchPage(
          ApiPagingParams nextPageMarker) =>
      listViewItinerariesApiCall!(nextPageMarker).then(
          (listViewItinerariesGetItinerariesWithDataContactSearchResponse) {
        final pageItems =
            (listViewItinerariesGetItinerariesWithDataContactSearchResponse
                        .jsonBody ??
                    [])
                .toList() as List;
        final newNumItems = nextPageMarker.numItems + pageItems.length;
        listViewItinerariesPagingController?.appendPage(
          pageItems,
          (pageItems.length > 0)
              ? ApiPagingParams(
                  nextPageNumber: nextPageMarker.nextPageNumber + 1,
                  numItems: newNumItems,
                  lastResponse:
                      listViewItinerariesGetItinerariesWithDataContactSearchResponse,
                )
              : null,
        );
      });
}
