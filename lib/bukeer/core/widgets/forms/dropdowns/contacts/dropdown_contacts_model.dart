import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import 'package:bukeer/backend/api_requests/api_calls.dart';
import '../../../buttons/btn_create/btn_create_widget.dart';
import '../../place_picker/place_picker_widget.dart';
import '../../../containers/contacts/contacts_container_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_animations.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'package:bukeer/custom_code/widgets/index.dart' as custom_widgets;
import 'dart:async';
import 'dropdown_contacts_widget.dart' show DropdownContactsWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class DropdownContactsModel extends FlutterFlowModel<DropdownContactsWidget> {
  ///  Local state fields for this component.

  int limit = 10;

  bool createContact = false;

  String? phoneNumberE164;

  String? phoneNumber2E164;

  ///  State fields for stateful widgets in this component.

  // GlobalKey removed to prevent duplicate key errors
  // final formKey = GlobalKey<FormState>();
  // State field(s) for search_field widget.
  // GlobalKey removed to prevent duplicate key errors
  // final searchFieldKey = GlobalKey();
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldTextController;
  String? searchFieldSelectedOption;
  String? Function(BuildContext, String?)? searchFieldTextControllerValidator;
  // Model for BtnCreate component.
  late BtnCreateModel btnCreateModel;
  // State field(s) for SwitchIsCompany widget.
  bool? switchIsCompanyValue;
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
  // State field(s) for mailContact widget.
  FocusNode? mailContactFocusNode;
  TextEditingController? mailContactTextController;
  String? Function(BuildContext, String?)? mailContactTextControllerValidator;
  // Model for place_picker component.
  late PlacePickerModel placePickerModel;
  // Stores action output result for [Validate Form] action in add_contact widget.
  bool? responseFormAddContact;
  // Stores action output result for [Backend Call - API (insertLocations)] action in add_contact widget.
  ApiCallResponse? responseInsertLocation;
  // Stores action output result for [Backend Call - API (insertContact)] action in add_contact widget.
  ApiCallResponse? insertContactApiResponse;
  // State field(s) for ListViewContacts widget.

  PagingController<ApiPagingParams, dynamic>? listViewContactsPagingController;
  Function(ApiPagingParams nextPageMarker)? listViewContactsApiCall;

  @override
  void initState(BuildContext context) {
    btnCreateModel = createModel(context, () => BtnCreateModel());
    nameContactTextControllerValidator = _nameContactTextControllerValidator;
    placePickerModel = createModel(context, () => PlacePickerModel());
  }

  @override
  void dispose() {
    searchFieldFocusNode?.dispose();

    btnCreateModel.dispose();
    nameContactFocusNode?.dispose();
    nameContactTextController?.dispose();

    lastNameContactFocusNode?.dispose();
    lastNameContactTextController?.dispose();

    mailContactFocusNode?.dispose();
    mailContactTextController?.dispose();

    placePickerModel.dispose();
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
      ..addPageRequestListener(listViewContactsGetContactSearchPage);
  }

  void listViewContactsGetContactSearchPage(ApiPagingParams nextPageMarker) =>
      listViewContactsApiCall!(nextPageMarker)
          .then((listViewContactsGetContactSearchResponse) {
        final pageItems =
            (listViewContactsGetContactSearchResponse.jsonBody ?? []).toList()
                as List;
        final newNumItems = nextPageMarker.numItems + pageItems.length;
        listViewContactsPagingController?.appendPage(
          pageItems,
          (pageItems.length > 0)
              ? ApiPagingParams(
                  nextPageNumber: nextPageMarker.nextPageNumber + 1,
                  numItems: newNumItems,
                  lastResponse: listViewContactsGetContactSearchResponse,
                )
              : null,
        );
      });
}
