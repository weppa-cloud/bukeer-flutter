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

Future<String> calculateTotal(
    String costo, // Valor del costo ingresado
    String profit // Valor del porcentaje ingresado
    ) async {
  // Convertir valores a double
  final double? costoValue = double.tryParse(costo);
  double? profitValue = double.tryParse(profit);

  // Si se ingresan costo y profit, calcular el total
  if (costoValue != null && profitValue != null) {
    double total;

    // Usar la fórmula simple de markup/porcentaje sobre costo:
    // total = costo * (1 + porcentaje/100)
    total = costoValue * (1 + (profitValue / 100));

    // Redondear el resultado a 2 decimales
    final totalFormatted = total.toStringAsFixed(2);
    return totalFormatted;
  }

  // Si no se puede calcular, devuelve un mensaje vacío
  return '';
}
