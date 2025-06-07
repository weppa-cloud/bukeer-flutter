import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../design_system/index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'boton_menu_mobile_model.dart';
export 'boton_menu_mobile_model.dart';

class BotonMenuMobileWidget extends StatefulWidget {
  const BotonMenuMobileWidget({super.key});

  @override
  State<BotonMenuMobileWidget> createState() => _BotonMenuMobileWidgetState();
}

class _BotonMenuMobileWidgetState extends State<BotonMenuMobileWidget> {
  late BotonMenuMobileModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BotonMenuMobileModel());

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
        icon: Icon(Icons.menu),
        onPressed: () async {
          Navigator.pop(context);
        },
        size: BukeerIconButtonSize.large,
        variant: BukeerIconButtonVariant.outlined,
        borderColor: BukeerColors.primary,
        fillColor: BukeerColors.primaryAccent,
        iconColor: BukeerColors.primaryText,
        tooltip: 'Menú',
      ),
    );
  }
}
