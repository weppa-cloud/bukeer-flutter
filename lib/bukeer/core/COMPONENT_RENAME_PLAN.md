# Component Rename Plan

## Overview
This document outlines all components that need to be renamed to comply with the naming conventions established in NAMING_CONVENTIONS.md. Components are organized by priority and category.

## Migration Progress
- ✅ **Containers**: All `component_container_*` → `*_container` (COMPLETED)
- 🔄 **Buttons**: Spanish → English renaming (IN PROGRESS)
- ⏳ **Forms**: Remove redundant prefixes (PENDING)
- ⏳ **Other Components**: Various renamings (PENDING)

## Priority Levels
- 🔴 **HIGH**: Core components used across multiple features
- 🟡 **MEDIUM**: Feature-specific components with moderate usage
- 🟢 **LOW**: Rarely used or demo components

## Components to Rename

### 🔴 HIGH PRIORITY - Core Widgets

#### Buttons (Spanish → English)
| Current Name | Proposed Name | Location |
|-------------|---------------|----------|
| `boton_back_widget` | `btn_back_widget` | `/core/widgets/buttons/` |
| `boton_crear_widget` | `btn_create_widget` | `/core/widgets/buttons/` |
| `boton_menu_mobile_widget` | `btn_mobile_menu_widget` | `/core/widgets/buttons/` |

#### Forms (Remove redundant "component" prefix)
| Current Name | Proposed Name | Location |
|-------------|---------------|----------|
| `component_date_widget` | `form_date_picker_widget` | `/core/widgets/forms/` |
| `component_date_range_widget` | `form_date_range_widget` | `/core/widgets/forms/` |
| `component_birth_date_widget` | `form_birth_date_widget` | `/core/widgets/forms/` |
| `component_place_widget` | `form_place_picker_widget` | `/core/widgets/forms/` |
| `component_add_currency_widget` | `form_currency_selector_widget` | `/core/widgets/forms/` |

#### Containers (✅ COMPLETED - Migrated from component_container_* to *_container)
| Current Name | Status | Location |
|-------------|--------|----------|
| `activities_container_widget` | ✅ DONE | `/core/widgets/containers/` |
| `accounts_container_widget` | ✅ DONE | `/core/widgets/containers/` |
| `contacts_container_widget` | ✅ DONE | `/core/widgets/containers/` |
| `flights_container_widget` | ✅ DONE | `/core/widgets/containers/` |
| `hotels_container_widget` | ✅ DONE | `/core/widgets/containers/` |
| `itineraries_container_widget` | ✅ DONE | `/core/widgets/containers/` |
| `transfers_container_widget` | ✅ DONE | `/core/widgets/containers/` |

**Migration Details:**
- Removed redundant `component_container_` prefix
- Moved from various module directories to centralized `/core/widgets/containers/`
- Updated all class names from `ComponentContainer*Widget` to `*ContainerWidget`
- All imports updated across the codebase
- Removed old `component_container_itineraries` directory

#### Dropdowns (Spanish → English)
| Current Name | Proposed Name | Location |
|-------------|---------------|----------|
| `dropdown_contactos_widget` | `dropdown_contacts_widget` | `/core/widgets/forms/dropdowns/` |
| Other dropdowns | ✅ OK | Various |

#### Navigation
| Current Name | Status | Location |
|-------------|--------|----------|
| `web_nav_widget` | ✅ OK (Consider `nav_web_widget` for consistency) | `/core/widgets/navigation/` |
| `mobile_nav_widget` | ✅ OK (Consider `nav_mobile_widget` for consistency) | `/core/widgets/navigation/` |
| `main_logo_small_widget` | ✅ OK (Consider `nav_logo_small_widget`) | `/core/widgets/navigation/` |

#### Payments (Remove redundant "component" prefix)
| Current Name | Proposed Name | Location |
|-------------|---------------|----------|
| `component_add_paid_widget` | `payment_add_widget` | `/core/widgets/payments/` |
| `component_provider_payments_widget` | `payment_provider_widget` | `/core/widgets/payments/` |

### 🟡 MEDIUM PRIORITY - Feature Components

