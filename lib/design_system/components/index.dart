/// Bukeer Design System Components
///
/// This file exports all design system components including:
/// - Buttons: Standard button implementations with consistent styling
/// - Cards: Service cards for displaying flight, hotel, and activity information
/// - Chips: Meta chips for displaying metadata with icons
/// - Containers: Price containers and specialized display components
/// - Navigation: Unified navigation component for web and mobile
/// - Modals: Standardized modal and dialog components
/// - Forms: Form field components with validation and styling
/// - Layout: Responsive layout helpers and containers
///
/// Usage:
/// ```dart
/// import 'package:bukeer/design_system/components/index.dart';
///
/// // Using buttons
/// BukeerButton.primary(text: 'Save', onPressed: () {})
/// BukeerFAB(icon: Icons.add, onPressed: () {})
///
/// // Using cards
/// BukeerFlightCard(airline: 'JetSmart', origin: 'BOG', destination: 'MDE')
///
/// // Using chips
/// BukeerMetaChip(icon: Icons.date_range, text: '08 Jun 2025')
/// BukeerMetaChipStyles.person(text: '5 adultos')
///
/// // Using containers
/// BukeerPriceContainer(totalPrice: 7450100, pricePerPerson: 1490020)
///
/// // Using navigation
/// BukeerNavigation(currentRoute: '/home', navigationItems: items)
///
/// // Using modals
/// BukeerModal.show(context: context, modal: modal)
///
/// // Using forms
/// BukeerTextField.email(label: 'Email', controller: controller)
/// ```

// Buttons
export 'buttons/bukeer_button.dart';
export 'buttons/bukeer_fab.dart';
export 'buttons/bukeer_icon_button.dart';

// Cards
export 'cards/bukeer_service_card.dart';
export 'cards/bukeer_itinerary_card.dart';

// Chips
export 'chips/bukeer_meta_chip.dart';

// Containers
export 'containers/bukeer_price_container.dart';

// Navigation
export 'navigation/bukeer_navigation.dart';

// Modals
export 'modals/bukeer_modal.dart';

// Forms
export 'forms/bukeer_text_field.dart';

// Error Handling & Feedback (exported as part of design system)
export '../../components/error_feedback_system.dart';
export '../../components/form_error_handler.dart';
export '../../components/error_aware_app.dart';
