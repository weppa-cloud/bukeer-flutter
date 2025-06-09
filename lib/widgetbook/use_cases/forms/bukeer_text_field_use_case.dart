import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bukeer/design_system/index.dart';

List<WidgetbookUseCase> getBukeerTextFieldUseCases() {
  return [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) {
        final controller = TextEditingController();

        final label = context.knobs.string(
          label: 'Label',
          initialValue: 'Email',
        );

        final hintText = context.knobs.string(
          label: 'Hint Text',
          initialValue: 'Enter your email',
        );

        final helperText = context.knobs.stringOrNull(
          label: 'Helper Text',
          initialValue: 'We\'ll never share your email',
        );

        final errorText = context.knobs.stringOrNull(
          label: 'Error Text',
          initialValue: null,
        );

        final type = context.knobs.list(
          label: 'Field Type',
          options: BukeerTextFieldType.values,
          initialOption: BukeerTextFieldType.text,
          labelBuilder: (type) => type.name,
        );

        final required = context.knobs.boolean(
          label: 'Required',
          initialValue: false,
        );

        final leadingIcon = context.knobs.listOrNull(
          label: 'Leading Icon',
          options: [
            Icons.email,
            Icons.person,
            Icons.lock,
            Icons.search,
            Icons.phone,
          ],
          initialOption: null,
          labelBuilder: (icon) {
            if (icon == null) return 'None';
            switch (icon) {
              case Icons.email:
                return 'Email';
              case Icons.person:
                return 'Person';
              case Icons.lock:
                return 'Lock';
              case Icons.search:
                return 'Search';
              case Icons.phone:
                return 'Phone';
              default:
                return 'Icon';
            }
          },
        );

        final trailingIcon = context.knobs.listOrNull(
          label: 'Trailing Icon',
          options: [
            Icons.clear,
            Icons.visibility,
            Icons.check,
            Icons.info_outline,
          ],
          initialOption: null,
          labelBuilder: (icon) {
            if (icon == null) return 'None';
            switch (icon) {
              case Icons.clear:
                return 'Clear';
              case Icons.visibility:
                return 'Visibility';
              case Icons.check:
                return 'Check';
              case Icons.info_outline:
                return 'Info';
              default:
                return 'Icon';
            }
          },
        );

        final enabled = context.knobs.boolean(
          label: 'Enabled',
          initialValue: true,
        );

        final readOnly = context.knobs.boolean(
          label: 'Read Only',
          initialValue: false,
        );

        final maxLines = context.knobs.intOrNull.slider(
          label: 'Max Lines',
          initialValue: 1,
          min: 1,
          max: 5,
        );

        return Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: BukeerTextField(
              controller: controller,
              label: label,
              hintText: hintText,
              helperText: helperText,
              errorText: errorText,
              type: type,
              required: required,
              leadingIcon: leadingIcon,
              trailingIcon: trailingIcon,
              enabled: enabled,
              readOnly: readOnly,
              maxLines: maxLines,
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Common Fields',
      builder: (context) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email field
                BukeerTextField(
                  controller: TextEditingController(),
                  label: 'Email',
                  hintText: 'Enter your email',
                  leadingIcon: Icons.email,
                  type: BukeerTextFieldType.email,
                ),
                SizedBox(height: 16),
                // Password field
                BukeerTextField(
                  controller: TextEditingController(),
                  label: 'Password',
                  hintText: 'Enter your password',
                  leadingIcon: Icons.lock,
                  type: BukeerTextFieldType.password,
                ),
                SizedBox(height: 16),
                // Search field
                BukeerTextField(
                  controller: TextEditingController(),
                  label: 'Search',
                  hintText: 'Search for items...',
                  leadingIcon: Icons.search,
                  trailingIcon: Icons.filter_list,
                ),
                SizedBox(height: 16),
                // Phone field
                BukeerTextField(
                  controller: TextEditingController(),
                  label: 'Phone Number',
                  hintText: '+1 (555) 123-4567',
                  leadingIcon: Icons.phone,
                  type: BukeerTextFieldType.phone,
                ),
              ],
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Validation States',
      builder: (context) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Normal state
                BukeerTextField(
                  controller: TextEditingController(text: 'john@example.com'),
                  label: 'Normal State',
                  hintText: 'Enter email',
                  leadingIcon: Icons.email,
                  type: BukeerTextFieldType.email,
                ),
                SizedBox(height: 16),
                // Success state
                BukeerTextField(
                  controller: TextEditingController(text: 'john@example.com'),
                  label: 'Success State',
                  hintText: 'Enter email',
                  leadingIcon: Icons.email,
                  trailingIcon: Icons.check_circle,
                  helperText: 'Email is valid',
                  type: BukeerTextFieldType.email,
                ),
                SizedBox(height: 16),
                // Error state
                BukeerTextField(
                  controller: TextEditingController(text: 'invalid-email'),
                  label: 'Error State',
                  hintText: 'Enter email',
                  leadingIcon: Icons.email,
                  errorText: 'Please enter a valid email address',
                  type: BukeerTextFieldType.email,
                ),
                SizedBox(height: 16),
                // Warning state (custom)
                BukeerTextField(
                  controller: TextEditingController(text: 'john@temp-mail.com'),
                  label: 'Warning State',
                  hintText: 'Enter email',
                  leadingIcon: Icons.email,
                  trailingIcon: Icons.warning,
                  helperText: 'This looks like a temporary email',
                  type: BukeerTextFieldType.email,
                ),
              ],
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Different Types',
      builder: (context) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Multi-line text
                  BukeerTextField(
                    controller: TextEditingController(),
                    label: 'Description',
                    hintText: 'Enter a detailed description...',
                    maxLines: 4,
                  ),
                  SizedBox(height: 16),
                  // Number input
                  BukeerTextField(
                    controller: TextEditingController(),
                    label: 'Amount',
                    hintText: '0.00',
                    leadingIcon: Icons.attach_money,
                    type: BukeerTextFieldType.decimal,
                  ),
                  SizedBox(height: 16),
                  // Date input (simulated)
                  BukeerTextField(
                    controller: TextEditingController(text: '2024-01-15'),
                    label: 'Date',
                    hintText: 'YYYY-MM-DD',
                    leadingIcon: Icons.calendar_today,
                    trailingIcon: Icons.arrow_drop_down,
                    readOnly: true,
                  ),
                  SizedBox(height: 16),
                  // Disabled field
                  BukeerTextField(
                    controller: TextEditingController(text: 'Cannot edit this'),
                    label: 'Disabled Field',
                    hintText: 'This is disabled',
                    enabled: false,
                  ),
                  SizedBox(height: 16),
                  // Read-only field
                  BukeerTextField(
                    controller: TextEditingController(text: 'Read only value'),
                    label: 'Read Only Field',
                    hintText: 'This is read only',
                    readOnly: true,
                    trailingIcon: Icons.lock_outline,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  ];
}
