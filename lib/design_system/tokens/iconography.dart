import 'package:flutter/material.dart';

/// Design tokens for iconography in the Bukeer application
/// Provides consistent icon sizes, styles, and semantic mappings
class BukeerIconography {
  BukeerIconography._();

  // ================================
  // ICON SIZE TOKENS
  // ================================
  
  /// Extra small icons - for inline text
  static const double xs = 12.0;
  
  /// Small icons - for dense UI
  static const double sm = 16.0;
  
  /// Medium icons - standard size
  static const double md = 20.0;
  
  /// Large icons - for emphasis
  static const double lg = 24.0;
  
  /// Extra large icons - for headers
  static const double xl = 32.0;
  
  /// 2X Large icons - for features/cards
  static const double xxl = 48.0;
  
  /// 3X Large icons - for empty states
  static const double xxxl = 64.0;
  
  /// Huge icons - for splash/welcome screens
  static const double huge = 96.0;

  // ================================
  // COMPONENT-SPECIFIC SIZES
  // ================================
  
  /// App bar icons
  static const double appBar = lg;
  
  /// Navigation bar icons
  static const double navBar = lg;
  
  /// Tab bar icons
  static const double tabBar = md;
  
  /// Button icons (when used with text)
  static const double buttonWithText = sm;
  
  /// Button icons (standalone)
  static const double buttonStandalone = md;
  
  /// Form field icons
  static const double formField = md;
  
  /// List item leading icons
  static const double listLeading = lg;
  
  /// List item trailing icons
  static const double listTrailing = md;
  
  /// Card action icons
  static const double cardAction = md;
  
  /// Floating action button icons
  static const double fab = lg;
  
  /// Avatar placeholder icons
  static const double avatar = xl;
  
  /// Status indicators
  static const double statusIndicator = sm;
  
  /// Loading spinners
  static const double loadingSpinner = lg;

  // ================================
  // SEMANTIC ICON MAPPINGS
  // ================================
  
  // Navigation & Actions
  static const IconData home = Icons.home_outlined;
  static const IconData homeSelected = Icons.home;
  static const IconData back = Icons.arrow_back;
  static const IconData forward = Icons.arrow_forward;
  static const IconData close = Icons.close;
  static const IconData menu = Icons.menu;
  static const IconData more = Icons.more_vert;
  static const IconData moreHorizontal = Icons.more_horiz;
  static const IconData search = Icons.search;
  static const IconData filter = Icons.filter_list;
  static const IconData sort = Icons.sort;
  static const IconData refresh = Icons.refresh;
  
  // CRUD Operations
  static const IconData add = Icons.add;
  static const IconData create = Icons.add_circle_outline;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline;
  static const IconData save = Icons.save_outlined;
  static const IconData cancel = Icons.cancel_outlined;
  static const IconData copy = Icons.copy_outlined;
  static const IconData duplicate = Icons.content_copy;
  
  // Status & Feedback
  static const IconData success = Icons.check_circle_outline;
  static const IconData error = Icons.error_outline;
  static const IconData warning = Icons.warning_amber_outlined;
  static const IconData info = Icons.info_outline;
  static const IconData loading = Icons.hourglass_empty;
  
  // Form & Input
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;
  static const IconData calendar = Icons.calendar_today_outlined;
  static const IconData time = Icons.access_time_outlined;
  static const IconData location = Icons.location_on_outlined;
  static const IconData upload = Icons.upload_outlined;
  static const IconData download = Icons.download_outlined;
  static const IconData attach = Icons.attach_file_outlined;
  
  // User & Profile
  static const IconData user = Icons.person_outline;
  static const IconData users = Icons.people_outline;
  static const IconData profile = Icons.account_circle_outlined;
  static const IconData settings = Icons.settings_outlined;
  static const IconData logout = Icons.logout_outlined;
  static const IconData login = Icons.login_outlined;
  
  // Business Domain - Travel & Tourism
  static const IconData itinerary = Icons.map_outlined;
  static const IconData hotel = Icons.hotel_outlined;
  static const IconData flight = Icons.flight_outlined;
  static const IconData activity = Icons.local_activity_outlined;
  static const IconData transfer = Icons.directions_car_outlined;
  static const IconData transport = Icons.directions_bus_outlined;
  static const IconData restaurant = Icons.restaurant_outlined;
  static const IconData attraction = Icons.place_outlined;
  static const IconData passport = Icons.card_membership_outlined;
  static const IconData luggage = Icons.luggage_outlined;
  static const IconData camera = Icons.camera_alt_outlined;
  
