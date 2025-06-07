/// Bukeer Design System Components
///
/// This file exports all design system components including:
/// - Buttons: Standard button implementations with consistent styling
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
