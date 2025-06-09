import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../core/widgets/buttons/btn_create/btn_create_widget.dart';
import '../../core/widgets/forms/search_box/search_box_widget.dart';
import '../../core/widgets/navigation/web_nav/web_nav_widget.dart';
import '../../core/widgets/modals/contact/add_edit/modal_add_edit_contact_widget.dart';
import '../../core/widgets/modals/contact/details/modal_details_contact_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'dart:async';
import 'main_contacts_widget.dart' show MainContactsWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class MainContactsModel extends FlutterFlowModel<MainContactsWidget> {
  ///  Local state fields for this page.

  String isProviderClientState = 'provider';

  ///  State fields for stateful widgets in this page.

  // Model for webNav component.
  late WebNavModel webNavModel;
  // Model for BtnCreate component.
  late BtnCreateModel btnCreateModel;
  // Model for SearchBox component.
  late SearchBoxModel searchBoxModel;
  // State field(s) for ListViewSearch widget.

  PagingController<ApiPagingParams, dynamic>? listViewSearchPagingController;
  Function(ApiPagingParams nextPageMarker)? listViewSearchApiCall;

  @override
  void initState(BuildContext context) {
    webNavModel = createModel(context, () => WebNavModel());
    btnCreateModel = createModel(context, () => BtnCreateModel());
    searchBoxModel = createModel(context, () => SearchBoxModel());
  }

  @override
  void dispose() {
    webNavModel.dispose();
    btnCreateModel.dispose();
    searchBoxModel.dispose();

    listViewSearchPagingController?.dispose();
  }

  /// Additional helper methods.
  Future waitForOnePageForListViewSearch({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete =
          (listViewSearchPagingController?.nextPageKey?.nextPageNumber ?? 0) >
              0;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }

  PagingController<ApiPagingParams, dynamic> setListViewSearchController(
    Function(ApiPagingParams) apiCall,
  ) {
    listViewSearchApiCall = apiCall;
    return listViewSearchPagingController ??=
        _createListViewSearchController(apiCall);
  }

  PagingController<ApiPagingParams, dynamic> _createListViewSearchController(
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
      ..addPageRequestListener(listViewSearchGetContactSearchPage);
  }

  void listViewSearchGetContactSearchPage(ApiPagingParams nextPageMarker) =>
      listViewSearchApiCall!(nextPageMarker)
          .then((listViewSearchGetContactSearchResponse) {
        final pageItems =
            (listViewSearchGetContactSearchResponse.jsonBody ?? []).toList()
                as List;
        final newNumItems = nextPageMarker.numItems + pageItems.length;
        listViewSearchPagingController?.appendPage(
          pageItems,
          (pageItems.length > 0)
              ? ApiPagingParams(
                  nextPageNumber: nextPageMarker.nextPageNumber + 1,
                  numItems: newNumItems,
                  lastResponse: listViewSearchGetContactSearchResponse,
                )
              : null,
        );
      });
}
