import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../backend/supabase/supabase.dart';
import '../../component_container_activities/component_container_activities_widget.dart';
import '../../componentes/component_place/component_place_widget.dart';
import '../component_container_contacts/component_container_contacts_widget.dart';
import '../modal_add_edit_contact/modal_add_edit_contact_widget.dart';
import '../../itinerarios/component_container_itineraries/component_container_itineraries_widget.dart';
import '../../productos/component_container_hotels/component_container_hotels_widget.dart';
import '../../productos/component_container_transfers/component_container_transfers_widget.dart';
import '../../productos/modal_add_product/modal_add_product_widget.dart';
import '../../productos/modal_details_product/modal_details_product_widget.dart';
import '../../../flutter_flow/flutter_flow_animations.dart';
import '../../../flutter_flow/flutter_flow_button_tabbar.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'modal_details_contact_widget.dart' show ModalDetailsContactWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class ModalDetailsContactModel
    extends FlutterFlowModel<ModalDetailsContactWidget> {
  ///  Local state fields for this component.

  int? photoNumber;

  int? activeTab = 3;

  bool createContact = false;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - API (validateDeleteContact)] action in IconButton widget.
  ApiCallResponse? apiResponseValidateDeleteContact;
  // Stores action output result for [Backend Call - Delete Row(s)] action in IconButton widget.
  List<LocationsRow>? apiResponseDeleteLocation;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for nameContact widget.
  FocusNode? nameContactFocusNode;
  TextEditingController? nameContactTextController;
  String? Function(BuildContext, String?)? nameContactTextControllerValidator;
  String? _nameContactTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Nombre es obligatorio';
    }

    return null;
  }

  // State field(s) for lastNameContact widget.
  FocusNode? lastNameContactFocusNode;
  TextEditingController? lastNameContactTextController;
  String? Function(BuildContext, String?)?
      lastNameContactTextControllerValidator;
  // State field(s) for phoneContact widget.
  FocusNode? phoneContactFocusNode;
  TextEditingController? phoneContactTextController;
  String? Function(BuildContext, String?)? phoneContactTextControllerValidator;
  // State field(s) for phone2Contact widget.
  FocusNode? phone2ContactFocusNode;
  TextEditingController? phone2ContactTextController;
  String? Function(BuildContext, String?)? phone2ContactTextControllerValidator;
  // State field(s) for mailContact widget.
  FocusNode? mailContactFocusNode;
  TextEditingController? mailContactTextController;
  String? Function(BuildContext, String?)? mailContactTextControllerValidator;
  String? _mailContactTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Email es obligatorio';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // State field(s) for positionContact widget.
  FocusNode? positionContactFocusNode;
  TextEditingController? positionContactTextController;
  String? Function(BuildContext, String?)?
      positionContactTextControllerValidator;
  // Model for component_place component.
  late ComponentPlaceModel componentPlaceModel;
  // State field(s) for notify widget.
  bool? notifyValue;
  // Stores action output result for [Validate Form] action in add_contact widget.
  bool? responseFormAddContact;
  // Stores action output result for [Backend Call - API (insertLocations)] action in add_contact widget.
  ApiCallResponse? responseInsertLocation;
  // Stores action output result for [Backend Call - API (insertRelatedContact)] action in add_contact widget.
  ApiCallResponse? insertContactApiResponse;
  // State field(s) for ListViewContacts widget.

  PagingController<ApiPagingParams, dynamic>? listViewContactsPagingController;
  Function(ApiPagingParams nextPageMarker)? listViewContactsApiCall;

  @override
  void initState(BuildContext context) {
    nameContactTextControllerValidator = _nameContactTextControllerValidator;
    mailContactTextControllerValidator = _mailContactTextControllerValidator;
    componentPlaceModel = createModel(context, () => ComponentPlaceModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    nameContactFocusNode?.dispose();
    nameContactTextController?.dispose();

    lastNameContactFocusNode?.dispose();
    lastNameContactTextController?.dispose();

    phoneContactFocusNode?.dispose();
    phoneContactTextController?.dispose();

    phone2ContactFocusNode?.dispose();
    phone2ContactTextController?.dispose();

    mailContactFocusNode?.dispose();
    mailContactTextController?.dispose();

    positionContactFocusNode?.dispose();
    positionContactTextController?.dispose();

    componentPlaceModel.dispose();
    listViewContactsPagingController?.dispose();
  }

  /// Additional helper methods.
  Future waitForOnePageForListViewContacts({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete =
          (listViewContactsPagingController?.nextPageKey?.nextPageNumber ?? 0) >
              0;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }

  PagingController<ApiPagingParams, dynamic> setListViewContactsController(
    Function(ApiPagingParams) apiCall,
  ) {
    listViewContactsApiCall = apiCall;
    return listViewContactsPagingController ??=
        _createListViewContactsController(apiCall);
  }

  PagingController<ApiPagingParams, dynamic> _createListViewContactsController(
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
      ..addPageRequestListener(listViewContactsGetRelatedContactPage);
  }

  void listViewContactsGetRelatedContactPage(ApiPagingParams nextPageMarker) =>
      listViewContactsApiCall!(nextPageMarker)
          .then((listViewContactsGetRelatedContactResponse) {
        final pageItems =
            (listViewContactsGetRelatedContactResponse.jsonBody ?? []).toList()
                as List;
        final newNumItems = nextPageMarker.numItems + pageItems.length;
        listViewContactsPagingController?.appendPage(
          pageItems,
          (pageItems.length > 0)
              ? ApiPagingParams(
                  nextPageNumber: nextPageMarker.nextPageNumber + 1,
                  numItems: newNumItems,
                  lastResponse: listViewContactsGetRelatedContactResponse,
                )
              : null,
        );
      });
}
