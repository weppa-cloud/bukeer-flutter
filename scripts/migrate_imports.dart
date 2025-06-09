#!/usr/bin/env dart
// Script to automatically migrate imports after component reorganization
// Usage: dart scripts/migrate_imports.dart

import 'dart:io';

// Import mappings from old paths to new paths
final Map<String, String> importMappings = {
  // Navigation components
  'bukeer/componentes/web_nav/web_nav_widget.dart':
      'bukeer/core/widgets/navigation/web_nav/web_nav_widget.dart',
  'bukeer/componentes/mobile_nav/mobile_nav_widget.dart':
      'bukeer/core/widgets/navigation/mobile_nav/mobile_nav_widget.dart',
  'bukeer/componentes/main_logo_small/main_logo_small_widget.dart':
      'bukeer/core/widgets/navigation/main_logo_small/main_logo_small_widget.dart',

  // Button components
  'bukeer/componentes/boton_crear/boton_crear_widget.dart':
      'bukeer/core/widgets/buttons/boton_crear/boton_crear_widget.dart',
  'bukeer/componentes/boton_back/boton_back_widget.dart':
      'bukeer/core/widgets/buttons/boton_back/boton_back_widget.dart',
  'bukeer/componentes/boton_menu_mobile/boton_menu_mobile_widget.dart':
      'bukeer/core/widgets/buttons/boton_menu_mobile/boton_menu_mobile_widget.dart',

  // Form components
  'bukeer/componentes/search_box/search_box_widget.dart':
      'bukeer/core/widgets/forms/search_box/search_box_widget.dart',
  'bukeer/componentes/date_picker/component_date_widget.dart':
      'bukeer/core/widgets/forms/date_picker/component_date_widget.dart',
  'bukeer/componentes/date_range_picker/component_date_range_widget.dart':
      'bukeer/core/widgets/forms/date_range_picker/component_date_range_widget.dart',
  'bukeer/componentes/place_picker/component_place_widget.dart':
      'bukeer/core/widgets/forms/place_picker/component_place_widget.dart',
  'bukeer/componentes/birth_date_picker/component_birth_date_widget.dart':
      'bukeer/core/widgets/forms/birth_date_picker/component_birth_date_widget.dart',
  'bukeer/componentes/currency_selector/component_add_currency_widget.dart':
      'bukeer/core/widgets/forms/currency_selector/component_add_currency_widget.dart',

  // Container components
  'bukeer/contactos/component_container_contacts/component_container_contacts_widget.dart':
      'bukeer/core/widgets/containers/contacts/component_container_contacts_widget.dart',
  'bukeer/contactos/component_container_accounts/component_container_accounts_widget.dart':
      'bukeer/core/widgets/containers/accounts/component_container_accounts_widget.dart',
  'bukeer/itinerarios/component_container_itineraries/component_container_itineraries_widget.dart':
      'bukeer/core/widgets/containers/itineraries/component_container_itineraries_widget.dart',
  'bukeer/productos/component_container_hotels/component_container_hotels_widget.dart':
      'bukeer/core/widgets/containers/hotels/component_container_hotels_widget.dart',
  'bukeer/productos/component_container_transfers/component_container_transfers_widget.dart':
      'bukeer/core/widgets/containers/transfers/component_container_transfers_widget.dart',
  'bukeer/productos/component_container_flights/component_container_flights_widget.dart':
      'bukeer/core/widgets/containers/flights/component_container_flights_widget.dart',
  'bukeer/component_container_activities/component_container_activities_widget.dart':
      'bukeer/core/widgets/containers/activities/component_container_activities_widget.dart',

  // Dropdown components
  'bukeer/itinerarios/dropdown_products/dropdown_products_widget.dart':
      'bukeer/core/widgets/forms/dropdowns/products/dropdown_products_widget.dart',
  'bukeer/itinerarios/dropdown_airports/dropdown_airports_widget.dart':
      'bukeer/core/widgets/forms/dropdowns/airports/dropdown_airports_widget.dart',
  'bukeer/itinerarios/dropdown_contactos/dropdown_contactos_widget.dart':
      'bukeer/core/widgets/forms/dropdowns/contacts/dropdown_contactos_widget.dart',
  'bukeer/itinerarios/dropdown_accounts/dropdown_accounts_widget.dart':
      'bukeer/core/widgets/forms/dropdowns/accounts/dropdown_accounts_widget.dart',
  'bukeer/itinerarios/dropdown_travel_planner/dropdown_travel_planner_widget.dart':
      'bukeer/core/widgets/forms/dropdowns/travel_planner/dropdown_travel_planner_widget.dart',

  // Modal components
  'bukeer/contactos/modal_add_edit_contact/modal_add_edit_contact_widget.dart':
      'bukeer/core/widgets/modals/contact/add_edit/modal_add_edit_contact_widget.dart',
  'bukeer/contactos/modal_details_contact/modal_details_contact_widget.dart':
      'bukeer/core/widgets/modals/contact/details/modal_details_contact_widget.dart',
  'bukeer/modal_add_edit_itinerary/modal_add_edit_itinerary_widget.dart':
      'bukeer/core/widgets/modals/itinerary/add_edit/modal_add_edit_itinerary_widget.dart',
  'bukeer/productos/modal_add_product/modal_add_product_widget.dart':
      'bukeer/core/widgets/modals/product/add/modal_add_product_widget.dart',
  'bukeer/productos/modal_details_product/modal_details_product_widget.dart':
      'bukeer/core/widgets/modals/product/details/modal_details_product_widget.dart',
  'bukeer/users/modal_add_user/modal_add_user_widget.dart':
      'bukeer/core/widgets/modals/user/add/modal_add_user_widget.dart',
  'bukeer/itinerarios/pasajeros/modal_add_passenger/modal_add_passenger_widget.dart':
      'bukeer/core/widgets/modals/passenger/add/modal_add_passenger_widget.dart',

  // Payment components
  'bukeer/itinerarios/pagos/payment_add/component_add_paid_widget.dart':
      'bukeer/core/widgets/payments/payment_add/component_add_paid_widget.dart',
  'bukeer/itinerarios/proveedores/payment_provider/component_provider_payments_widget.dart':
      'bukeer/core/widgets/payments/payment_provider/component_provider_payments_widget.dart',
  'bukeer/productos/edit_payment_methods/edit_payment_methods_widget.dart':
      'bukeer/core/widgets/payments/edit_payment_methods/edit_payment_methods_widget.dart',

  // Auth components
  'bukeer/users/auth_login/auth_login_widget.dart':
      'bukeer/users/auth/login/auth_login_widget.dart',
  'bukeer/users/auth_create/auth_create_widget.dart':
      'bukeer/users/auth/register/auth_create_widget.dart',
  'bukeer/users/auth_reset_password/auth_reset_password_widget.dart':
      'bukeer/users/auth/reset_password/auth_reset_password_widget.dart',
  'bukeer/users/forgot_password/forgot_password_widget.dart':
      'bukeer/users/auth/forgot_password/forgot_password_widget.dart',

  // Profile components
  'bukeer/users/edit_personal_profile/edit_personal_profile_widget.dart':
      'bukeer/users/profile/edit_personal/edit_personal_profile_widget.dart',
  'bukeer/users/main_profile_account/main_profile_account_widget.dart':
      'bukeer/users/profile/main_account/main_profile_account_widget.dart',
  'bukeer/users/main_profile_page/main_profile_page_widget.dart':
      'bukeer/users/profile/main_page/main_profile_page_widget.dart',
};

