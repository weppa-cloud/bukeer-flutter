import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'boton_back_model.dart';
export 'boton_back_model.dart';

class BotonBackWidget extends StatefulWidget {
  const BotonBackWidget({super.key});

  @override
  State<BotonBackWidget> createState() => _BotonBackWidgetState();
}

class _BotonBackWidgetState extends State<BotonBackWidget> {
  late BotonBackModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BotonBackModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
      child: FlutterFlowIconButton(
        borderColor: FlutterFlowTheme.of(context).primary,
        borderRadius: 12.0,
        borderWidth: 2.0,
        buttonSize: 46.0,
        fillColor: FlutterFlowTheme.of(context).accent1,
        icon: Icon(
          Icons.arrow_back_sharp,
          color: FlutterFlowTheme.of(context).primaryText,
        ),
        onPressed: () async {
          Navigator.pop(context);
        },
      ),
    );
  }
}
