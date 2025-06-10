import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bukeer/bukeer/core/widgets/modals/itinerary/add_edit/modal_add_edit_itinerary_widget.dart';
import 'package:bukeer/design_system/index.dart';
import 'package:bukeer/services/app_services.dart';
import 'package:bukeer/services/itinerary_service.dart';
import 'package:bukeer/services/product_service.dart';
import 'package:provider/provider.dart';

WidgetbookComponent getModalAddEditItineraryUseCases() {
  return WidgetbookComponent(
    name: 'ModalAddEditItinerary',
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
        name: 'Interactive',
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
    // Setup mock data
    _setupMockData();
  }

  void _setupMockData() {
    if (widget.isEdit) {
      // Set mock itinerary data for edit mode
      final itineraryService = appServices.itinerary;
      itineraryService.setAllDataItinerary({
        'id': 'ITN-2024-001',
        'name': 'Viaje a Cartagena - Familia Pérez',
        'contact_id': 1,
        'travel_planner_id': 2,
        'start_date': '2024-03-15',
        'end_date': '2024-03-22',
        'validity_date': '2024-02-28',
        'language': 'Español',
        'passenger_count': 4,
        'currency_type': 'USD',
        'request_type': 'Standard',
        'personalized_message':
            'Esperamos que disfruten de las hermosas playas de Cartagena.',
        'main_image': 'https://picsum.photos/400/300',
      });

      // Set mock product data
      final productService = appServices.product;
      productService.setAllDataHotel({
        'personalized_message': 'Hotel boutique en el centro histórico',
      });
    }

    // Set mock contact data
    final contactService = appServices.contact;
    contactService.setSelectedContact({
      'id': 1,
      'name': 'Juan Pérez',
      'email': 'juan.perez@example.com',
      'phone': '+57 300 123 4567',
    });

    // Set mock user data
    final userService = appServices.user;
    userService.setAgentInfo({
      'id': 1,
      'name': 'María García',
      'email': 'maria.garcia@bukeer.com',
      'role': 'Travel Planner',
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItineraryService()),
        ChangeNotifierProvider(create: (_) => ProductService()),
      ],
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
                          '• Título: ${widget.isEdit ? "Editar itinerario" : "Crear nuevo itinerario"}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '• Formulario complejo con múltiples secciones',
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
                      _buildFeatureChip('Nombre del itinerario'),
                      _buildFeatureChip('Selector de cliente'),
                      _buildFeatureChip('Travel planner'),
                      _buildFeatureChip('Fechas de viaje'),
                      _buildFeatureChip('Idioma y moneda'),
                      _buildFeatureChip('Cantidad de pasajeros'),
                      _buildFeatureChip('Tipo de solicitud'),
                      _buildFeatureChip('Mensaje personalizado'),
                      _buildFeatureChip('Galería de imágenes'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Form Sections
                  Text(
                    'Secciones del formulario:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text('1. Información básica (nombre, cliente, planner)'),
                  Text('2. Fechas del viaje (inicio, fin, validez)'),
                  Text('3. Configuración (idioma, moneda, pasajeros)'),
                  Text(
                      '4. Tipo de solicitud (Econo, Standard, Premium, Luxury)'),
                  Text('5. Mensaje personalizado'),
                  Text(
                      '6. Galería de imágenes con selección de imagen principal'),

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
                            'Este modal requiere múltiples APIs y servicios. '
                            'Algunos componentes como la galería de imágenes y dropdowns dinámicos '
                            'están simplificados para la demostración en Widgetbook.',
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
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black54,
            child: Center(
              child: Container(
                width: 600,
                height: MediaQuery.of(context).size.height * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Mock header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: BukeerColors.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            widget.isEdit
                                ? 'Editar itinerario'
                                : 'Agregar itinerario',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(dialogContext).pop(),
                          ),
                        ],
                      ),
                    ),
                    // Mock content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Note about modal limitations
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: Colors.blue[700],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Modal simplificado para demostración. El modal real requiere múltiples servicios y APIs.',
                                      style: TextStyle(
                                        color: Colors.blue[700],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Form fields preview
                            _buildFormSection('Información básica', [
                              _buildFormField(
                                  'Nombre de itinerario',
                                  widget.isEdit
                                      ? 'Viaje a Cartagena - Familia Pérez'
                                      : ''),
                              _buildFormField(
                                  'Cliente',
                                  widget.isEdit
                                      ? 'Juan Pérez'
                                      : 'Seleccione un cliente'),
                              _buildFormField(
                                  'Travel Planner',
                                  widget.isEdit
                                      ? 'María García'
                                      : 'Seleccione un planner'),
                            ]),

                            const SizedBox(height: 24),

                            _buildFormSection('Fechas del viaje', [
                              _buildFormField('Fecha de inicio',
                                  widget.isEdit ? '15/03/2024' : 'DD/MM/AAAA'),
                              _buildFormField('Fecha de fin',
                                  widget.isEdit ? '22/03/2024' : 'DD/MM/AAAA'),
                              _buildFormField('Fecha de validez',
                                  widget.isEdit ? '28/02/2024' : 'DD/MM/AAAA'),
                            ]),

                            const SizedBox(height: 24),

                            _buildFormSection('Configuración', [
                              _buildFormField(
                                  'Idioma',
                                  widget.isEdit
                                      ? 'Español'
                                      : 'Seleccione idioma'),
                              _buildFormField('Moneda',
                                  widget.isEdit ? 'USD' : 'Seleccione moneda'),
                              _buildFormField('Cantidad de pasajeros',
                                  widget.isEdit ? '4' : '0'),
                            ]),

                            const SizedBox(height: 24),

                            _buildFormSection('Tipo de solicitud', [
                              _buildRequestTypeSelector(
                                  widget.isEdit ? 'Standard' : null),
                            ]),

                            const SizedBox(height: 24),

                            _buildFormSection('Mensaje personalizado', [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.isEdit
                                      ? 'Esperamos que disfruten de las hermosas playas de Cartagena.'
                                      : 'Escriba aquí su mensaje personalizado...',
                                  style: TextStyle(
                                    color: widget.isEdit
                                        ? Colors.black
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ]),

                            const SizedBox(height: 24),

                            _buildFormSection('Galería de imágenes', [
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    'Galería de imágenes\n(No disponible en Widgetbook)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    // Mock footer
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BukeerButton.secondary(
                            text: 'Cancelar',
                            onPressed: () => Navigator.of(dialogContext).pop(),
                          ),
                          const SizedBox(width: 16),
                          BukeerButton.primary(
                            text: widget.isEdit ? 'Guardar cambios' : 'Agregar',
                            onPressed: () => Navigator.of(dialogContext).pop(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildFormField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isEmpty ? label : value,
                    style: TextStyle(
                      color: value.isEmpty ? Colors.grey[500] : Colors.black,
                    ),
                  ),
                ),
                if (label.contains('Seleccione'))
                  Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestTypeSelector(String? selected) {
    final types = ['Econo', 'Standard', 'Premium', 'Luxury'];
    return Wrap(
      spacing: 8,
      children: types.map((type) {
        final isSelected = type == selected;
        return ChoiceChip(
          label: Text(type),
          selected: isSelected,
          onSelected: (_) {},
          selectedColor: BukeerColors.primary.withOpacity(0.2),
          labelStyle: TextStyle(
            color: isSelected ? BukeerColors.primary : Colors.grey[700],
          ),
        );
      }).toList(),
    );
  }
}