#### Products Module
| Current Name | Proposed Name | Location |
|-------------|---------------|----------|
| `component_inclusion_widget` | `product_inclusion_widget` | `/productos/` |
| `component_add_schedule_activity_widget` | `activity_schedule_add_widget` | `/productos/` |
| `component_preview_schedule_activity_widget` | `activity_schedule_preview_widget` | `/productos/` |
| `add_edit_tarifa_widget` | `tariff_add_edit_widget` | `/productos/` |

#### Itineraries Module - Preview Components
| Current Name | Proposed Name | Location |
|-------------|---------------|----------|
| `component_itinerary_preview_activities_widget` | `preview_itinerary_activities_widget` | `/itinerarios/preview/` |
| `component_itinerary_preview_flights_widget` | `preview_itinerary_flights_widget` | `/itinerarios/preview/` |
| `component_itinerary_preview_hotels_widget` | `preview_itinerary_hotels_widget` | `/itinerarios/preview/` |
| `component_itinerary_preview_transfers_widget` | `preview_itinerary_transfers_widget` | `/itinerarios/preview/` |
| `preview_itinerary_u_r_l_widget` | `preview_itinerary_url_widget` | `/itinerarios/preview/` |

#### Itineraries Module - Services
| Current Name | Proposed Name | Location |
|-------------|---------------|----------|
| `add_a_i_flights_widget` | `flights_ai_add_widget` | `/itinerarios/servicios/` |
| `add_activities_widget` | `activities_add_widget` | `/itinerarios/servicios/` |
| `add_flights_widget` | `flights_add_widget` | `/itinerarios/servicios/` |
| `add_hotel_widget` | `hotel_add_widget` | `/itinerarios/servicios/` |
| `add_transfer_widget` | `transfer_add_widget` | `/itinerarios/servicios/` |

#### Auth Module
| Current Name | Proposed Name | Location |
|-------------|---------------|----------|
| `auth_create_widget` | `auth_register_widget` | `/users/auth/register/` |
| Other auth widgets | ✅ OK | Various |

#### Profile Module
| Current Name | Proposed Name | Location |
|-------------|---------------|----------|
| `edit_personal_profile_widget` | `profile_edit_personal_widget` | `/users/profile/edit_personal/` |

### 🟢 LOW PRIORITY - Rarely Used Components

#### Demo Components
- Consider removing or moving to a separate `/demo/` directory
- Not critical for immediate renaming

## Migration Steps

### Phase 1: High Priority Core Widgets (Week 1)
1. Rename button widgets (Spanish → English)
2. Rename form components (remove "component" prefix)
3. Rename payment components
4. Update all imports

### Phase 2: Medium Priority Feature Components (Week 2)
1. Rename product module components
2. Rename itinerary preview components
3. Rename service components
4. Update imports and tests

### Phase 3: Low Priority & Cleanup (Week 3)
1. Handle remaining components
2. Update documentation
3. Run comprehensive tests

## Automated Renaming Script

Consider creating a script to automate the renaming process:

```bash
#!/bin/bash
# Example rename script (to be developed)

# Rename files
mv boton_back_widget.dart btn_back_widget.dart
mv boton_back_model.dart btn_back_model.dart

# Update imports across codebase
find . -name "*.dart" -exec sed -i '' 's/boton_back_widget/btn_back_widget/g' {} \;
find . -name "*.dart" -exec sed -i '' 's/BotonBackWidget/BtnBackWidget/g' {} \;
find . -name "*.dart" -exec sed -i '' 's/BotonBackModel/BtnBackModel/g' {} \;
```

## Validation Checklist

For each renamed component:
- [ ] File renamed following convention
- [ ] Class name updated to match
- [ ] Model file renamed and updated
- [ ] All imports updated
- [ ] Tests updated and passing
- [ ] No broken references
- [ ] Documentation updated

## Risk Mitigation

1. **Create backups** before mass renaming
2. **Test incrementally** after each batch
3. **Use version control** to track changes
4. **Update in small batches** to minimize conflicts
5. **Communicate changes** to team members

## Success Metrics

- ✅ 100% compliance with naming conventions
- ✅ No broken imports or references
- ✅ All tests passing
- ✅ Improved code readability
- ✅ Easier component discovery

## Notes

### Special Considerations
1. Some components may have external dependencies - check before renaming
2. FlutterFlow generated code may need special handling
3. Consider impact on existing PRs and branches

### Future Improvements
1. Implement linting rules to enforce conventions
2. Create component generator with proper naming
3. Regular audits to maintain consistency