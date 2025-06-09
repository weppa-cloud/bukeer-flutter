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

import '../../../backend/supabase/supabase.dart'; // Asegúrate de tener este import

Future<bool> validategPaid(
    double inputAmount, String id, String typeTransaction) async {
  final supabase = Supabase.instance.client;

  if (typeTransaction == 'ingreso') {
    // Obtener el valor de pending_paid de la tabla itineraries
    final response = await supabase
        .from('itineraries')
        .select('pending_paid')
        .eq('id', id)
        .single(); // Obtén solo un registro si solo deseas comparar con uno específico

    // Verificar si hay un error
    if (response == null) {
      print('Error al obtener los datos');
      return false; // Retornar false si ocurre un error
    }

    // Obtener el valor de pending_paid de la respuesta
    double pendingPaid = response['pending_paid'];

    // Comparar el inputAmount con pending_paid
    if (inputAmount > pendingPaid) {
      return false; // Si el valor es mayor, retornamos false
    }

    return true; // Si el valor es válido (no mayor), retornamos true
  } else if (typeTransaction == 'egreso') {
    // Obtener el valor de pending_paid_cost de la tabla itinerary_items
    final response = await supabase
        .from('itinerary_items')
        .select('pending_paid_cost')
        .eq('id', id)
        .single(); // Obtén solo un registro si solo deseas comparar con uno específico

    // Verificar si hay un error
    if (response == null) {
      print('Error al obtener los datos');
      return false; // Retornar false si ocurre un error
    }

    // Obtener el valor de pending_paid_cost de la respuesta
    double pendingPaidCost = response['pending_paid_cost'];

    // Comparar el inputAmount con pending_paid_cost
    if (inputAmount > pendingPaidCost) {
      return false; // Si el valor es mayor, retornamos false
    }

    return true; // Si el valor es válido (no mayor), retornamos true
  } else {
    print('Tipo de transacción no válido');
    return false; // Retornar false si el tipo de transacción no es válido
  }
}
