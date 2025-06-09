import '../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../design_system/index.dart';
import '../../../../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'btn_mobile_menu_model.dart';
import '/design_system/tokens/index.dart';
export 'btn_mobile_menu_model.dart';

class BtnMobileMenuWidget extends StatefulWidget {
  const BtnMobileMenuWidget({super.key});

  @override
  State<BtnMobileMenuWidget> createState() => _BtnMobileMenuWidgetState();
}

class _BtnMobileMenuWidgetState extends State<BtnMobileMenuWidget> {
  late BtnMobileMenuModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BtnMobileMenuModel());

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
