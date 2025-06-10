import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bukeer/bukeer/core/widgets/modals/contact/add_edit/modal_add_edit_contact_widget.dart';
import 'package:bukeer/design_system/index.dart';
import 'package:bukeer/services/app_services.dart';
import 'package:bukeer/services/contact_service.dart';
import 'package:provider/provider.dart';

WidgetbookComponent getModalAddEditContactUseCases() {
  return WidgetbookComponent(
    name: 'ModalAddEditContact',
    useCases: [
      WidgetbookUseCase(
        name: 'Create Mode',
        builder: (context) => _ModalWrapper(
          isEdit: false,
        ),
      ),
      WidgetbookUseCase(
        name: 'Edit Mode',
        builder: (context) => _ModalWrapper(
          isEdit: true,
        ),
      ),
      WidgetbookUseCase(
        name: 'With Options',
        builder: (context) => _ModalWrapper(
          isEdit: context.knobs.boolean(
            label: 'Edit Mode',
            initialValue: false,
          ),
        ),
      ),
    ],
  );
}

class _ModalWrapper extends StatefulWidget {
  final bool isEdit;

  const _ModalWrapper({
    required this.isEdit,
  });

  @override
  State<_ModalWrapper> createState() => _ModalWrapperState();
}

class _ModalWrapperState extends State<_ModalWrapper> {
  @override
  void initState() {
    super.initState();
    // Setup mock data for edit mode
    if (widget.isEdit) {
      _setupMockContactData();
    }
  }

  void _setupMockContactData() {
    // Set mock contact data for edit mode
    final contactService = appServices.contact;
    contactService.setAllDataContact({
      'id': 'CONT-001',
      'name': 'Juan',
      'last_name': 'Pérez',
      'email': 'juan.perez@example.com',
      'phone': '+57 300 123 4567',
      'document_type': 'Cédula de ciudadanía',
      'document_number': '1234567890',
      'nationality_id': 1,
      'is_client': true,
      'is_company': false,
      'is_provider': false,
      'birth_date': '1990-01-15',
      'location': 'Bogotá, Colombia',
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContactService(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Stack(
          children: [
            // Background content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modal Info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información del modal:',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Modo: ${widget.isEdit ? "Edición" : "Creación"}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '• Tamaño: 700px × 1000px (max-width: 650px)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '• Validación de formulario activa',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Features
                  Text(
                    'Características del componente:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFeatureChip('Foto de perfil'),
                      _buildFeatureChip('Múltiples campos'),
                      _buildFeatureChip('Validación'),
                      _buildFeatureChip('Selector de lugar'),
                      _buildFeatureChip('Fecha de nacimiento'),
                      _buildFeatureChip('Teléfonos internacionales'),
                      _buildFeatureChip('Switches de tipo'),
                    ],
                  ),

                  const Spacer(),

                  // Warning
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: Colors.orange[700],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Este modal requiere autenticación y acceso a APIs para funcionar completamente. '
                            'En Widgetbook mostramos una versión simplificada.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.orange[700],
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Show Modal Button
                  Center(
                    child: BukeerButton(
                      text: 'Mostrar Modal',
                      onPressed: () => _showModal(context),
                      icon: Icons.open_in_new,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: BukeerColors.primaryAccent.withOpacity(0.5),
      labelStyle: TextStyle(color: BukeerColors.primary),
      side: BorderSide(color: BukeerColors.primary.withOpacity(0.3)),
    );
  }

  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Wrap in a scaffold to provide proper constraints
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Material(
              color: Colors.transparent,
              child: ModalAddEditContactWidget(
                isEdit: widget.isEdit,
              ),
            ),
          ),
        );
      },
    );
  }
}
