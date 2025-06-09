# Widget Analysis Report - Bukeer Project

## Executive Summary
Total widgets found: 71 (excluding already migrated to core)
- **15 widgets already migrated to core/widgets**
- **56 widgets remaining in modules**

## Current Structure Analysis

### 1. Core Widgets (Already Migrated) ✅
Location: `/lib/bukeer/core/widgets/`

#### Buttons (3)
- `boton_back` - Generic back button
- `boton_crear` - Generic create button  
- `boton_menu_mobile` - Mobile menu button

#### Forms (6)
- `currency_selector` - Currency input field
- `birth_date_picker` - Birth date picker
- `date_picker` - Date picker
- `date_range_picker` - Date range picker
- `place_picker` - Place/location picker
- `search_box` - Search input component

#### Navigation (3)
- `main_logo_small` - Logo component
- `mobile_nav` - Mobile navigation
- `web_nav` - Web navigation

### 2. Module-Specific Widgets (To Remain in Modules)

#### Agenda Module (1 widget)
- `main_agenda` - **Main page** (keep in module)

#### Dashboard Module (4 widgets)
- `main_home` - **Main page** (keep in module)
- `reporte_cuentas_por_cobrar` - Accounts receivable report (specific)
- `reporte_cuentas_por_pagar` - Accounts payable report (specific)
- `reporte_ventas` - Sales report (specific)

#### Contactos Module (5 widgets)
- `main_contacts` - **Main page** (keep in module)
- `modal_add_edit_contact` - **Modal** (keep in module/modals/)
- `modal_details_contact` - **Modal** (keep in module/modals/)
- `component_container_accounts` - ⚠️ **Redundant name** (refactor needed)
- `component_container_contacts` - ⚠️ **Redundant name** (refactor needed)

#### Itinerarios Module (23 widgets)
##### Main Pages & Details
- `main_itineraries` - **Main page**
- `itinerary_details` - Details page
- `add_passengers_itinerary` - Passenger management page

##### Modals
- `modal_add_edit_itinerary` - **Modal** (already in modals/)
- `modal_add_passenger` - **Modal**

##### Service-Specific Components
- `component_container_itineraries` - ⚠️ **Redundant name**
- `dropdown_accounts` - Account selector (specific)
- `dropdown_contactos` - Contact selector (specific)
- `dropdown_travel_planner` - Travel planner selector
- `dropdown_airports` - Airport selector
- `dropdown_products` - Product selector

##### Add Service Forms
- `add_a_i_flights` - AI flight form
- `add_activities` - Activity form
- `add_flights` - Flight form
- `add_hotel` - Hotel form
- `add_transfer` - Transfer form

##### Preview Components
- `component_itinerary_preview_activities`
- `component_itinerary_preview_flights`
- `component_itinerary_preview_hotels`
- `component_itinerary_preview_transfers`
- `preview_itinerary_u_r_l` - URL preview page

##### Other Components
- `payment_add` - Payment component
- `payment_provider` - Provider payments
- `reservation_message` - Reservation messaging
- `show_reservation_message` - Display reservation message
- `travel_planner_section` - Travel planner section

#### Productos Module (11 widgets + 1 in widgets/)
##### Main & Modals
- `main_products` - **Main page**
- `modal_add_product` - **Modal**
- `modal_details_product` - **Modal**

##### Container Components (⚠️ Redundant names)
- `component_container_flights`
- `component_container_hotels`
- `component_container_transfers`
- `activities_container` (in widgets/ subfolder)

##### Service-Specific Components
- `add_edit_tarifa` - Rate editor
- `component_add_schedule_activity` - Schedule activity
- `component_preview_schedule_activity` - Preview schedule
- `component_inclusion` - Inclusion editor
- `edit_payment_methods` - Payment methods editor

#### Users Module (10 widgets)
##### Auth Pages
- `auth_create` - Registration page
- `auth_login` - Login page
- `auth_reset_password` - Password reset
- `forgot_password` - Forgot password page

##### Main Pages
- `main_users` - **Main page**
- `main_profile_page` - Profile page
- `main_profile_account` - Account profile

##### Other
- `edit_personal_profile` - Profile editor
- `modal_add_user` - **Modal**

#### Examples Module (2 widgets)
- `booking` - Demo booking widget
- `dropdown_hotel_tarifa` - Demo dropdown

## Recommendations

### 1. Immediate Actions
1. **Complete current migration** of components to core/widgets
2. **Refactor redundant names** - Remove `component_container_` prefix:
   - `component_container_accounts` → `accounts_list`
   - `component_container_contacts` → `contacts_list`
   - `component_container_itineraries` → `itineraries_list`
   - `component_container_flights` → `flights_list`
   - `component_container_hotels` → `hotels_list`
   - `component_container_transfers` → `transfers_list`

### 2. Potential Core Migration Candidates
These widgets could potentially be generalized for core:
- **Dropdowns** (if they can be made generic):
  - `dropdown_accounts`
  - `dropdown_contactos`
  - `dropdown_airports`
  - `dropdown_products`
  
### 3. Module Organization Structure
Recommended structure for each module:
```
module/
├── main_page/           # Main page widget
├── modals/             # Modal dialogs
├── widgets/            # Module-specific widgets
├── sections/           # Page sections
└── components/         # Reusable module components
```

### 4. Naming Conventions
- Remove redundant prefixes like `component_container_`
- Use descriptive names that indicate purpose
- Consider English naming for consistency (long-term)

## Summary by Module

| Module | Total | Main Pages | Modals | Service-Specific | Core Candidates |
|--------|-------|------------|---------|------------------|-----------------|
| Agenda | 1 | 1 | 0 | 0 | 0 |
| Dashboard | 4 | 1 | 0 | 3 | 0 |
| Contactos | 5 | 1 | 2 | 2 | 0 |
| Itinerarios | 23 | 2 | 2 | 19 | 4 (dropdowns) |
| Productos | 12 | 1 | 2 | 9 | 0 |
| Users | 10 | 3 | 1 | 6 | 0 |
| Examples | 2 | 0 | 0 | 2 | 0 |
| **TOTAL** | **57** | **9** | **7** | **41** | **4** |

## Migration Priority
1. ✅ Core UI components (buttons, forms, navigation) - **DONE**
2. 🔄 Refactor redundant container names
3. 📦 Consider generic dropdown migration
4. 🏗️ Reorganize module structures
5. 🌐 Long-term: English naming convention