/// Ejemplos de uso de los Core Widgets de Bukeer
///
/// Este archivo contiene ejemplos prácticos de cómo usar
/// cada componente core en diferentes escenarios.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bukeer/bukeer/core/widgets/index.dart';
import 'package:bukeer/services/app_services.dart';
import 'package:bukeer/services/ui_state_service.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';

// ============================================
// NAVIGATION EXAMPLES
// ============================================

/// Ejemplo de layout con navegación completa
class NavigationLayoutExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Navegación superior para desktop
      appBar: responsiveVisibility(
        context: context,
        phone: false,
        tablet: false,
      )
          ? PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: WebNavWidget(),
            )
          : null,

      body: Column(
        children: [
          // Logo en el header
          Padding(
            padding: EdgeInsets.all(16.0),
            child: MainLogoSmallWidget(),
          ),

          // Contenido principal
          Expanded(
            child: Center(
              child: Text('Contenido de la página'),
            ),
          ),
        ],
      ),

      // Navegación inferior para móvil
      bottomNavigationBar: responsiveVisibility(
        context: context,
        tabletLandscape: false,
        desktop: false,
      )
          ? MobileNavWidget()
          : null,
    );
  }
}

// ============================================
// FORM EXAMPLES
// ============================================

/// Ejemplo de formulario con fechas
class DateFormExample extends StatefulWidget {
  @override
  _DateFormExampleState createState() => _DateFormExampleState();
}

class _DateFormExampleState extends State<DateFormExample> {
  DateTime? _singleDate;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _birthDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fecha individual
        Text('Fecha de evento:'),
        DatePickerWidget(
          dateStart: _singleDate,
          callBackDate: (newDate) {
            setState(() {
              _singleDate = newDate;
            });
          },
        ),
        SizedBox(height: 20),

        // Rango de fechas
        Text('Periodo del viaje:'),
        DateRangePickerWidget(
          dateStart: _startDate,
          dateEnd: _endDate,
          callBackDateRange: (start, end) {
            setState(() {
              _startDate = start;
              _endDate = end;
            });
            // Note: Date range setting would be implemented based on UiStateService methods
            // appServices.ui.setDateRange(start, end);
          },
        ),
        SizedBox(height: 20),

        // Fecha de nacimiento
        Text('Fecha de nacimiento del pasajero:'),
        BirthDatePickerWidget(
          birthDate: _birthDate,
          callBackDate: (newDate) {
            setState(() {
              _birthDate = newDate;
            });
          },
        ),
      ],
    );
  }
}

/// Ejemplo de formulario de ubicación y precio
class LocationPriceFormExample extends StatefulWidget {
  @override
  _LocationPriceFormExampleState createState() =>
      _LocationPriceFormExampleState();
}

class _LocationPriceFormExampleState extends State<LocationPriceFormExample> {
  String? _city;
  String? _country;
  LatLng? _coordinates;
  double? _price;
  String _currency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selector de lugar
        Text('Destino:'),
        PlacePickerWidget(
          city: _city,
          country: _country,
          callBackPlace: (city, country, lat, lng) {
            setState(() {
              _city = city;
              _country = country;
              _coordinates = LatLng(lat, lng);
            });

            // Actualizar servicio global si es necesario
            if (city != null && country != null) {
              appServices.ui.setSelectedLocation(
                name: city,
                city: city,
                country: country,
              );
            }
          },
        ),
        SizedBox(height: 20),

        // Input de precio con moneda
        Text('Precio del servicio:'),
        CurrencySelectorWidget(
          amount: _price,
          currency: _currency,
          onAmountChanged: (value) {
            setState(() {
              _price = value;
            });
          },
          onCurrencyChanged: (currency) {
            setState(() {
              _currency = currency ?? 'USD';
            });
          },
        ),

        // Mostrar valor formateado
        if (_price != null)
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Precio: ${_currency} ${_price!.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}

/// Ejemplo de búsqueda integrada
class SearchIntegrationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // La SearchBox se integra automáticamente con appServices.ui.searchQuery
        SearchBoxWidget(),

        SizedBox(height: 20),

        // Escuchar cambios en la búsqueda
        Consumer<UiStateService>(
          builder: (context, uiState, child) {
            final query = uiState.searchQuery;

            if (query.isEmpty) {
              return Text('Ingresa un término de búsqueda');
            }

            return Column(
              children: [
                Text('Buscando: "$query"'),
                // Aquí irían los resultados de búsqueda
              ],
            );
          },
        ),
      ],
    );
  }
}

