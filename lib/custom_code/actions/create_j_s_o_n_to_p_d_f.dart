// Automatic FlutterFlow imports
import '../../backend/schema/structs/index.dart';
import '../../backend/supabase/supabase.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '../../flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> getProductImages(
    {required String auth_token,
    required String entity_Id,
    int limit = 3}) async {
  final url = Uri.parse(
      'https://wzlxbpicdcdvxvdcvgas.supabase.co/rest/v1/rpc/function_get_images_and_main_image');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $auth_token',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0NjQyODAsImV4cCI6MjA0MTA0MDI4MH0.dSh-yGzemDC7DL_rf7fwgWlMoEKv1SlBCxd8ElFs_d8',
      },
      body: jsonEncode({'p_id': entity_Id}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      // Extraer solo las URLs de imágenes
      final List<String> imageUrls = [];

      for (var item in jsonData) {
        if (item is Map<String, dynamic> && item.containsKey('image_url')) {
          imageUrls.add(item['image_url'] as String);

          // Solo obtenemos las primeras 'limit' imágenes
          if (imageUrls.length >= limit) {
            break;
          }
        }
      }

      return imageUrls;
    } else {
      print(
          'Error al obtener imágenes: ${response.statusCode} - ${response.body}');
      return [];
    }
  } catch (e) {
    print('Error en la petición de imágenes: $e');
    return [];
  }
}

