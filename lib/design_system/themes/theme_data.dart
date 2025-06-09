import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../tokens/index.dart';

/// Comprehensive theme data for the Bukeer application
/// Provides light and dark themes with full design token integration
class BukeerThemeData {
  BukeerThemeData._();

  // Helper method to create Plus Jakarta Sans text style
  static TextStyle _plusJakartaSans({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = BukeerColors.textPrimary,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // ================================
  // LIGHT THEME
  // ================================

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,

        // Color Scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: BukeerColors.primary,
          brightness: Brightness.light,
          primary: BukeerColors.primary,
          secondary: BukeerColors.secondary,
          surface: BukeerColors.surfacePrimary,
          surfaceContainerHighest: BukeerColors.surfaceSecondary,
          error: BukeerColors.error,
          onPrimary: BukeerColors.white,
          onSecondary: BukeerColors.white,
          onSurface: BukeerColors.textPrimary,
          onError: BukeerColors.white,
        ),

        // Scaffold
        scaffoldBackgroundColor: BukeerColors.backgroundPrimary,

        // App Bar
        appBarTheme: const AppBarTheme(
          backgroundColor: BukeerColors.surfacePrimary,
          foregroundColor: BukeerColors.textPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: BukeerColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Outfit',
          ),
          iconTheme: IconThemeData(
            color: BukeerColors.textPrimary,
            size: BukeerIconography.appBar,
          ),
        ),

