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

Future<void> deleteImageFromSupabase(
  String imageUrl,
  String apiKey,
) async {
  if (imageUrl.isEmpty) {
    return;
  }

  // Crear cliente de Supabase dinámicamente con la clave API proporcionada
  final supabaseUrl = 'https://wzlxbpicdcdvxvdcvgas.supabase.co';
  final client = SupabaseClient(supabaseUrl, apiKey);

  try {
    // Extraer el bucket y el path completo de la URL de la imagen
    final uri = Uri.parse(imageUrl);

    // Detectar el bucket automáticamente (cuarto segmento) y extraer el path del archivo
    final bucket = uri.pathSegments[4]; // El bucket es el cuarto segmento
    final imagePath =
        uri.pathSegments.sublist(5).join('/'); // Ruta completa del archivo

    // Realizar la solicitud para eliminar la imagen
    final response = await client.storage.from(bucket).remove([imagePath]);

    // Verificar si la respuesta contiene objetos eliminados
    if (response.isNotEmpty) {
      response.forEach((fileObject) {});
    } else {
      print('No se encontró el archivo para eliminar o no se pudo eliminar.');
    }
  } catch (e) {
    print('Error inesperado al eliminar la imagen: $e');
  }
}