void main() {
  print('🔄 Starting import migration...\n');

  final projectRoot = Directory.current.path;
  final libDir = Directory('$projectRoot/lib');

  if (!libDir.existsSync()) {
    print(
        '❌ Error: lib directory not found. Make sure you run this from the project root.');
    exit(1);
  }

  int filesProcessed = 0;
  int importsUpdated = 0;

  // Process all Dart files in the lib directory
  processDirectory(libDir, (file) {
    if (file.path.endsWith('.dart')) {
      final updates = processFile(file);
      if (updates > 0) {
        filesProcessed++;
        importsUpdated += updates;
        print('✅ Updated ${file.path} (${updates} imports)');
      }
    }
  });

  print('\n📊 Migration Summary:');
  print('   Files processed: $filesProcessed');
  print('   Imports updated: $importsUpdated');
  print('\n✨ Import migration completed!');
}

void processDirectory(Directory dir, Function(File) fileProcessor) {
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File) {
      fileProcessor(entity);
    }
  }
}

int processFile(File file) {
  final content = file.readAsStringSync();
  var updatedContent = content;
  int updateCount = 0;

  // Process each import mapping
  importMappings.forEach((oldPath, newPath) {
    // Match various import patterns
    final patterns = [
      // Simple imports
      RegExp('import\\s+[\'"]([^\'"]*)$oldPath[\'"];'),
      // Imports with show/hide
      RegExp('import\\s+[\'"]([^\'"]*)$oldPath[\'"]\\s+(show|hide)\\s+[^;]+;'),
      // Imports with as
      RegExp('import\\s+[\'"]([^\'"]*)$oldPath[\'"]\\s+as\\s+\\w+;'),
      // Export statements
      RegExp('export\\s+[\'"]([^\'"]*)$oldPath[\'"];'),
      RegExp('export\\s+[\'"]([^\'"]*)$oldPath[\'"]\\s+(show|hide)\\s+[^;]+;'),
    ];

    for (final pattern in patterns) {
      final matches = pattern.allMatches(updatedContent);
      for (final match in matches) {
        final fullMatch = match.group(0)!;
        final prefix = match.group(1) ?? '';

        // Calculate the new relative path if needed
        final newImport =
            fullMatch.replaceAll('$prefix$oldPath', '$prefix$newPath');

        updatedContent = updatedContent.replaceAll(fullMatch, newImport);
        updateCount++;
      }
    }
  });

  // Write back if changes were made
  if (updateCount > 0) {
    file.writeAsStringSync(updatedContent);
  }

  return updateCount;
}
