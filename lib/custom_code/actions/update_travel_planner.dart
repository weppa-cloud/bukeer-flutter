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

Future<bool> updateTravelPlanner(
  String itineraryId,
  String newAgentId,
) async {
  try {
    // Actualizar el campo agent en la tabla itineraries
    final response = await SupaFlow.client
        .from('itineraries')
        .update({
          'agent': newAgentId,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', itineraryId)
        .select();

    // Verificar si la actualización fue exitosa
    if (response != null && response.isNotEmpty) {
      debugPrint('Travel Planner actualizado exitosamente');
      return true;
    } else {
      debugPrint('Error al actualizar Travel Planner: respuesta vacía');
      return false;
    }
  } catch (e) {
    debugPrint('Error al actualizar Travel Planner: $e');
    return false;
  }
}