  // Financial
  static const IconData payment = Icons.payment_outlined;
  static const IconData money = Icons.monetization_on_outlined;
  static const IconData currency = Icons.currency_exchange_outlined;
  static const IconData invoice = Icons.receipt_outlined;
  static const IconData credit = Icons.credit_card_outlined;
  static const IconData bank = Icons.account_balance_outlined;
  
  // Communication
  static const IconData email = Icons.email_outlined;
  static const IconData phone = Icons.phone_outlined;
  static const IconData message = Icons.message_outlined;
  static const IconData chat = Icons.chat_outlined;
  static const IconData notification = Icons.notifications_outlined;
  static const IconData share = Icons.share_outlined;
  
  // Data & Content
  static const IconData document = Icons.description_outlined;
  static const IconData pdf = Icons.picture_as_pdf_outlined;
  static const IconData image = Icons.image_outlined;
  static const IconData folder = Icons.folder_outlined;
  static const IconData archive = Icons.archive_outlined;
  static const IconData favorite = Icons.favorite_border;
  static const IconData favoriteSelected = Icons.favorite;
  static const IconData bookmark = Icons.bookmark_border;
  static const IconData bookmarkSelected = Icons.bookmark;
  
  // System & Technical
  static const IconData sync = Icons.sync_outlined;
  static const IconData cloud = Icons.cloud_outlined;
  static const IconData wifi = Icons.wifi_outlined;
  static const IconData security = Icons.security_outlined;
  static const IconData link = Icons.link_outlined;
  static const IconData api = Icons.api_outlined;
  static const IconData database = Icons.storage_outlined;
  
  // UI Controls
  static const IconData expand = Icons.expand_more;
  static const IconData collapse = Icons.expand_less;
  static const IconData next = Icons.chevron_right;
  static const IconData previous = Icons.chevron_left;
  static const IconData dropdown = Icons.arrow_drop_down;
  static const IconData checkbox = Icons.check_box_outline_blank;
  static const IconData checkboxSelected = Icons.check_box;
  static const IconData radio = Icons.radio_button_unchecked;
  static const IconData radioSelected = Icons.radio_button_checked;
  
  // Media & Display
  static const IconData play = Icons.play_arrow_outlined;
  static const IconData pause = Icons.pause_outlined;
  static const IconData stop = Icons.stop_outlined;
  static const IconData fullscreen = Icons.fullscreen_outlined;
  static const IconData zoom = Icons.zoom_in_outlined;
  static const IconData print = Icons.print_outlined;
  
  // Layout & Organization
  static const IconData grid = Icons.grid_view_outlined;
  static const IconData list = Icons.list_outlined;
  static const IconData card = Icons.view_agenda_outlined;
  static const IconData dashboard = Icons.dashboard_outlined;
  static const IconData analytics = Icons.analytics_outlined;
  
  // ================================
  // UTILITY METHODS
  // ================================
  
  /// Get icon size by category
  static double getSize(IconSize size) {
    switch (size) {
      case IconSize.xs:
        return xs;
      case IconSize.sm:
        return sm;
      case IconSize.md:
        return md;
      case IconSize.lg:
        return lg;
      case IconSize.xl:
        return xl;
      case IconSize.xxl:
        return xxl;
      case IconSize.xxxl:
        return xxxl;
      case IconSize.huge:
        return huge;
    }
  }
  
  /// Get icon size for specific component
  static double getComponentSize(IconComponent component) {
    switch (component) {
      case IconComponent.appBar:
        return appBar;
      case IconComponent.navBar:
        return navBar;
      case IconComponent.tabBar:
        return tabBar;
      case IconComponent.buttonWithText:
        return buttonWithText;
      case IconComponent.buttonStandalone:
        return buttonStandalone;
      case IconComponent.formField:
        return formField;
      case IconComponent.listLeading:
        return listLeading;
      case IconComponent.listTrailing:
        return listTrailing;
      case IconComponent.cardAction:
        return cardAction;
      case IconComponent.fab:
        return fab;
      case IconComponent.avatar:
        return avatar;
      case IconComponent.statusIndicator:
        return statusIndicator;
      case IconComponent.loadingSpinner:
        return loadingSpinner;
    }
  }
  
