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

Future<bool> deleteScheduleActivity(
  String activityId, // ID del registro de la actividad
  String itemId, // ID del item a eliminar
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

    // Filtrar el array para eliminar el ítem con el ID especificado
    scheduleData = scheduleData.where((item) => item['id'] != itemId).toList();

    // Actualizar el registro en Supabase con el array modificado
    await supabase
        .from('activities')
        .update({'schedule_data': scheduleData}).eq('id', activityId);

    return true; // Operación exitosa
  } catch (e) {
    print('Error eliminando ítem del schedule: $e');
    return false; // En caso de error, devolvemos false
  }
}
