import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '../backend/schema/structs/index.dart';
import '../backend/supabase/supabase.dart';
import '../auth/supabase_auth/auth_util.dart';

double? calculateTotalOrProfit(
  String costo,
  String? profit,
  String? total,
) {
  // Convertir valores a double
  final double? costoValue = double.tryParse(costo ?? '');
  final double? profitValue = double.tryParse(profit ?? '');
  final double? totalValue = double.tryParse(total ?? '');

  // Verificar si costo y profit están llenos, calcular total
  if (costoValue != null && profitValue != null) {
    final result = costoValue / (1 - (profitValue / 100));
    return double.parse(result.toStringAsFixed(1)); // Redondear a 1 decimal
  }

  // Verificar si costo y total están llenos, calcular profit
  if (costoValue != null && totalValue != null && costoValue > 0) {
    final result = (1 - (costoValue / totalValue)) * 100;
    return double.parse(result.toStringAsFixed(1)); // Redondear a 1 decimal
  }

  // Si no se puede calcular, retornar null
  return null;
}

List<dynamic>? accountCurrencyJsonCopy(
  String? baseCurrency,
  List<dynamic>? currencyList,
) {
  // Inicializamos la lista si es null
  currencyList ??= [];

  if (baseCurrency == null || baseCurrency.isEmpty) {
    return currencyList; // Si no hay moneda base, devolvemos la lista actual
  }

  // Verificar si la nueva base ya existe como una moneda opcional
  bool isNewBaseAnOptional = currencyList
      .any((item) => item["name"] == baseCurrency && item["type"] == "opt");

  if (isNewBaseAnOptional) {
    return currencyList; // No cambiar la base si ya es opcional
  }

  // Encontrar la moneda base actual en la lista
  int currentBaseIndex =
      currencyList.indexWhere((item) => item["type"] == "base");

  if (currentBaseIndex != -1) {
    // Convertir la base actual en opcional manteniendo su tasa
    Map<String, dynamic> currentBase = currencyList.removeAt(currentBaseIndex);
    currentBase["type"] = "opt";
    currencyList.add(currentBase); // Reinsertamos la antigua base como opcional
  }

  // Agregar la nueva base al inicio
  currencyList.insert(0, {"name": baseCurrency, "type": "base", "rate": 1});

  return currencyList;
}

dynamic returnJson(String? jsonString) {
/*
  // Verificamos si jsonString no es nulo
  if (jsonString == null) {
    debugPrint('El JSON es nulo.');
    return null;
  }

  try {
    // Parseamos el string JSON recibido
    final parsedData = json.decode(jsonString);

    // Si es un array y no está vacío, tomamos el primer elemento
    if (parsedData is List && parsedData.isNotEmpty) {
      return parsedData[0]; // Retornamos el primer objeto como Map
    }

    // Si es un objeto directamente, lo retornamos como está
    if (parsedData is Map<String, dynamic>) {
      return parsedData;
    }
  } catch (e) {
    // Manejo de errores si el JSON no es válido
    debugPrint('Error parsing JSON: $e');
  }

  // Si el formato es inválido, devolvemos null
  return null;
*/
}

