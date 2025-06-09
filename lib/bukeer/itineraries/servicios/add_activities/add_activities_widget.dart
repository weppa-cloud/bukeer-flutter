import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import '../../../../backend/api_requests/api_calls.dart';
import 'package:bukeer/backend/supabase/supabase.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/design_system/components/index.dart';
import '../../../core/widgets/forms/dropdowns/products/dropdown_products_widget.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_animations.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '../../../../custom_code/actions/index.dart' as actions;
import '../../../../custom_code/widgets/index.dart' as custom_widgets;
import 'package:bukeer/legacy/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_activities_model.dart';
import '../../../../services/ui_state_service.dart';
import '../../../../services/product_service.dart';
import '../../../../services/contact_service.dart';
import '../../../../services/app_services.dart';
export 'add_activities_model.dart';

class AddActivitiesWidget extends StatefulWidget {
  const AddActivitiesWidget({
    super.key,
    bool? isEdit,
    this.itineraryId,
  }) : this.isEdit = isEdit ?? false;

  final bool isEdit;
  final String? itineraryId;

  static String routeName = 'add_activities';
  static String routePath = 'addActivities';

  @override
  State<AddActivitiesWidget> createState() => _AddActivitiesWidgetState();
}

class _AddActivitiesWidgetState extends State<AddActivitiesWidget>
    with TickerProviderStateMixin {
  late AddActivitiesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddActivitiesModel());

    _model.quantityTextController ??= TextEditingController(
        text: valueOrDefault<String>(
      widget!.isEdit == true
          ? getJsonField(
              context.read<ProductService>().allDataActivity,
              r'''$.quantity''',
            ).toString().toString()
          : getJsonField(
              context.read<ContactService>().allDataContact,
              r'''$[:].passenger_count''',
            ).toString().toString(),
      '1',
    ));
    _model.quantityFocusNode ??= FocusNode();

    _model.unitCostTextController ??= TextEditingController(
        text: valueOrDefault<String>(
      widget!.isEdit == true
          ? getJsonField(
              context.read<ProductService>().allDataActivity,
              r'''$.unit_cost''',
            ).toString().toString()
          : _model.unitCost.toString(),
      'Costo',
    ));
    _model.unitCostFocusNode ??= FocusNode();

    _model.markupTextController ??= TextEditingController(
        text: valueOrDefault<String>(
      widget!.isEdit == true
          ? getJsonField(
              context.read<ProductService>().allDataActivity,
              r'''$.profit_percentage''',
            ).toString().toString()
          : _model.profitActivities.toString(),
      'Margen',
    ));
    _model.markupFocusNode ??= FocusNode();

    _model.totalCostTextController ??= TextEditingController(
        text: valueOrDefault<String>(
      widget!.isEdit == true
          ? functions.calculateTotalFunction(_model.unitCostTextController.text,
              _model.markupTextController.text)
          : _model.totalCost.toString(),
      'Total',
    ));
    _model.totalCostFocusNode ??= FocusNode();

    _model.messageActivityTextController ??= TextEditingController(text: () {
      if (widget!.isEdit == false) {
        return '';
      } else if ('${getJsonField(
                context.read<ProductService>().allDataActivity,
                r'''$.personalized_message''',
              ).toString().toString()}' !=
              null &&
          '${getJsonField(
                context.read<ProductService>().allDataActivity,
                r'''$.personalized_message''',
              ).toString().toString()}' !=
              '') {
        return getJsonField(
          context.read<ProductService>().allDataActivity,
          r'''$.personalized_message''',
        ).toString().toString();
      } else {
        return '';
      }
    }());
    _model.messageActivityFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
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
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
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

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<FFAppState>(); // Migrated to modern services

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: BukeerColors.getBackground(context),
          body: SafeArea(
            top: true,
            child: Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: EdgeInsets.all(BukeerSpacing.s),
                child: Material(
                  color: Colors.transparent,
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 600.0,
                      maxHeight: 700.0,
                    ),
                    decoration: BoxDecoration(
                      color:
                          BukeerColors.getBackground(context, secondary: true),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12.0,
                          color: Color(0x1E000000),
                          offset: Offset(
                            0.0,
                            5.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding: EdgeInsets.all(BukeerSpacing.m),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        Icons.volunteer_activism,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 28.0,
                                      ),
                                      if (widget!.isEdit == true)
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  2.0, 0.0, 2.0, 0.0),
                                          child: Text(
                                            'Editar',
                                            style: FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineMediumFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .headlineMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                      if (widget!.isEdit == false)
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  2.0, 0.0, 2.0, 0.0),
                                          child: Text(
                                            'Agregar actividad',
                                            style: FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineMediumFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .headlineMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                    ].divide(SizedBox(width: BukeerSpacing.s)),
                                  ),
                                ),
                                if (widget!.isEdit)
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 5.0, 5.0, 0.0),
                                    child: BukeerIconButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.trashAlt,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 24.0,
                                      ),
                                      size: BukeerIconButtonSize.medium,
                                      variant: BukeerIconButtonVariant.danger,
                                      onPressed: () async {
                                        var confirmDialogResponse =
                                            await showDialog<bool>(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: Text('Mensaje'),
                                                      content: Text(
                                                          '¿Está seguro que desea borrar este ítem?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext,
                                                                  false),
                                                          child:
                                                              Text('Cancelar'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext,
                                                                  true),
                                                          child:
                                                              Text('Confirmar'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ) ??
                                                false;
                                        if (confirmDialogResponse) {
                                          _model.responseActivityDeleted =
                                              await ItineraryItemsTable()
                                                  .delete(
                                            matchingRows: (rows) =>
                                                rows.eqOrNull(
                                              'id',
                                              getJsonField(
                                                context
                                                    .read<ProductService>()
                                                    .allDataActivity,
                                                r'''$.id''',
                                              ).toString(),
                                            ),
                                            returnRows: true,
                                          );
                                          Navigator.pop(context);
                                        }

                                        safeSetState(() {});
                                      },
                                    ),
                                  ),
                                if (widget!.isEdit)
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 5.0, 0.0, 0.0),
                                    child: BukeerIconButton(
                                      icon: Icon(
                                        Icons.content_copy,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 24.0,
                                      ),
                                      size: BukeerIconButtonSize.medium,
                                      variant: BukeerIconButtonVariant.outlined,
                                      onPressed: () async {
                                        var confirmDialogResponse =
                                            await showDialog<bool>(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: Text('Mensaje'),
                                                      content: Text(
                                                          '¿Estas seguro que vas a realizar una copia de este itinerario y sus items?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext,
                                                                  false),
                                                          child: Text('Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext,
                                                                  true),
                                                          child:
                                                              Text('Confirm'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ) ??
                                                false;
                                        if (confirmDialogResponse) {
                                          _model.apiResponseDuplicateItemActivity =
                                              await DuplicateItineraryItemCall
                                                  .call(
                                            originalId: getJsonField(
                                              context
                                                  .read<ProductService>()
                                                  .allDataActivity,
                                              r'''$.id''',
                                            ).toString(),
                                            authToken: currentJwtToken,
                                          );

                                          if ((_model
                                                  .apiResponseDuplicateItemActivity
                                                  ?.succeeded ??
                                              true)) {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: Text('Mensaje'),
                                                  content: Text(
                                                      'Actividad duplicada con éxito.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              alertDialogContext),
                                                      child: Text('Ok'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: Text('Mensaje'),
                                                  content: Text(
                                                      'Hubo un error al duplicar item.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              alertDialogContext),
                                                      child: Text('Ok'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        }

                                        safeSetState(() {});
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 0.0,
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    direction: Axis.horizontal,
                                    runAlignment: WrapAlignment.start,
                                    verticalDirection: VerticalDirection.down,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 245.0,
                                        child: Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          height: 70.0,
                                          child: custom_widgets
                                              .CustomDatePickerWidget(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                1.0,
                                            height: 70.0,
                                            initialStartDate: widget!.isEdit
                                                ? getJsonField(
                                                    context
                                                        .read<ProductService>()
                                                        .allDataActivity,
                                                    r'''$.date''',
                                                  ).toString()
                                                : getJsonField(
                                                    context
                                                        .read<ContactService>()
                                                        .allDataContact,
                                                    r'''$[:].start_date''',
                                                  ).toString(),
                                            labelText: 'Fecha',
                                            isRangePicker: false,
                                            onRangeSelected: (startDateStr,
                                                endDateStr) async {},
                                            onDateSelected: (date) async {
                                              _model.initialDate = date;
                                              safeSetState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 90.0,
                                        child: TextFormField(
                                          controller:
                                              _model.quantityTextController,
                                          focusNode: _model.quantityFocusNode,
                                          onChanged: (_) =>
                                              EasyDebounce.debounce(
                                            '_model.quantityTextController',
                                            Duration(milliseconds: 2000),
                                            () async {
                                              _model.totalCost =
                                                  valueOrDefault<double>(
                                                double.parse(_model
                                                        .quantityTextController
                                                        .text) *
                                                    double.parse(_model
                                                        .totalCostTextController
                                                        .text),
                                                0.0,
                                              );
                                              safeSetState(() {});
                                            },
                                          ),
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Cantidad',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMediumFamily,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMediumIsCustom,
                                                    ),
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMediumFamily,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMediumIsCustom,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      BukeerSpacing.s),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 20.0, 20.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                fontSize: BukeerTypography
                                                    .bodySmallSize,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          maxLines: null,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          validator: _model
                                              .quantityTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        enableDrag: false,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: DropdownProductsWidget(
                                                productType: 'activities',
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 100),
                                      curve: Curves.easeInOut,
                                      width: MediaQuery.sizeOf(context).width *
                                          1.0,
                                      constraints: BoxConstraints(
                                        minHeight: 70.0,
                                        maxWidth: 770.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 3.0,
                                            color: BukeerColors.overlay,
                                            offset: Offset(
                                              0.0,
                                              1.0,
                                            ),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(
                                            BukeerSpacing.s),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(BukeerSpacing.s),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: 44.0,
                                              height: 44.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent1,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        BukeerSpacing.s),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    BukeerSpacing.xs),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Image.network(
                                                    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxiZWFjaHxlbnwwfHx8fDE3MzAxNjgxMTV8MA&ixlib=rb-4.0.3&q=80&w=1080',
                                                    width: 60.0,
                                                    height: 60.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        widget!.isEdit == true
                                                            ? (context
                                                                        .read<
                                                                            UiStateService>()
                                                                        .itemsProducts !=
                                                                    null
                                                                ? getJsonField(
                                                                    context
                                                                        .read<
                                                                            UiStateService>()
                                                                        .itemsProducts,
                                                                    r'''$.name''',
                                                                  ).toString()
                                                                : getJsonField(
                                                                    context
                                                                        .read<
                                                                            ProductService>()
                                                                        .allDataActivity,
                                                                    r'''$.product_name''',
                                                                  ).toString())
                                                            : valueOrDefault<
                                                                String>(
                                                                getJsonField(
                                                                  context
                                                                      .read<
                                                                          UiStateService>()
                                                                      .itemsProducts,
                                                                  r'''$.name''',
                                                                )?.toString(),
                                                                'Seleccionar',
                                                              ),
                                                        'Seleccionar',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 4.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      'Actividad',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Card(
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              elevation: 1.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    BukeerSpacing.xs),
                                                child: Icon(
                                                  Icons.chevron_right_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                      'containerOnPageLoadAnimation2']!),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if ((context
                                                  .read<UiStateService>()
                                                  .itemsProducts !=
                                              null) ||
                                          (widget!.isEdit == true))
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context
                                                .read<UiStateService>()
                                                .selectRates = true;
                                            safeSetState(() {});
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 100),
                                            curve: Curves.easeInOut,
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                1.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 3.0,
                                                  color: BukeerColors.overlay,
                                                  offset: Offset(
                                                    0.0,
                                                    1.0,
                                                  ),
                                                )
                                              ],
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                bottomRight:
                                                    Radius.circular(0.0),
                                                topLeft: Radius.circular(12.0),
                                                topRight: Radius.circular(12.0),
                                              ),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  BukeerSpacing.s),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      12.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            valueOrDefault<
                                                                String>(
                                                              widget!.isEdit ==
                                                                      true
                                                                  ? (_model.itemsActivitiesRates !=
                                                                          null
                                                                      ? getJsonField(
                                                                          _model
                                                                              .itemsActivitiesRates,
                                                                          r'''$.name''',
                                                                        )
                                                                          .toString()
                                                                      : getJsonField(
                                                                          context
                                                                              .read<ProductService>()
                                                                              .allDataActivity,
                                                                          r'''$.rate_name''',
                                                                        )
                                                                          .toString())
                                                                  : valueOrDefault<
                                                                      String>(
                                                                      getJsonField(
                                                                        _model
                                                                            .itemsActivitiesRates,
                                                                        r'''$.name''',
                                                                      )?.toString(),
                                                                      'Seleccionar',
                                                                    ),
                                                              'Seleccionar',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLargeFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLargeIsCustom,
                                                                ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      12.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            'Tarifa',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMediumIsCustom,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Card(
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    elevation: 1.0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            if (_model
                                                                    .selectRates ==
                                                                false)
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            4.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .chevron_right_rounded,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  size: 24.0,
                                                                ),
                                                              ),
                                                            if (_model
                                                                    .selectRates ==
                                                                true)
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            10.0,
                                                                            8.0,
                                                                            6.0),
                                                                child: FaIcon(
                                                                  FontAwesomeIcons
                                                                      .angleDown,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  size: 16.0,
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ).animateOnPageLoad(animationsMap[
                                            'containerOnPageLoadAnimation3']!),
                                      if (context
                                              .read<UiStateService>()
                                              .selectRates ==
                                          true)
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 0.0, 4.0, 0.0),
                                          child: Material(
                                            color: Colors.transparent,
                                            elevation: 3.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(12.0),
                                                bottomRight:
                                                    Radius.circular(12.0),
                                                topLeft: Radius.circular(0.0),
                                                topRight: Radius.circular(0.0),
                                              ),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(12.0),
                                                  bottomRight:
                                                      Radius.circular(12.0),
                                                  topLeft: Radius.circular(0.0),
                                                  topRight:
                                                      Radius.circular(0.0),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(8.0, 8.0,
                                                                8.0, 4.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            'Seleccionar tarifa',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMediumFamily,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineMediumIsCustom,
                                                                ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            _model.selectRates =
                                                                false;
                                                            safeSetState(() {});
                                                          },
                                                          child: Card(
                                                            clipBehavior: Clip
                                                                .antiAliasWithSaveLayer,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryBackground,
                                                            elevation: 1.0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40.0),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                Icons
                                                                    .close_sharp,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 18.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ].divide(SizedBox(
                                                          width:
                                                              BukeerSpacing.s)),
                                                    ),
                                                  ),
                                                  Divider(
                                                    height: 1.0,
                                                    thickness: 1.0,
                                                    indent: 0.0,
                                                    endIndent: 0.0,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                  ),
                                                  FutureBuilder<
                                                      ApiCallResponse>(
                                                    future:
                                                        GetActivitiesRatesCall
                                                            .call(
                                                      idProduct: widget!
                                                                  .isEdit ==
                                                              true
                                                          ? (context
                                                                      .read<
                                                                          UiStateService>()
                                                                      .itemsProducts !=
                                                                  null
                                                              ? getJsonField(
                                                                  context
                                                                      .read<
                                                                          UiStateService>()
                                                                      .itemsProducts,
                                                                  r'''$.id''',
                                                                ).toString()
                                                              : getJsonField(
                                                                  context
                                                                      .read<
                                                                          ProductService>()
                                                                      .allDataActivity,
                                                                  r'''$.id_product''',
                                                                ).toString())
                                                          : getJsonField(
                                                              context
                                                                  .read<
                                                                      UiStateService>()
                                                                  .itemsProducts,
                                                              r'''$.id''',
                                                            ).toString(),
                                                      authToken:
                                                          currentJwtToken,
                                                    ),
                                                    builder:
                                                        (context, snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: SizedBox(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            child:
                                                                CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                      Color>(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      final listViewGetActivitiesRatesResponse =
                                                          snapshot.data!;

                                                      return Builder(
                                                        builder: (context) {
                                                          final activityRatesItem =
                                                              listViewGetActivitiesRatesResponse
                                                                  .jsonBody
                                                                  .toList();

                                                          return ListView
                                                              .separated(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            primary: false,
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            itemCount:
                                                                activityRatesItem
                                                                    .length,
                                                            separatorBuilder:
                                                                (_, __) =>
                                                                    SizedBox(
                                                                        height:
                                                                            2.0),
                                                            itemBuilder: (context,
                                                                activityRatesItemIndex) {
                                                              final activityRatesItemItem =
                                                                  activityRatesItem[
                                                                      activityRatesItemIndex];
                                                              return InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  _model.itemsActivitiesRates =
                                                                      activityRatesItemItem;
                                                                  _model.profitActivities =
                                                                      getJsonField(
                                                                    activityRatesItemItem,
                                                                    r'''$.profit''',
                                                                  );
                                                                  _model.unitCost =
                                                                      getJsonField(
                                                                    activityRatesItemItem,
                                                                    r'''$.unit_cost''',
                                                                  );
                                                                  _model.totalCost =
                                                                      getJsonField(
                                                                    activityRatesItemItem,
                                                                    r'''$.price''',
                                                                  );
                                                                  await Future
                                                                      .wait([
                                                                    Future(
                                                                        () async {
                                                                      safeSetState(
                                                                          () {
                                                                        _model.unitCostTextController?.text = _model
                                                                            .unitCost
                                                                            .toString();
                                                                      });
                                                                    }),
                                                                    Future(
                                                                        () async {
                                                                      safeSetState(
                                                                          () {
                                                                        _model.markupTextController?.text = _model
                                                                            .profitActivities
                                                                            .toString();
                                                                      });
                                                                    }),
                                                                    Future(
                                                                        () async {
                                                                      safeSetState(
                                                                          () {
                                                                        _model.totalCostTextController?.text = _model
                                                                            .totalCost
                                                                            .toString();
                                                                      });
                                                                    }),
                                                                  ]);
                                                                  context
                                                                      .read<
                                                                          UiStateService>()
                                                                      .selectRates = false;
                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            8.0,
                                                                            8.0,
                                                                            8.0,
                                                                            8.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Text(
                                                                                    valueOrDefault<String>(
                                                                                      getJsonField(
                                                                                        activityRatesItemItem,
                                                                                        r'''$.name''',
                                                                                      )?.toString(),
                                                                                      'Nombre',
                                                                                    ),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          letterSpacing: 0.0,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Text(
                                                                                      valueOrDefault<String>(
                                                                                        '\$${getJsonField(
                                                                                          activityRatesItemItem,
                                                                                          r'''$.price''',
                                                                                        ).toString()}',
                                                                                        'Precio',
                                                                                      ),
                                                                                      textAlign: TextAlign.end,
                                                                                      style: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                            color: BukeerColors.primary,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Align(
                                                                              alignment: AlignmentDirectional(1.0, 0.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(bottom: BukeerSpacing.xs),
                                                                                child: Wrap(
                                                                                  spacing: 8.0,
                                                                                  runSpacing: 0.0,
                                                                                  alignment: WrapAlignment.start,
                                                                                  crossAxisAlignment: WrapCrossAlignment.start,
                                                                                  direction: Axis.horizontal,
                                                                                  runAlignment: WrapAlignment.start,
                                                                                  verticalDirection: VerticalDirection.down,
                                                                                  clipBehavior: Clip.none,
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                          child: Text(
                                                                                            'Markup',
                                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 0.0, 0.0),
                                                                                          child: Text(
                                                                                            '${getJsonField(
                                                                                              activityRatesItemItem,
                                                                                              r'''$.profit''',
                                                                                            ).toString()}%',
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                  color: BukeerColors.primaryText,
                                                                                                  fontSize: BukeerTypography.captionSize,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: EdgeInsets.only(right: BukeerSpacing.xs),
                                                                                          child: Text(
                                                                                            'Tarifa neta',
                                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                                  letterSpacing: 0.0,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 0.0, 0.0),
                                                                                          child: Text(
                                                                                            '\$${valueOrDefault<String>(
                                                                                              getJsonField(
                                                                                                activityRatesItemItem,
                                                                                                r'''$.unit_cost''',
                                                                                              )?.toString(),
                                                                                              'costo unico',
                                                                                            )}',
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                  fontSize: BukeerTypography.captionSize,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          4.0,
                                                                          0.0),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_forward_ios,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        size:
                                                                            16.0,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 8.0, 0.0, 8.0),
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 100),
                                      curve: Curves.easeInOut,
                                      width: MediaQuery.sizeOf(context).width *
                                          1.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 3.0,
                                            color: BukeerColors.overlay,
                                            offset: Offset(
                                              0.0,
                                              1.0,
                                            ),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(
                                            BukeerSpacing.s),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Visibility(
                                        visible: (_model.itemsActivitiesRates !=
                                                null) ||
                                            (widget!.isEdit == true),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 20.0, 0.0, 12.0),
                                          child: Wrap(
                                            spacing: 12.0,
                                            runSpacing: 8.0,
                                            alignment: WrapAlignment.center,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.start,
                                            direction: Axis.horizontal,
                                            runAlignment: WrapAlignment.start,
                                            verticalDirection:
                                                VerticalDirection.down,
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                width: 190.0,
                                                child: TextFormField(
                                                  controller: _model
                                                      .unitCostTextController,
                                                  focusNode:
                                                      _model.unitCostFocusNode,
                                                  onChanged: (_) =>
                                                      EasyDebounce.debounce(
                                                    '_model.unitCostTextController',
                                                    Duration(
                                                        milliseconds: 2000),
                                                    () async {
                                                      _model.responseTotal =
                                                          await actions
                                                              .calculateTotal(
                                                        _model
                                                            .unitCostTextController
                                                            .text,
                                                        _model
                                                            .markupTextController
                                                            .text,
                                                      );
                                                      safeSetState(() {
                                                        _model.totalCostTextController
                                                                ?.text =
                                                            _model
                                                                .responseTotal!;
                                                      });
                                                      _model.totalCost =
                                                          valueOrDefault<
                                                              double>(
                                                        double.parse(_model
                                                                .quantityTextController
                                                                .text) *
                                                            double.parse(_model
                                                                .totalCostTextController
                                                                .text),
                                                        0.0,
                                                      );
                                                      safeSetState(() {});

                                                      safeSetState(() {});
                                                    },
                                                  ),
                                                  autofocus: false,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelText: 'Tarifa neta',
                                                    labelStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                              letterSpacing:
                                                                  0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumIsCustom,
                                                            ),
                                                    hintStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                              letterSpacing:
                                                                  0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumIsCustom,
                                                            ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              BukeerSpacing.sm),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              BukeerSpacing.sm),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              BukeerSpacing.sm),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              BukeerSpacing.sm),
                                                    ),
                                                    filled: true,
                                                    fillColor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                    contentPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                20.0,
                                                                24.0,
                                                                20.0,
                                                                24.0),
                                                  ),
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                  cursorColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  validator: _model
                                                      .unitCostTextControllerValidator
                                                      .asValidator(context),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            '^[0-9]*([\\\\.][0-9]{0,2})?\$'))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 100.0,
                                                child: TextFormField(
                                                  controller: _model
                                                      .markupTextController,
                                                  focusNode:
                                                      _model.markupFocusNode,
                                                  onChanged: (_) =>
                                                      EasyDebounce.debounce(
                                                    '_model.markupTextController',
                                                    Duration(
                                                        milliseconds: 2000),
                                                    () async {
                                                      _model.responseTotal2 =
                                                          await actions
                                                              .calculateTotal(
                                                        _model
                                                            .unitCostTextController
                                                            .text,
                                                        _model
                                                            .markupTextController
                                                            .text,
                                                      );
                                                      safeSetState(() {
                                                        _model.totalCostTextController
                                                                ?.text =
                                                            _model
                                                                .responseTotal2!;
                                                      });
                                                      _model.totalCost =
                                                          valueOrDefault<
                                                              double>(
                                                        double.parse(_model
                                                                .quantityTextController
                                                                .text) *
                                                            double.parse(_model
                                                                .totalCostTextController
                                                                .text),
                                                        0.0,
                                                      );
                                                      safeSetState(() {});

                                                      safeSetState(() {});
                                                    },
                                                  ),
                                                  autofocus: false,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelText: 'Markup %',
                                                    labelStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                              letterSpacing:
                                                                  0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumIsCustom,
                                                            ),
                                                    hintStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                              letterSpacing:
                                                                  0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumIsCustom,
                                                            ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              BukeerSpacing.sm),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              BukeerSpacing.sm),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              BukeerSpacing.sm),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              BukeerSpacing.sm),
                                                    ),
                                                    filled: true,
                                                    fillColor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                    contentPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                20.0,
                                                                24.0,
                                                                20.0,
                                                                24.0),
                                                  ),
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                  cursorColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  validator: _model
                                                      .markupTextControllerValidator
                                                      .asValidator(context),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            '^[0-9]*([\\\\.][0-9]*)?\$'))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 190.0,
                                                child: TextFormField(
                                                  controller: _model
                                                      .totalCostTextController,
                                                  focusNode:
                                                      _model.totalCostFocusNode,
                                                  onChanged: (_) =>
                                                      EasyDebounce.debounce(
                                                    '_model.totalCostTextController',
                                                    Duration(
                                                        milliseconds: 2000),
                                                    () async {
                                                      _model.responseProfit2 =
                                                          await actions
                                                              .calculateProfit(
                                                        _model
                                                            .unitCostTextController
                                                            .text,
                                                        _model
                                                            .totalCostTextController
                                                            .text,
                                                      );
                                                      safeSetState(() {
                                                        _model.markupTextController
                                                                ?.text =
                                                            _model
                                                                .responseProfit2!;
                                                      });
                                                      _model.totalCost =
                                                          valueOrDefault<
                                                              double>(
                                                        double.parse(_model
                                                                .quantityTextController
                                                                .text) *
                                                            double.parse(_model
                                                                .totalCostTextController
                                                                .text),
                                                        0.0,
                                                      );
                                                      safeSetState(() {});

                                                      safeSetState(() {});
                                                    },
                                                  ),
                                                  autofocus: false,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelText: 'Valor  Total',
                                                    labelStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                              letterSpacing:
                                                                  0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumIsCustom,
                                                            ),
                                                    hintStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                              letterSpacing:
                                                                  0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumIsCustom,
                                                            ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              BukeerSpacing.sm),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              BukeerSpacing.sm),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              BukeerSpacing.sm),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              BukeerSpacing.sm),
                                                    ),
                                                    filled: true,
                                                    fillColor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                    contentPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                20.0,
                                                                24.0,
                                                                20.0,
                                                                24.0),
                                                  ),
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                  cursorColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  validator: _model
                                                      .totalCostTextControllerValidator
                                                      .asValidator(context),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            '^[0-9]*([\\\\.][0-9]{0,2})?\$'))
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Total',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineSmallFamily,
                                                          fontSize:
                                                              BukeerTypography
                                                                  .bodyMediumSize,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineSmallIsCustom,
                                                        ),
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        '\$',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLargeFamily,
                                                                  fontSize:
                                                                      BukeerTypography
                                                                          .headlineSmallSize,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLargeIsCustom,
                                                                ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    8.0,
                                                                    0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            formatNumber(
                                                              valueOrDefault<
                                                                      double>(
                                                                    double.tryParse(_model
                                                                        .totalCostTextController
                                                                        .text),
                                                                    0.0,
                                                                  ) *
                                                                  valueOrDefault<
                                                                      int>(
                                                                    int.tryParse(_model
                                                                        .quantityTextController
                                                                        .text),
                                                                    0,
                                                                  ),
                                                              formatType:
                                                                  FormatType
                                                                      .decimal,
                                                              decimalType:
                                                                  DecimalType
                                                                      .commaDecimal,
                                                            ),
                                                            '0',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                                fontSize:
                                                                    BukeerTypography
                                                                        .headlineSmallSize,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLargeIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(
                                                    width: BukeerSpacing.s)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 5.0, 24.0, 5.0),
                                    child: Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: _model
                                            .messageActivityTextController,
                                        focusNode:
                                            _model.messageActivityFocusNode,
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Mensaje destacado',
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .labelMediumIsCustom,
                                              ),
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .labelMediumIsCustom,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                BukeerSpacing.s),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                BukeerSpacing.s),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                BukeerSpacing.s),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                BukeerSpacing.s),
                                          ),
                                          filled: true,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          contentPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20.0, 24.0, 20.0, 24.0),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        maxLines: null,
                                        minLines: 3,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        validator: _model
                                            .messageActivityTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                ]
                                    .divide(SizedBox(height: BukeerSpacing.s))
                                    .addToStart(
                                        SizedBox(height: BukeerSpacing.s)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.05),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      context
                                          .read<UiStateService>()
                                          .itemsProducts = null;
                                      context
                                          .read<ProductService>()
                                          .allDataActivity = null;
                                      safeSetState(() {});
                                      Navigator.pop(context);
                                    },
                                    text: 'Cancelar',
                                    options: FFButtonOptions(
                                      height: 44.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                      elevation: 0.0,
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          BukeerSpacing.s),
                                      hoverColor: FlutterFlowTheme.of(context)
                                          .alternate,
                                      hoverBorderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                      hoverTextColor:
                                          FlutterFlowTheme.of(context)
                                              .primaryText,
                                      hoverElevation: 3.0,
                                    ),
                                  ),
                                ),
                                if (widget!.isEdit == false)
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.05),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        if ((_model.unitCostTextController
                                                        .text !=
                                                    null &&
                                                _model.unitCostTextController
                                                        .text !=
                                                    '') &&
                                            (_model.markupTextController.text !=
                                                    null &&
                                                _model.markupTextController
                                                        .text !=
                                                    '') &&
                                            (_model.totalCostTextController
                                                        .text !=
                                                    null &&
                                                _model.totalCostTextController
                                                        .text !=
                                                    '') &&
                                            (_model.quantityTextController
                                                        .text !=
                                                    null &&
                                                _model.quantityTextController
                                                        .text !=
                                                    '')) {
                                          _model.apiResponseAddItineraryItem =
                                              await AddItineraryItemsCall.call(
                                            quantity: int.tryParse(_model
                                                .quantityTextController.text),
                                            authToken: currentJwtToken,
                                            idProduct: getJsonField(
                                              context
                                                  .read<UiStateService>()
                                                  .itemsProducts,
                                              r'''$.id''',
                                            ).toString(),
                                            productType: 'Servicios',
                                            destination: getJsonField(
                                              context
                                                  .read<UiStateService>()
                                                  .itemsProducts,
                                              r'''$.city''',
                                            ).toString(),
                                            productName: getJsonField(
                                              context
                                                  .read<UiStateService>()
                                                  .itemsProducts,
                                              r'''$.name''',
                                            ).toString(),
                                            rateName: getJsonField(
                                              _model.itemsActivitiesRates,
                                              r'''$.name''',
                                            ).toString(),
                                            profitPercentage: double.tryParse(
                                                _model
                                                    .markupTextController.text),
                                            unitCost: double.tryParse(_model
                                                .unitCostTextController.text),
                                            date: _model.initialDate != null &&
                                                    _model.initialDate != ''
                                                ? _model.initialDate
                                                : getJsonField(
                                                    context
                                                        .read<ContactService>()
                                                        .allDataContact,
                                                    r'''$[:].start_date''',
                                                  ).toString(),
                                            idItinerary: widget!.itineraryId,
                                            totalPrice: valueOrDefault<double>(
                                              double.parse(functions
                                                      .calculateTotalFunction(
                                                          _model
                                                              .unitCostTextController
                                                              .text,
                                                          _model
                                                              .markupTextController
                                                              .text)) *
                                                  int.parse(_model
                                                      .quantityTextController
                                                      .text),
                                              0.0,
                                            ),
                                            accountId: currentUserUid,
                                            personalizedMessage: (String
                                                personalizedMessage) {
                                              return personalizedMessage
                                                  .replaceAll('\n', '\\n');
                                            }(_model
                                                .messageActivityTextController
                                                .text),
                                          );

                                          if ((_model
                                                  .apiResponseAddItineraryItem
                                                  ?.succeeded ??
                                              true)) {
                                            context
                                                .read<UiStateService>()
                                                .itemsProducts = null;
                                            context
                                                .read<ProductService>()
                                                .allDataActivity = null;
                                            safeSetState(() {});
                                            _model.totalCost = 0.0;
                                            _model.unitCost = 0.0;
                                            _model.profitActivities = 0.0;
                                            _model.itemsActivitiesRates = null;
                                            safeSetState(() {});
                                            context.safePop();
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: Text('Mensaje'),
                                                  content: Text(
                                                      'Todos los campos son obligatorios'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              alertDialogContext),
                                                      child: Text('Ok'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Mensaje'),
                                                content: Text(
                                                    'Todos los campos son obligatorios.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }

                                        safeSetState(() {});
                                      },
                                      text: 'Agregar',
                                      options: FFButtonOptions(
                                        height: 44.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmallFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .titleSmallIsCustom,
                                            ),
                                        elevation: 3.0,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            BukeerSpacing.s),
                                        hoverColor: FlutterFlowTheme.of(context)
                                            .accent1,
                                        hoverBorderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        hoverTextColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                        hoverElevation: 0.0,
                                      ),
                                    ),
                                  ),
                                if (widget!.isEdit == true)
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.05),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        if ((_model.unitCostTextController
                                                        .text !=
                                                    null &&
                                                _model.unitCostTextController
                                                        .text !=
                                                    '') &&
                                            (_model.markupTextController.text !=
                                                    null &&
                                                _model.markupTextController
                                                        .text !=
                                                    '') &&
                                            (_model.totalCostTextController
                                                        .text !=
                                                    null &&
                                                _model.totalCostTextController
                                                        .text !=
                                                    '') &&
                                            (_model.quantityTextController
                                                        .text !=
                                                    null &&
                                                _model.quantityTextController
                                                        .text !=
                                                    '')) {
                                          _model.apiResponseUpdateItineraryItem =
                                              await UpdateItineraryItemsCall
                                                  .call(
                                            authToken: currentJwtToken,
                                            id: getJsonField(
                                              context
                                                  .read<ProductService>()
                                                  .allDataActivity,
                                              r'''$.id''',
                                            ).toString(),
                                            unitCost: double.tryParse(_model
                                                .unitCostTextController.text),
                                            quantity: int.tryParse(_model
                                                .quantityTextController.text),
                                            date: _model.initialDate != null &&
                                                    _model.initialDate != ''
                                                ? _model.initialDate
                                                : getJsonField(
                                                    context
                                                        .read<ProductService>()
                                                        .allDataActivity,
                                                    r'''$.date''',
                                                  ).toString(),
                                            profitPercentage: double.tryParse(
                                                _model
                                                    .markupTextController.text),
                                            idProduct: context
                                                        .read<UiStateService>()
                                                        .itemsProducts !=
                                                    null
                                                ? getJsonField(
                                                    context
                                                        .read<UiStateService>()
                                                        .itemsProducts,
                                                    r'''$.id''',
                                                  ).toString()
                                                : getJsonField(
                                                    context
                                                        .read<ProductService>()
                                                        .allDataActivity,
                                                    r'''$.id_product''',
                                                  ).toString(),
                                            totalPrice: valueOrDefault<double>(
                                              double.parse(functions
                                                      .calculateTotalFunction(
                                                          _model
                                                              .unitCostTextController
                                                              .text,
                                                          _model
                                                              .markupTextController
                                                              .text)) *
                                                  int.parse(_model
                                                      .quantityTextController
                                                      .text),
                                              0.0,
                                            ),
                                            productType: 'Servicios',
                                            destination: context
                                                        .read<UiStateService>()
                                                        .itemsProducts !=
                                                    null
                                                ? getJsonField(
                                                    context
                                                        .read<UiStateService>()
                                                        .itemsProducts,
                                                    r'''$.city''',
                                                  ).toString()
                                                : getJsonField(
                                                    context
                                                        .read<ProductService>()
                                                        .allDataActivity,
                                                    r'''$.destination''',
                                                  ).toString(),
                                            rateName: _model
                                                        .itemsActivitiesRates !=
                                                    null
                                                ? getJsonField(
                                                    _model.itemsActivitiesRates,
                                                    r'''$.name''',
                                                  ).toString()
                                                : getJsonField(
                                                    context
                                                        .read<ProductService>()
                                                        .allDataActivity,
                                                    r'''$.rate_name''',
                                                  ).toString(),
                                            productName: context
                                                        .read<UiStateService>()
                                                        .itemsProducts !=
                                                    null
                                                ? getJsonField(
                                                    context
                                                        .read<UiStateService>()
                                                        .itemsProducts,
                                                    r'''$.name''',
                                                  ).toString()
                                                : getJsonField(
                                                    context
                                                        .read<ProductService>()
                                                        .allDataActivity,
                                                    r'''$.product_name''',
                                                  ).toString(),
                                            personalizedMessage: (String
                                                personalizedMessage) {
                                              return personalizedMessage
                                                  .replaceAll('\n', '\\n');
                                            }(_model
                                                .messageActivityTextController
                                                .text),
                                          );

                                          if ((_model
                                                  .apiResponseUpdateItineraryItem
                                                  ?.succeeded ??
                                              true)) {
                                            context
                                                .read<UiStateService>()
                                                .itemsProducts = null;
                                            context
                                                .read<ProductService>()
                                                .allDataActivity = null;
                                            safeSetState(() {});
                                            _model.itemsActivitiesRates = null;
                                            _model.unitCost = 0.0;
                                            _model.totalCost = 0.0;
                                            _model.profitActivities = 0.0;
                                            safeSetState(() {});
                                            context.safePop();
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: Text('Mensaje'),
                                                  content: Text(
                                                      'Ocurrio un error inesperado.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              alertDialogContext),
                                                      child: Text('Ok'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                content: Text(
                                                    'Todos los campos son obligatorios'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }

                                        safeSetState(() {});
                                      },
                                      text: 'Guardar',
                                      options: FFButtonOptions(
                                        height: 44.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmallFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .titleSmallIsCustom,
                                            ),
                                        elevation: 3.0,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            BukeerSpacing.s),
                                        hoverColor: FlutterFlowTheme.of(context)
                                            .accent1,
                                        hoverBorderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        hoverTextColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                        hoverElevation: 0.0,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ].divide(SizedBox(height: BukeerSpacing.s)),
                      ),
                    ),
                  ),
                ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation1']!),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
