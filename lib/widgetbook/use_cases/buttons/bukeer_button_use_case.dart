import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bukeer/design_system/index.dart';

List<WidgetbookUseCase> getBukeerButtonUseCases() {
  return [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) {
        final text = context.knobs.string(
          label: 'Text',
          initialValue: 'Click me',
        );

        final variant = context.knobs.list(
          label: 'Variant',
          options: BukeerButtonVariant.values,
          initialOption: BukeerButtonVariant.primary,
          labelBuilder: (variant) => variant.name,
        );

        final size = context.knobs.list(
          label: 'Size',
          options: BukeerButtonSize.values,
          initialOption: BukeerButtonSize.medium,
          labelBuilder: (size) => size.name,
        );

        final width = context.knobs.list(
          label: 'Width',
          options: BukeerButtonWidth.values,
          initialOption: BukeerButtonWidth.auto,
          labelBuilder: (width) => width.name,
        );

        final isEnabled = context.knobs.boolean(
          label: 'Enabled',
          initialValue: true,
        );

        final isLoading = context.knobs.boolean(
          label: 'Loading',
          initialValue: false,
        );

        final showIcon = context.knobs.boolean(
          label: 'Show Icon',
          initialValue: false,
        );

        final iconData = context.knobs.list(
          label: 'Icon',
          options: [
            Icons.add,
            Icons.check,
            Icons.arrow_forward,
            Icons.send,
            Icons.save,
          ],
          initialOption: Icons.add,
          labelBuilder: (icon) {
            switch (icon) {
              case Icons.add:
                return 'Add';
              case Icons.check:
                return 'Check';
              case Icons.arrow_forward:
                return 'Arrow Forward';
              case Icons.send:
                return 'Send';
              case Icons.save:
                return 'Save';
              default:
                return 'Icon';
            }
          },
        );

        final iconPosition = context.knobs.list(
          label: 'Icon Position',
          options: BukeerButtonIconPosition.values,
          initialOption: BukeerButtonIconPosition.leading,
          labelBuilder: (position) => position.name,
        );

        return Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: BukeerButton(
              text: text,
              icon: showIcon ? iconData : null,
              variant: variant,
              size: size,
              width: width,
              onPressed: isEnabled ? () {} : null,
              isLoading: isLoading,
              enabled: isEnabled,
              iconPosition: iconPosition,
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Loading State',
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BukeerButton.primary(
                text: 'Loading...',
                onPressed: () {},
                isLoading: true,
              ),
              SizedBox(height: 16),
              BukeerButton.secondary(
                text: 'Processing...',
                onPressed: () {},
                isLoading: true,
              ),
              SizedBox(height: 16),
              BukeerButton.outlined(
                text: 'Please wait...',
                onPressed: () {},
                isLoading: true,
              ),
            ],
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Different Sizes',
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BukeerButton.primary(
                text: 'Small Button',
                onPressed: () {},
                size: BukeerButtonSize.small,
              ),
              SizedBox(height: 16),
              BukeerButton.primary(
                text: 'Medium Button',
                onPressed: () {},
                size: BukeerButtonSize.medium,
              ),
              SizedBox(height: 16),
              BukeerButton.primary(
                text: 'Large Button',
                onPressed: () {},
                size: BukeerButtonSize.large,
              ),
            ],
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Variants',
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BukeerButton.primary(
                text: 'Primary Button',
                onPressed: () {},
              ),
              SizedBox(height: 16),
              BukeerButton.secondary(
                text: 'Secondary Button',
                onPressed: () {},
              ),
              SizedBox(height: 16),
              BukeerButton.outlined(
                text: 'Outlined Button',
                onPressed: () {},
              ),
              SizedBox(height: 16),
              BukeerButton.text(
                text: 'Text Button',
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'With Icons',
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BukeerButton.primary(
                text: 'Add Item',
                onPressed: () {},
                icon: Icons.add,
                iconPosition: BukeerButtonIconPosition.leading,
              ),
              SizedBox(height: 16),
              BukeerButton.primary(
                text: 'Send Message',
                onPressed: () {},
                icon: Icons.send,
                iconPosition: BukeerButtonIconPosition.trailing,
              ),
              SizedBox(height: 16),
              BukeerButton.secondary(
                text: 'Save Draft',
                onPressed: () {},
                icon: Icons.save_alt,
              ),
              SizedBox(height: 16),
              BukeerButton.outlined(
                text: 'Delete',
                onPressed: () {},
                icon: Icons.delete_outline,
                borderColor: BukeerColors.error,
              ),
            ],
          ),
        );
      },
    ),
  ];
}
