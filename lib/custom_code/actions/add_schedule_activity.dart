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

import 'package:uuid/uuid.dart';

Future<bool> addScheduleActivity(
  String idProduct,
  String? title,
  String? description,
  String? image,
) async {
  // Obtener la instancia del cliente de Supabase
  final supabase = Supabase.instance.client;
  try {
    // Obtener el registro actual para conseguir el array existente de itinerary
    final response = await supabase
        .from('activities')
        .select('schedule_data')
        .eq('id', idProduct)
        .maybeSingle();

    // Crear un UUID único para el nuevo elemento
    final uuid = Uuid();
    final String itemId = uuid.v4(); // Genera un UUID v4

    // Preparar el nuevo ítem a insertar con ID único
    final newItem = {
      'id': itemId, // Agregamos el ID único
      'image': image ?? '',
      'title': title ?? '',
      'description': description ?? '',
    };

    // Obtener el array existente o crear uno nuevo si no existe
    List<dynamic> currentItinerary = [];
    if (response != null && response['schedule_data'] != null) {
      currentItinerary = List<dynamic>.from(response['schedule_data']);
    }

    // Agregar el nuevo ítem al final del array
    currentItinerary.add(newItem);

    // Actualizar el registro en Supabase con el nuevo array de itinerary
    final updateResponse = await supabase
        .from('activities')
        .update({'schedule_data': currentItinerary}).eq('id', idProduct);

    return true; // Operación exitosa
  } catch (e) {
    print('Error agregando ítem al itinerario: $e');
    return false; // En caso de error, devolvemos false
  }
}
