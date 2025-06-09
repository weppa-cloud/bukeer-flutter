import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../../../auth/supabase_auth/auth_util.dart';
import '../../../../../../../backend/api_requests/api_calls.dart';
import '../../../../../../../flutter_flow/flutter_flow_animations.dart';
import '../../../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../../../../design_system/index.dart';
import '../../../../../../../custom_code/actions/index.dart' as actions;
import '../../../../../../../services/ui_state_service.dart';
import '../../../../../../../services/product_service.dart';
import '../../../../../../../services/contact_service.dart';
import '../../../../../../../services/itinerary_service.dart';
import '../../../../../../../services/account_service.dart';
import '../../../../../../../services/app_services.dart';
import '../../../../../../../bukeer/itinerarios/itinerary_details/itinerary_details_widget.dart';
import 'modal_add_edit_itinerary_model.dart';
import 'sections/index.dart';
import 'package:bukeer/design_system/tokens/index.dart';
export 'modal_add_edit_itinerary_model.dart';

class ModalAddEditItineraryWidgetRefactored extends StatefulWidget {
  final bool isEdit;
  final dynamic allDataItinerary;

  const ModalAddEditItineraryWidgetRefactored({
    super.key,
    bool? isEdit,
    this.allDataItinerary,
  }) : this.isEdit = isEdit ?? false;

  @override
  State<ModalAddEditItineraryWidgetRefactored> createState() =>
      _ModalAddEditItineraryWidgetRefactoredState();
}

