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
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

Future<List<dynamic>> setMessageReservation(
  String idItem,
  String message,
  String type,
) async {
  // Obtener la instancia del cliente de Supabase
  final supabase = Supabase.instance.client;

  // Verificar que el mensaje no esté vacío
  if (message.trim().isEmpty) {
    return [];
  }

  try {
    // 1. Leer el registro actual para obtener los mensajes existentes
    final response = await supabase
        .from('itinerary_items')
        .select('reservation_messages')
        .eq('id', idItem)
        .maybeSingle();

    // 2. Generar un UUID v4 para el nuevo mensaje
    final uuid = Uuid();
    final String messageId = uuid.v4();

    // 3. Obtener la fecha actual en formato "d MMM yyyy" (ej: "3 Abr 2025")
    final DateTime now = DateTime.now();
    final DateFormat formatter =
        DateFormat('d MMM yyyy', 'es'); // Formato en español
    final String formattedDate = formatter.format(now);

    // 4. Crear el nuevo mensaje con el campo date
    final newMessage = {
      'id': messageId,
      'type': type,
      'message': message,
      'date': formattedDate, // Añadimos la fecha actual formateada
    };

    // 5. Inicializar o recuperar el array de mensajes
    List<dynamic> messages = [];
    if (response != null && response['reservation_messages'] != null) {
      // Verificamos si es un array
      if (response['reservation_messages'] is List) {
        messages = List.from(response['reservation_messages']);
      }
    }

    // 6. Añadir el nuevo mensaje al final
    messages.add(newMessage);

    // 7. Devolver el array completo de mensajes
    return messages;
  } catch (e) {
    print('Error en setMessageReservation: $e');
    return [];
  }
}