List<dynamic>? accountCurrencyJson(
  String? baseCurrency,
  String? optCurrency,
  double? rate,
  List<dynamic>? currencyList,
) {
  // Inicializamos la lista si es null
  currencyList ??= [];

  if (baseCurrency == null || baseCurrency.isEmpty) {
    return currencyList; // Si no hay moneda base, devolvemos la lista actual
  }

  // Encontrar la moneda base actual en la lista
  int currentBaseIndex =
      currencyList.indexWhere((item) => item["type"] == "base");
  Map<String, dynamic>? currentBase =
      currentBaseIndex != -1 ? currencyList[currentBaseIndex] : null;

  // Verificar si la nueva base ya existe como una moneda opcional
  bool isNewBaseAnOptional = currencyList
      .any((item) => item["name"] == baseCurrency && item["type"] == "opt");

  if (isNewBaseAnOptional) {
    return currencyList; // No cambiar la base si ya es opcional
  }

  // Si la nueva base es diferente de la actual y no es opcional, hacer el cambio
  if (currentBase != null && currentBase["name"] != baseCurrency) {
    // Convertir la base actual en opcional manteniendo su tasa
    currentBase["type"] = "opt";

    // Insertar la nueva base al inicio con rate 1
    currencyList.insert(0, {"type": "base", "name": baseCurrency, "rate": 1});
  } else if (currentBase == null) {
    // Si no hay una base, establecer la nueva base
    currencyList.insert(0, {"type": "base", "name": baseCurrency, "rate": 1});
  }

  // Validar que la moneda opcional no sea vacía y distinta de la base
  if (optCurrency != null &&
      optCurrency.isNotEmpty &&
      optCurrency != baseCurrency &&
      rate != null) {
    int existingIndex =
        currencyList.indexWhere((item) => item["name"] == optCurrency);

    if (existingIndex != -1) {
      // Si la moneda opcional ya existe, actualizamos su tasa
      currencyList[existingIndex]["rate"] = rate;
    } else {
      // Si no existe, la agregamos
      currencyList.add({"type": "opt", "name": optCurrency, "rate": rate});
    }
  }

  return currencyList;
}

double? costMultiCurrenty(
  List<dynamic>? listCurrenty,
  String? typeCurrenty,
  double? cost,
) {
  if (listCurrenty == null || typeCurrenty == null || cost == null) {
    return null; // Retorna null si alguno de los parámetros es nulo
  }

  // Busca el objeto en listCurrenty donde el name coincida con typeCurrenty
  final currency = listCurrenty.firstWhere(
    (item) => item["name"] == typeCurrenty,
    orElse: () => {},
  );

  // Si no se encuentra una coincidencia, retorna null
  if (currency.isEmpty) {
    return null;
  }

  // Extrae el rate y realiza la multiplicación
  double rate = currency["rate"] ?? 1.0;
  return cost * rate;
}

bool showBtnReserva(dynamic data) {
  // Verifica si data es un Map y contiene la clave 'reservation_status'
  if (data is Map && data.containsKey('reservation_status')) {
    // Accede a 'reservation_status' de manera segura
    final reservationStatus = data['reservation_status'];

    // Si reservationStatus es true, ocultar el botón (retornar false)
    if (reservationStatus == false) {
      return false;
    }
  }

  // Si no se cumple la condición, mostrar el botón (retornar true)
  return true;
}

double? getExchangeRate(
  List<dynamic>? listCurrenty,
  String? typeCurrenty,
) {
  if (listCurrenty == null || typeCurrenty == null) {
    return null; // Retorna null si alguno de los parámetros es nulo
  }

  // Busca el objeto en listCurrenty donde el name coincida con typeCurrenty
  final currency = listCurrenty.firstWhere(
    (item) => item["name"] == typeCurrenty,
    orElse: () => {},
  );

  // Si no se encuentra una coincidencia, retorna null
  if (currency.isEmpty) {
    return null;
  }

  // Extrae el rate
  double rate = currency["rate"] ?? 1.0;

  // Si la moneda no es COP, invertir la tasa
  if (typeCurrenty != "COP") {
    rate = 1 / rate;
  }

  return rate;
}

bool showBtnRegistrarPago(dynamic data) {
  if (data is Map && data.containsKey('pending_paid_cost')) {
    // Accede a 'reservation_status' de manera segura
    final pending_paid_cost = data['pending_paid_cost'];

    // Si reservationStatus es true, ocultar el botón (retornar false)
    if (pending_paid_cost <= 0) {
      return true;
    }
  }

  // Si no se cumple la condición, mostrar el botón (retornar true)
  return false;
}

