import 'package:bukeer/legacy/flutter_flow/flutter_flow_animations.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'dart:math';
import 'dart:ui';
import 'birth_date_picker_widget.dart' show BirthDatePickerWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BirthDatePickerModel extends FlutterFlowModel<BirthDatePickerWidget> {
  ///  Local state fields for this component.

  DateTime? limitedDateTime;

  ///  State fields for stateful widgets in this component.

  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
