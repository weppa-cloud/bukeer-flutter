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

import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'dart:math' as math;
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;

const PdfColor green = PdfColor.fromInt(0xff9ce5d0);
const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
final PdfColor colorBrandBlue = PdfColor(0.12, 0.29, 0.65);
const sep = 120.0;

final format = PdfPageFormat.a4;

// Función para guardar el PDF en segundo plano
Future<Uint8List> saveDocumentInBackground(pw.Document doc) async {
  final completer = Completer<Uint8List>();

  // Mover la operación de guardado a un isolate separado
  try {
    // Intentar primero con opciones estándar
    final result = await compute((document) async {
      try {
        return await document.save();
      } catch (e) {
        print('Error guardando PDF con opciones estándar: $e');
        return Uint8List(0);
      }
    }, doc);

    // Si el resultado es vacío, intentar con opciones más seguras
    if (result.isEmpty) {
      print('Intentando guardar PDF con opciones alternativas...');

      // Crear un nuevo documento con opciones más seguras
      final newDoc = pw.Document(
        compress: false,
        verbose: false,
        version: PdfVersion.pdf_1_5,
      );

      // Copiar páginas del documento original al nuevo
      for (var i = 0; i < doc.document.pdfPageList.pages.length; i++) {
        try {
          final page = doc.document.pdfPageList.pages[i];
          newDoc.addPage(pw.Page(
              pageFormat: page.pageFormat, build: (context) => pw.Container()));
          newDoc.document.pdfPageList.pages[i] = page;
        } catch (e) {
          print('Error al copiar página $i: $e');
        }
      }

      // Intentar guardar el nuevo documento
      final backupResult = await compute((document) async {
        try {
          return await document.save();
        } catch (e) {
          print('Error guardando PDF con opciones alternativas: $e');
          return Uint8List(0);
        }
      }, newDoc);

      completer.complete(backupResult);
    } else {
      completer.complete(result);
    }
  } catch (e) {
    print('Error general en saveDocumentInBackground: $e');
    completer.complete(Uint8List(0));
  }

  return completer.future;
}

bool isProgressiveJpeg(Uint8List bytes) {
  // JPEG empieza con los bytes FF D8
  if (bytes.length < 10 || bytes[0] != 0xFF || bytes[1] != 0xD8) {
    return false; // No es un JPEG
  }

  // Buscar el marcador de escaneo progresivo (0xFF, 0xC2)
  for (int i = 2; i < bytes.length - 1; i++) {
    if (bytes[i] == 0xFF && (bytes[i + 1] == 0xC2 || bytes[i + 1] == 0xC0)) {
      return bytes[i + 1] == 0xC2; // True si es progresivo (0xC2)
    }
  }

  return false; // No encontró marcadores relevantes
}

// Función de diagnóstico detallado de imágenes
void diagnosticarImagen(Uint8List bytes, String url) {
  // Verificar si la imagen es muy pequeña
  if (bytes.length < 1000) {
    return;
  }

  // Analizar los primeros bytes para determinar el tipo
  String tipoDetectado = "desconocido";
  String hexSignature = '';

  // Obtener los primeros bytes como hexadecimal para diagnóstico
  for (int i = 0; i < math.min(12, bytes.length); i++) {
    hexSignature +=
        bytes[i].toRadixString(16).padLeft(2, '0').toUpperCase() + ' ';
  }

  // Detectar tipo basado en firmas
  if (bytes.length > 8) {
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      tipoDetectado = "PNG";
    } else if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
      if (isProgressiveJpeg(bytes)) {
        tipoDetectado = "JPEG progresivo";
      } else {
        tipoDetectado = "JPEG estándar";
      }
    } else if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) {
      tipoDetectado = "GIF";
    } else if (bytes[0] == 0x42 && bytes[1] == 0x4D) {
      tipoDetectado = "BMP";
    } else if (bytes.length > 12 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      tipoDetectado = "WEBP";
    }
  }
}

