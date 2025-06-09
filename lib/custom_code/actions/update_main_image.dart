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

Future<void> updateMainImage(String type, String id, String url) async {
  final client = Supabase.instance.client;

  try {
    print('Argumentos recibidos:');
    print('type: $type');
    print('id: $id');
    print('url: $url');
    // Determinar la tabla y el campo a actualizar según el `type`
    String tableName;

    switch (type) {
      case 'activities':
        tableName = 'activities';
        break;
      case 'hotels':
        tableName = 'hotels';
        break;
      case 'transfers':
        tableName = 'transfers';
        break;
      default:
        throw Exception('Tipo no soportado: $type');
    }

    // Actualizar la tabla correspondiente con la URL en el campo `main_image`
    final updateResponse =
        await client.from(tableName).update({'main_image': url}).eq('id', id);

    if (updateResponse.error != null) {
      print('Error al actualizar $type: ${updateResponse.error!.message}');
    } else {
      print('$type actualizado exitosamente con URL: $url');
    }
  } catch (e) {
    print('Error inesperado: $e');
  }
}
