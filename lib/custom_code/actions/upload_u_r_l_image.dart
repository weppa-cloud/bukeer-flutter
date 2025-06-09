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

import 'index.dart'; // Imports other custom actions.

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> uploadURLImage(
  List<String> fileUrls,
  String entityId,
  String accountId,
  String apiKey,
) async {
  final client = Supabase.instance.client;

  // Lista para almacenar URLs no aceptadas
  List<String> invalidUrls = [];

  // Lista de extensiones de imágenes válidas
  final validImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'avif',
    'bmp',
    'jfif'
  ];

  for (var i = 0; i < fileUrls.length; i++) {
    final imageUrl = fileUrls[i];

    // Obtener la extensión del archivo desde la URL
    final fileExtension = imageUrl.split('.').last.toLowerCase();

    // Verificar si la extensión es válida
    if (!validImageExtensions.contains(fileExtension)) {
      // Si no es una imagen válida, agregar a la lista de URLs no aceptadas
      invalidUrls.add(imageUrl);
      print('URL no aceptada (formato no válido): $imageUrl');

      // Eliminar el objeto no aceptado de Supabase inmediatamente
      await deleteImageFromSupabase(imageUrl, apiKey);
      continue; // Saltar al siguiente archivo
    }

    try {
      // Insertar la URL en la tabla `images`
      final insertResponse = await client.from('images').insert(
          {'url': imageUrl, 'entity_id': entityId, 'account_id': accountId});

      if (insertResponse.error != null) {
        print('Error al agregar URL: ${insertResponse.error!.message}');
      }
    } catch (e) {
      print('Error inesperado: $e');
    }
  }
}