// ============================================
// BUTTON EXAMPLES
// ============================================

/// Ejemplo de página con botón de retroceso
class DetailPageExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BtnBackWidget(),
        title: Text('Detalle del Producto'),
      ),
      body: Center(
        child: Text('Contenido del detalle'),
      ),
    );
  }
}

/// Ejemplo de lista con botón de crear
class ListWithCreateExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item ${index + 1}'),
          );
        },
      ),
      floatingActionButton: BtnCreateWidget(
        onPressed: () {
          // Abrir modal de creación
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => CreateItemModal(),
          );
        },
      ),
    );
  }
}

/// Modal de creación de ejemplo
class CreateItemModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text('Crear Nuevo Item', style: TextStyle(fontSize: 20)),
          // Formulario de creación
        ],
      ),
    );
  }
}

/// Ejemplo de drawer móvil
class MobileDrawerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BtnMobileMenuWidget(),
        title: Text('Mi App'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: MainLogoSmallWidget(),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () => context.pushNamed('home'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () => context.pushNamed('profile'),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Contenido principal'),
      ),
    );
  }
}

// ============================================
// COMPLETE FORM EXAMPLE
// ============================================

/// Ejemplo completo de formulario de reserva
class BookingFormExample extends StatefulWidget {
  @override
  _BookingFormExampleState createState() => _BookingFormExampleState();
}

class _BookingFormExampleState extends State<BookingFormExample> {
  // Datos del formulario
  String? _destination;
  String? _country;
  DateTime? _checkIn;
  DateTime? _checkOut;
  double? _budget;
  String _currency = 'USD';
  List<DateTime?> _passengersBirthDates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BtnBackWidget(),
        title: Text('Nueva Reserva'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Búsqueda de destino
            Text('Buscar destino:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            SearchBoxWidget(),

            SizedBox(height: 24),

            // Lugar específico
            Text('Destino seleccionado:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            PlacePickerWidget(
              city: _destination,
              country: _country,
              callBackPlace: (city, country, lat, lng) {
                setState(() {
                  _destination = city;
                  _country = country;
                });
              },
            ),

            SizedBox(height: 24),

            // Fechas del viaje
            Text('Fechas del viaje:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            DateRangePickerWidget(
              dateStart: _checkIn,
              dateEnd: _checkOut,
              callBackDateRange: (start, end) {
                setState(() {
                  _checkIn = start;
                  _checkOut = end;
                });
              },
            ),

            SizedBox(height: 24),

            // Presupuesto
            Text('Presupuesto estimado:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            CurrencySelectorWidget(
              amount: _budget,
              currency: _currency,
              onAmountChanged: (value) {
                setState(() {
                  _budget = value;
                });
              },
              onCurrencyChanged: (currency) {
                setState(() {
                  _currency = currency ?? 'USD';
                });
              },
            ),

            SizedBox(height: 24),

            // Pasajeros
            Text('Pasajeros:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            ..._buildPassengersList(),

            SizedBox(height: 32),

            // Botón de guardar
            Center(
              child: ElevatedButton(
                onPressed: _saveBooking,
                child: Text('Guardar Reserva'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPassengersList() {
    List<Widget> passengers = [];

    for (int i = 0; i < _passengersBirthDates.length; i++) {
      passengers.add(
        Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: BirthDatePickerWidget(
                  birthDate: _passengersBirthDates[i],
                  callBackDate: (date) {
                    setState(() {
                      _passengersBirthDates[i] = date;
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove_circle),
                onPressed: () {
                  setState(() {
                    _passengersBirthDates.removeAt(i);
                  });
                },
              ),
            ],
          ),
        ),
      );
    }

    passengers.add(
      TextButton.icon(
        icon: Icon(Icons.add),
        label: Text('Agregar Pasajero'),
        onPressed: () {
          setState(() {
            _passengersBirthDates.add(null);
          });
        },
      ),
    );

    return passengers;
  }

  void _saveBooking() {
    // Validar datos
    if (_destination == null || _checkIn == null || _checkOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    // Guardar reserva
    print('Guardando reserva:');
    print('Destino: $_destination, $_country');
    print('Fechas: $_checkIn - $_checkOut');
    print('Presupuesto: $_currency $_budget');
    print('Pasajeros: ${_passengersBirthDates.length}');

    // Aquí iría la lógica para guardar en la base de datos
  }
}
