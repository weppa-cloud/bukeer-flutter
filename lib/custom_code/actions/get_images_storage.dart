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

import 'dart:convert';

Future<List<dynamic>> getImagesStorage() async {
  try {
    final supabase = SupaFlow.client;
    final storageResponse = await supabase.storage
        .from('images')
        .list(path: 'assets/itinerary-default-images');

    List<Map<String, dynamic>> imagesList = [];

    for (final file in storageResponse) {
      final String imagePath = supabase.storage
          .from('images')
          .getPublicUrl('assets/itinerary-default-images/${file.name}');

      // Crear un objeto JSON simplificado con solo url y name
      Map<String, dynamic> imageObject = {
        'url': imagePath,
        'name': file.name,
      };

      imagesList.add(imageObject);
    }

    // Si no hay imágenes, añadir un placeholder
    if (imagesList.isEmpty) {
      imagesList.add({
        'url': 'https://via.placeholder.com/150',
        'name': 'placeholder.jpg',
      });
    }

    return imagesList;
  } catch (e) {
    print('Error al obtener imágenes del storage: $e');
    return [
      {
        'url': 'https://via.placeholder.com/150',
        'name': 'error.jpg',
      }
    ];
  }
}