dynamic convertCurrencyOptToBase(
  double amount,
  String currency,
  List<dynamic>? rates,
) {
  try {
    // Verificar si rates es nulo
    if (rates == null || rates.isEmpty) {
      return amount; // Devolver valor original
    }

    // Encontrar la moneda base
    Map<String, dynamic>? baseRate;
    for (var rate in rates) {
      if (rate['type'] == 'base') {
        baseRate = rate;
        break;
      }
    }

    if (baseRate == null) {
      return amount; // Devolver valor original
    }

    String baseCurrency = baseRate['name'];

    // Si la moneda ya es la base, no hacer conversión
    if (currency == baseCurrency) {
      // Redondear a máximo 2 decimales
      return (amount * 100).round() / 100;
    }

    // Buscar la tasa de la moneda de entrada
    Map<String, dynamic>? currencyRate;
    for (var rate in rates) {
      if (rate['name'] == currency) {
        currencyRate = rate;
        break;
      }
    }

    if (currencyRate == null) {
      return amount; // Devolver valor original
    }

    // Convertir a la moneda base
    // Si tenemos por ejemplo 500USD y base es COP, dividimos por la tasa
    double convertedAmount = amount / currencyRate['rate'];

    // Redondear a máximo 2 decimales
    return (convertedAmount * 100).round() / 100;
  } catch (e) {
    // En caso de cualquier error, devolver el valor original
    return amount;
  }
}

dynamic convertCurrencyBaseToOpt(
  double amount,
  String currency,
  List<dynamic>? rates,
) {
  try {
    // Verificar si rates es nulo
    if (rates == null || rates.isEmpty) {
      return amount; // Devolver valor original
    }

    // Encontrar la moneda base
    Map<String, dynamic>? baseRate;
    for (var rate in rates) {
      if (rate['type'] == 'base') {
        baseRate = rate;
        break;
      }
    }

    if (baseRate == null) {
      return amount; // Devolver valor original
    }

    String baseCurrency = baseRate['name'];

    // Si la moneda destino es la misma que la base, no hacer conversión
    if (currency == baseCurrency) {
      // Redondear a máximo 2 decimales
      return (amount * 100).round() / 100;
    }

    // Buscar la tasa de la moneda destino
    Map<String, dynamic>? currencyRate;
    for (var rate in rates) {
      if (rate['name'] == currency) {
        currencyRate = rate;
        break;
      }
    }

    if (currencyRate == null) {
      return amount; // Devolver valor original
    }

    // Convertir de la moneda base a la moneda destino
    // Si tenemos por ejemplo 500COP y queremos pasarlo a USD, multiplicamos por la tasa
    double convertedAmount = amount * currencyRate['rate'];

    // Redondear a máximo 2 decimales
    return (convertedAmount * 100).round() / 100;
  } catch (e) {
    // En caso de cualquier error, devolver el valor original
    return amount;
  }
}

String calculateTotalFunction(
  String costo,
  String profit,
) {
  // Convertir valores a double
  final double? costoValue = double.tryParse(costo);
  double? profitValue = double.tryParse(profit);

  // Si se ingresan costo y profit válidos, calcular el total
  if (costoValue != null && profitValue != null) {
    double total;

    // Usar la fórmula simple de markup/porcentaje sobre costo:
    // total = costo * (1 + porcentaje/100)
    total = costoValue * (1 + (profitValue / 100));

    // Redondear el resultado a 2 decimales
    return total.toStringAsFixed(2);
  }

  // Si no se puede calcular, devuelve un mensaje vacío
  return '';
}

List<dynamic>? accountTypesIncreaseJson(
  List<dynamic>? types,
  String? name,
  double? rate,
) {
  // Inicializamos la lista si es null
  types ??= [];

  // Verificar si name y rate son válidos
  if (name == null || name.isEmpty || rate == null) {
    return types; // Si no hay nombre o rate, devolvemos la lista actual
  }

  // Buscar el índice del elemento con el nombre proporcionado
  int existingIndex = types.indexWhere((item) => item["name"] == name);

  if (existingIndex != -1) {
    // Si el elemento existe, actualizamos su rate
    types[existingIndex]["rate"] = rate;
  } else {
    // Si no existe, lo agregamos
    types.add({"name": name, "rate": rate});
  }

  return types;
}

