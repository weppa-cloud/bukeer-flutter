import '../../../../backend/supabase/supabase.dart';
import '../../../productos/component_inclusion/component_inclusion_widget.dart';
import '../../../../flutter_flow/flutter_flow_expanded_image_view.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'component_itinerary_preview_hotels_widget.dart'
    show ComponentItineraryPreviewHotelsWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ComponentItineraryPreviewHotelsModel
    extends FlutterFlowModel<ComponentItineraryPreviewHotelsWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
