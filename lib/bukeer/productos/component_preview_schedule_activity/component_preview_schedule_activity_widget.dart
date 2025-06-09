import '../component_add_schedule_activity/component_add_schedule_activity_widget.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '../../../custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'component_preview_schedule_activity_model.dart';
import 'package:bukeer/design_system/tokens/index.dart';
export 'component_preview_schedule_activity_model.dart';

class ComponentPreviewScheduleActivityWidget extends StatefulWidget {
  const ComponentPreviewScheduleActivityWidget({
    super.key,
    required this.title,
    this.description,
    this.image,
    required this.idProduct,
    this.idSchedule,
  });

  final String? title;
  final String? description;
  final String? image;
  final String? idProduct;
  final String? idSchedule;

  @override
  State<ComponentPreviewScheduleActivityWidget> createState() =>
      _ComponentPreviewScheduleActivityWidgetState();
}

class _ComponentPreviewScheduleActivityWidgetState
    extends State<ComponentPreviewScheduleActivityWidget> {
  late ComponentPreviewScheduleActivityModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => ComponentPreviewScheduleActivityModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 852.0,
      ),
      decoration: BoxDecoration(
        color: BukeerColors.getBackground(context, secondary: true),
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: BukeerSpacing.s),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 110.0,
              height: 110.0,
              decoration: BoxDecoration(
                color: BukeerColors.getBackground(context),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(BukeerSpacing.s),
                child: Image.network(
                  valueOrDefault<String>(
                    widget!.image,
                    'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: BukeerSpacing.s),
                    child: Text(
                      valueOrDefault<String>(
                        widget!.title,
                        'Title',
                      ),
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).labelMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .labelMediumIsCustom,
                          ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    decoration: BoxDecoration(),
                    child: Text(
                      widget!.description!,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodySmallFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts:
                                !FlutterFlowTheme.of(context).bodySmallIsCustom,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BukeerIconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.edit,
                    color: BukeerColors.primaryText,
                    size: 16.0,
                  ),
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: ComponentAddScheduleActivityWidget(
                            idProduct: widget!.idProduct!,
                            isEdit: true,
                            title: widget!.title,
                            description: widget!.description,
                            image: '',
                            idSchedule: widget!.idSchedule,
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                ),
                BukeerIconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: BukeerColors.primaryText,
                    size: 20.0,
                  ),
                  onPressed: () async {
                    var confirmDialogResponse = await showDialog<bool>(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: Text('Mensaje'),
                              content: Text(
                                  '¿Estás seguro que quieres eliminar este ítem?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext, false),
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext, true),
                                  child: Text('Confirmar'),
                                ),
                              ],
                            );
                          },
                        ) ??
                        false;
                    if (confirmDialogResponse) {
                      _model.responseDeleteSchedule =
                          await actions.deleteScheduleActivity(
                        widget!.idProduct!,
                        widget!.idSchedule!,
                      );
                    }

                    safeSetState(() {});
                  },
                ),
              ]
                  .divide(SizedBox(height: BukeerSpacing.s))
                  .addToStart(SizedBox(height: BukeerSpacing.s))
                  .addToEnd(SizedBox(height: BukeerSpacing.s)),
            ),
          ]
              .divide(SizedBox(width: BukeerSpacing.s))
              .addToStart(SizedBox(width: BukeerSpacing.s))
              .addToEnd(SizedBox(width: BukeerSpacing.s)),
        ),
      ),
    );
  }
}
