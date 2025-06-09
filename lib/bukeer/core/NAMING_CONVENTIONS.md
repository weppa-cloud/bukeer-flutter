# Bukeer Component Naming Conventions

## Overview
This document establishes the naming conventions for all components in the Bukeer Flutter project. These conventions ensure consistency, readability, and maintainability across the codebase.

## File and Directory Structure

### Directory Organization
```
lib/bukeer/
├── core/
│   └── widgets/
│       ├── buttons/
│       ├── containers/
│       ├── forms/
│       │   └── dropdowns/
│       ├── modals/
│       ├── navigation/
│       └── payments/
├── [feature_name]/
│   ├── main_[feature]/
│   └── [sub_features]/
└── users/
    ├── auth/
    └── profile/
```

## Component Naming Rules

### 1. Widget Files
- **Pattern**: `[category]_[descriptive_name]_widget.dart`
- **Widget Class**: `[Category][DescriptiveName]Widget`
- **Model Class**: `[Category][DescriptiveName]Model`

### 2. Categories and Prefixes

#### Core Widgets (`/core/widgets/`)
| Category | Prefix | Example File | Example Class |
|----------|--------|--------------|---------------|
| Buttons | `btn_` | `btn_primary_widget.dart` | `BtnPrimaryWidget` |
| Containers | `container_` | `container_contacts_widget.dart` | `ContainerContactsWidget` |
| Forms | `form_` | `form_date_picker_widget.dart` | `FormDatePickerWidget` |
| Dropdowns | `dropdown_` | `dropdown_airports_widget.dart` | `DropdownAirportsWidget` |
| Modals | `modal_` | `modal_add_contact_widget.dart` | `ModalAddContactWidget` |
| Navigation | `nav_` | `nav_web_widget.dart` | `NavWebWidget` |
| Payments | `payment_` | `payment_add_widget.dart` | `PaymentAddWidget` |

#### Feature Pages
| Type | Pattern | Example |
|------|---------|---------|
| Main Pages | `main_[feature]` | `main_contacts_widget.dart` |
| Detail Pages | `[feature]_details` | `itinerary_details_widget.dart` |
| List Pages | `[feature]_list` | `products_list_widget.dart` |

#### Auth Pages (`/users/auth/`)
| Type | Pattern | Example |
|------|---------|---------|
| Login | `auth_login` | `auth_login_widget.dart` |
| Register | `auth_register` | `auth_register_widget.dart` |
| Reset | `auth_reset_password` | `auth_reset_password_widget.dart` |

### 3. Model Files
- Always paired with widget files
- **Pattern**: `[same_name_as_widget]_model.dart`
- **Class**: `[WidgetName]Model`

### 4. Section Files
- For breaking large widgets into sections
- **Pattern**: `[parent]_[section]_section.dart`
- **Example**: `itinerary_header_section.dart`

## Naming Convention Rules

### DO ✅

1. **Use English** for all names
   ```dart
   // Good
   class BtnPrimaryWidget extends StatefulWidget
   
   // Bad
   class BotonPrimarioWidget extends StatefulWidget
   ```

2. **Use descriptive names** that clearly indicate purpose
   ```dart
   // Good
   dropdown_airports_widget.dart
   
   // Bad
   dropdown_widget.dart
   ```

3. **Follow category prefixes** consistently
   ```dart
   // Good
   modal_add_contact_widget.dart
   modal_edit_product_widget.dart
   
   // Bad
   add_contact_modal_widget.dart
   contact_modal_widget.dart
   ```

4. **Use snake_case** for file names
   ```dart
   // Good
   form_date_picker_widget.dart
   
   // Bad
   FormDatePickerWidget.dart
   formDatePicker_widget.dart
   ```

5. **Use PascalCase** for class names
   ```dart
   // Good
   class FormDatePickerWidget extends StatefulWidget
   
   // Bad
   class form_date_picker_widget extends StatefulWidget
   class formDatePickerWidget extends StatefulWidget
   ```

### DON'T ❌

1. **Avoid redundant naming**
   ```dart
   // Bad
   component_container_contacts_widget.dart
   
   // Good
   container_contacts_widget.dart
   ```

2. **Don't mix languages**
   ```dart
   // Bad
   boton_back_widget.dart  // Spanish
   
   // Good
   btn_back_widget.dart    // English
   ```

3. **Avoid generic names**
   ```dart
   // Bad
   component_widget.dart
   custom_widget.dart
   
   // Good
   form_passenger_info_widget.dart
   ```

4. **Don't use abbreviations** (except common ones)
   ```dart
   // Bad
   comp_add_curr_widget.dart
   
   // Good
   form_currency_selector_widget.dart
   
   // Acceptable abbreviations
   btn_ (button)
   nav_ (navigation)
   auth_ (authentication)
   ```

## Examples of Good vs Bad Naming

### Good Examples ✅
```
lib/bukeer/core/widgets/
├── buttons/
│   ├── btn_primary_widget.dart
│   ├── btn_secondary_widget.dart
│   └── btn_icon_widget.dart
├── containers/
│   ├── container_contacts_widget.dart
│   └── container_activities_widget.dart
├── forms/
│   ├── form_date_picker_widget.dart
│   └── dropdowns/
│       ├── dropdown_airports_widget.dart
│       └── dropdown_contacts_widget.dart
└── modals/
    ├── contact/
    │   ├── modal_add_contact_widget.dart
    │   └── modal_edit_contact_widget.dart
    └── product/
        └── modal_product_details_widget.dart
```

### Bad Examples ❌
```
lib/bukeer/
├── componentes/  // Spanish
│   ├── component_container_contacts_widget.dart  // Redundant
│   └── boton_crear_widget.dart  // Spanish
├── component_add_currency_widget.dart  // No category
├── ModalAddEditContactWidget.dart  // PascalCase filename
└── web_nav.dart  // Missing _widget suffix
```

## Migration Guidelines

When renaming existing components:

1. **Update all imports** in dependent files
2. **Update class names** to match new conventions
3. **Update model files** alongside widget files
4. **Test thoroughly** after renaming
5. **Update documentation** if any

## Special Cases

### 1. Preview Components
For preview-specific components:
- **Pattern**: `preview_[feature]_[type]_widget.dart`
- **Example**: `preview_itinerary_activities_widget.dart`

### 2. Service-Specific Components
For components tied to specific services:
- **Pattern**: `[service]_[action]_widget.dart`
- **Example**: `flight_booking_widget.dart`

### 3. Shared Components
Components used across multiple features:
- Place in `/core/widgets/` with appropriate category
- Use generic but descriptive names
- **Example**: `form_date_range_picker_widget.dart`

## File Organization Example

```dart
// File: lib/bukeer/core/widgets/modals/contact/modal_add_contact_widget.dart

import 'modal_add_contact_model.dart';
export 'modal_add_contact_model.dart';

class ModalAddContactWidget extends StatefulWidget {
  // Implementation
}

class _ModalAddContactWidgetState extends State<ModalAddContactWidget> {
  late ModalAddContactModel _model;
  // Implementation
}
```

## Enforcement

1. **Code Reviews**: Ensure new components follow conventions
2. **Linting**: Consider custom lint rules for naming
3. **Documentation**: Keep this guide updated
4. **Migration**: Gradually rename non-conforming components

## Version History

- **v1.0** (2025-01-06): Initial naming conventions established