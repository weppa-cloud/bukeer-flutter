import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bukeer/design_system/index.dart';

WidgetbookComponent getBukeerModalUseCases() {
  return WidgetbookComponent(
    name: 'BukeerModal',
    useCases: [
      WidgetbookUseCase(
        name: 'Basic Modal',
        builder: (context) => _ModalShowcase(
          builder: (context) => BukeerModal(
            title: context.knobs.string(
              label: 'Title',
              initialValue: 'Modal Title',
            ),
            subtitle: context.knobs.string(
              label: 'Subtitle',
              initialValue: 'This is a subtitle for the modal',
            ),
            body: Text(
              context.knobs.string(
                label: 'Body Content',
                initialValue:
                    'This is the modal body content. You can add any widget here.',
              ),
            ),
            size: context.knobs.list(
              label: 'Size',
              options: BukeerModalSize.values,
              labelBuilder: (size) => size.name,
              initialOption: BukeerModalSize.medium,
            ),
            dismissible: context.knobs.boolean(
              label: 'Dismissible',
              initialValue: true,
            ),
            onClose: context.knobs.boolean(
              label: 'Show Close Button',
              initialValue: true,
            )
                ? () => Navigator.of(context).pop()
                : null,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Actions',
        builder: (context) => _ModalShowcase(
          builder: (context) => BukeerModal(
            title: 'Confirm Action',
            subtitle: 'Are you sure you want to proceed?',
            body: const Text(
              'This action cannot be undone. Please confirm your choice.',
            ),
            primaryAction: BukeerModalAction.primary(
              text: context.knobs.string(
                label: 'Primary Action Text',
                initialValue: 'Confirm',
              ),
              onPressed: () => Navigator.of(context).pop(),
              isLoading: context.knobs.boolean(
                label: 'Primary Loading',
                initialValue: false,
              ),
            ),
            secondaryAction: BukeerModalAction.secondary(
              text: context.knobs.string(
                label: 'Secondary Action Text',
                initialValue: 'Cancel',
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            size: BukeerModalSize.small,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Loading State',
        builder: (context) => _ModalShowcase(
          builder: (context) => BukeerModal(
            title: 'Processing Request',
            body: const Text(
              'Please wait while we process your request...',
            ),
            isLoading: true,
            primaryAction: BukeerModalAction.primary(
              text: 'Save',
              onPressed: null,
            ),
            secondaryAction: BukeerModalAction.secondary(
              text: 'Cancel',
              onPressed: null,
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Form Modal',
        builder: (context) => _ModalShowcase(
          builder: (context) => BukeerModal(
            title: 'Add New Contact',
            subtitle: 'Fill in the contact information',
            body: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BukeerTextField(
                  controller: TextEditingController(),
                  label: 'Name',
                  hintText: 'Enter contact name',
                ),
                SizedBox(height: BukeerSpacing.md),
                BukeerTextField(
                  controller: TextEditingController(),
                  label: 'Email',
                  hintText: 'Enter email address',
                  type: BukeerTextFieldType.email,
                ),
                SizedBox(height: BukeerSpacing.md),
                BukeerTextField(
                  controller: TextEditingController(),
                  label: 'Phone',
                  hintText: 'Enter phone number',
                  type: BukeerTextFieldType.phone,
                ),
              ],
            ),
            primaryAction: BukeerModalAction.primary(
              text: 'Save Contact',
              onPressed: () => Navigator.of(context).pop(),
              icon: Icons.save,
            ),
            secondaryAction: BukeerModalAction.secondary(
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
            size: BukeerModalSize.medium,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Multiple Actions',
        builder: (context) => _ModalShowcase(
          builder: (context) => BukeerModal(
            title: 'Document Options',
            body: const Text(
              'Choose what you want to do with this document.',
            ),
            primaryAction: BukeerModalAction.primary(
              text: 'Download',
              onPressed: () => Navigator.of(context).pop(),
              icon: Icons.download,
            ),
            secondaryAction: BukeerModalAction.secondary(
              text: 'Share',
              onPressed: () => Navigator.of(context).pop(),
              icon: Icons.share,
            ),
            additionalActions: [
              BukeerModalAction.text(
                text: 'Print',
                onPressed: () => Navigator.of(context).pop(),
                icon: Icons.print,
              ),
              BukeerModalAction.text(
                text: 'Delete',
                onPressed: () => Navigator.of(context).pop(),
                icon: Icons.delete,
              ),
            ],
            size: BukeerModalSize.medium,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Custom Header/Footer',
        builder: (context) => _ModalShowcase(
          builder: (context) => BukeerModal(
            body: const Text(
              'This modal has custom header and footer widgets.',
            ),
            customHeader: Container(
              padding: BukeerSpacing.all24,
              decoration: BoxDecoration(
                color: BukeerColors.primary.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: BukeerColors.primary,
                    width: 2.0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: BukeerColors.primary,
                    size: 24.0,
                  ),
                  SizedBox(width: BukeerSpacing.sm),
                  Expanded(
                    child: Text(
                      'Custom Header',
                      style: BukeerTypography.titleMedium.copyWith(
                        color: BukeerColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            customFooter: Container(
              padding: BukeerSpacing.all24,
              decoration: BoxDecoration(
                color: BukeerColors.backgroundSecondary,
                border: Border(
                  top: BorderSide(
                    color: BukeerColors.borderPrimary,
                    width: 1.0,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  'Custom Footer Widget',
                  style: BukeerTypography.bodyMedium,
                ),
              ),
            ),
            size: BukeerModalSize.small,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Large Content',
        builder: (context) => _ModalShowcase(
          builder: (context) => BukeerModal(
            title: 'Terms and Conditions',
            subtitle: 'Please read carefully',
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  20,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: BukeerSpacing.md),
                    child: Text(
                      'Section ${index + 1}: Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      style: BukeerTypography.bodyMedium,
                    ),
                  ),
                ),
              ),
            ),
            primaryAction: BukeerModalAction.primary(
              text: 'Accept',
              onPressed: () => Navigator.of(context).pop(),
            ),
            secondaryAction: BukeerModalAction.secondary(
              text: 'Decline',
              onPressed: () => Navigator.of(context).pop(),
            ),
            size: BukeerModalSize.large,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    ],
  );
}

// Helper widget to show modal on button press
class _ModalShowcase extends StatelessWidget {
  final BukeerModal Function(BuildContext context) builder;

  const _ModalShowcase({required this.builder});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BukeerButton(
        text: 'Show Modal',
        onPressed: () {
          BukeerModal.showResponsive(
            context: context,
            modal: builder(context),
          );
        },
        icon: Icons.open_in_new,
      ),
    );
  }
}
