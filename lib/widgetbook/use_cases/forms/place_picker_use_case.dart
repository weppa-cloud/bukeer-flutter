import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bukeer/bukeer/core/widgets/forms/place_picker/place_picker_widget.dart';
import 'package:bukeer/design_system/index.dart';

WidgetbookComponent getPlacePickerUseCases() {
  return WidgetbookComponent(
    name: 'PlacePicker',
    useCases: [
      WidgetbookUseCase(
        name: 'Default (No Location)',
        builder: (context) => _PlacePickerWrapper(
          location: null,
          locationName: null,
        ),
      ),
      WidgetbookUseCase(
        name: 'With Location String',
        builder: (context) => _PlacePickerWrapper(
          location: 'Miami Beach, FL, USA',
          locationName: null,
        ),
      ),
      WidgetbookUseCase(
        name: 'With Location Name',
        builder: (context) => _PlacePickerWrapper(
          location: null,
          locationName: 'Hotel Fontainebleau',
        ),
      ),
      WidgetbookUseCase(
        name: 'With Both Location and Name',
        builder: (context) => _PlacePickerWrapper(
          location: 'Miami Beach, FL, USA',
          locationName: 'Hotel Fontainebleau',
        ),
      ),
      WidgetbookUseCase(
        name: 'Long Location Name',
        builder: (context) => _PlacePickerWrapper(
          location:
              'Avenida Principal de Los Palos Grandes con Calle Santa Teresa, Caracas, Miranda, Venezuela',
          locationName: null,
        ),
      ),
      WidgetbookUseCase(
        name: 'Airport Location',
        builder: (context) => _PlacePickerWrapper(
          location: 'MIA - Miami International Airport',
          locationName: 'Aeropuerto Internacional de Miami',
        ),
      ),
      WidgetbookUseCase(
        name: 'Tourist Attraction',
        builder: (context) => _PlacePickerWrapper(
          location: null,
          locationName: 'Machu Picchu',
        ),
      ),
    ],
  );
}

class _PlacePickerWrapper extends StatefulWidget {
  final String? location;
  final String? locationName;

  const _PlacePickerWrapper({
    this.location,
    this.locationName,
  });

  @override
  State<_PlacePickerWrapper> createState() => _PlacePickerWrapperState();
}

class _PlacePickerWrapperState extends State<_PlacePickerWrapper> {
  String? _selectedLocation;
  List<String> _selectionHistory = [];

  @override
  void initState() {
    super.initState();
    if (widget.location != null) {
      _selectedLocation = widget.location;
    } else if (widget.locationName != null) {
      _selectedLocation = widget.locationName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Place Picker
            Center(
              child: PlacePickerWidget(
                location: widget.location,
                locationName: widget.locationName,
              ),
            ),

            const SizedBox(height: 32),

            // Current Selection Info
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
                    'Información de ubicación:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.location != null) ...[
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: BukeerColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Dirección: ${widget.location}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (widget.locationName != null) ...[
                    Row(
                      children: [
                        Icon(Icons.label,
                            size: 16, color: BukeerColors.secondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Nombre: ${widget.locationName}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (widget.location == null && widget.locationName == null)
                    Text(
                      'No hay ubicación seleccionada',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Selection History (simulated)
            if (_selectionHistory.isNotEmpty) ...[
              Text(
                'Historial de selecciones:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 8),
              ...(_selectionHistory.map((location) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $location',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ))),
            ],

            const Spacer(),

            // Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BukeerColors.primaryAccent.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: BukeerColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Información del componente',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Haz clic en el ícono azul para abrir el selector de lugares\n'
                    '• El texto se trunca después de 25 caracteres\n'
                    '• Requiere API Keys de Google Maps configuradas\n'
                    '• Soporta ubicaciones por dirección o nombre',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
