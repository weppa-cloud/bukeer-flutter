import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bukeer/design_system/index.dart';

List<WidgetbookUseCase> getBukeerIconButtonUseCases() {
  return [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) {
        final size = context.knobs.list(
          label: 'Size',
          options: [
            BukeerIconButtonSize.small,
            BukeerIconButtonSize.medium,
            BukeerIconButtonSize.large,
          ],
          initialOption: BukeerIconButtonSize.medium,
          labelBuilder: (size) {
            switch (size) {
              case BukeerIconButtonSize.small:
                return 'Small (32px)';
              case BukeerIconButtonSize.medium:
                return 'Medium (40px)';
              case BukeerIconButtonSize.large:
                return 'Large (48px)';
              default:
                return size.toString();
            }
          },
        );

        final variant = context.knobs.list(
          label: 'Variant',
          options: BukeerIconButtonVariant.values,
          initialOption: BukeerIconButtonVariant.ghost,
          labelBuilder: (variant) => variant.name,
        );

        final borderRadius = context.knobs.double.slider(
          label: 'Border Radius',
          initialValue: 8,
          min: 0,
          max: 32,
        );

        final borderWidth = context.knobs.double.slider(
          label: 'Border Width',
          initialValue: 2,
          min: 1,
          max: 4,
        );

        final showLoading = context.knobs.boolean(
          label: 'Show Loading',
          initialValue: false,
        );

        final iconData = context.knobs.list(
          label: 'Icon',
          options: [
            Icons.add,
            Icons.edit,
            Icons.delete,
            Icons.favorite,
            Icons.share,
            Icons.more_vert,
          ],
          initialOption: Icons.add,
          labelBuilder: (icon) {
            switch (icon) {
              case Icons.add:
                return 'Add';
              case Icons.edit:
                return 'Edit';
              case Icons.delete:
                return 'Delete';
              case Icons.favorite:
                return 'Favorite';
              case Icons.share:
                return 'Share';
              case Icons.more_vert:
                return 'More';
              default:
                return 'Icon';
            }
          },
        );

        return Center(
          child: BukeerIconButton(
            icon: Icon(iconData),
            size: size,
            variant: variant,
            borderRadius: borderRadius,
            borderWidth: borderWidth,
            showLoadingIndicator: showLoading,
            onPressed: () {},
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Common Actions',
      builder: (context) {
        return Center(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              // Add button
              BukeerIconButton(
                icon: Icon(Icons.add),
                variant: BukeerIconButtonVariant.filled,
                fillColor: BukeerColors.primary,
                onPressed: () {},
              ),
              // Edit button
              BukeerIconButton(
                icon: Icon(Icons.edit),
                variant: BukeerIconButtonVariant.outlined,
                borderColor: BukeerColors.primary,
                iconColor: BukeerColors.primary,
                onPressed: () {},
              ),
              // Delete button
              BukeerIconButton(
                icon: Icon(Icons.delete),
                variant: BukeerIconButtonVariant.danger,
                onPressed: () {},
              ),
              // More options
              BukeerIconButton(
                icon: Icon(Icons.more_horiz),
                variant: BukeerIconButtonVariant.ghost,
                onPressed: () {},
              ),
              // Favorite
              BukeerIconButton(
                icon: Icon(Icons.favorite_border),
                variant: BukeerIconButtonVariant.outlined,
                borderColor: BukeerColors.error,
                iconColor: BukeerColors.error,
                onPressed: () {},
              ),
              // Share
              BukeerIconButton(
                icon: Icon(Icons.share),
                variant: BukeerIconButtonVariant.filled,
                fillColor: BukeerColors.secondary,
                onPressed: () {},
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Small
              BukeerIconButton(
                icon: Icon(Icons.star),
                size: BukeerIconButtonSize.small,
                variant: BukeerIconButtonVariant.filled,
                fillColor: BukeerColors.primary,
                onPressed: () {},
              ),
              SizedBox(width: 16),
              // Medium
              BukeerIconButton(
                icon: Icon(Icons.star),
                size: BukeerIconButtonSize.medium,
                variant: BukeerIconButtonVariant.filled,
                fillColor: BukeerColors.primary,
                onPressed: () {},
              ),
              SizedBox(width: 16),
              // Large
              BukeerIconButton(
                icon: Icon(Icons.star),
                size: BukeerIconButtonSize.large,
                variant: BukeerIconButtonVariant.filled,
                fillColor: BukeerColors.primary,
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'States',
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Normal State',
                  style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 8),
              BukeerIconButton(
                icon: Icon(Icons.add),
                variant: BukeerIconButtonVariant.filled,
                fillColor: BukeerColors.primary,
                onPressed: () {},
              ),
              SizedBox(height: 24),
              Text('Disabled State',
                  style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 8),
              BukeerIconButton(
                icon: Icon(Icons.add),
                variant: BukeerIconButtonVariant.filled,
                fillColor: BukeerColors.primary,
                onPressed: null,
              ),
              SizedBox(height: 24),
              Text('Loading State',
                  style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 8),
              BukeerIconButton(
                icon: Icon(Icons.refresh),
                variant: BukeerIconButtonVariant.filled,
                fillColor: BukeerColors.primary,
                showLoadingIndicator: true,
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    ),
  ];
}
