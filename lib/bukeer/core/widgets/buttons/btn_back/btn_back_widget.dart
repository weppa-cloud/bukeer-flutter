import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/components/index.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'btn_back_model.dart';
export 'btn_back_model.dart';

class BtnBackWidget extends StatefulWidget {
  const BtnBackWidget({super.key});

  @override
  State<BtnBackWidget> createState() => _BtnBackWidgetState();
}

class _BtnBackWidgetState extends State<BtnBackWidget> {
  late BtnBackModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BtnBackModel());

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
