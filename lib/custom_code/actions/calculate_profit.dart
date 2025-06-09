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

Future<String> calculateProfit(
    String costo, // Valor del costo ingresado
    String total // Valor del total ingresado
    ) async {
  // Convertir valores a double
  final double? costoValue = double.tryParse(costo);
  double? totalValue = double.tryParse(total);

  if (costoValue != null &&
      totalValue != null &&
      totalValue > 0 &&
      costoValue > 0) {
    // Redondear el total a dos decimales para ser consistente
    totalValue = double.parse(totalValue.toStringAsFixed(2));

    // Calcular el profit usando la fórmula simple de markup:
    // profit = ((total - costo) / costo) * 100
    double profitResult = ((totalValue - costoValue) / costoValue) * 100;

    // Buscamos una precisión que garantice que el total recalculado
    // con dos decimales coincida exactamente con el total original
    for (int precision = 1; precision <= 15; precision++) {
      // Redondear el resultado al número de decimales actual
      String valueWithPrecision = profitResult.toStringAsFixed(precision);
      double calculatedValue = double.parse(valueWithPrecision);

      // Recalcular el total usando el profit redondeado y la fórmula de markup
      // total = costo * (1 + profit/100)
      double recalculatedTotal = costoValue * (1 + (calculatedValue / 100));

      // Redondear el total recalculado a dos decimales
      recalculatedTotal = double.parse(recalculatedTotal.toStringAsFixed(2));

      // Verificar si el total recalculado coincide exactamente con el total original
      if (recalculatedTotal == totalValue) {
        return valueWithPrecision;
      }
    }

    // Si no encontramos una precisión exacta, vamos a hacer un ajuste iterativo
    // Buscaremos el porcentaje que, al recalcularlo, dé exactamente el total con dos decimales
    double adjustedPercentage = profitResult;
    double step = 0.00001; // Paso muy pequeño para ajuste fino

    // Intentamos con valores ligeramente mayores
    for (int i = 0; i < 10000; i++) {
      adjustedPercentage += step;

      // Recalcular el total usando el porcentaje ajustado
      double recalculatedTotal = costoValue * (1 + (adjustedPercentage / 100));

      // Redondear el total recalculado a dos decimales
      recalculatedTotal = double.parse(recalculatedTotal.toStringAsFixed(2));

      if (recalculatedTotal == totalValue) {
        // Encontramos un valor que funciona perfectamente
        return adjustedPercentage.toString();
      }
    }

    // Si no funcionó incrementando, intentamos decrementando
    adjustedPercentage = profitResult;

    for (int i = 0; i < 10000; i++) {
      adjustedPercentage -= step;

      if (adjustedPercentage <= 0) break; // Evitamos valores negativos

      // Recalcular el total usando el porcentaje ajustado
      double recalculatedTotal = costoValue * (1 + (adjustedPercentage / 100));

      // Redondear el total recalculado a dos decimales
      recalculatedTotal = double.parse(recalculatedTotal.toStringAsFixed(2));

      if (recalculatedTotal == totalValue) {
        // Encontramos un valor que funciona perfectamente
        return adjustedPercentage.toString();
      }
    }

    // Si aún no encontramos una coincidencia exacta, devolvemos el valor inicial
    return profitResult.toString();
  }

  // Si no se puede calcular, devuelve vacío
  return '';
}