class _ModalAddEditItineraryWidgetRefactoredState
    extends State<ModalAddEditItineraryWidgetRefactored>
    with TickerProviderStateMixin {
  late ModalAddEditItineraryModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalAddEditItineraryModel());

    // On component load action
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.responseGetImagesStorage = await actions.getImagesStorage();
      _model.images = _model.responseGetImagesStorage!.toList().cast<dynamic>();
      safeSetState(() {});
    });

    _initializeTextControllers();
    _setupAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void _initializeTextControllers() {
    _model.nameItineraryTextController ??= TextEditingController(
      text: widget.isEdit == true
          ? getJsonField(
              context.read<ItineraryService>().allDataItinerary,
              r'''$[:].name''',
            ).toString()
          : '',
    );
    _model.nameItineraryFocusNode ??= FocusNode();

    _model.messageActivityTextController ??= TextEditingController(text: () {
      if (widget.isEdit == false) {
        return '';
      } else if ('${getJsonField(
                context.read<ProductService>().allDataHotel,
                r'''$.personalized_message''',
              ).toString()}' !=
              null &&
          '${getJsonField(
                context.read<ProductService>().allDataHotel,
                r'''$.personalized_message''',
              ).toString()}' !=
              '') {
        return getJsonField(
          context.read<ItineraryService>().allDataItinerary,
          r'''$[:].personalized_message''',
        ).toString();
      } else {
        return '';
      }
    }());
    _model.messageActivityFocusNode ??= FocusNode();
  }

  void _setupAnimations() {
    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.0, 100.0),
            end: const Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (widget.isEdit) {
      await _handleEdit();
    } else {
      await _handleAdd();
    }
  }

  Future<void> _handleAdd() async {
    var shouldSetState = false;

    if ((_model.initialStartDate == null || _model.initialStartDate == '') ||
        (_model.initialEndDate == null || _model.initialEndDate == '') ||
        (_model.initialDate == null || _model.initialDate == '')) {
      await _showErrorDialog('Todos los campos son requeridos');
      return;
    }

    _model.responseFormAddItinerary = _validateForm();
    shouldSetState = true;

    if (_model.responseFormAddItinerary!) {
      _model.apiResponseCreateItineraryContact = await _createItinerary();
      shouldSetState = true;

      if ((_model.apiResponseCreateItineraryContact?.succeeded ?? true)) {
        _resetUIState();
        _navigateToItineraryDetails();
      } else {
        await _showErrorDialog('Todos los campos son requeridos');
      }
    } else {
      await _showErrorDialog('Todos los campos son requeridos.');
    }

    if (shouldSetState) safeSetState(() {});
  }

  Future<void> _handleEdit() async {
    var shouldSetState = false;

    _model.responseFormEditItinerary = _validateForm();
    shouldSetState = true;

    if (_model.responseFormEditItinerary!) {
      _model.responseUpdateItinerary = await _updateItinerary();
      shouldSetState = true;

      if ((_model.responseUpdateItinerary?.succeeded ?? true)) {
        _resetUIState();
        context.safePop();
      } else {
        await _showErrorDialog(
          (_model.responseUpdateItinerary?.jsonBody ?? '').toString(),
        );
      }
    } else {
      await _showErrorDialog('Todos los campos son requeridos');
    }

    if (shouldSetState) safeSetState(() {});
  }

  bool _validateForm() {
    if (_model.formKey.currentState == null ||
        !_model.formKey.currentState!.validate()) {
      return false;
    }
    return _model.languageValue != null &&
        _model.currencyTypeValue != null &&
        _model.requestTypeValue != null;
  }

  Future<ApiCallResponse> _createItinerary() async {
    final uiService = context.read<UiStateService>();

    return await CreateItineraryForContactCall.call(
      name: _model.nameItineraryTextController.text,
      startDate: _model.initialStartDate,
      endDate: _model.initialEndDate,
      passengerCount: _model.countControllerValue,
      validUntil: _model.initialDate,
      currencyType: _model.currencyTypeValue,
      language: _model.languageValue,
      requestType: _model.requestTypeValue,
      idCreatedBy: currentUserUid,
      agent: _model.selectedTravelPlannerId ?? currentUserUid,
      idContact: uiService.isCreatedInItinerary == true
          ? getJsonField(uiService.selectedContact, r'''$[:].id''').toString()
          : getJsonField(uiService.selectedContact, r'''$.id''').toString(),
      idFm: appServices.account.accountIdFm ?? '',
      accountId: appServices.account.accountId ?? '',
      authToken: currentJwtToken,
      currencyJson: appServices.account.accountCurrency ?? [],
      status: 'Presupuesto',
      typesIncreaseJson: appServices.account.accountTypesIncrease ?? [],
      personalizedMessage:
          _formatPersonalizedMessage(_model.messageActivityTextController.text),
      mainImage: _getMainImage(),
    );
  }

  Future<ApiCallResponse> _updateItinerary() async {
    final itineraryService = context.read<ItineraryService>();
    final uiService = context.read<UiStateService>();

    return await UpdateItineraryCall.call(
      authToken: currentJwtToken,
      name: _model.nameItineraryTextController.text,
      startDate: _model.initialStartDate ??
          getJsonField(
            itineraryService.allDataItinerary,
            r'''$[:].start_date''',
          ).toString(),
      passengerCount: _model.countControllerValue,
      endDate: _model.initialEndDate ??
          getJsonField(
            itineraryService.allDataItinerary,
            r'''$[:].end_date''',
          ).toString(),
      validUntil: _model.initialDate ??
          getJsonField(
            itineraryService.allDataItinerary,
            r'''$[:].valid_until''',
          ).toString(),
      language: _model.languageValue,
      requestType: _model.requestTypeValue,
      agent: _model.selectedTravelPlannerId ??
          getJsonField(
            itineraryService.allDataItinerary,
            r'''$[:].agent''',
          ).toString(),
      idCreatedBy: getJsonField(
        itineraryService.allDataItinerary,
        r'''$[:].id_created_by''',
      ).toString(),
      idContact: _getContactId(),
      id: getJsonField(
        itineraryService.allDataItinerary,
        r'''$[:].id''',
      ).toString(),
      currencyType: _model.currencyTypeValue,
      personalizedMessage:
          _formatPersonalizedMessage(_model.messageActivityTextController.text),
      mainImage: uiService.selectedImageUrl,
    );
  }

  String _formatPersonalizedMessage(String message) {
    return message.replaceAll('\n', '\\n');
  }

  String _getMainImage() {
    final selectedImage = context.read<UiStateService>().selectedImageUrl;
    return selectedImage?.isNotEmpty == true
        ? selectedImage!
        : 'https://images.unsplash.com/photo-1533699224246-6dc3b3ed3304?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyfHxjb2xvbWJpYXxlbnwwfHx8fDE3Mzc0MjQxNzF8MA&ixlib=rb-4.0.3&q=80&w=1080';
  }

  String _getContactId() {
    final uiService = context.read<UiStateService>();
    final itineraryService = context.read<ItineraryService>();

    if (uiService.isCreatedInItinerary == true) {
      return getJsonField(uiService.selectedContact, r'''$[:].id''').toString();
    } else if (uiService.selectedContact != null) {
      return getJsonField(uiService.selectedContact, r'''$.id''').toString();
    } else {
      return getJsonField(
              itineraryService.allDataItinerary, r'''$[:].id_contact''')
          .toString();
    }
  }

  void _resetUIState() {
    final uiService = context.read<UiStateService>();
    uiService.selectedContact = null;
    uiService.isCreatedInItinerary = false;
    safeSetState(() {});
  }

  void _navigateToItineraryDetails() {
    context.pushNamed(
      ItineraryDetailsWidget.routeName,
      pathParameters: {
        'id': serializeParam(
          getJsonField(
            (_model.apiResponseCreateItineraryContact?.jsonBody ?? ''),
            r'''$[:].itinerary_id''',
          ).toString(),
          ParamType.String,
        ),
      }.withoutNulls,
    );
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          title: const Text('Mensaje'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(alertDialogContext),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AccountService>();

    return Form(
      key: _model.formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Align(
        alignment: const AlignmentDirectional(0.0, 0.0),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 670.0,
            maxHeight: 700.0,
          ),
          decoration: BoxDecoration(
            color: BukeerColors.getBackground(context, secondary: true),
            boxShadow: [
              BoxShadow(
                blurRadius: 12.0,
                color: BukeerColors.overlay,
                offset: const Offset(0.0, 5.0),
              )
            ],
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeaderSection(isEdit: widget.isEdit),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 12.0, 16.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        BasicInfoSection(
                          isEdit: widget.isEdit,
                          allDataItinerary: widget.allDataItinerary,
                          nameController: _model.nameItineraryTextController!,
                          nameFocusNode: _model.nameItineraryFocusNode!,
                          nameValidator:
                              _model.nameItineraryTextControllerValidator,
                          languageValue:
                              _model.languageValue ?? _getDefaultLanguage(),
                          onLanguageChanged: (val) =>
                              safeSetState(() => _model.languageValue = val),
                          countControllerValue: _model.countControllerValue ??
                              _getDefaultPassengerCount(),
                          onCountChanged: (count) => safeSetState(
                              () => _model.countControllerValue = count),
                          onTravelPlannerChanged: (newAgentId) async {
                            _model.selectedTravelPlannerId = newAgentId;
                            safeSetState(() {});
                          },
                          currentTravelPlannerId: _getCurrentTravelPlannerId(),
                          onDateRangeSelected:
                              (startDateStr, endDateStr) async {
                            _model.initialStartDate = startDateStr;
                            _model.initialEndDate = endDateStr;
                            safeSetState(() {});
                          },
                          onValidUntilSelected: (date) async {
                            _model.initialDate = date;
                            safeSetState(() {});
                          },
                          initialStartDate: _getInitialStartDate(),
                          initialEndDate: _getInitialEndDate(),
                          validUntilDate: _getValidUntilDate(),
                        ),
                        TravelPlannerSection(
                          currencyTypeValue:
                              _model.currencyTypeValue ?? _getDefaultCurrency(),
                          onCurrencyChanged: (val) => safeSetState(
                              () => _model.currencyTypeValue = val),
                          requestTypeValue: _model.requestTypeValue ??
                              _getDefaultRequestType(),
                          onRequestChanged: (val) =>
                              safeSetState(() => _model.requestTypeValue = val),
                        ),
                        MessageSection(
                          messageController:
                              _model.messageActivityTextController!,
                          messageFocusNode: _model.messageActivityFocusNode!,
                          messageValidator:
                              _model.messageActivityTextControllerValidator,
                        ),
                        ImageSelectionSection(images: _model.images),
                      ],
                    ),
                  ),
                ),
              ),
              FooterSection(
                isEdit: widget.isEdit,
                onCancel: () => context.safePop(),
                onSave: _handleSave,
              ),
            ],
          ),
        ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
      ),
    );
  }

  String _getDefaultLanguage() {
    if (widget.isEdit == true) {
      return getJsonField(
        context.read<ItineraryService>().allDataItinerary,
        r'''$[:].language''',
      ).toString();
    }
    return 'Español';
  }

  int _getDefaultPassengerCount() {
    if (widget.isEdit == true) {
      return getJsonField(
        context.read<ItineraryService>().allDataItinerary,
        r'''$[:].passenger_count''',
      );
    }
    return 1;
  }

  String? _getCurrentTravelPlannerId() {
    if (widget.isEdit == true) {
      return getJsonField(
        context.read<ItineraryService>().allDataItinerary,
        r'''$[:].agent''',
      )?.toString();
    }
    return currentUserUid;
  }

  String _getDefaultCurrency() {
    if (widget.isEdit == true) {
      return getJsonField(
        context.read<ItineraryService>().selectedItinerary ?? {},
        r'''$[:].currency_type''',
      ).toString();
    }
    return getJsonField(
      appServices.account.accountCurrency?.firstOrNull ?? {},
      r'''$.name''',
    ).toString();
  }

  String _getDefaultRequestType() {
    if (widget.isEdit == true) {
      return getJsonField(
        context.read<ItineraryService>().allDataItinerary,
        r'''$[:].request_type''',
      ).toString();
    }
    return 'Econo';
  }

  String? _getInitialStartDate() {
    return getJsonField(
      context.read<ItineraryService>().allDataItinerary,
      r'''$[:].start_date''',
    )?.toString();
  }

  String? _getInitialEndDate() {
    return getJsonField(
      context.read<ItineraryService>().allDataItinerary,
      r'''$[:].end_date''',
    )?.toString();
  }

  String? _getValidUntilDate() {
    return getJsonField(
      context.read<ItineraryService>().allDataItinerary,
      r'''$[:].valid_until''',
    ).toString();
  }
}
