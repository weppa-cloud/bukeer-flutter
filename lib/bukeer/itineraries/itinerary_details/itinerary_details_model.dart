import '../../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../../backend/supabase/supabase.dart';
import '../../core/widgets/navigation/web_nav/web_nav_widget.dart';
import '../../core/widgets/payments/payment_add/payment_add_widget.dart';
import '../../core/widgets/modals/passenger/add/modal_add_passenger_widget.dart';
import '../preview/component_itinerary_preview_activities/component_itinerary_preview_activities_widget.dart';
import '../preview/component_itinerary_preview_flights/component_itinerary_preview_flights_widget.dart';
import '../preview/component_itinerary_preview_hotels/component_itinerary_preview_hotels_widget.dart';
import '../preview/component_itinerary_preview_transfers/component_itinerary_preview_transfers_widget.dart';
import '../../core/widgets/payments/payment_provider/payment_provider_widget.dart';
import '../proveedores/reservation_message/reservation_message_widget.dart';
import '../proveedores/show_reservation_message/show_reservation_message_widget.dart';
import '../servicios/add_a_i_flights/add_a_i_flights_widget.dart';
import '../travel_planner_section/travel_planner_section_widget.dart';
import '../../core/widgets/modals/itinerary/add_edit/modal_add_edit_itinerary_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'dart:ui';
import '../../../custom_code/actions/index.dart' as actions;
import 'package:bukeer/legacy/flutter_flow/custom_functions.dart' as functions;
import '../../../index.dart';
import 'itinerary_details_widget.dart' show ItineraryDetailsWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class ItineraryDetailsModel extends FlutterFlowModel<ItineraryDetailsWidget> {
  ///  Local state fields for this page.

  int? typeProduct = 1;

  String? idHotelSelected;

  String botonCopyURL = 'Copiar URL';

  List<dynamic> itemsItineraryProvider = [];
  void addToItemsItineraryProvider(dynamic item) =>
      itemsItineraryProvider.add(item);
  void removeFromItemsItineraryProvider(dynamic item) =>
      itemsItineraryProvider.remove(item);
  void removeAtIndexFromItemsItineraryProvider(int index) =>
      itemsItineraryProvider.removeAt(index);
  void insertAtIndexInItemsItineraryProvider(int index, dynamic item) =>
      itemsItineraryProvider.insert(index, item);
  void updateItemsItineraryProviderAtIndex(
          int index, Function(dynamic) updateFn) =>
      itemsItineraryProvider[index] = updateFn(itemsItineraryProvider[index]);

  ///  State fields for stateful widgets in this page.

  // Model for webNav component.
  late WebNavModel webNavModel;
  // State field(s) for switch_confirmar widget.
  bool? switchConfirmarValue;
  // Stores action output result for [Backend Call - API (updateItineraryStatus)] action in switch_confirmar widget.
  ApiCallResponse? apiResponseChangeStatus;
  // Stores action output result for [Backend Call - API (updateItineraryStatus)] action in switch_confirmar widget.
  ApiCallResponse? apiResponseChangeStatusCopy;
  // Stores action output result for [Backend Call - API (duplicateItinerary)] action in IconCopyButton widget.
  ApiCallResponse? apiResponseDuplicateItinerary;
  // Stores action output result for [Backend Call - Query Rows] action in Row widget.
  List<ItineraryItemsRow>? itemsItinerary;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Stores action output result for [Custom Action - userAdminSupeardminValidate] action in Column widget.
  bool? responseValidateUserToFlights;
  // Stores action output result for [Custom Action - userAdminSupeardminValidate] action in Column widget.
  bool? responseValidateUserToHotels;
  // Stores action output result for [Custom Action - userAdminSupeardminValidate] action in Column widget.
  bool? responseValidateUserToActivities;
  // Stores action output result for [Custom Action - userAdminSupeardminValidate] action in Column widget.
  bool? responseValidateUserToTransfer;
  // Stores action output result for [Custom Action - createJSONToPDFVoucher] action in GenerarPDF widget.
  dynamic? responseJson;
  // Stores action output result for [Custom Action - createJSONToPDF] action in GenerarPDF widget.
  dynamic? responseJsonItinerary;
  // Stores action output result for [Backend Call - API (itineraryProposalPdf)] action in GenerarPDFv2 widget.
  ApiCallResponse? apiResult7dk;
  // State field(s) for ver_valores_url widget.
  bool? verValoresUrlValue;
  // Stores action output result for [Backend Call - API (updateItineraryRatesVisibility)] action in ver_valores_url widget.
  ApiCallResponse? apiResponseRatesVisibility;
  // Stores action output result for [Backend Call - API (updateItineraryRatesVisibility)] action in ver_valores_url widget.
  ApiCallResponse? apiResponseRatesVisibilityFalse;
  // State field(s) for publicar_url widget.
  bool? publicarUrlValue;
  // Stores action output result for [Backend Call - API (updateItineraryVisibility)] action in publicar_url widget.
  ApiCallResponse? apiResponseChangeItineraryVisibility;
  // Stores action output result for [Backend Call - API (updateItineraryVisibility)] action in publicar_url widget.
  ApiCallResponse? apiResponseChangeItineraryVisibilityFalse;
  // State field(s) for ListViewItemsItinerary widget.

  PagingController<ApiPagingParams, dynamic>?
      listViewItemsItineraryPagingController;
  Function(ApiPagingParams nextPageMarker)? listViewItemsItineraryApiCall;

  // Stores action output result for [Custom Action - validatePassengers] action in Button widget.
  bool? responseValidatePassengers;
  // Stores action output result for [Custom Action - validatePassengers] action in Row widget.
  bool? responseValidatePassengersUpdate;
  // Stores action output result for [Custom Action - validatePassengers] action in Button widget.
  bool? responseValidatePassengersPaid;

  // Model for TravelPlannerSection component.
  late TravelPlannerSectionModel travelPlannerSectionModel;

  @override
  void initState(BuildContext context) {
    webNavModel = createModel(context, () => WebNavModel());
    travelPlannerSectionModel =
        createModel(context, () => TravelPlannerSectionModel());
  }

  @override
  void dispose() {
    webNavModel.dispose();
    travelPlannerSectionModel.dispose();
    tabBarController?.dispose();
    listViewItemsItineraryPagingController?.dispose();
  }

  /// Additional helper methods.
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
}