  /// Create an Icon widget with standard sizing
  static Widget icon(
    IconData iconData, {
    IconSize size = IconSize.md,
    Color? color,
    String? semanticLabel,
    TextDirection? textDirection,
  }) {
    return Icon(
      iconData,
      size: getSize(size),
      color: color,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }
  
  /// Create an Icon widget for specific component
  static Widget componentIcon(
    IconData iconData, {
    required IconComponent component,
    Color? color,
    String? semanticLabel,
    TextDirection? textDirection,
  }) {
    return Icon(
      iconData,
      size: getComponentSize(component),
      color: color,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }
  
  /// Create a status icon with appropriate color
  static Widget statusIcon(
    IconStatus status, {
    IconSize size = IconSize.md,
    String? semanticLabel,
  }) {
    late IconData iconData;
    late Color color;
    
    switch (status) {
      case IconStatus.success:
        iconData = success;
        color = Colors.green;
        break;
      case IconStatus.error:
        iconData = error;
        color = Colors.red;
        break;
      case IconStatus.warning:
        iconData = warning;
        color = Colors.amber;
        break;
      case IconStatus.info:
        iconData = info;
        color = Colors.blue;
        break;
      case IconStatus.loading:
        iconData = loading;
        color = Colors.grey;
        break;
    }
    
    return Icon(
      iconData,
      size: getSize(size),
      color: color,
      semanticLabel: semanticLabel,
    );
  }
  
  /// Create an animated rotating icon (for loading states)
  static Widget rotatingIcon(
    IconData iconData, {
    IconSize size = IconSize.md,
    Color? color,
    Duration duration = const Duration(seconds: 1),
    String? semanticLabel,
  }) {
    return _RotatingIcon(
      iconData: iconData,
      size: getSize(size),
      color: color,
      duration: duration,
      semanticLabel: semanticLabel,
    );
  }
}

/// Icon size enumeration
enum IconSize {
  xs,    // 12.0
  sm,    // 16.0
  md,    // 20.0
  lg,    // 24.0
  xl,    // 32.0
  xxl,   // 48.0
  xxxl,  // 64.0
  huge,  // 96.0
}

/// Icon component context enumeration
enum IconComponent {
  appBar,
  navBar,
  tabBar,
  buttonWithText,
  buttonStandalone,
  formField,
  listLeading,
  listTrailing,
  cardAction,
  fab,
  avatar,
  statusIndicator,
  loadingSpinner,
}

/// Icon status enumeration
enum IconStatus {
  success,
  error,
  warning,
  info,
  loading,
}

/// Rotating icon widget for loading states
class _RotatingIcon extends StatefulWidget {
  final IconData iconData;
  final double size;
  final Color? color;
  final Duration duration;
  final String? semanticLabel;
  
  const _RotatingIcon({
    required this.iconData,
    required this.size,
    this.color,
    required this.duration,
    this.semanticLabel,
  });
  
  @override
  State<_RotatingIcon> createState() => _RotatingIconState();
}

class _RotatingIconState extends State<_RotatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2.0 * 3.14159,
          child: Icon(
            widget.iconData,
            size: widget.size,
            color: widget.color,
            semanticLabel: widget.semanticLabel,
          ),
        );
      },
    );
  }
}

/// Extension for easier iconography access in widgets
extension BukeerIconographyExtension on BuildContext {
  BukeerIconography get icons => BukeerIconography._();
}

/// Icon theme data for consistent styling
class BukeerIconTheme {
  static const IconThemeData light = IconThemeData(
    size: BukeerIconography.md,
    color: Color(0xFF1A1A1A), // BukeerColors.textPrimary
  );
  
  static const IconThemeData dark = IconThemeData(
    size: BukeerIconography.md,
    color: Color(0xFFFFFFFF), // BukeerColors.textPrimaryDark
  );
  
  static const IconThemeData primary = IconThemeData(
    size: BukeerIconography.md,
    color: Color(0xFF4B39EF), // BukeerColors.primary
  );
  
  static const IconThemeData secondary = IconThemeData(
    size: BukeerIconography.md,
    color: Color(0xFF39D2C0), // BukeerColors.secondary
  );
}