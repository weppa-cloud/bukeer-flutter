import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'btn_create_model.dart';
export 'btn_create_model.dart';

class BtnCreateWidget extends StatefulWidget {
  const BtnCreateWidget({super.key});

  @override
  State<BtnCreateWidget> createState() => _BtnCreateWidgetState();
}

class _BtnCreateWidgetState extends State<BtnCreateWidget> {
  late BtnCreateModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BtnCreateModel());

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
      color: BukeerColors.primary,
      size: BukeerSpacing.xl,
    );
  }
}
