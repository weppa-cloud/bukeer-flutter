import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'main_logo_small_model.dart';
export 'main_logo_small_model.dart';

class MainLogoSmallWidget extends StatefulWidget {
  const MainLogoSmallWidget({super.key});

  @override
  State<MainLogoSmallWidget> createState() => _MainLogoSmallWidgetState();
}

class _MainLogoSmallWidgetState extends State<MainLogoSmallWidget> {
  late MainLogoSmallModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainLogoSmallModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(BukeerSpacing.s),
          child: Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/images/Logo-Bukeer-FullBlanco-03.png'
                : 'assets/images/Logo-Bukeer-02.png',
            width: 167.8,
            height: 40.25,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
