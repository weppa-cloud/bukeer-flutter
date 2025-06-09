// Automatic FlutterFlow imports
import '../../../backend/schema/structs/index.dart';
import '../../../backend/supabase/supabase.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:bukeer/legacy/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Versión modificada de createJSONToPDFVoucher con ordenación mejorada

import 'package:supabase_flutter/supabase_flutter.dart';

Future<dynamic> createJSONToPDFVoucher(
    String idItinerary, String idContact, String idAccount) async {
  final supabase = Supabase.instance.client;

  try {
    final contactResponse = await supabase
        .from('contacts')
        .select('name, email, last_name')
        .eq('id', idContact)
        .maybeSingle();

    if (contactResponse == null) {
      return {'error': 'Contacto no encontrado'};
    }

    final contactName = contactResponse['name'] ?? '';
    final contactLastName = contactResponse['last_name'] ?? '';
    final contactEmail = contactResponse['email'] ?? '';

//Informacion de la cuenta

    final accountResponse = await supabase
        .from('accounts')
        .select(
            'name, phone, phone2, mail, logo_image, type_id, number_id, cancellation_policy, privacy_policy, terms_conditions, location,locations:location (address)')
        .eq('id', idAccount)
        .maybeSingle();

    if (accountResponse == null) {
      return {'error': 'Cuenta no encontrado'};
    }

    final accountName = accountResponse['name'] ?? 'Desconocido';
    final accountEmail = accountResponse['mail'] ?? 'email@desconocido.com';
    final accountPhone = accountResponse['phone'] ?? 'Desconocido';
    final accountPhone2 = accountResponse['phone2'] ?? 'Desconocido';
    final accountImage = accountResponse['logo_image'] ?? 'Desconocido';
    final accountType = accountResponse['type_id'] ?? 'Desconocido';
    final accountNumberId = accountResponse['number_id'] ?? 'Desconocido';
    final accountAddress =
        accountResponse['locations']?['address'] ?? 'Dirección desconocida';

    // Al recibir los datos de Supabase
    final accountCancellationPolicy = accountResponse['cancellation_policy'];
    final accountPrivacyPolicy = accountResponse['privacy_policy'];
    final accountTermsConditions = accountResponse['terms_conditions'];

// Función para limpiar y validar valores
    String cleanValue(dynamic value) {
      // Si es null, retornar 'Desconocido'
      if (value == null) return 'Desconocido';

      // Convertir a String y eliminar espacios en blanco
      String strValue = value.toString().trim();

      // Si está vacío o termina con ":", retornar 'Desconocido'
      if (strValue.isEmpty || strValue.endsWith(':')) return 'Desconocido';

      // Devolver el valor limpio
      return strValue;
    }

// Aplicar la limpieza
    final cleanedCancellationPolicy = cleanValue(accountCancellationPolicy);
    final cleanedPrivacyPolicy = cleanValue(accountPrivacyPolicy);
    final cleanedTermsConditions = cleanValue(accountTermsConditions);

    final itineraryResponse = await supabase
        .from('itineraries')
        .select(
            'start_date, end_date, total_amount, status, id_created_by, id_fm, passenger_count, currency, currency_type, pending_paid, paid')
        .eq('id', idItinerary)
        .maybeSingle();

    if (itineraryResponse == null) {
      return {'error': 'Itinerario no encontrado'};
    }

    final startDate = itineraryResponse['start_date'] ?? '';
    final endDate = itineraryResponse['end_date'] ?? '';
    final grossTotal = itineraryResponse['total_amount'] ?? 0;
    final pendingPaid = itineraryResponse['pending_paid'] ?? 0;
    final paid = itineraryResponse['paid'] ?? 0;

    final status = itineraryResponse['status'] ?? '';
    final idAgente = itineraryResponse['id_created_by'] ?? '';
    final idFm = itineraryResponse['id_fm'] ?? '';
    final passengerCount = itineraryResponse['passenger_count'] ?? 0;
    final currency = itineraryResponse['currency'];
    final currencyType = itineraryResponse['currency_type'];

    final agentResponse = await supabase
        .from('contacts')
        .select('name, email')
        .eq('user_id', idAgente)
        .maybeSingle();

    if (agentResponse == null) {
      return {'error': 'Agente no encontrado'};
    }

    final agentName = agentResponse['name'] ?? '';

    // Nueva consulta - Obtener transacciones relacionadas con el itinerario
    List<Map<String, dynamic>> transactions = [];
    try {
      final transactionsResponse = await supabase
          .from('transactions')
          .select('*')
          .eq('id_itinerary', idItinerary)
          .eq('type', 'ingreso'); // Filtro adicional para type = ingreso

      // Transformar las transacciones en una lista de mapas
      if (transactionsResponse != null && transactionsResponse.isNotEmpty) {
        for (var transaction in transactionsResponse) {
          transactions.add(transaction);
        }
        print('Ingresos encontrados: ${transactions.length}');
      } else {
        print('No se encontraron ingresos para este itinerario');
        // Transacciones será una lista vacía en este caso
      }
    } catch (e) {
      print('Error al consultar ingresos: $e');
      // En caso de error, transacciones seguirá siendo una lista vacía
    }

    // Nueva consulta - Obtener pasajeros relacionados con el itinerario
    List<Map<String, dynamic>> passengers = [];
    try {
      final passengersResponse = await supabase
          .from('passenger')
          .select('*')
          .eq('itinerary_id', idItinerary);

      // Transformar los pasajeros en una lista de mapas
      if (passengersResponse != null && passengersResponse.isNotEmpty) {
        for (var passenger in passengersResponse) {
          passengers.add(passenger);
        }
        print('Pasajeros encontrados: ${passengers.length}');
      } else {
        print('No se encontraron pasajeros para este itinerario');
        // Pasajeros será una lista vacía en este caso
      }
    } catch (e) {
      print('Error al consultar pasajeros: $e');
      // En caso de error, pasajeros seguirá siendo una lista vacía
    }

    // Obtener los items sin ordenamiento inicial para manejar la ordenación manualmente
    final itemsResponse = await supabase
        .from('itinerary_items')
        .select(
            'id, product_name, product_type, id_product, rate_name, destination, date, flight_departure, flight_arrival, departure_time, arrival_time, airline, hotel_nights, quantity, personalized_message')
        .eq('id_itinerary', idItinerary)
        .order('date', ascending: true);

    if (itemsResponse == null || itemsResponse.isEmpty) {
      return {'error': 'No se encontraron items'};
    }

    Map<String, List<Map<String, dynamic>>> groupedItems = {
      'Servicios': [],
      'Vuelos': [],
      'Transporte': [],
      'Hoteles': []
    };

    // Procesamos todos los items
    for (var item in itemsResponse) {
      final productType = item['product_type'];
      final productId = item['id_product'];
      final product_name = item['product_name'];
      final airline = item['airline'];

      // Asegurarse que la fecha sea una cadena válida para posterior ordenamiento
      String dateStr = item['date'] ?? '';

      // Intentar crear un DateTime a partir de la fecha
      DateTime? parsedDate;
      try {
        if (dateStr.isNotEmpty) {
          parsedDate = DateTime.parse(dateStr);
        }
      } catch (e) {
        print("Error al analizar fecha: $dateStr - $e");
      }

      Map<String, dynamic> newItem = {
        'name': item['product_name'] ?? 'Nombre no disponible',
        'rate_name': item['rate_name'] ?? 'Nombre no disponible',
        'destination': item['destination'] ?? 'Ubicación desconocida',
        'date': dateStr,
        'parsedDate': parsedDate, // Guardamos el DateTime para ordenar después
        'departure_time': item['departure_time'] ?? '--',
        'arrival_time': item['arrival_time'] ?? '--',
        'hotel_nights': item['hotel_nights'] ?? '--',
        'quantity': item['quantity'] ?? '--',
        'main_image': 'https://example.com/default-image.jpg',
        'personalized_message': item['personalized_message'],
      };

      if (productType == 'Hoteles') {
        final hotel = await supabase
            .from('hotels')
            .select('description_short, main_image, instructions')
            .eq('id', productId)
            .maybeSingle();
        if (hotel != null) {
          newItem['description'] = hotel['description_short'] ?? '';
          newItem['main_image'] = hotel['main_image'] ?? newItem['main_image'];
          newItem['instructions'] = hotel['instructions'] ?? '';
        }
        groupedItems['Hoteles']?.add(newItem);
      } else if (productType == 'Servicios') {
        if (product_name == 'Fee bancario') continue;
        final activity = await supabase
            .from('activities')
            .select('description_short, main_image, instructions')
            .eq('id', productId)
            .maybeSingle();
        if (activity != null) {
          newItem['description'] = activity['description_short'] ?? '';
          newItem['main_image'] =
              activity['main_image'] ?? newItem['main_image'];
          newItem['instructions'] = activity['instructions'] ?? '';
        }
        groupedItems['Servicios']?.add(newItem);
      } else if (productType == 'Vuelos') {
        // Extraer solo los nombres de las ciudades, eliminando los códigos IATA
        String departureFull = item['flight_departure'] ?? '';
        String arrivalFull = item['flight_arrival'] ?? '';

        // Obtener nombre de aerolinea
        final airlineResponse =
            await supabase.from('airlines').select('name').eq('id', airline);

        if (airlineResponse == null || airlineResponse.isEmpty) {
          return {'error': 'No se encontraron items'};
        }

        // Si el formato es "AAD - Adado", extraer solo "Adado"
        String departureName = departureFull.contains(' - ')
            ? departureFull.split(' - ')[1].trim()
            : departureFull;

        String arrivalName = arrivalFull.contains(' - ')
            ? arrivalFull.split(' - ')[1].trim()
            : arrivalFull;

        newItem['name'] = '${airlineResponse[0]["name"]}';
        newItem['departure'] = departureName;
        newItem['arrival'] = arrivalName;

        groupedItems['Vuelos']?.add(newItem);
      } else if (productType == 'Transporte') {
        final transport = await supabase
            .from(
                'transfers') // Asegúrate de que este es el nombre correcto de la tabla
            .select('description_short, main_image, instructions')
            .eq('id', productId)
            .maybeSingle();
        if (transport != null) {
          newItem['description'] = transport['description_short'] ?? '';
          newItem['main_image'] =
              transport['main_image'] ?? newItem['main_image'];
          newItem['instructions'] = transport['instructions'] ?? '';
        }
        groupedItems['Transporte']?.add(newItem);
      }
    }

    // Ordenar cada grupo de items por fecha (del más reciente al más antiguo)
    groupedItems.forEach((key, value) {
      value.sort((a, b) {
        // Si tenemos parsedDate, usamos eso para ordenar
        if (a['parsedDate'] != null && b['parsedDate'] != null) {
          return (a['parsedDate'] as DateTime)
              .compareTo(b['parsedDate'] as DateTime);
        }

        // Si no, intentamos comparar las cadenas de fecha directamente
        try {
          final DateTime dateA = DateTime.parse(a['date'].toString());
          final DateTime dateB = DateTime.parse(b['date'].toString());
          return dateA.compareTo(dateB); // Ordenamiento ascendente
        } catch (e) {
          print('Error al ordenar fechas: $e');
          return 0;
        }
      });

      // Limpiar campo auxiliar parsedDate antes de devolver los datos
      for (var item in value) {
        item.remove('parsedDate');
      }
    });

    print("HOTELES ORDENADOS:");
    for (var item in groupedItems['Hoteles'] ?? []) {
      print("Fecha: ${item['date']} - ${item['name']}");
    }

    print("SERVICIOS ORDENADOS:");
    for (var item in groupedItems['Servicios'] ?? []) {
      print("Fecha: ${item['date']} - ${item['name']}");
    }

    final orderJson = {
      'customer_name': contactName,
      'customer_lastname': contactLastName,
      'email': contactEmail,
      'start_date': startDate,
      'end_date': endDate,
      'itinerary_id': idFm,
      'gross_total': grossTotal,
      'pending_paid': pendingPaid,
      'paid': paid,
      'status': status,
      'passenger_count': passengerCount,
      'agentName': agentName,
      'currency_type': currencyType,
      'currency': currency,
      'account_name': accountName,
      'account_phone': accountPhone,
      'account_phone2': accountPhone2,
      'account_image': accountImage,
      'account_address': accountAddress,
      'account_terms_conditions': cleanedTermsConditions,
      'account_privacy_policy': cleanedPrivacyPolicy,
      'account_cancellation_policy': cleanedCancellationPolicy,

      'account_email': accountEmail,
      'account_type': accountType,
      'account_number_id': accountNumberId,
      'items': groupedItems,
      'transactions': transactions,
      'passengers': passengers, // Añadir pasajeros al JSON
    };

    print("JSON generado: ${jsonEncode(orderJson)}");
    return orderJson;
  } catch (e) {
    print('Error al generar el JSON: $e');
    return {'error': e.toString()};
  }
}
