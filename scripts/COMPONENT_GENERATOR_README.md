# 🛠️ Component Generator System

## Overview

The Bukeer Component Generator is a command-line tool that helps developers quickly create new components following the project's established patterns and best practices.

## Usage

```bash
dart scripts/generate_component.dart [type] [name]
```

### Examples

```bash
# Generate a new button component
dart scripts/generate_component.dart button primary_action

# Generate a new modal component  
dart scripts/generate_component.dart modal user_settings

# Generate a new form component
dart scripts/generate_component.dart form email_input

# Generate a new dropdown component
dart scripts/generate_component.dart dropdown currency_selector
```

## Component Types

| Type | Directory | Use Case |
|------|-----------|----------|
| `button` | `/core/widgets/buttons/` | Action buttons, icon buttons |
| `form` | `/core/widgets/forms/` | Input fields, form controls |
| `modal` | `/core/widgets/modals/` | Dialog boxes, popups |
| `container` | `/core/widgets/containers/` | Data containers, lists |
| `dropdown` | `/core/widgets/forms/dropdowns/` | Select dropdowns |
| `navigation` | `/core/widgets/navigation/` | Nav bars, menus |
| `payment` | `/core/widgets/payments/` | Payment-related components |

## Generated Files

For each component, the generator creates:

1. **Widget file** (`[type]_[name]_widget.dart`)
   - Main component implementation
   - Follows FlutterFlow patterns
   - Includes proper imports and structure

2. **Model file** (`[type]_[name]_model.dart`)
   - State management for the component
   - Controller and focus node management
   - Lifecycle methods

3. **Index update**
   - Automatically adds export to category's `index.dart`

## File Structure Example

When you run:
```bash
dart scripts/generate_component.dart button primary_action
```

It creates:
```
lib/bukeer/core/widgets/buttons/
└── button_primary_action/
    ├── button_primary_action_widget.dart
    └── button_primary_action_model.dart
```

## Templates

The generator uses pre-defined templates for common component types:

### Button Template
- Includes loading and disabled states
- Icon support
- Customizable dimensions
- Follows Bukeer design system

### Modal Template
- Header with title and close button
- Scrollable content area
- Footer with action buttons
- Responsive sizing

### Form Template
- Label and hint text
- Validation support
- Required field indicator
- Error state handling

## Customization

### Adding New Component Types

1. Edit `scripts/generate_component.dart`
2. Add new type to `componentTypes` map:
```dart
const Map<String, String> componentTypes = {
  // ... existing types
  'card': 'cards', // New type
};
```

3. Create template in `scripts/templates/component_templates.dart`:
```dart
const String cardTemplate = '''
// Your card template code
''';
```

4. Add to templates map:
```dart
const Map<String, String> templates = {
  // ... existing templates
  'card': cardTemplate,
};
```

## Best Practices

1. **Naming Convention**
   - Use lowercase with underscores for component names
   - Be descriptive: `user_profile` not just `profile`
   - Follow type prefix: `button_submit`, `modal_confirm`

2. **After Generation**
   - Implement component logic
   - Add required parameters
   - Create tests in `test/widgets/core/[type]/`
   - Update component documentation

3. **State Management**
   - Use the generated model for state
   - Dispose controllers properly
   - Follow FlutterFlow patterns

## Testing

After generating a component, create tests:

```dart
// test/widgets/core/buttons/button_primary_action_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/bukeer/core/widgets/buttons/button_primary_action/button_primary_action_widget.dart';

void main() {
  testWidgets('ButtonPrimaryAction renders correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ButtonPrimaryActionWidget(
          text: 'Test Button',
          onPressed: () {},
        ),
      ),
    );
    
    expect(find.text('Test Button'), findsOneWidget);
  });
}
```

## Troubleshooting

### Component already exists
- Check if component is already in the directory
- Use a different name or delete existing component first

### Invalid component type
- Check available types with `dart scripts/generate_component.dart`
- Ensure type is lowercase

### Import errors after generation
- Run `flutter pub get`
- Check that paths are correct for your component depth

## Future Enhancements

- [ ] Interactive mode with prompts
- [ ] Component preview generation
- [ ] Automatic test file creation
- [ ] Storybook/Widgetbook integration
- [ ] Custom template selection
- [ ] Component documentation generation