Future<void> createPDF(dynamic contact, dynamic agent, dynamic itinerary,
    dynamic itineraryItems, String accountId, dynamic account) async {
  final doc = pw.Document(compress: false);

  // Descargar foto de perfil del agente
  Uint8List? agentImage;
  try {
    final imageResponse = await http.get(Uri.parse(agent['image']));
    if (imageResponse.statusCode == 200) {
      agentImage = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  // Descargar header
  Uint8List? headerImage;
  try {
    // Determinar qué URL usar
    String imageUrl =
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/photo-1533699224246-6dc3b3ed3304%20(1).jpg';

    // Si hay una imagen en el itinerario y no está vacía, usarla
    if (itinerary['main_image_itinerary'] != null &&
        itinerary['main_image_itinerary'].toString().isNotEmpty) {
      imageUrl = itinerary['main_image_itinerary'].toString();
    }

    final imageResponse = await http.get(Uri.parse(imageUrl));
    if (imageResponse.statusCode == 200) {
      headerImage = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
      // Si falló la descarga de la imagen del itinerario, intentar con la imagen predeterminada
      final defaultImageResponse = await http.get(Uri.parse(
          'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/photo-1533699224246-6dc3b3ed3304%20(1).jpg'));
      if (defaultImageResponse.statusCode == 200) {
        headerImage = defaultImageResponse.bodyBytes;
      }
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
    // En caso de error, intentar con la imagen predeterminada
    try {
      final defaultImageResponse = await http.get(Uri.parse(
          'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/photo-1533699224246-6dc3b3ed3304%20(1).jpg'));
      if (defaultImageResponse.statusCode == 200) {
        headerImage = defaultImageResponse.bodyBytes;
      }
    } catch (e) {
      print('Error al descargar la imagen predeterminada: $e');
    }
  }

  // Descargar Brand
  Uint8List? brandImage;
  try {
    final imageResponse = await http.get(Uri.parse(account['logo_account']));
    if (imageResponse.statusCode == 200) {
      brandImage = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  // Descargar icono usuario
  Uint8List? iconUser;
  try {
    final imageResponse = await http.get(Uri.parse(
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/usuario.png'));
    if (imageResponse.statusCode == 200) {
      iconUser = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  // Descargar icono calendario
  Uint8List? iconCalendar;
  try {
    final imageResponse = await http.get(Uri.parse(
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/calendario.png'));
    if (imageResponse.statusCode == 200) {
      iconCalendar = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  // Descargar icono passangers
  Uint8List? iconPasangers;
  try {
    final imageResponse = await http.get(Uri.parse(
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/passengers.png'));
    if (imageResponse.statusCode == 200) {
      iconPasangers = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  // Descargar icono noches
  Uint8List? iconNight;
  try {
    final imageResponse = await http.get(Uri.parse(
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/luna.png'));
    if (imageResponse.statusCode == 200) {
      iconNight = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  // Descargar icono ubicacion
  Uint8List? iconLocation;
  try {
    final imageResponse = await http.get(Uri.parse(
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/ubicacion.png'));
    if (imageResponse.statusCode == 200) {
      iconLocation = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  // Descargar icono incluye
  Uint8List? iconInclude;
  try {
    final imageResponse = await http.get(Uri.parse(
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/include.png'));
    if (imageResponse.statusCode == 200) {
      iconInclude = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  // Descargar icono no incluye
  Uint8List? iconNotInclude;
  try {
    final imageResponse = await http.get(Uri.parse(
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/not_include.png'));
    if (imageResponse.statusCode == 200) {
      iconNotInclude = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  // Descargar icono recomendaciones
  Uint8List? iconRecomendations;
  try {
    final imageResponse = await http.get(Uri.parse(
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/recomendaciones.png'));
    if (imageResponse.statusCode == 200) {
      iconRecomendations = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  // Descargar icono email
  Uint8List? iconEmail;
  try {
    final imageResponse = await http.get(Uri.parse(
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/email.png'));
    if (imageResponse.statusCode == 200) {
      iconEmail = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  // Descargar icono avion
  Uint8List? iconPlane;
  try {
    final imageResponse = await http.get(Uri.parse(
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/avion.png'));
    if (imageResponse.statusCode == 200) {
      iconPlane = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  // Descargar icono carro
  Uint8List? iconCar;
  try {
    final imageResponse = await http.get(Uri.parse(
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/carro.png'));
    if (imageResponse.statusCode == 200) {
      iconCar = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  // Descargar icono office
  Uint8List? iconOffice;
  try {
    final imageResponse = await http.get(Uri.parse(
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/edificio.png'));
    if (imageResponse.statusCode == 200) {
      iconOffice = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  // Descargar default image
  Uint8List? defaultImage;
  try {
    final imageResponse = await http.get(Uri.parse(
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg'));
    if (imageResponse.statusCode == 200) {
      defaultImage = imageResponse.bodyBytes;
    } else {
      print('Error al descargar la imagen: ${imageResponse.statusCode}');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
  }

  final pageTheme = await _myPageTheme(format, account);

// Lista de widgets para los ítems del itinerario
  final List<pw.Widget> itineraryWidgets = [];

// Color azul específico
  final PdfColor colorBrandBlue =
      PdfColor(32 / 255, 76 / 255, 167 / 255); // rgb(32, 76, 167)

// -----------------------------------------------

// Agrupa los ítems por fecha
  Map<String, List<dynamic>> itemsByDate = {};

// Procesa todos los ítems y agrúpalos por fecha
  for (var item in itineraryItems) {
    String originalDate = item['date'] ?? '';

    // Inicializa la lista para esta fecha si no existe
    if (!itemsByDate.containsKey(originalDate)) {
      itemsByDate[originalDate] = [];
    }

    // Añade el ítem a la lista de esta fecha
    itemsByDate[originalDate]!.add(item);
  }

// Ordena las fechas
  List<String> sortedDates = itemsByDate.keys.toList()..sort();

// Descargar imagenes
  Future<List<Uint8List?>> downloadImagesFromUrls(
      List<String> imageUrls) async {
    List<Uint8List?> imageBytesList = [];
    final urls = imageUrls.take(3).toList();

    for (String url in urls) {
      try {
        // Verificar si NO es jpg, jpeg o png
        if (!url.toLowerCase().endsWith('.jpg') &&
            !url.toLowerCase().endsWith('.jpeg') &&
            !url.toLowerCase().endsWith('.png')) {
          print('Formato no compatible excluido: ${url.split('.').last}');
          imageBytesList.add(null);
          continue;
        }

        // Descargar la imagen con transformación
        Uri originalUri = Uri.parse(url);
        String optimizedUrl = url;

        if (url.contains('supabase.co/storage/v1/object/public')) {
          // Forzar formato PNG
          final queryParams = {
            ...originalUri.queryParameters,
            'width': '300',
            'height': '200',
            'format': 'png',
            'quality': '90',
          };

          optimizedUrl = Uri(
            scheme: originalUri.scheme,
            host: originalUri.host,
            path: originalUri.path,
            queryParameters: queryParams,
          ).toString();
        }

        final imageResponse = await http.get(Uri.parse(optimizedUrl));
        if (imageResponse.statusCode == 200) {
          final bytes = imageResponse.bodyBytes;

          // Imprimir información de depuración
          diagnosticarImagen(bytes, url);

          // ¡SOLUCIÓN ESPECÍFICA! Excluir las imágenes con exactamente 12921 bytes
          if (bytes.length == 12921) {
            print('Excluyendo imagen problemática de 12921 bytes');
            imageBytesList.add(null);
            continue;
          }

          // También excluir imágenes demasiado pequeñas (probablemente corruptas)
          if (bytes.length < 1000) {
            print('Excluyendo imagen demasiado pequeña: ${bytes.length} bytes');
            imageBytesList.add(null);
            continue;
          }

          // VERIFICACIÓN FINAL: asegurarse que tiene firma de imagen válida
          bool isValidImage = false;
          if (bytes.length > 8) {
            // Verificar PNG
            if (bytes[0] == 0x89 &&
                bytes[1] == 0x50 &&
                bytes[2] == 0x4E &&
                bytes[3] == 0x47) {
              isValidImage = true;
            }
            // Verificar JPEG
            else if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
              // Asegurarse que no sea JPEG progresivo
              if (!isProgressiveJpeg(bytes)) {
                isValidImage = true;
              }
            }
          }

          if (isValidImage) {
            imageBytesList.add(bytes);
          } else {
            imageBytesList.add(null);
          }
        } else {
          print('Error al descargar imagen: ${imageResponse.statusCode}');
          imageBytesList.add(null);
        }
      } catch (e) {
        print('Error al descargar imagen: $e');
        imageBytesList.add(null);
      }
    }
    return imageBytesList;
  }

// Revisar imágenes
// Función para renderizar una imagen de manera segura
  pw.Widget safeImage(Uint8List? imageBytes) {
    if (imageBytes == null || imageBytes.isEmpty) {
      return pw.Container(
        height: 80,
        color: PdfColors.grey300,
        child: pw.Center(
          child: pw.Text('Sin imagen',
              style: pw.TextStyle(color: PdfColors.grey700)),
        ),
      );
    }

    try {
      // VERIFICACIÓN ADICIONAL: Asegurarse que es una imagen válida antes de intentar renderizarla
      bool isValidImage = false;

      if (imageBytes.length > 8) {
        // Verificar PNG
        if (imageBytes[0] == 0x89 &&
            imageBytes[1] == 0x50 &&
            imageBytes[2] == 0x4E &&
            imageBytes[3] == 0x47) {
          isValidImage = true;
        }
        // Verificar JPEG
        else if (imageBytes[0] == 0xFF && imageBytes[1] == 0xD8) {
          isValidImage = true;
        }
      }

      if (!isValidImage) {
        print('Datos de imagen inválidos en safeImage - sustituyendo');
        return pw.Container(
          height: 80,
          color: PdfColors.grey300,
          child: pw.Center(
            child: pw.Text('Imagen inválida',
                style: pw.TextStyle(color: PdfColors.grey700)),
          ),
        );
      }

      return pw.ClipRRect(
        verticalRadius: 8,
        horizontalRadius: 8,
        child: pw.Image(
          pw.MemoryImage(imageBytes),
          fit: pw.BoxFit.cover,
          dpi: 160,
        ),
      );
    } catch (e) {
      print('Error renderizando imagen en PDF: $e');
      return pw.Container(
        height: 80,
        color: PdfColors.grey300,
        child: pw.Center(
          child: pw.Text('Error de imagen',
              style: pw.TextStyle(color: PdfColors.grey700)),
        ),
      );
    }
  }

//------------------------------------------------------------
// Recorre las fechas ordenadas
  for (int dayIndex = 0; dayIndex < sortedDates.length; dayIndex++) {
    String date = sortedDates[dayIndex];

    // Añade el encabezado de fecha con el índice del día
    itineraryWidgets.add(_buildDateHeader(date, dayIndex + 1));

    // Obtiene los ítems para esta fecha
    List<dynamic> dateItems = itemsByDate[date]!;

    // Procesa todos los ítems para esta fecha
    for (int i = 0; i < dateItems.length; i++) {
      var item = dateItems[i];
      bool isLastItemForDate = i == dateItems.length - 1;

      final itemName = item["name"] ?? "Sin nombre";
      final itemRateName = item["rate_name"] ?? "Sin tarifa";
      final itemDestination = item["destination"] ?? "Sin destino";
      final itemDate = item["date"] ?? "Sin fecha";
      final itemDescription = item["description"] ?? "Sin descripción";
      final itemImageUrl = item["main_image"] ??
          "https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg";
      final productType = item["product_type"] ?? "Sin tipo";
      final departure_time = item["departure_time"] ?? "--";
      final arrival_time = item["arrival_time"] ?? "--";
      final iata_departure = item["iata_departure"] ?? "--";
      final iata_destination = item["iata_destination"] ?? "--";
      final itemDeparture = item["departure"] ?? "--";
      final hotelNights = item["hotel_nights"] ?? "--";
      final inclutions = item["inclutions"] ?? "--";
      final exclutions = item["exclutions"] ?? "--";
      final recomendations = item["recomendations"] ?? "--";
      final images = item["images"] ?? [];

      // Descargar la imagen principal
      Uint8List? mainImageBytes;
      try {
        final imageResponse = await http.get(Uri.parse(itemImageUrl));
        if (imageResponse.statusCode == 200) {
          mainImageBytes = imageResponse.bodyBytes;
        } else {
          print('Error al descargar la imagen: ${imageResponse.statusCode}');
        }
      } catch (e) {
        print('Error al descargar la imagen: $e');
      }

      // Agregar los datos del ítem a la lista de widgets según tipo
      if (productType == "Hoteles" || productType == "Servicios") {
        // Convertir el string a lista
        List<String> imageUrls = [];
        imageUrls = (images as List).map((url) => url.toString()).toList();

        List<Uint8List?> imageBytesList =
            await downloadImagesFromUrls(imageUrls);

        // 1. SECCIÓN DE ENCABEZADO: Título, ubicación, noches y pasajeros
        itineraryWidgets.add(
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Solo el círculo con icono
              pw.Container(
                width: 35,
                alignment: pw.Alignment.center,
                child: pw.Container(
                  width: 28,
                  height: 28,
                  decoration: pw.BoxDecoration(
                    color: colorBrandBlue,
                    shape: pw.BoxShape.circle,
                  ),
                  child: pw.Center(
                    child: iconOffice != null
                        ? pw.Image(pw.MemoryImage(iconOffice),
                            width: 16, height: 16, dpi: 200)
                        : pw.Text(
                            productType == "Hoteles" ? "H" : "S",
                            style: pw.TextStyle(
                                color: PdfColors.white, fontSize: 12),
                          ),
                  ),
                ),
              ),

              // Columna con la información del encabezado
              pw.Expanded(
                child: pw.Container(
                  margin: const pw.EdgeInsets.only(left: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Título del ítem en la parte superior
                      pw.Text(
                        itemName,
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),

                      pw.SizedBox(height: 5),

                      // Fila con la información de ubicación, noches y personas
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment
                            .start, // Alinea elementos al inicio para textos multilinea
                        children: [
                          // Logo ubicación
                          pw.Container(
                            width: 13,
                            height: 13,
                            child: iconLocation != null
                                ? pw.Image(pw.MemoryImage(iconLocation),
                                    dpi: 200)
                                : null,
                          ),
                          pw.SizedBox(width: 5),
                          // Texto destino con tamaño adaptativo
                          pw.Flexible(
                            flex: 5, // Asigna más espacio al destino
                            child: pw.Text(
                              itemDestination,
                              style: pw.TextStyle(fontSize: 10),
                              softWrap: true,
                              maxLines: 3, // Limita a 3 líneas máximo
                            ),
                          ),
                          pw.SizedBox(width: 15),
                          // Parte de noches y pasajeros
                          pw.Expanded(
                            flex: 4, // Asigna espacio al resto de elementos
                            child: pw.Row(
                              children: [
                                // Logo noches
                                if (productType == "Hoteles") ...[
                                  pw.Container(
                                    width: 13,
                                    height: 13,
                                    child: iconNight != null
                                        ? pw.Image(pw.MemoryImage(iconNight),
                                            dpi: 200)
                                        : null,
                                  ),
                                  pw.SizedBox(width: 5),
                                  pw.Text(
                                    "${hotelNights} ${hotelNights == 1 ? 'noche' : 'noches'}",
                                    style: pw.TextStyle(fontSize: 10),
                                  ),
                                  pw.SizedBox(width: 15),
                                ],
                                // Logo pasajeros
                                pw.Container(
                                  width: 13,
                                  height: 13,
                                  child: iconPasangers != null
                                      ? pw.Image(pw.MemoryImage(iconPasangers),
                                          dpi: 200)
                                      : null,
                                ),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  "${itinerary['passengers']} ${itinerary['passengers'] == 1 ? 'pasajero' : 'pasajeros'}",
                                  style: pw.TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

        itineraryWidgets.add(
          pw.SizedBox(height: 5),
        );

        // 2. SECCIÓN DE IMÁGENES
        itineraryWidgets.add(
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Espacio para mantener la alineación
              pw.Container(width: 35),

              // Columna con las imágenes
              pw.Expanded(
                child: pw.Container(
                  margin: const pw.EdgeInsets.only(left: 10),
                  child: pw.Row(
                    children: [
                      if (imageBytesList.length >= 1 &&
                          imageBytesList[0] != null)
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                              height: 80, child: safeImage(imageBytesList[0])),
                        ),
                      pw.SizedBox(width: 5),
                      if (imageBytesList.length >= 2 &&
                          imageBytesList[1] != null)
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                              height: 80, child: safeImage(imageBytesList[1])),
                        ),
                      pw.SizedBox(width: 5),
                      if (imageBytesList.length >= 3 &&
                          imageBytesList[2] != null)
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                              height: 80, child: safeImage(imageBytesList[2])),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

        itineraryWidgets.add(
          pw.SizedBox(height: 5),
        );

        // 3. SECCIÓN DE DESCRIPCIÓN
        itineraryWidgets.add(
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Espacio para mantener la alineación
              pw.Container(width: 35),

              // Columna con la descripción
              pw.Expanded(
                child: pw.Container(
                  margin: const pw.EdgeInsets.only(left: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        itemDescription != null
                            ? itemDescription.replaceAll('\\n', '\n')
                            : "Descripción no disponible",
                        style: pw.TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

        itineraryWidgets.add(
          pw.SizedBox(height: 5),
        );

        // 4. SECCIÓN DE INCLUYE/NO INCLUYE
        itineraryWidgets.add(
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Espacio para mantener la alineación
              pw.Container(width: 35),

              // Columna con las secciones incluye/no incluye
              pw.Expanded(
                child: pw.Container(
                  margin: const pw.EdgeInsets.only(left: 10),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Sección "Incluye"
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // Logo incluye
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: 13,
                                  height: 13,
                                  child: iconInclude != null
                                      ? pw.Image(pw.MemoryImage(iconInclude),
                                          dpi: 200)
                                      : null,
                                ),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  "Incluye",
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              inclutions.replaceAll('\\n', '\n'),
                              style: pw.TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                      ),

                      pw.SizedBox(width: 10),

                      // Sección "No incluye"
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                //Logo no incluye
                                pw.Container(
                                  width: 13,
                                  height: 13,
                                  child: iconNotInclude != null
                                      ? pw.Image(pw.MemoryImage(iconNotInclude),
                                          dpi: 200)
                                      : null,
                                ),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  "No incluye",
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              exclutions.replaceAll('\\n', '\n'),
                              style: pw.TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

        itineraryWidgets.add(
          pw.SizedBox(height: 5),
        );

        // 5. SECCIÓN DE RECOMENDACIONES
        itineraryWidgets.add(
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Espacio para mantener la alineación
              pw.Container(width: 35),

              // Columna con las recomendaciones
              pw.Expanded(
                child: pw.Container(
                  margin: const pw.EdgeInsets.only(left: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Fila que contiene solo el ícono y el título
                      pw.Row(
                        children: [
                          pw.Container(
                            width: 13,
                            height: 13,
                            child: iconRecomendations != null
                                ? pw.Image(pw.MemoryImage(iconRecomendations),
                                    dpi: 200)
                                : null,
                          ),
                          pw.SizedBox(width: 5),
                          pw.Text(
                            "Recomendaciones",
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      // Texto de recomendaciones debajo del ícono y título
                      pw.Text(
                        recomendations.replaceAll('\\n', '\n'),
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

        itineraryWidgets.add(
          pw.SizedBox(height: 5),
        );

        // 6. SECCIÓN DE ITINERARIO (Actividades por día)
        if (item.containsKey('schedule') &&
            item['schedule'] != null &&
            item['schedule'] is List &&
            (item['schedule'] as List).isNotEmpty) {
          // Agregamos un título para la sección de itinerario
          itineraryWidgets.add(
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Espacio para mantener la alineación
                pw.Container(width: 35),

                // Columna con el título del itinerario
                pw.Expanded(
                  child: pw.Container(
                    margin: const pw.EdgeInsets.only(left: 10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            // Icono para itinerario (usando el icono de calendario si existe)
                            pw.Container(
                              width: 13,
                              height: 13,
                              child: iconCalendar != null
                                  ? pw.Image(pw.MemoryImage(iconCalendar),
                                      dpi: 200)
                                  : null,
                            ),
                            pw.SizedBox(width: 5),
                            pw.Text(
                              "Itinerario detallado",
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );

          itineraryWidgets.add(pw.SizedBox(height: 10));

          // Recorremos cada elemento del itinerario y lo agregamos individualmente
          for (var activityItem in item['schedule']) {
            if (activityItem is Map) {
              // Extraer datos del elemento del itinerario
              String activityTitle = activityItem['title'] ?? "Sin título";
              String activityDescription =
                  activityItem['description'] ?? "Sin descripción";
              String imageUrl = activityItem['image'] ?? "";

              // Descargamos la imagen si existe una URL
              Uint8List? activityImageBytes;
              if (imageUrl.isNotEmpty) {
                try {
                  List<String> tempImageList = [imageUrl];
                  List<Uint8List?> tempImageBytes =
                      await downloadImagesFromUrls(tempImageList);
                  if (tempImageBytes.isNotEmpty && tempImageBytes[0] != null) {
                    activityImageBytes = tempImageBytes[0];
                  }
                } catch (e) {
                  print("Error al descargar imagen del itinerario: $e");
                }
              }

              // Agregar el elemento del itinerario
              itineraryWidgets.add(
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Espacio para mantener la alineación
                    pw.Container(width: 35),

                    // Contenido del elemento del itinerario
                    pw.Expanded(
                      child: pw.Container(
                        margin: const pw.EdgeInsets.only(left: 10),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // Imagen con manejo seguro de errores
                            (() {
                              try {
                                if (activityImageBytes != null) {
                                  return pw.Container(
                                    width: 60,
                                    height: 60,
                                    margin: const pw.EdgeInsets.only(right: 10),
                                    child: pw.ClipRRect(
                                      verticalRadius: 8,
                                      horizontalRadius: 8,
                                      child: pw.Image(
                                        pw.MemoryImage(activityImageBytes),
                                        fit: pw.BoxFit.cover,
                                        dpi: 200,
                                      ),
                                    ),
                                  );
                                } else if (defaultImage != null) {
                                  return pw.Container(
                                    width: 60,
                                    height: 60,
                                    margin: const pw.EdgeInsets.only(right: 10),
                                    child: pw.ClipRRect(
                                      verticalRadius: 8,
                                      horizontalRadius: 8,
                                      child: pw.Image(
                                        pw.MemoryImage(defaultImage),
                                        fit: pw.BoxFit.cover,
                                        dpi: 200,
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                print("Error al crear widget de imagen: $e");
                                if (defaultImage != null) {
                                  try {
                                    return pw.Container(
                                      width: 60,
                                      height: 60,
                                      margin:
                                          const pw.EdgeInsets.only(right: 10),
                                      child: pw.ClipRRect(
                                        verticalRadius: 8,
                                        horizontalRadius: 8,
                                        child: pw.Image(
                                          pw.MemoryImage(defaultImage),
                                          fit: pw.BoxFit.cover,
                                          dpi: 200,
                                        ),
                                      ),
                                    );
                                  } catch (defaultError) {
                                    print(
                                        "Error también con imagen predeterminada: $defaultError");
                                  }
                                }
                              }
                              // Si llegamos aquí, usar un marcador de posición
                              return pw.Container(
                                width: 60,
                                height: 60,
                                margin: const pw.EdgeInsets.only(right: 10),
                                decoration: pw.BoxDecoration(
                                  borderRadius: pw.BorderRadius.circular(8),
                                  color: PdfColors.grey300,
                                ),
                                child: pw.Center(
                                  child: pw.Text(
                                    "N/A",
                                    style: pw.TextStyle(
                                      color: PdfColors.grey700,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              );
                            })(),

                            // Información textual del elemento
                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  // Título del elemento
                                  pw.Text(
                                    activityTitle,
                                    style: pw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),

                                  pw.SizedBox(height: 3),

                                  // Descripción del elemento
                                  pw.Text(
                                    activityDescription.replaceAll('\\n', '\n'),
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );

              // Añadimos espacio entre elementos del itinerario
              itineraryWidgets.add(pw.SizedBox(height: 8));
            }
          }

          // Espacio final después de toda la sección de itinerario
          itineraryWidgets.add(pw.SizedBox(height: 5));
        }

        // 7. SECCIÓN DE MENSAJE PERSONALIZADO
        if (item['personalized_message'] != null &&
            item['personalized_message'].toString().trim().isNotEmpty) {
          itineraryWidgets.add(
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Espacio para mantener la alineación
                pw.Container(width: 35),

                // Columna con el mensaje personalizado
                pw.Expanded(
                  child: pw.Container(
                    margin: const pw.EdgeInsets.only(left: 10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Fila que contiene solo el ícono y el título
                        pw.Row(
                          children: [
                            pw.Container(
                              width: 13,
                              height: 13,
                              child: iconEmail != null
                                  ? pw.Image(pw.MemoryImage(iconEmail),
                                      dpi: 200)
                                  : null,
                            ),
                            pw.SizedBox(width: 5),
                            pw.Text(
                              "Mensaje personalizado",
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        // Texto de mensaje personalizado debajo del ícono y título
                        pw.Text(
                          item['personalized_message']
                              .toString()
                              .replaceAll('\\n', '\n'),
                          style: pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );

          itineraryWidgets.add(
            pw.SizedBox(height: 5),
          );
        }
      } else if (productType == "Vuelos") {
        // Ítem tipo Vuelo
        itineraryWidgets.add(
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 35,
                child: pw.Column(
                  children: [
                    // Logo de avión
                    pw.Container(
                      width: 28,
                      height: 28,
                      decoration: pw.BoxDecoration(
                        color: colorBrandBlue,
                        shape: pw.BoxShape.circle,
                      ),
                      child: pw.Center(
                        child: iconPlane != null
                            ? pw.Image(pw.MemoryImage(iconPlane),
                                width: 16, height: 16, dpi: 200)
                            : pw.Text(
                                "✈",
                                style: pw.TextStyle(
                                    color: PdfColors.white, fontSize: 12),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              // Columna con el contenido principal
              pw.Expanded(
                child: pw.Container(
                  margin: const pw.EdgeInsets.only(left: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        itemName.trim(),
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),

                      pw.SizedBox(height: 10),

                      // Fila con origen, aerolínea/duración, y destino
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Columna de origen
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                iata_departure.trim(),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                itemDeparture.trim(),
                                style: pw.TextStyle(fontSize: 10),
                              ),
                              pw.SizedBox(height: 5),
                              pw.Text(
                                departure_time != null ? departure_time : "--",
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                "Salida",
                                style: pw.TextStyle(fontSize: 8),
                              ),
                            ],
                          ),

                          // Columna central con aerolínea e info de vuelo
                          pw.Column(
                            children: [
                              // Imagen aerolínea
                              pw.Container(
                                height: 50,
                                margin: const pw.EdgeInsets.only(top: 10),
                                child: pw.Center(
                                  child: mainImageBytes != null
                                      ? pw.Image(
                                          pw.MemoryImage(mainImageBytes),
                                          width:
                                              120, // Define el ancho máximo que deseas
                                          fit: pw.BoxFit
                                              .contain, // Escala la imagen manteniendo su proporción
                                          dpi: 200,
                                        )
                                      : pw.Text(
                                          "???",
                                          style: pw.TextStyle(
                                            fontSize: 14,
                                            color: colorBrandBlue,
                                          ),
                                        ),
                                ),
                              ),

                              pw.SizedBox(height: 10),

                              // Número de vuelo
                              /* pw.Text(
                                "AE2480",
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  color: PdfColors.grey700,
                                ),
                              ),

                              // Duración
                              pw.Text(
                                "8 hrs 32 min",
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  color: PdfColors.grey700,
                                ),
                              ),*/
                            ],
                          ),

                          // Columna de destino
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                iata_destination.trim(),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                itemDestination.trim(),
                                style: pw.TextStyle(fontSize: 10),
                              ),
                              pw.SizedBox(height: 5),
                              pw.Text(
                                arrival_time.trim(),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                "Llegada",
                                style: pw.TextStyle(fontSize: 8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        // Añadir mensaje personalizado para Vuelos si existe
        if (item['personalized_message'] != null &&
            item['personalized_message'].toString().trim().isNotEmpty) {
          itineraryWidgets.add(
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Espacio para mantener la alineación
                pw.Container(width: 35),

                // Columna con el mensaje personalizado
                pw.Expanded(
                  child: pw.Container(
                    margin: const pw.EdgeInsets.only(left: 10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Fila que contiene solo el ícono y el título
                        pw.Row(
                          children: [
                            pw.Container(
                              width: 13,
                              height: 13,
                              child: iconEmail != null
                                  ? pw.Image(pw.MemoryImage(iconEmail),
                                      dpi: 200)
                                  : null,
                            ),
                            pw.SizedBox(width: 5),
                            pw.Text(
                              "Mensaje personalizado",
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        // Texto de mensaje personalizado
                        pw.Text(
                          item['personalized_message']
                              .toString()
                              .replaceAll('\\n', '\n'),
                          style: pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );

          itineraryWidgets.add(
            pw.SizedBox(height: 5),
          );
        }
      } else if (productType == "Transporte") {
        itineraryWidgets.add(
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 35,
                child: pw.Column(
                  children: [
                    // Círculo con icono de carro
                    pw.Container(
                      width: 28,
                      height: 28,
                      decoration: pw.BoxDecoration(
                        color: colorBrandBlue,
                        shape: pw.BoxShape.circle,
                      ),
                      child: pw.Center(
                        child: iconCar != null
                            ? pw.Image(pw.MemoryImage(iconCar),
                                width: 16, height: 16, dpi: 200)
                            : pw.Text(
                                "🚗",
                                style: pw.TextStyle(
                                    color: PdfColors.white, fontSize: 12),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              // Imagen del vehículo (a la izquierda de la información)
              mainImageBytes != null
                  ? pw.Container(
                      width: 60,
                      height: 60,
                      margin: const pw.EdgeInsets.only(left: 10, right: 5),
                      child: pw.ClipRRect(
                        verticalRadius: 8,
                        horizontalRadius: 8,
                        child: pw.Image(
                          pw.MemoryImage(mainImageBytes),
                          fit: pw.BoxFit.cover,
                          dpi: 200,
                        ),
                      ),
                    )
                  : pw.SizedBox(width: 0),

              // Información del transporte (después de la imagen)
              pw.Expanded(
                child: pw.Container(
                  margin: const pw.EdgeInsets.only(left: 5),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Ubicación con punto negro
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment
                            .start, // Alinea el icono con la parte superior del texto
                        children: [
                          // Icono de ubicación (fijo)
                          pw.Container(
                            width: 13,
                            height: 13,
                            child: iconLocation != null
                                ? pw.Image(pw.MemoryImage(iconLocation),
                                    dpi: 200)
                                : null,
                          ),
                          pw.SizedBox(width: 5),
                          // Texto de destino con capacidad para múltiples líneas
                          pw.Expanded(
                            child: pw.Text(
                              itemDestination,
                              style: pw.TextStyle(fontSize: 10),
                              softWrap:
                                  true, // Permite que el texto pase a la siguiente línea
                              maxLines: 3, // Limita a máximo 3 líneas
                            ),
                          ),
                        ],
                      ),

                      // Título del transporte
                      pw.Text(
                        itemName,
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),

                      // Descripción del traslado
                      pw.Text(
                        itemRateName,
                        style: pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

        itineraryWidgets.add(pw.SizedBox(height: 10));
        // Añadir mensaje personalizado para Transporte si existe
        if (item['personalized_message'] != null &&
            item['personalized_message'].toString().trim().isNotEmpty) {
          itineraryWidgets.add(
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Espacio para mantener la alineación
                pw.Container(width: 35),

                // Columna con el mensaje personalizado
                pw.Expanded(
                  child: pw.Container(
                    margin: const pw.EdgeInsets.only(left: 10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Fila que contiene solo el ícono y el título
                        pw.Row(
                          children: [
                            pw.Container(
                              width: 13,
                              height: 13,
                              child: iconEmail != null
                                  ? pw.Image(pw.MemoryImage(iconEmail),
                                      dpi: 200)
                                  : null,
                            ),
                            pw.SizedBox(width: 5),
                            pw.Text(
                              "Mensaje personalizado",
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        // Texto de mensaje personalizado
                        pw.Text(
                          item['personalized_message']
                              .toString()
                              .replaceAll('\\n', '\n'),
                          style: pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );

          itineraryWidgets.add(pw.SizedBox(height: 5));
        }
      }

      if (!isLastItemForDate) {
        itineraryWidgets.add(pw.SizedBox(height: 10));
      }
    }

    // Añadir espacio entre grupos de fechas
    itineraryWidgets.add(pw.SizedBox(height: 20));
  }

//Descargar logo
  Uint8List? logoImage;
  try {
    final logoResponse = await http.get(Uri.parse(
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/9fc24733-b127-4184-aa22-12f03b98927a/brand/LOGO-COLOMBIA-TOURS-2-08-1.png?format=png')); // Forzar formato PNG

    if (logoResponse.statusCode == 200) {
      // Verificar que es una imagen válida
      final bytes = logoResponse.bodyBytes;
      if (bytes.length > 8 &&
          bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47) {
        // Es un PNG válido
        logoImage = bytes;
      } else {
        print('Logo descargado no es un PNG válido - omitiendo');
        logoImage = null;
      }
    }
  } catch (e) {
    print('Error al descargar el logo: $e');
    logoImage = null;
  }

// Páginas Principales
  try {
    doc.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (pw.Context context) => [
          //Header
          pw.Container(
            // Ignorar márgenes usando margen negativo
            margin: pw.EdgeInsets.only(
              left: -60, // Valor negativo del margen estándar
              top: -60,
              right: -60,
            ),
            width: pageTheme.pageFormat.width + 120, // Compensar los márgenes
            height: 150,
            child: headerImage != null
                ? pw.Image(
                    pw.MemoryImage(headerImage),
                    fit: pw.BoxFit.cover,
                    dpi: 250,
                  )
                : pw.Container(
                    color: PdfColors.grey300,
                    child: pw.Center(
                      child: pw.Text('Encabezado'),
                    ),
                  ),
          ),
          pw.SizedBox(height: 10),
          pw.Partitions(
            children: [
              //Nombre del itinerario
              pw.Partition(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Container(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: <pw.Widget>[
                          pw.Text(itinerary['name'],
                              textScaleFactor: 1.5,
                              style: pw.Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(fontWeight: pw.FontWeight.bold)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.only(top: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //Imagen de la empresa
              pw.Partition(
                width: sep,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: <pw.Widget>[
                          pw.Container(
                            width: 100,
                            height: 100,
                            child: brandImage != null
                                ? pw.Image(pw.MemoryImage(brandImage), dpi: 200)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          pw.SizedBox(height: 10),

          // Detalles del cliente
          pw.Partitions(
            children: [
              // Nombre del cliente
              pw.Partition(
                flex: 3, // Mayor proporción para el nombre
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 16,
                      height: 16,
                      child: iconUser != null
                          ? pw.Image(pw.MemoryImage(iconUser), dpi: 200)
                          : null,
                    ),
                    pw.SizedBox(width: 4),
                    pw.Expanded(
                      child: pw.Text(
                        (contact['name'] + ' ' + contact['lastname']).length >
                                20
                            ? (contact['name'] + ' ' + contact['lastname'])
                                    .substring(0, 20) +
                                '...'
                            : (contact['name'] + ' ' + contact['lastname']),
                        style: pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ID
              pw.Partition(
                flex: 2,
                child: pw.Text(
                  "ID ${itinerary['id_fm']}",
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 10,
                  ),
                ),
              ),

              // Fechas
              pw.Partition(
                flex: 4,
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment
                      .start, // Alinear al inicio para texto multilínea
                  children: [
                    pw.Container(
                      width: 16,
                      height: 16,
                      child: iconCalendar != null
                          ? pw.Image(pw.MemoryImage(iconCalendar), dpi: 200)
                          : null,
                    ),
                    pw.SizedBox(width: 3),
                    pw.Expanded(
                      // Añadido para permitir texto multilínea
                      child: pw.Text(
                        "${DateFormat('dd MMM yyyy', 'es').format(DateTime.parse(itinerary['start_date']))} - ${DateFormat('dd MMM yyyy', 'es').format(DateTime.parse(itinerary['end_date']))}",
                        //"${itinerary['start_date']} hasta ${itinerary['end_date']}",
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 10,
                        ),
                        maxLines: 2,
                        softWrap: true, // Permitir saltos de línea
                      ),
                    ),
                  ],
                ),
              ),

              // Número de personas
              pw.Partition(
                flex: 2,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      width: 16,
                      height: 16,
                      child: iconPasangers != null
                          ? pw.Image(pw.MemoryImage(iconPasangers), dpi: 200)
                          : null,
                    ),
                    pw.SizedBox(width: 3),
                    pw.Text(
                      "${itinerary['passengers']} ${itinerary['passengers'] == 1 ? 'persona' : 'personas'}",
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 10),

          // Detalles del agente
          pw.Container(
            width: pageTheme.pageFormat.availableWidth,
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColor(0.9, 0.92, 0.97), // Color de fondo azul claro
              borderRadius: pw.BorderRadius.circular(15),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Foto del agente
                pw.Container(
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(color: PdfColors.blue800, width: 1.5),
                  ),
                  padding: pw.EdgeInsets.all(2), // Espacio entre bordes
                  child: pw.Container(
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      border: pw.Border.all(color: PdfColors.white, width: 2),
                    ),
                    child: pw.ClipOval(
                      child: pw.Container(
                        width: 50,
                        height: 50,
                        child: agentImage != null
                            ? pw.Image(pw.MemoryImage(agentImage),
                                fit: pw.BoxFit.cover, dpi: 200)
                            : pw.Container(
                                color: PdfColors.red100, // Fondo de la foto
                                child: pw.Center(
                                  child: pw.Text("Agente",
                                      style: pw.TextStyle(
                                          fontSize: 20,
                                          color: PdfColors.white)),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(width: 15),

                // Información del agente y mensaje
                pw.Expanded(
                  child: pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 1),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Nombre y título
                        pw.Text(
                          agent['name'] + ' ' + agent['lastname'],
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),

                        pw.Text(
                          "Travel Planner",
                          style: pw.TextStyle(
                            fontSize: 10,
                          ),
                        ),

                        // Email con ícono
                        pw.Row(
                          children: [
                            pw.Container(
                              width: 15,
                              height: 15,
                              child: iconEmail != null
                                  ? pw.Image(pw.MemoryImage(iconEmail),
                                      dpi: 200)
                                  : null,
                            ),
                            pw.SizedBox(width: 3),
                            pw.Text(
                              agent['email'],
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),

                        // Mensaje personalizado
                        pw.SizedBox(height: 8),
                        pw.Text(
                          itinerary['personalized_message'],
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontStyle: pw.FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 10),
          ...itineraryWidgets,
        ],
      ),
    );
  } catch (e) {
    print("Error al crear la primera página: $e");
  }

  // Página de reserva
  doc.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      build: (pw.Context context) => [
        //Header
        pw.Container(
          margin: pw.EdgeInsets.only(
            left: -60, // Valor negativo del margen estándar
            top: -60,
            right: -60,
          ),
          width: pageTheme.pageFormat.width + 120, // Compensar los márgenes
          height: 150,
          child: headerImage != null
              ? pw.Image(
                  pw.MemoryImage(headerImage),
                  fit: pw.BoxFit.cover,
                  dpi: 250,
                )
              : pw.Container(
                  color: PdfColors.grey300,
                  child: pw.Center(
                    child: pw.Text('Encabezado'),
                  ),
                ),
        ),
        pw.SizedBox(height: 10),
        pw.Partitions(
          children: [
            //Nombre del itinerario
            pw.Partition(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Container(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: <pw.Widget>[
                        pw.Text(itinerary['name'],
                            textScaleFactor: 1.5,
                            style: pw.Theme.of(context)
                                .defaultTextStyle
                                .copyWith(fontWeight: pw.FontWeight.bold)),
                        pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //Imagen de la empresa
            pw.Partition(
              width: sep,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Container(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: <pw.Widget>[
                        pw.Container(
                          width: 100,
                          height: 100,
                          child: brandImage != null
                              ? pw.Image(pw.MemoryImage(brandImage), dpi: 200)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),

        pw.SizedBox(height: 10),

        // Detalles del cliente
        pw.Partitions(
          children: [
            // Nombre del cliente
            pw.Partition(
              flex: 3, // Mayor proporción para el nombre
              child: pw.Row(
                children: [
                  pw.Container(
                    width: 16,
                    height: 16,
                    child: iconUser != null
                        ? pw.Image(pw.MemoryImage(iconUser), dpi: 200)
                        : null,
                  ),
                  pw.SizedBox(width: 4),
                  pw.Expanded(
                    child: pw.Text(
                      (contact['name'] + ' ' + contact['lastname']).length > 20
                          ? (contact['name'] + ' ' + contact['lastname'])
                                  .substring(0, 20) +
                              '...'
                          : (contact['name'] + ' ' + contact['lastname']),
                      style: pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ID
            pw.Partition(
              flex: 2,
              child: pw.Text(
                "ID ${itinerary['id_fm']}",
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 10,
                ),
              ),
            ),
            // Fechas
            pw.Partition(
              flex: 4,
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment
                    .start, // Alinear al inicio para texto multilínea
                children: [
                  pw.Container(
                    width: 16,
                    height: 16,
                    child: iconCalendar != null
                        ? pw.Image(pw.MemoryImage(iconCalendar), dpi: 200)
                        : null,
                  ),
                  pw.SizedBox(width: 3),
                  pw.Expanded(
                    // Añadido para permitir texto multilínea
                    child: pw.Text(
                      "${DateFormat('dd MMM yyyy', 'es').format(DateTime.parse(itinerary['start_date']))} - ${DateFormat('dd MMM yyyy', 'es').format(DateTime.parse(itinerary['end_date']))}",
                      //"${itinerary['start_date']} hasta ${itinerary['end_date']}",
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 10,
                      ),
                      maxLines: 2,
                      softWrap: true, // Permitir saltos de línea
                    ),
                  ),
                ],
              ),
            ),
            // Número de personas
            pw.Partition(
              flex: 2,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    width: 16,
                    height: 16,
                    child: iconPasangers != null
                        ? pw.Image(pw.MemoryImage(iconPasangers), dpi: 200)
                        : null,
                  ),
                  pw.SizedBox(width: 3),
                  pw.Text(
                    "${itinerary['passengers']} ${itinerary['passengers'] == 1 ? 'persona' : 'personas'}",
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 10),

        // Detalles del agente
        pw.Container(
          width: pageTheme.pageFormat.availableWidth,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColor(0.9, 0.92, 0.97), // Color de fondo azul claro
            borderRadius: pw.BorderRadius.circular(15),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Foto del agente
              pw.Container(
                decoration: pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                  border: pw.Border.all(color: PdfColors.blue800, width: 1.5),
                ),
                padding: pw.EdgeInsets.all(2), // Espacio entre bordes
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(color: PdfColors.white, width: 2),
                  ),
                  child: pw.ClipOval(
                    child: pw.Container(
                      width: 50,
                      height: 50,
                      child: agentImage != null
                          ? pw.Image(pw.MemoryImage(agentImage),
                              fit: pw.BoxFit.cover, dpi: 200)
                          : pw.Container(
                              color: PdfColors.red100, // Fondo de la foto
                              child: pw.Center(
                                child: pw.Text("Agente",
                                    style: pw.TextStyle(
                                        fontSize: 20, color: PdfColors.white)),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 15),

              // Información del agente y mensaje
              pw.Expanded(
                child: pw.Padding(
                  padding: pw.EdgeInsets.symmetric(vertical: 1),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Nombre y título
                      pw.Text(
                        agent['name'] + ' ' + agent['lastname'],
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),

                      pw.Text(
                        "Travel Planner",
                        style: pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),

                      // Email con ícono
                      pw.Row(
                        children: [
                          pw.Container(
                            width: 15,
                            height: 15,
                            child: iconEmail != null
                                ? pw.Image(pw.MemoryImage(iconEmail), dpi: 200)
                                : null,
                          ),
                          pw.SizedBox(width: 3),
                          pw.Text(
                            agent['email'],
                            style: pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ),

                      pw.SizedBox(height: 8),
                      pw.Text(
                        itinerary['personalized_message'],
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontStyle: pw.FontStyle.italic,
                        ),
                      ),

                      /*pw.SizedBox(height: 10),

                    // Cita
                    pw.Text(
                      "\"${contact['name']}, sé que estás buscando el viaje perfecto para vivir una experiencia auténtica y llena de aventura en Colombia.\"",
                      style: pw.TextStyle(
                        fontStyle: pw.FontStyle.italic,
                        fontSize: 10,
                      ),
                    ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 10),

        // Oferta
        pw.Container(
          width: 120,
          decoration: pw.BoxDecoration(
            color: colorBrandBlue,
            borderRadius: pw.BorderRadius.circular(15),
          ),
          child: pw.Padding(
            padding: pw.EdgeInsets.all(4),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  "Oferta",
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  "Válida hasta el ${DateFormat('dd MMM yyyy', 'es').format(DateTime.parse(itinerary['valid_until']))}",
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 8,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        pw.SizedBox(height: 15),

        // Tabla con totales
        pw.Container(
          decoration: pw.BoxDecoration(
            color: PdfColor(0.92, 0.94, 0.97), // Color azul más claro
            borderRadius: pw.BorderRadius.circular(12),
          ),
          child: pw.Table(
            border: pw.TableBorder(
              verticalInside: pw.BorderSide(
                  color: PdfColor(colorBrandBlue.red, colorBrandBlue.green,
                      colorBrandBlue.blue, 0.3),
                  width: 1),
            ),
            columnWidths: {
              0: pw.FlexColumnWidth(1),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Gran Total",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: colorBrandBlue,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Por Persona",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: colorBrandBlue,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Por Persona/Día",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: colorBrandBlue,
                      ),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "\$${formatNumber(convertCurrency(itinerary['total'], itinerary))} ${itinerary['moneda'] ?? ''}",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "\$${formatNumber(convertCurrency(itinerary['total'] / itinerary['passengers'], itinerary))} ${itinerary['moneda'] ?? ''}",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "\$${calculateDailyRateWithCurrency(itinerary)} ${itinerary['moneda'] ?? ''}",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 190),

        // Línea divisoria
        pw.Divider(thickness: 1, color: colorBrandBlue),

        pw.SizedBox(height: 5),

        // Términos y condiciones
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Términos y Condiciones: Al pagar confirmas los servicios y aceptas estar de acuerdo con los términos y condiciones del servicio especificados en ${account['terms_conditions_account']}',
              style: pw.TextStyle(
                fontSize: 10,
                color: colorBrandBlue,
              ),
            ),
            pw.Text(
              'Política de Privacidad: Tus datos están seguros al contactar a través de nuestros canales oficiales de acuerdo a lo señalado en la política especificada en ${account['privacy_policy_account']}',
              style: pw.TextStyle(
                fontSize: 10,
                color: colorBrandBlue,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  // Convertir el PDF a bytes
  //final Uint8List bytes = await doc.save();
  // Guardar en segundo plano

  final bytes = await saveDocumentInBackground(doc);

  // Subir el PDF a Supabase Storage
  final String pdfUrl = await _uploadPDFToStorage(bytes,
      "${accountId}/itineraries/itinerario_${contact['name']}_${contact['lastname']}_${itinerary['id_fm']}_${DateTime.now().millisecondsSinceEpoch}.pdf");

  // Descargar automáticamente el PDF
  _openPDF(pdfUrl);

  print("✅ PDF disponible en: $pdfUrl");
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format, dynamic account,
    [Uint8List? logoImage]) async {
  // Definir el color azul específico
  final PdfColor colombiaBlue =
      PdfColor(0.12, 0.29, 0.65); // RGB aproximado: 30, 75, 165

  //final String typeIdAccount = account['type_id_account']?.toString() ?? '';
  //final String numberIdAccount = account['number_id_account']?.toString() ?? '';

  // Ajustar márgenes, ajustando el margen inferior para el footer
  format = format.applyMargin(
      left: 2.0 * PdfPageFormat.cm,
      top: 1.0 * PdfPageFormat.cm,
      right: 2.0 * PdfPageFormat.cm,
      bottom: 70 + 0.5 * PdfPageFormat.cm); // Altura del footer + espacio extra

  return pw.PageTheme(
    pageFormat: format,
    theme: pw.ThemeData.withFont(
      base: await PdfGoogleFonts.openSansRegular(),
      bold: await PdfGoogleFonts.openSansBold(),
      icons: await PdfGoogleFonts.materialIcons(),
    ),
    buildBackground: (pw.Context context) {
      return pw.FullPage(
        ignoreMargins: true,
        child: pw.Stack(
          children: [
            // Footer en la parte inferior
            pw.Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: pw.Container(
                height: 70,
                color: colombiaBlue,
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // Texto a la izquierda
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          '${account['type_id_account']}: ${account['number_id_account']}',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 10,
                          ),
                        ),
                        pw.Text(
                          'Email: ${account['mail_account']}    Teléfono: ${account['phone_account']}',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 10,
                          ),
                        ),
                        pw.Text(
                          '${account['location_account']}',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),

                    // Y en la parte del logo:
                    pw.Text(
                      '${account['name_account']}',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _Block extends pw.StatelessWidget {
  _Block({
    required this.title,
    this.icon,
  });

  final String title;

  final pw.IconData? icon;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Container(
                  width: 6,
                  height: 6,
                  margin: const pw.EdgeInsets.only(top: 5.5, left: 2, right: 5),
                  decoration: const pw.BoxDecoration(
                    color: green,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.Text(title,
                    style: pw.Theme.of(context)
                        .defaultTextStyle
                        .copyWith(fontWeight: pw.FontWeight.bold)),
                pw.Spacer(),
                if (icon != null) pw.Icon(icon!, color: lightGreen, size: 18),
              ]),
          pw.Container(
            decoration: const pw.BoxDecoration(
                border: pw.Border(left: pw.BorderSide(color: green, width: 2))),
            padding: const pw.EdgeInsets.only(left: 10, top: 5, bottom: 5),
            margin: const pw.EdgeInsets.only(left: 5),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Lorem(length: 20),
                ]),
          ),
        ]);
  }
}

class _Category extends pw.StatelessWidget {
  _Category({required this.title});

  final String title;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        color: lightGreen,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      margin: const pw.EdgeInsets.only(bottom: 10, top: 20),
      padding: const pw.EdgeInsets.fromLTRB(10, 4, 10, 4),
      child: pw.Text(
        title,
        textScaleFactor: 1.5,
      ),
    );
  }
}

class _Percent extends pw.StatelessWidget {
  _Percent({
    required this.size,
    required this.value,
    required this.title,
  });

  final double size;

  final double value;

  final pw.Widget title;

  static const fontSize = 1.2;

  PdfColor get color => green;

  static const backgroundColor = PdfColors.grey300;

  static const strokeWidth = 5.0;

  @override
  pw.Widget build(pw.Context context) {
    final widgets = <pw.Widget>[
      pw.Container(
        width: size,
        height: size,
        child: pw.Stack(
          alignment: pw.Alignment.center,
          fit: pw.StackFit.expand,
          children: <pw.Widget>[
            pw.Center(
              child: pw.Text(
                '${(value * 100).round().toInt()}%',
                textScaleFactor: fontSize,
              ),
            ),
            pw.CircularProgressIndicator(
              value: value,
              backgroundColor: backgroundColor,
              color: color,
              strokeWidth: strokeWidth,
            ),
          ],
        ),
      )
    ];

    widgets.add(title);

    return pw.Column(children: widgets);
  }
}

class _UrlText extends pw.StatelessWidget {
  _UrlText(this.text, this.url);

  final String text;
  final String url;

  @override
  pw.Widget build(pw.Context context) {
    return pw.UrlLink(
      destination: url,
      child: pw.Text(text,
          style: const pw.TextStyle(
            decoration: pw.TextDecoration.underline,
            color: PdfColors.blue,
          )),
    );
  }
}

// Subir PDF a Supabase Storage con URL firmada de larga duración
Future<String> _uploadPDFToStorage(Uint8List pdfBytes, String fileName) async {
  final supabase = Supabase.instance.client;
  final bucketName = "images"; // bucke en Supabase

  //  Subir archivo
  await supabase.storage.from(bucketName).uploadBinary(
        fileName,
        pdfBytes,
        fileOptions: const FileOptions(upsert: true),
      );

  //  Genera una URL firmada con expiración de 100 años (3153600000 segundos)
  final signedUrl = await supabase.storage
      .from(bucketName)
      .createSignedUrl(fileName, 3153600000);
  return signedUrl;
}

// ? Descargar automáticamente el PDF en Web y abrirlo en móviles
void _openPDF(String pdfUrl) {
  _launchURL(pdfUrl);
}

// ? Función para abrir el PDF en el navegador en Web y en Android/iOS
Future<void> _launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'No se pudo abrir el enlace: $url';
  }
}

// Función para crear el encabezado de fecha

pw.Widget _buildDateHeader(String date, int dayNumber) {
  // Convertir la fecha a un formato más amigable
  String displayDate = date;
  try {
    final DateTime dateTime = DateTime.parse(date);
    // Lista de meses abreviados
    final List<String> months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    // Formato: DD Mes YYYY (ej: 27 Feb 2025)
    displayDate =
        "${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}";
  } catch (e) {
    print('Error al formatear fecha: $e');
  }

  return pw.Container(
    width: 180, // Ancho ligeramente mayor para acomodar el nuevo formato
    height: 35, // Altura fija para mejorar los bordes
    margin: pw.EdgeInsets.only(bottom: 15), // Espacio debajo del encabezado
    decoration: pw.BoxDecoration(
      color: colorBrandBlue,
      borderRadius: pw.BorderRadius.circular(
          17.5), // Mitad de la altura para bordes suaves
    ),
    child: pw.Center(
      // Centrar el texto vertical y horizontalmente
      child: pw.Text(
        "Día ${dayNumber}: ${displayDate}",
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ),
  );
}

// Función para formatear números con coma como separador decimal
String formatNumber(dynamic number) {
  if (number == null) return "0,0";

  try {
    double value = double.parse(number.toString());

    // Convertir a string con un decimal fijo
    String formatted = value.toStringAsFixed(1);

    // Separar parte entera y decimal
    List<String> parts = formatted.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : "0";

    // Agregar separadores de miles (.) a la parte entera
    String integerWithSeparators = "";
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        integerWithSeparators += ".";
      }
      integerWithSeparators += integerPart[i];
    }

    // Combinar con coma para decimal
    return "$integerWithSeparators,$decimalPart";
  } catch (e) {
    return "0,0";
  }
}

// Función para convertir a la moneda objetivo
double convertToTargetCurrency(double amount, dynamic itinerary) {
  List<dynamic> currencies = itinerary['monedas_type'];

  // Buscar la moneda objetivo (en este caso la moneda del itinerario)
  var targetCurrency = currencies
      .firstWhere((c) => c["name"] == itinerary['moneda'], orElse: () => null);

  // Si no se encuentra la moneda o no tiene rate, retornar el monto original
  if (targetCurrency == null || targetCurrency["rate"] == null) {
    return amount;
  }

  // Multiplicar por el rate para convertir a la moneda objetivo
  return amount * targetCurrency["rate"];
}

String calculateDailyRateWithCurrency(dynamic itinerary) {
  try {
    // Parsear fechas
    DateTime startDate = DateTime.parse(itinerary['start_date']);
    DateTime endDate = DateTime.parse(itinerary['end_date']);

    // Calcular días (incluyendo el día inicial y final)
    int days = endDate.difference(startDate).inDays + 1;
    if (days <= 0) days = 1;

    // Calcular total por persona
    double totalPerPerson = convertToTargetCurrency(
        itinerary['total'] / itinerary['passengers'], itinerary);

    // Calcular tarifa diaria (por persona por día)
    double dailyRate = totalPerPerson / days;

    // Formatear con la función de formato
    return formatNumber(dailyRate);
  } catch (e) {
    return "0,0";
  }
}

// Función para convertir moneda
double convertCurrency(double amount, dynamic itinerary) {
  return convertToTargetCurrency(amount, itinerary);
}