        // Bottom Navigation Bar
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: BukeerColors.surfacePrimary,
          selectedItemColor: BukeerColors.primary,
          unselectedItemColor: BukeerColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        // Navigation Bar (Material 3)
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: BukeerColors.surfacePrimary,
          indicatorColor: BukeerColors.primary.withOpacity(0.1),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: BukeerColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              );
            }
            return const TextStyle(
              color: BukeerColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                color: BukeerColors.primary,
                size: BukeerIconography.navBar,
              );
            }
            return const IconThemeData(
              color: BukeerColors.textSecondary,
              size: BukeerIconography.navBar,
            );
          }),
        ),

        // Cards
        cardTheme: CardThemeData(
          color: BukeerColors.surfacePrimary,
          shadowColor: Colors.black.withOpacity(0.1),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
          ),
          margin: BukeerSpacing.cardExternal,
        ),

        // Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: BukeerColors.primary,
            foregroundColor: BukeerColors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: BukeerSpacing.l,
              vertical: BukeerSpacing.m,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(BukeerSpacing.s),
            ),
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.1),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Outfit',
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: BukeerColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: BukeerSpacing.l,
              vertical: BukeerSpacing.m,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(BukeerSpacing.s),
            ),
            side: const BorderSide(
              color: BukeerColors.primary,
              width: 1.5,
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Outfit',
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: BukeerColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: BukeerSpacing.m,
              vertical: BukeerSpacing.s,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(BukeerSpacing.xs),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Outfit',
            ),
          ),
        ),

        // FloatingActionButton
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: BukeerColors.primary,
          foregroundColor: BukeerColors.white,
          elevation: 6,
          shape: CircleBorder(),
        ),

        // Input Decoration (TextFields)
        inputDecorationTheme: InputDecorationTheme(
          filled: false, // FlutterFlow default is unfilled
          fillColor: BukeerColors.surfaceSecondary,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: BukeerSpacing.m,
            vertical: BukeerSpacing.m,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
            borderSide: const BorderSide(
              color: BukeerColors
                  .alternate, // Use alternate color like FlutterFlow
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
            borderSide: const BorderSide(
              color: BukeerColors.alternate,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
            borderSide: const BorderSide(
              color: BukeerColors.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
            borderSide: const BorderSide(
              color: BukeerColors.error,
              width: 2,
            ),
          ),
          labelStyle: const TextStyle(
            color: BukeerColors.textSecondary,
            fontSize: 16,
            fontFamily: 'Outfit',
          ),
          hintStyle: const TextStyle(
            color: BukeerColors.textTertiary,
            fontSize: 16,
            fontFamily: 'Outfit',
          ),
          errorStyle: const TextStyle(
            color: BukeerColors.error,
            fontSize: 14,
            fontFamily: 'Outfit',
          ),
        ),

        // Divider
        dividerTheme: const DividerThemeData(
          color: BukeerColors.neutralLight,
          thickness: 1,
          space: BukeerSpacing.m,
        ),

        // Icon Theme
        iconTheme: BukeerIconTheme.light,

        // Text Theme
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 48, // FlutterFlow size
            fontWeight: FontWeight.w600,
            fontFamily: 'outfitSemiBold',
            color: BukeerColors.textPrimary,
          ),
          displayMedium: const TextStyle(
            fontSize: 36, // FlutterFlow size
            fontWeight: FontWeight.w600,
            fontFamily: 'outfitSemiBold',
            color: BukeerColors.textPrimary,
          ),
          displaySmall: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            fontFamily: 'outfitSemiBold',
            color: BukeerColors.textPrimary,
          ),
          headlineLarge: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            fontFamily: 'outfitSemiBold',
            color: BukeerColors.textPrimary,
          ),
          headlineMedium: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'outfitSemiBold',
            color: BukeerColors.textPrimary,
          ),
          headlineSmall: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'outfitSemiBold',
            color: BukeerColors.textPrimary,
          ),
          titleLarge: _plusJakartaSans(
            fontSize: 18, // FlutterFlow size
            fontWeight: FontWeight.w600,
            color: BukeerColors.textPrimary,
          ),
          titleMedium: _plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: BukeerColors.white, // FlutterFlow uses info color
          ),
          titleSmall: _plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: BukeerColors.white, // FlutterFlow uses info color
          ),
          bodyLarge: _plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: BukeerColors.textPrimary,
          ),
          bodyMedium: _plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: BukeerColors.textPrimary,
          ),
          bodySmall: _plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: BukeerColors.textSecondary,
          ),
          labelLarge: _plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: BukeerColors.textPrimary,
          ),
          labelMedium: _plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: BukeerColors.textSecondary,
          ),
          labelSmall: _plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: BukeerColors.textTertiary,
          ),
        ),

        // Chip Theme
        chipTheme: ChipThemeData(
          backgroundColor: BukeerColors.surfaceSecondary,
          selectedColor: BukeerColors.primary,
          labelStyle: const TextStyle(
            color: BukeerColors.textPrimary,
            fontFamily: 'Outfit',
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: BukeerSpacing.s,
            vertical: BukeerSpacing.xs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
          ),
        ),

        // Dialog Theme
        dialogTheme: DialogThemeData(
          backgroundColor: BukeerColors.surfacePrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.m),
          ),
          elevation: 16,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Outfit',
            color: BukeerColors.textPrimary,
          ),
          contentTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Outfit',
            color: BukeerColors.textPrimary,
          ),
        ),

        // SnackBar Theme
        snackBarTheme: SnackBarThemeData(
          backgroundColor: BukeerColors.neutralDark,
          contentTextStyle: const TextStyle(
            color: BukeerColors.white,
            fontSize: 14,
            fontFamily: 'Outfit',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.xs),
          ),
          behavior: SnackBarBehavior.floating,
          elevation: 8,
        ),

        // Tab Bar Theme
        tabBarTheme: const TabBarThemeData(
          labelColor: BukeerColors.primary,
          unselectedLabelColor: BukeerColors.textSecondary,
          indicatorColor: BukeerColors.primary,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Outfit',
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'Outfit',
          ),
        ),

        // List Tile Theme
        listTileTheme: const ListTileThemeData(
          iconColor: BukeerColors.textSecondary,
          textColor: BukeerColors.textPrimary,
          contentPadding: EdgeInsets.symmetric(
            horizontal: BukeerSpacing.m,
            vertical: BukeerSpacing.xs,
          ),
        ),

        // Checkbox Theme
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return BukeerColors.primary;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(BukeerColors.white),
          side: const BorderSide(color: BukeerColors.neutralMedium, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.xs),
          ),
        ),

        // Radio Theme
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return BukeerColors.primary;
            }
            return BukeerColors.neutralMedium;
          }),
        ),

        // Switch Theme
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return BukeerColors.white;
            }
            return BukeerColors.neutralMedium;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return BukeerColors.primary;
            }
            return BukeerColors.neutralLight;
          }),
        ),

        // Slider Theme
        sliderTheme: const SliderThemeData(
          activeTrackColor: BukeerColors.primary,
          inactiveTrackColor: BukeerColors.neutralLight,
          thumbColor: BukeerColors.primary,
          overlayColor: Color(0x1A4B39EF), // 10% primary
          valueIndicatorColor: BukeerColors.primary,
          valueIndicatorTextStyle: TextStyle(
            color: BukeerColors.white,
            fontFamily: 'Outfit',
          ),
        ),

        // Progress Indicator Theme
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: BukeerColors.primary,
          linearTrackColor: BukeerColors.neutralLight,
          circularTrackColor: BukeerColors.neutralLight,
        ),

        // Tooltip Theme
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: BukeerColors.neutralDark,
            borderRadius: BorderRadius.circular(BukeerSpacing.xs),
            boxShadow: BukeerShadows.tooltip,
          ),
          textStyle: const TextStyle(
            color: BukeerColors.white,
            fontSize: 12,
            fontFamily: 'Outfit',
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: BukeerSpacing.s,
            vertical: BukeerSpacing.xs,
          ),
        ),
      );

  // ================================
  // DARK THEME
  // ================================

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        // Color Scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: BukeerColors.primary,
          brightness: Brightness.dark,
          primary: BukeerColors.primary,
          secondary: BukeerColors.secondaryDark, // Use cyan for dark mode
          surface: BukeerColors.backgroundDark,
          surfaceContainerHighest: BukeerColors.backgroundDarkSecondary,
          error: BukeerColors.error,
          onPrimary: BukeerColors.white,
          onSecondary: BukeerColors.black,
          onSurface: BukeerColors.white,
          onError: BukeerColors.white,
        ),

        // Scaffold
        scaffoldBackgroundColor: BukeerColors.backgroundDark,

        // App Bar
        appBarTheme: const AppBarTheme(
          backgroundColor: BukeerColors.backgroundDark,
          foregroundColor: BukeerColors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: BukeerColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Outfit',
          ),
          iconTheme: IconThemeData(
            color: BukeerColors.white,
            size: BukeerIconography.appBar,
          ),
        ),

        // Card Theme (Dark)
        cardTheme: CardThemeData(
          color: BukeerColors.backgroundDarkSecondary,
          shadowColor: Colors.black.withOpacity(0.3),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
          ),
          margin: BukeerSpacing.cardExternal,
        ),

        // Text Theme (Dark) - FlutterFlow Original Colors
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 48, // FlutterFlow size
            fontWeight: FontWeight.w600,
            fontFamily: 'outfitSemiBold',
            color: Color(0xFFFFFFFF), // FlutterFlow primaryText
          ),
          displayMedium: const TextStyle(
            fontSize: 36, // FlutterFlow size
            fontWeight: FontWeight.w600,
            fontFamily: 'outfitSemiBold',
            color: Color(0xFFFFFFFF), // FlutterFlow primaryText
          ),
          displaySmall: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            fontFamily: 'outfitSemiBold',
            color: Color(0xFFFFFFFF), // FlutterFlow primaryText
          ),
          headlineLarge: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            fontFamily: 'outfitSemiBold',
            color: Color(0xFFFFFFFF), // FlutterFlow primaryText
          ),
          headlineMedium: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'outfitSemiBold',
            color: Color(0xFFFFFFFF), // FlutterFlow primaryText
          ),
          headlineSmall: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'outfitSemiBold',
            color: Color(0xFFFFFFFF), // FlutterFlow primaryText
          ),
          titleLarge: _plusJakartaSans(
            fontSize: 18, // FlutterFlow size
            fontWeight: FontWeight.w600,
            color: const Color(0xFFFFFFFF), // FlutterFlow primaryText
          ),
          titleMedium: _plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: BukeerColors.white, // FlutterFlow uses info color
          ),
          titleSmall: _plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: BukeerColors.white, // FlutterFlow uses info color
          ),
          bodyLarge: _plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFFFFFFF), // FlutterFlow primaryText
          ),
          bodyMedium: _plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFFFFFFF), // FlutterFlow primaryText
          ),
          bodySmall: _plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFA9ADC6), // FlutterFlow secondaryText
          ),
          labelLarge: _plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFFFFFFF), // FlutterFlow primaryText
          ),
          labelMedium: _plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFA9ADC6), // FlutterFlow secondaryText
          ),
          labelSmall: _plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFA9ADC6), // FlutterFlow secondaryText
          ),
        ),

        // Icon Theme (Dark)
        iconTheme: BukeerIconTheme.dark,

        // Input Decoration (Dark)
        inputDecorationTheme: InputDecorationTheme(
          filled: false, // Keep same as light theme
          fillColor: BukeerColors.backgroundDarkTertiary,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: BukeerSpacing.m,
            vertical: BukeerSpacing.m,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
            borderSide: BorderSide(
              color: BukeerColors.alternate
                  .withOpacity(0.5), // Better visibility in dark mode
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
            borderSide: BorderSide(
              color: BukeerColors.alternate
                  .withOpacity(0.5), // Better visibility in dark mode
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
            borderSide: const BorderSide(
              color: BukeerColors.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
            borderSide: const BorderSide(
              color: BukeerColors.error,
              width: 2,
            ),
          ),
          labelStyle: const TextStyle(
            color: BukeerColors.textSecondaryDark,
            fontSize: 16,
            fontFamily: 'Outfit',
          ),
          hintStyle: const TextStyle(
            color: BukeerColors.textTertiaryDark,
            fontSize: 16,
            fontFamily: 'Outfit',
          ),
          errorStyle: const TextStyle(
            color: BukeerColors.error,
            fontSize: 14,
            fontFamily: 'Outfit',
          ),
        ),

        // Divider (Dark)
        dividerTheme: DividerThemeData(
          color: BukeerColors.alternate.withOpacity(0.3),
          thickness: 1,
          space: BukeerSpacing.m,
        ),

        // Navigation Bar Theme (Dark)
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: BukeerColors.backgroundDarkSecondary,
          indicatorColor: BukeerColors.primary.withOpacity(0.2),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Outfit',
              color: BukeerColors.textPrimaryDark,
            ),
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                color: BukeerColors.primary,
                size: 24,
              );
            }
            return const IconThemeData(
              color: BukeerColors.textSecondaryDark,
              size: 24,
            );
          }),
        ),

        // Bottom Navigation Bar Theme (Dark)
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: BukeerColors.backgroundDarkSecondary,
          selectedItemColor: BukeerColors.primary,
          unselectedItemColor: BukeerColors.textSecondaryDark,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Outfit',
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            fontFamily: 'Outfit',
          ),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      );

  // ================================
  // UTILITY METHODS
  // ================================

  /// Get the appropriate theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }

  /// Check if the current theme is dark
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get the opposite theme
  static ThemeData getOppositeTheme(BuildContext context) {
    return isDark(context) ? light : dark;
  }
}

/// Theme extensions for additional custom properties
extension BukeerThemeExtension on ThemeData {
  /// Get Bukeer-specific colors that aren't in the standard ColorScheme
  Type get bukeerColors => BukeerColors;

  /// Get Bukeer-specific spacing values
  Type get bukeerSpacing => BukeerSpacing;

  /// Get Bukeer-specific animations
  Type get bukeerAnimations => BukeerAnimations;

  /// Get Bukeer-specific iconography
  Type get bukeerIconography => BukeerIconography;

  /// Get Bukeer-specific shadows
  Type get bukeerShadows => BukeerShadows;
}
