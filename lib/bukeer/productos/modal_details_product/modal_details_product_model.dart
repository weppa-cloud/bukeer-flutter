import '../../../auth/supabase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../backend/supabase/supabase.dart';
import '../component_add_schedule_activity/component_add_schedule_activity_widget.dart';
import '../component_preview_schedule_activity/component_preview_schedule_activity_widget.dart';
import '../modal_add_product/modal_add_product_widget.dart';
import '../../../flutter_flow/flutter_flow_animations.dart';
import '../../../flutter_flow/flutter_flow_expanded_image_view.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../flutter_flow/upload_data.dart';
import 'dart:math';
import 'dart:ui';
import '../../../custom_code/actions/index.dart' as actions;
import '../../../index.dart';
import 'modal_details_product_widget.dart' show ModalDetailsProductWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ModalDetailsProductModel
    extends FlutterFlowModel<ModalDetailsProductWidget> {
  ///  Local state fields for this component.

  int? photoNumber;

  int? activeTab = 3;

  String? imageMain;

  ///  State fields for stateful widgets in this component.

  // State field(s) for RatingBar widget.
  double? ratingBarValue;
  // Stores action output result for [Backend Call - API (validateDeleteProduct)] action in IconButton widget.
  ApiCallResponse? apiResponseValidateDeleteProduct;
  // Stores action output result for [Backend Call - API (deleteProducts)] action in IconButton widget.
  ApiCallResponse? apiResponseDeleteProduct;
  // Stores action output result for [Backend Call - Delete Row(s)] action in IconButton widget.
  List<LocationsRow>? apiResponseDeleteLocation;
  bool isDataUploading_uploadImagesSupabase = false;
  List<FFUploadedFile> uploadedLocalFiles_uploadImagesSupabase = [];
  List<String> uploadedFileUrls_uploadImagesSupabase = [];

  // Stores action output result for [Backend Call - Delete Row(s)] action in iconDeleteImage widget.
  List<ImagesRow>? deleteImageFromImages;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