double? accountIncreasePercentage(
  List<dynamic>? types,
  String? requestType,
) {
  // Verificar si los inputs son nulos
  if (types == null || requestType == null || types.isEmpty) {
    return null;
  }

  // Convertir requestType a minúsculas para hacer la comparación insensible a mayúsculas
  String requestTypeLower = requestType.toLowerCase();

  // Buscar el elemento en la lista que coincida con el requestType
  for (var type in types) {
    // Verificar si el tipo es un mapa y contiene las claves necesarias
    if (type is Map && type.containsKey('name') && type.containsKey('rate')) {
      // Convertir el nombre a minúsculas para comparar
      String typeName = type['name'].toString().toLowerCase();

      // Si coincide, devolver el rate
      if (typeName == requestTypeLower) {
        // Asegurarse de que rate sea un valor numérico
        var rate = type['rate'];
        if (rate is num) {
          return rate.toDouble();
        } else if (rate is String) {
          // Intentar convertir si es una cadena
          return double.tryParse(rate);
        }
      }
    }
  }

  // Si no se encuentra coincidencia, devolver null
  return null;
}

List<dynamic>? addPaymentMethod(
  List<dynamic>? paymentmethods,
  String? name,
) {
  // Inicializamos la lista si es null
  paymentmethods ??= [];

  // Verificar si name es válido
  if (name == null || name.isEmpty) {
    return paymentmethods; // Si no hay nombre, devolvemos la lista actual
  }

  // Buscar el índice del elemento con el nombre proporcionado
  int existingIndex = paymentmethods.indexWhere((item) => item["name"] == name);

  if (existingIndex != -1) {
    // Si el elemento ya existe, no hacemos nada
  } else {
    // Encontrar el ID máximo actual en la lista
    int maxId = -1; // Comenzamos con -1 para que el primer elemento sea 0

    for (var method in paymentmethods) {
      if (method.containsKey("id") &&
          method["id"] is int &&
          method["id"] > maxId) {
        maxId = method["id"];
      }
    }

    // Si no existe, lo agregamos con el campo "name" y un "id" autoincremental
    paymentmethods.add({"id": maxId + 1, "name": name});
  }

  return paymentmethods;
}

List<dynamic>? editOrRemovePaymentMethod(
  bool? edit,
  int? id,
  List<dynamic>? paymentmethods,
  String? name,
) {
  // Inicializamos la lista si es null
  paymentmethods ??= [];

  // Verificamos si el id es válido
  if (id == null) {
    return paymentmethods; // Si no hay id, devolvemos la lista actual
  }

  // Buscar el índice del elemento con el id proporcionado
  int existingIndex = paymentmethods.indexWhere((item) => item["id"] == id);

  // Si no encontramos el elemento con ese id, devolvemos la lista sin cambios
  if (existingIndex == -1) {
    return paymentmethods;
  }

  // Si edit es true, actualizamos el nombre
  if (edit == true) {
    // Solo actualizamos si el nombre es válido
    if (name != null && name.isNotEmpty) {
      paymentmethods[existingIndex]["name"] = name;
    }
  }
  // Si edit es false, eliminamos el elemento y reorganizamos los IDs
  else if (edit == false) {
    paymentmethods.removeAt(existingIndex);

    // Reorganizar los IDs después de eliminar
    for (int i = 0; i < paymentmethods.length; i++) {
      if (paymentmethods[i] is Map && paymentmethods[i].containsKey("id")) {
        paymentmethods[i]["id"] = i;
      }
    }
  }

  return paymentmethods;
}

int? calculatenights(
  String endDate,
  String startDate,
) {
  DateTime end = DateTime.parse(endDate);
  DateTime start = DateTime.parse(startDate);
  Duration difference = end.difference(start);
  int days = difference.inDays;
  return days;
}

String calculateDate(
  String dateStart,
  int nights,
) {
  String dateReturn = "";
  if (dateStart != "stop") {
    DateTime dateSt = DateTime.parse(dateStart);
    DateTime dateEnd = dateSt.add(Duration(days: nights));
    dateReturn = DateFormat('yyyy-MM-dd').format(dateEnd);
  }
  return dateReturn;
}

double? jsonArraySummation(
  List<dynamic> arrayJson,
  String field,
) {
  List<Map<String, dynamic>> productos = arrayJson.cast<Map<String, dynamic>>();

  String campoASumar = field;
  double sumaTotal = 0.0;

  sumaTotal = productos
      .map<double>((producto) => producto[campoASumar] as double)
      .reduce((a, b) => a + b);

  return sumaTotal;
}
