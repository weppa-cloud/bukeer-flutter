import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'boton_crear_model.dart';
export 'boton_crear_model.dart';

class BotonCrearWidget extends StatefulWidget {
  const BotonCrearWidget({super.key});

  @override
  State<BotonCrearWidget> createState() => _BotonCrearWidgetState();
}

class _BotonCrearWidgetState extends State<BotonCrearWidget> {
  late BotonCrearModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BotonCrearModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      FontAwesomeIcons.plusCircle,
      color: FlutterFlowTheme.of(context).primary,
      size: 36.0,
    );
  }
}