Future<dynamic> createJSONToPDF(String idItinerary, String idContact,
    String authToken, String accountId) async {
  // Crear cliente de Supabase
  final supabase = Supabase.instance.client;

  try {
    // 1. Obtener datos del contacto
    final contactResponse = await supabase
        .from('contacts')
        .select('name, email, last_name')
        .eq('id', idContact)
        .maybeSingle();

    if (contactResponse == null) {
      print('Contacto no encontrado');
      return {'error': 'Contacto no encontrado'};
    }

    final contactName = contactResponse['name'] ?? '';
    final contactLastName = contactResponse['last_name'] ?? '';
    final contactEmail = contactResponse['email'] ?? '';

    final contatctJSon = {
      'name': contactName,
      'email': contactEmail,
      'lastname': contactLastName
    };

    // 2. Obtener datos del itinerario
    final itineraryResponse = await supabase
        .from('itineraries')
        .select(
            'start_date, end_date, total_amount, status, id_created_by, id_fm, name, passenger_count, valid_until, currency_type, currency, personalized_message, main_image')
        .eq('id', idItinerary)
        .maybeSingle();

    if (itineraryResponse == null) {
      print('Itinerario no encontrado');
      return {'error': 'Itinerario no encontrado'};
    }

    // Obtener datos de la cuenta
    final accountResponse = await supabase
        .from('accounts')
        .select(
            'name, logo_image, type_id, number_id, phone, mail, location, website, cancellation_policy, privacy_policy, terms_conditions')
        .eq('id', accountId)
        .maybeSingle();

    if (accountResponse == null) {
      print('Contacto no encontrado');
      return {'error': 'Contacto no encontrado'};
    }

    final location_id_account = accountResponse['location'] ?? '';

    // Obtener ubicación
    final locationResponse = await supabase
        .from('locations')
        .select('address')
        .eq('id', location_id_account)
        .maybeSingle();

    if (locationResponse == null) {
      print('Contacto no encontrado');
      return {'error': 'Contacto no encontrado'};
    }

    final name_account = accountResponse['name'] ?? '';
    final type_id_account = accountResponse['type_id'] ?? '';
    final number_id_account = accountResponse['number_id'] ?? '';
    final phone_account = accountResponse['phone'] ?? '';
    final mail_account = accountResponse['mail'] ?? '';
    final location_account = locationResponse['address'] ?? '';
    final website_account = accountResponse['website'] ?? '';
    final cancellation_policy_account =
        accountResponse['cancellation_policy'] ?? '';
    final privacy_policy_account = accountResponse['privacy_policy'] ?? '';
    final terms_conditions_account = accountResponse['terms_conditions'] ?? '';
    final logo_account = accountResponse['logo_image'] ?? '';

    final accountJson = {
      'name_account': name_account,
      'type_id_account': type_id_account,
      'number_id_account': number_id_account,
      'phone_account': phone_account,
      'mail_account': mail_account,
      'location_account': location_account,
      'website_account': website_account,
      'cancellation_policy_account': cancellation_policy_account,
      'privacy_policy_account': privacy_policy_account,
      'terms_conditions_account': terms_conditions_account,
      'logo_account': logo_account
    };

    // Data itinerario

    final startDate = itineraryResponse['start_date'] ?? '';
    final endDate = itineraryResponse['end_date'] ?? '';
    final grossTotal = itineraryResponse['total_amount'] ?? 0;
    final status = itineraryResponse['status'] ?? '';
    final idAgente = itineraryResponse['id_created_by'] ?? '';
    final idFm = itineraryResponse['id_fm'] ?? '';
    final name = itineraryResponse['name'] ?? '';
    final passengers = itineraryResponse['passenger_count'] ?? '';
    final valid_until = itineraryResponse['valid_until'] ?? '';
    final moneda = itineraryResponse['currency_type'] ?? '';
    final monedas_type = itineraryResponse['currency'] ?? '';
    final personalized_message =
        itineraryResponse['personalized_message'] ?? '';
    final main_image_itinerary = itineraryResponse['main_image'] ?? '';

    final itineraryJson = {
      'start_date': startDate,
      'end_date': endDate,
      'total': grossTotal,
      'status': status,
      'id_fm': idFm,
      'name': name,
      'passengers': passengers,
      'id': idItinerary,
      'valid_until': valid_until,
      'moneda': moneda,
      'monedas_type': monedas_type,
      'personalized_message': personalized_message,
      'main_image_itinerary': main_image_itinerary
    };

    print("Id del agente del itinerario:");
    print(idAgente);

    final agentResponse = await supabase
        .from('contacts')
        .select('name, email, user_image, last_name')
        .eq('user_id', idAgente)
        .maybeSingle();

    if (agentResponse == null) {
      print('Agente no encontrado');
      return {'error': 'Agente no encontrado'};
    }

    final agentName = agentResponse['name'] ?? '';
    final agentLastName = agentResponse['last_name'] ?? '';
    final agentEmail = agentResponse['email'] ?? '';
    final agentImage = agentResponse['user_image'] ?? '';

    // Crear un objeto JSON para el agente
    final agentJson = {
      'name': agentName,
      'lastname': agentLastName,
      'email': agentEmail,
      'image': agentImage
    };

    // 3. Obtener items del itinerario
    var itemsResponse = await supabase
        .from('itinerary_items')
        .select(
            'id, product_name, product_type, id_product, rate_name, destination, date, flight_departure, flight_arrival, departure_time, arrival_time, airline, hotel_nights,personalized_message')
        .eq('id_itinerary', idItinerary)
        .order('date', ascending: true);

// Mapeo de prioridades para los tipos de producto
    const Map<String, int> typePriority = {
      'Vuelos': 1,
      'Transporte': 2,
      'Hoteles': 3,
      'Servicios': 4,
      // Añade cualquier otro tipo con una prioridad mayor
    };

// Ordenar los elementos con la misma fecha según la prioridad del tipo
    List<Map<String, dynamic>> itemsOrderType =
        List<Map<String, dynamic>>.from(itemsResponse);
    itemsOrderType.sort((a, b) {
      // Primero comparar por fecha
      final dateA = a['date'] as String;
      final dateB = b['date'] as String;
      final dateComparison = dateA.compareTo(dateB);

      if (dateComparison != 0) {
        return dateComparison; // Si las fechas son diferentes, ordenar por fecha
      }

      // Si las fechas son iguales, ordenar por tipo de producto según la prioridad
      final typeA = a['product_type'] as String;
      final typeB = b['product_type'] as String;

      final priorityA =
          typePriority[typeA] ?? 999; // Valor alto para tipos desconocidos
      final priorityB = typePriority[typeB] ?? 999;

      return priorityA.compareTo(priorityB);
    });

// Ahora asignar los elementos ordenados de vuelta a itemsResponse
    itemsResponse = itemsOrderType;

    if (itemsResponse == null || itemsResponse.isEmpty) {
      print('No se encontraron items para el itinerario');
      return {'error': 'No se encontraron items'};
    }

    // 4. Procesar items
    List<Map<String, dynamic>> items = [];
    for (var item in itemsResponse) {
      final productType = item['product_type'];
      final productId = item['id_product'];
      final airline = item['airline'];
      final hotelNights = item['hotel_nights'];
      final product_name = item['product_name'];

      // Obtener imágenes del producto
      final List<String> imageUrls = await getProductImages(
        auth_token: authToken,
        entity_Id: productId,
      );

      if (productType == 'Hoteles') {
        // Consultar información adicional en la tabla `hotels`
        final hotelResponse = await supabase
            .from('hotels')
            .select(
                'name, description, main_image, inclutions, exclutions, recomendations')
            .eq('id', productId)
            .maybeSingle();

        if (hotelResponse != null) {
          items.add({
            'name': item['product_name'] ?? 'Nombre no disponible',
            'inclutions': hotelResponse['inclutions'] ?? '-',
            'exclutions': hotelResponse['exclutions'] ?? '-',
            'recomendations': hotelResponse['recomendations'] ?? '-',
            'rate_name': item['rate_name'] ?? 'Nombre no disponible',
            'destination': item['destination'] ?? 'Ubicación desconocida',
            'date': item['date'] ?? 'fecha desconocida',
            'description':
                hotelResponse['description'] ?? 'Descripción no disponible',
            'main_image': hotelResponse['main_image'] ??
                'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg', // Imagen genérica
            'product_type': 'Hoteles',
            'hotel_nights': hotelNights,
            'images': imageUrls,
            'personalized_message':
                item['personalized_message'] ?? '' // Añadido aquí
          });
        }
      } else if (productType == 'Servicios') {
        // No renderizar Fee bancario
        if (product_name == 'Fee bancario') continue;

        // Consultar información adicional en la tabla `activities`
        final activityResponse = await supabase
            .from('activities')
            .select(
                'name, description, main_image, inclutions, exclutions, recomendations, schedule_data')
            .eq('id', productId)
            .maybeSingle();

        if (activityResponse != null) {
          items.add({
            'name': item['product_name'] ?? 'Nombre no disponible',
            'inclutions': activityResponse['inclutions'] ?? '-',
            'exclutions': activityResponse['exclutions'] ?? '-',
            'recomendations': activityResponse['recomendations'] ?? '-',
            'rate_name': item['rate_name'] ?? 'Nombre no disponible',
            'destination': item['destination'] ?? 'Ubicación desconocida',
            'date': item['date'] ?? 'Fecha desconocida',
            'description':
                activityResponse['description'] ?? 'Descripción no disponible',
            'main_image': activityResponse['main_image'] ??
                'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg', // Imagen genérica
            'product_type': 'Servicios',
            'images': imageUrls,
            'personalized_message': item['personalized_message'] ?? '',
            'schedule': activityResponse['schedule_data'] ?? '-',
          });
        }
      } else if (productType == 'Vuelos') {
        // Consultar información adicional en la tabla `flights`
        final flightsResponse = await supabase
            .from('airlines')
            .select('logo_png, name')
            .eq('id', airline)
            .maybeSingle();

        if (flightsResponse != null) {
          items.add({
            'name': 'Vuelo a ${item['flight_arrival']?.split('-')?[1] ?? '--'}',
            'destination': item['flight_arrival']?.split('-')[1] ?? '--',
            'departure': item['flight_departure']?.split('-')[1] ?? '--',
            'iata_destination': item['flight_arrival']?.split('-')[0] ?? '--',
            'iata_departure': item['flight_departure']?.split('-')[0] ?? '--',
            'date': item['date'] ?? 'Fecha desconocida',
            'departure_time': item['departure_time'] ?? '--',
            'arrival_time': item['arrival_time'] ?? '--',
            'main_image': flightsResponse['logo_png'] ??
                'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/despegar.png',
            'product_type': 'Vuelos',
            'personalized_message':
                item['personalized_message'] ?? '' // Añadido aquí
          });
        }
      } else if (productType == 'Transporte') {
        // Consultar información adicional en la tabla `transfers`

        //if (activityResponse != null) {
        items.add({
          'name': item['product_name'] ?? 'Nombre no disponible',
          'date': item['date'] ?? 'Fecha desconocida',
          'destination': item['destination'] ?? 'Ubicación desconocida',
          'rate_name': item['rate_name'] ?? '--',
          'departure_time': item['departure_time'] ?? '--',
          'main_image':
              'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/transfer.jpeg',
          'product_type': 'Transporte',
          'personalized_message':
              item['personalized_message'] ?? '' // Añadido aquí
        });
        //}
      }
    }

    // 5. Crear el JSON final
    final orderJson = {
      'account': accountJson,
      'contact': contatctJSon,
      'itinerary': itineraryJson,
      'agent': agentJson,
      'items': items
    };

    // Retornar el JSON final
    return orderJson;
  } catch (e) {
    print('Error al generar el JSON: $e');
    return {'error': e.toString()};
  }
}
