// Automatic FlutterFlow imports
import '../../backend/schema/structs/index.dart';
import '../../backend/supabase/supabase.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:bukeer/legacy/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> editScheduleActivity(
  String activityId, // ID del registro de la actividad
  String itemId, // ID del item dentro del array
  String? title, // Nuevo título (opcional)
  String? description, // Nueva descripción (opcional)
  String? image, // Nueva imagen (opcional)
) async {
  // Obtener la instancia del cliente de Supabase
  final supabase = Supabase.instance.client;

  try {
    // Obtener el registro actual para conseguir el array existente de schedule_data
    final response = await supabase
        .from('activities')
        .select('schedule_data')
        .eq('id', activityId)
        .maybeSingle();

    // Verificar que el registro existe y tiene un array schedule_data
    if (response == null || response['schedule_data'] == null) {
      print('No se encontró el registro o no tiene schedule_data');
      return false;
    }

    // Convertir el array existente a una lista de Dart
    List<dynamic> scheduleData = List<dynamic>.from(response['schedule_data']);

    // Buscar el índice del ítem a modificar por su ID
    int itemIndex = scheduleData.indexWhere((item) => item['id'] == itemId);

    // Verificar si se encontró el ítem
    if (itemIndex == -1) {
      print('No se encontró el ítem con ID: $itemId');
      return false;
    }

    // Actualizar los campos del ítem, manteniendo los valores originales si no se proporcionan nuevos
    scheduleData[itemIndex] = {
      'id': itemId, // Mantener el mismo ID
      'title': (title == null || title.isEmpty)
          ? scheduleData[itemIndex]['title']
          : title,
      'description': (description == null || description.isEmpty)
          ? scheduleData[itemIndex]['description']
          : description,
      'image': (image == null || image.isEmpty)
          ? scheduleData[itemIndex]['image']
          : image,
    };
    // Actualizar el registro en Supabase con el array modificado
    await supabase
        .from('activities')
        .update({'schedule_data': scheduleData}).eq('id', activityId);

    return true; // Operación exitosa
  } catch (e) {
    print('Error editando ítem del schedule: $e');
    return false; // En caso de error, devolvemos false
  }
}
