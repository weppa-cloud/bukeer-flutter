import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bukeer/design_system/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';

// Import use cases
import 'use_cases/buttons/bukeer_button_use_case.dart';
import 'use_cases/buttons/bukeer_icon_button_use_case.dart';
import 'use_cases/forms/bukeer_text_field_use_case.dart';
import 'use_cases/forms/search_box_use_case.dart';
import 'use_cases/forms/date_range_picker_use_case.dart';
import 'use_cases/forms/place_picker_use_case.dart';
import 'use_cases/forms/currency_selector_use_case.dart';
import 'use_cases/modals/bukeer_modal_use_case.dart';
import 'use_cases/modals/modal_add_edit_contact_use_case.dart';
import 'use_cases/modals/modal_add_edit_itinerary_use_case.dart';
import 'use_cases/navigation/web_nav_use_case.dart';
import 'use_cases/navigation/mobile_nav_use_case.dart';

class WidgetbookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      appBuilder: (context, child) {
        return MaterialApp(
          title: 'Bukeer Design System',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            primaryColor: BukeerColors.primary,
            colorScheme: ColorScheme.light(
              primary: BukeerColors.primary,
              secondary: BukeerColors.secondary,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: BukeerColors.primary,
            colorScheme: ColorScheme.dark(
              primary: BukeerColors.primary,
              secondary: BukeerColors.secondary,
            ),
          ),
          home: child,
        );
      },
      directories: [
        WidgetbookFolder(
          name: 'Design System',
          children: [
            WidgetbookFolder(
              name: 'Buttons',
              children: [
                WidgetbookComponent(
                  name: 'BukeerButton',
                  useCases: getBukeerButtonUseCases(),
                ),
                WidgetbookComponent(
                  name: 'BukeerIconButton',
                  useCases: getBukeerIconButtonUseCases(),
                ),
              ],
            ),
            WidgetbookFolder(
              name: 'Forms',
              children: [
                WidgetbookComponent(
                  name: 'BukeerTextField',
                  useCases: getBukeerTextFieldUseCases(),
                ),
                getSearchBoxUseCases(),
                getDateRangePickerUseCases(),
                getPlacePickerUseCases(),
                getCurrencySelectorUseCases(),
              ],
            ),
            WidgetbookFolder(
              name: 'Modals',
              children: [
                getBukeerModalUseCases(),
                getModalAddEditContactUseCases(),
                getModalAddEditItineraryUseCases(),
              ],
            ),
            WidgetbookFolder(
              name: 'Navigation',
              children: [
                getWebNavUseCases(),
                getMobileNavUseCases(),
              ],
            ),
          ],
        ),
      ],
      addons: [
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhone13,
            Devices.ios.iPad,
            Devices.android.samsungGalaxyS20,
            Devices.macOS.macBookPro,
          ],
        ),
        ThemeAddon<ThemeData>(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeData.light().copyWith(
                primaryColor: BukeerColors.primary,
                colorScheme: ColorScheme.light(
                  primary: BukeerColors.primary,
                  secondary: BukeerColors.secondary,
                ),
              ),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: ThemeData.dark().copyWith(
                primaryColor: BukeerColors.primary,
                colorScheme: ColorScheme.dark(
                  primary: BukeerColors.primary,
                  secondary: BukeerColors.secondary,
                ),
              ),
            ),
          ],
          themeBuilder: (context, theme, child) {
            return Theme(data: theme, child: child);
          },
        ),
        TextScaleAddon(
          scales: [0.85, 1.0, 1.15, 1.3, 1.5, 2.0],
        ),
        LocalizationAddon(
          locales: [
            const Locale('en', 'US'),
            const Locale('es', 'ES'),
          ],
          localizationsDelegates: [
            DefaultWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
          ],
        ),
        InspectorAddon(),
        AccessibilityAddon(),
        AlignmentAddon(),
        GridAddon(),
      ],
    );
  }
}
