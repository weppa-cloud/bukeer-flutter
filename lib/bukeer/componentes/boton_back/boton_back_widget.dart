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
      padding: EdgeInsets.only(right: BukeerSpacing.s),
      child: BukeerIconButton(
        icon: Icon(Icons.arrow_back_sharp),
        onPressed: () async {
          Navigator.pop(context);
        },
        size: BukeerIconButtonSize.large,
        variant: BukeerIconButtonVariant.outlined,
        borderColor: BukeerColors.primary,
        fillColor: BukeerColors.primaryAccent,
        iconColor: BukeerColors.primaryText,
        tooltip: 'Volver',
      ),
    );
  }
}
