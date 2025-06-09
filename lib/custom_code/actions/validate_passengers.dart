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

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> validatePassengers(String itinerary) async {
  // Obtener la instancia del cliente de Supabase
  final supabase = Supabase.instance.client;

  try {
    // Paso 1: Consultar la tabla de itinerarios para obtener el passenger_count
    final itineraryResponse = await supabase
        .from('itineraries')
        .select('passenger_count')
        .eq('id', itinerary)
        .maybeSingle();

    // Verificar si se encontró el itinerario
    if (itineraryResponse == null) {
      return false; // No se encontró el itinerario
    }

    // Obtener el passenger_count esperado
    final int expectedPassengerCount = itineraryResponse['passenger_count'];

    // Paso 2: Contar cuántos pasajeros están asociados con este itinerario
    // Obtenemos todos los registros y contamos manualmente
    final passengersResponse =
        await supabase.from('passenger').select().eq('itinerary_id', itinerary);

    // Obtener el conteo actual de pasajeros contando la lista de resultados
    final int actualPassengerCount = passengersResponse.length;

    // Paso 3: Comparar los conteos y devolver el resultado
    return actualPassengerCount == expectedPassengerCount;
  } catch (e) {
    print('Error validando pasajeros: $e');
    return false; // En caso de error, devolvemos false
  }
}
