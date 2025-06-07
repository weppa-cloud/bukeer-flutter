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

import 'package:url_launcher/url_launcher.dart';

import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;

final format = PdfPageFormat.a4;
final PdfColor colorBrandBlue =
    PdfColor(0.12, 0.29, 0.65); // Color azul de la marca

// Función para formatear valores monetarios con punto como separador de miles y coma para decimales
String formatMoney(dynamic value) {
  if (value == null) return '0';

  // Convertir a double
  double numValue;
  if (value is String) {
    try {
      // Reemplazar cualquier coma existente con puntos para parsear
      numValue = double.parse(value.replaceAll(',', '.'));
    } catch (e) {
      print('Error al parsear valor de string: $e');
      return '0';
    }
  } else if (value is num) {
    numValue = value.toDouble();
  } else {
    return '0';
  }

  // Dividir en partes enteras y decimales
  String valueStr = numValue.toStringAsFixed(2);
  List<String> parts = valueStr.split('.');

  // Formatear parte entera con separadores de miles
  String integerPart = parts[0];
  String formattedInteger = '';

  for (int i = 0; i < integerPart.length; i++) {
    if (i > 0 && (integerPart.length - i) % 3 == 0) {
      formattedInteger += '.';
    }
    formattedInteger += integerPart[i];
  }

  // Agregar parte decimal con separador de coma
  return parts.length > 1 ? '$formattedInteger,${parts[1]}' : formattedInteger;
}

// Nueva función para convertir el monto total a la moneda seleccionada
double convertCurrency(
    double totalAmount, String currencyType, List<dynamic> currencies) {
  // Si no hay datos de moneda o está vacío, retornar el monto original
  if (currencies == null || currencies.isEmpty) {
    return totalAmount;
  }

  // Buscar la moneda seleccionada en la lista de currencies
  Map<String, dynamic>? selectedCurrency;
  for (var currency in currencies) {
    if (currency['name'] == currencyType) {
      selectedCurrency = currency;
      break;
    }
  }

  // Si no encontramos la moneda o es de tipo base, retornar el monto original
  if (selectedCurrency == null || selectedCurrency['type'] == 'base') {
    return totalAmount;
  }

  // Si la moneda es opcional (type = 'opt'), multiplicar por la tasa
  if (selectedCurrency['type'] == 'opt') {
    double rate = 0.0;
    // Convertir rate a double, manejar diferentes tipos de entrada
    if (selectedCurrency['rate'] is String) {
      rate = double.tryParse(selectedCurrency['rate']) ?? 0.0;
    } else if (selectedCurrency['rate'] is num) {
      rate = selectedCurrency['rate'].toDouble();
    }

    // Aplicar la conversión
    return totalAmount * rate;
  }

  // Si llegamos aquí, retornar el monto original
  return totalAmount;
}

Future<void> createVoucherPDF(
    String clientName,
    String agency,
    String departureDate,
    String returnDate,
    int nights,
    int passengersCount,
    String itineraryId,
    String currency,
    String accountId,
    double totalAmount,
    dynamic transactions,
    dynamic passengers,
    dynamic allDataJson,
    dynamic items,
    String? clientLastName) async {
  final pdf = pw.Document(compress: false);

  try {
    // Obtener el tipo de moneda y las tasas de conversión
    String currencyType = allDataJson['currency_type'] ?? currency;
    List<dynamic> currencies = [];
    if (allDataJson.containsKey('currency') &&
        allDataJson['currency'] is List) {
      currencies = allDataJson['currency'];
    }

    // Convertir el monto total a la moneda seleccionada
    double convertedAmount =
        convertCurrency(totalAmount, currencyType, currencies);

    // Descargar el logo de la empresa
    final String logoImageUrl = allDataJson['account_image'] ??
        "https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/default-image.jpg";
    final logoResponse = await http.get(Uri.parse(logoImageUrl));
    Uint8List? logoImage;
    if (logoResponse.statusCode == 200) {
      logoImage = logoResponse.bodyBytes;
    } else {
      print('Error al cargar el logo: ${logoResponse.statusCode}');
    }

    // Iconos para las categorías (opcional)
    const String transportIconUrl =
        "https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/carro.png";
    final transportIconResponse = await http.get(Uri.parse(transportIconUrl));
    Uint8List? transportIcon;
    if (transportIconResponse.statusCode == 200) {
      transportIcon = transportIconResponse.bodyBytes;
    }

    // Descargar icono de email
    Uint8List? emailIcon;
    try {
      const String emailIconUrl =
          "https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/email.png";
      final emailIconResponse = await http.get(Uri.parse(emailIconUrl));
      if (emailIconResponse.statusCode == 200) {
        emailIcon = emailIconResponse.bodyBytes;
      } else {
        print(
            'Error al cargar el icono de email: ${emailIconResponse.statusCode}');
      }
    } catch (e) {
      print('Error al cargar el icono de email: $e');
    }

    /// Descargar icono de ubicación
    Uint8List? locationIcon;
    try {
      const String locationIconUrl =
          "https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/ubicacion.png";
      final locationIconResponse = await http.get(Uri.parse(locationIconUrl));
      if (locationIconResponse.statusCode == 200) {
        locationIcon = locationIconResponse.bodyBytes;
      } else {
        print(
            'Error al cargar el icono de ubicación: ${locationIconResponse.statusCode}');
      }
    } catch (e) {
      print('Error al cargar el icono de ubicación: $e');
    }

    /// Descargar icono de teléfono
    Uint8List? phoneIcon;
    try {
      const String phoneIconUrl =
          "https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/telefono.png";
      final phoneIconResponse = await http.get(Uri.parse(phoneIconUrl));
      if (phoneIconResponse.statusCode == 200) {
        phoneIcon = phoneIconResponse.bodyBytes;
      } else {
        print(
            'Error al cargar el icono de teléfono: ${phoneIconResponse.statusCode}');
      }
    } catch (e) {
      print('Error al cargar el icono de teléfono: $e');
    }

    const String hotelIconUrl =
        "https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/edificio.png";
    final hotelIconResponse = await http.get(Uri.parse(hotelIconUrl));
    Uint8List? hotelIcon;
    if (hotelIconResponse.statusCode == 200) {
      hotelIcon = hotelIconResponse.bodyBytes;
    }

    const String flightIconUrl =
        "https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/avion.png";
    final flightIconResponse = await http.get(Uri.parse(flightIconUrl));
    Uint8List? flightIcon;
    if (flightIconResponse.statusCode == 200) {
      flightIcon = flightIconResponse.bodyBytes;
    }

    const String serviceIconUrl =
        "https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/icon-service.png";
    final serviceIconResponse = await http.get(Uri.parse(serviceIconUrl));
    Uint8List? serviceIcon;
    if (serviceIconResponse.statusCode == 200) {
      serviceIcon = serviceIconResponse.bodyBytes;
    }
    // Crear tema personalizado para el documento
    pw.ThemeData customTheme;
    try {
      customTheme = pw.ThemeData.withFont(
        base: await PdfGoogleFonts.openSansRegular(),
        bold: await PdfGoogleFonts.openSansBold(),
        icons: await PdfGoogleFonts.materialIcons(),
      );
    } catch (e) {
      print('Error al cargar fuentes: $e');
      customTheme = pw.ThemeData.base();
    }

    // Organizar los datos por categoría
    List<Map<String, dynamic>> transporteItems = [];
    List<Map<String, dynamic>> hotelesItems = [];
    List<Map<String, dynamic>> vuelosItems = [];
    List<Map<String, dynamic>> serviciosItems = [];

    // Preparar datos para pasajeros
    List<Map<String, dynamic>> passengersData = [];

    // Preparar datos para pagos/transacciones
    List<Map<String, dynamic>> paymentsData = [];

    String paid = allDataJson['paid'].toString();
    String pending_paid = allDataJson['pending_paid'].toString();

    // Procesar pasajeros
    if (passengers is List) {
      try {
        passengersData = List<Map<String, dynamic>>.from(passengers);
        print("Procesados ${passengersData.length} pasajeros");
      } catch (e) {
        print("Error al procesar pasajeros: $e");
        // Intento alternativo si falla el casting directo
        for (var passenger in passengers) {
          if (passenger is Map) {
            passengersData.add(Map<String, dynamic>.from(passenger));
          }
        }
      }
    }

    // Procesar transacciones
    if (transactions is List) {
      try {
        paymentsData = List<Map<String, dynamic>>.from(transactions);
        print("Procesadas ${paymentsData.length} transacciones");
      } catch (e) {
        print("Error al procesar transacciones: $e");
        // Intento alternativo si falla el casting directo
        for (var transaction in transactions) {
          if (transaction is Map) {
            paymentsData.add(Map<String, dynamic>.from(transaction));
          }
        }
      }
    }

    if (items is Map) {
      // Procesar categorías si están presentes en el mapa
      if (items.containsKey('Transporte') && items['Transporte'] is List) {
        transporteItems = List<Map<String, dynamic>>.from(items['Transporte']);
      }
      if (items.containsKey('Hoteles') && items['Hoteles'] is List) {
        hotelesItems = List<Map<String, dynamic>>.from(items['Hoteles']);
      }
      if (items.containsKey('Vuelos') && items['Vuelos'] is List) {
        vuelosItems = List<Map<String, dynamic>>.from(items['Vuelos']);
      }
      if (items.containsKey('Servicios') && items['Servicios'] is List) {
        serviciosItems = List<Map<String, dynamic>>.from(items['Servicios']);
      }

      // Procesamiento de pasajeros desde el JSON
      if (items.containsKey('passengers') && items['passengers'] is List) {
        passengersData = List<Map<String, dynamic>>.from(items['passengers']);
      } else if (items.containsKey('Pasajeros') && items['Pasajeros'] is List) {
        passengersData = List<Map<String, dynamic>>.from(items['Pasajeros']);
      }

      // Procesamiento de transacciones/pagos desde el JSON
      if (items.containsKey('transactions') && items['transactions'] is List) {
        paymentsData = List<Map<String, dynamic>>.from(items['transactions']);
      } else if (items.containsKey('Pagos') && items['Pagos'] is List) {
        paymentsData = List<Map<String, dynamic>>.from(items['Pagos']);
      }
    }

    // Estado de pago
    // Estado de pago
    String paymentStatus = "NO PAGADO";
    PdfColor statusColor =
        PdfColor(0.88, 0.27, 0.05); // Color rojo/naranja por defecto

// Verificar si pending_paid es 0
    if (allDataJson.containsKey('pending_paid') &&
        (allDataJson['pending_paid'] <= 500 ||
            allDataJson['pending_paid'] == "0")) {
      paymentStatus = "PAGADO";
      statusColor = PdfColor(0.13, 0.65, 0.15); // Color verde para PAGADO
    } else {
      // Mantener los casos de override existentes por si acaso
      if (items is Map && items.containsKey('EstadoPago')) {
        paymentStatus = items['EstadoPago'].toString();
      } else if (items is Map && items.containsKey('status')) {
        paymentStatus = items['status'].toString();
      }
    }
    // Generar el documento PDF
    pdf.addPage(
      pw.MultiPage(
        theme: customTheme,
        pageFormat: format,
        margin: const pw.EdgeInsets.all(20),
        header: (pw.Context context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 20),
            child: pw.Column(
              children: [
                // Primera fila con logo y datos de contacto
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // Logo
                    logoImage != null
                        ? pw.Container(
                            width: 150,
                            height: 60,
                            child: pw.Image(pw.MemoryImage(logoImage)))
                        : pw.Container(),
                    pw.Spacer(),
                    // Información de contacto
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Row(
                          children: [
                            pw.Container(
                              width: 12,
                              height: 12,
                              child: phoneIcon != null
                                  ? pw.Image(pw.MemoryImage(phoneIcon))
                                  : pw.Text("E",
                                      style: pw.TextStyle(fontSize: 9)),
                            ),
                            pw.SizedBox(width: 5),
                            pw.Text(
                                "Tels: ${allDataJson['account_phone']} ${allDataJson['account_phone2']}",
                                style: pw.TextStyle(fontSize: 9)),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Container(
                              width: 12,
                              height: 12,
                              child: emailIcon != null
                                  ? pw.Image(pw.MemoryImage(emailIcon))
                                  : pw.Text("E",
                                      style: pw.TextStyle(fontSize: 9)),
                            ),
                            pw.SizedBox(width: 5),
                            pw.Text("${allDataJson['account_email']}",
                                style: pw.TextStyle(fontSize: 9)),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Container(
                              width: 12,
                              height: 12,
                              child: locationIcon != null
                                  ? pw.Image(pw.MemoryImage(locationIcon))
                                  : pw.Text("L",
                                      style: pw.TextStyle(fontSize: 9)),
                            ),
                            pw.SizedBox(width: 5),
                            pw.Text("${allDataJson['account_address']}",
                                style: pw.TextStyle(fontSize: 9)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // Línea divisoria
                pw.Container(
                  margin: const pw.EdgeInsets.symmetric(vertical: 10),
                  child: pw.Divider(color: PdfColors.grey400),
                ),

                // Información NIT
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                        "${allDataJson['account_name']} ${allDataJson['account_type']}: ${allDataJson['account_number_id']}",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Spacer(),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      decoration: pw.BoxDecoration(
                        color: statusColor,
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                      child: pw.Text(
                        paymentStatus,
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
                // Fila con datos del cliente e información del itinerario
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 10),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Columna izquierda - Datos del cliente
                      pw.Container(
                        width: 250,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              clientLastName != null && clientLastName != ''
                                  ? clientName + ' ' + clientLastName
                                  : clientName,
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text("Fecha Salida: $departureDate",
                                style: pw.TextStyle(fontSize: 10)),
                            pw.Text("Fecha Regreso: $returnDate",
                                style: pw.TextStyle(fontSize: 10)),
                            pw.Text("Numero de Pasajeros: $passengersCount",
                                style: pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                      // Columna derecha - Caja con datos del itinerario
                      pw.Expanded(
                        child: pw.Container(
                          padding: const pw.EdgeInsets.all(10),
                          decoration: pw.BoxDecoration(
                            color: colorBrandBlue,
                            borderRadius: pw.BorderRadius.circular(5),
                          ),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              // ID
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text("ID $itineraryId",
                                      style: pw.TextStyle(
                                          fontSize: 14,
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColors.white)),
                                  pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.end,
                                    children: [
                                      pw.Text("Total",
                                          style: pw.TextStyle(
                                              fontSize: 12,
                                              color: PdfColors.white)),
                                      // Usamos el monto convertido en lugar del monto original
                                      pw.Text(
                                          "${formatMoney(convertedAmount)} ${allDataJson['currency_type']}",
                                          style: pw.TextStyle(
                                              fontSize: 14,
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColors.white)),
                                    ],
                                  ),
                                ],
                              ),

                              // Moneda y fecha
                              pw.SizedBox(height: 5),
                              pw.Row(
                                children: [
                                  pw.Text("Moneda: $currencyType",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          color: PdfColors.white)),
                                  pw.SizedBox(width: 20),
                                  pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text("Fecha",
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              color: PdfColors.white)),
                                      pw.Text(
                                          DateTime.now()
                                              .toString()
                                              .substring(0, 10),
                                          style: pw.TextStyle(
                                              fontSize: 10,
                                              color: PdfColors.white)),
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
                ),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          // Lista para almacenar los textos como widgets
          List<pw.Widget> footerWidgets = [];

          // Para términos y condiciones
          if ("${allDataJson['account_terms_conditions']}" != "Desconocido") {
            footerWidgets.add(
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text:
                          "Para consultar nuestros Términos y Condiciones completos, visite ",
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.TextSpan(
                      text: "aquí",
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.blue,
                        decoration: pw.TextDecoration.underline,
                      ),
                      annotation: pw.AnnotationUrl(
                          "${allDataJson['account_terms_conditions']}"),
                    ),
                  ],
                ),
                textAlign: pw.TextAlign.center,
              ),
            );
          }

          // Para política de privacidad
          if ("${allDataJson['account_privacy_policy']}" != "Desconocido") {
            footerWidgets.add(
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text:
                          "Información sobre cómo tratamos sus datos en nuestra Política de Privacidad ",
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.TextSpan(
                      text: "aquí",
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.blue,
                        decoration: pw.TextDecoration.underline,
                      ),
                      annotation: pw.AnnotationUrl(
                          "${allDataJson['account_privacy_policy']}"),
                    ),
                  ],
                ),
                textAlign: pw.TextAlign.center,
              ),
            );
          }

          // Para política de cancelación
          if ("${allDataJson['account_cancellation_policy']}" !=
              "Desconocido") {
            footerWidgets.add(
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: "Conozca nuestra Política de Cancelación ",
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.TextSpan(
                      text: "aquí",
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.blue,
                        decoration: pw.TextDecoration.underline,
                      ),
                      annotation: pw.AnnotationUrl(
                          "${allDataJson['account_cancellation_policy']}"),
                    ),
                  ],
                ),
                textAlign: pw.TextAlign.center,
              ),
            );
          }

          // Crear lista de widgets con espaciado de manera segura
          List<pw.Widget> spacedWidgets = [];
          for (int i = 0; i < footerWidgets.length; i++) {
            spacedWidgets.add(footerWidgets[i]);
            // Solo añadir espacio si no es el último elemento
            if (i < footerWidgets.length - 1) {
              spacedWidgets.add(pw.SizedBox(height: 2));
            }
          }

          return pw.Container(
            margin: const pw.EdgeInsets.only(top: 20),
            child: pw.Column(
              children: [
                pw.Divider(color: PdfColors.grey400),
                pw.SizedBox(height: 5),
                // Usar spacedWidgets directamente
                ...spacedWidgets,
              ],
            ),
          );
        },
        build: (pw.Context context) {
          // Preparar la lista de contenidos para el PDF
          List<pw.Widget> widgets = [];

          Map<String, String> contactInfo = {};

          // Agregar instrucciones de hoteles
          if (items is Map &&
              items.containsKey('Hoteles') &&
              items['Hoteles'] is List) {
            for (var hotel in items['Hoteles']) {
              if (hotel['name'] != null &&
                  hotel['instructions'] != null &&
                  hotel['instructions'] != '-') {
                contactInfo[hotel['name']] = hotel['instructions'];
              }
            }
          }

          // Agregar instrucciones de servicios
          if (items is Map &&
              items.containsKey('Servicios') &&
              items['Servicios'] is List) {
            for (var servicio in items['Servicios']) {
              if (servicio['name'] != null &&
                  servicio['instructions'] != null &&
                  servicio['instructions'] != '-') {
                contactInfo[servicio['name']] = servicio['instructions'];
              }
            }
          }

          // Agregar instrucciones de transporte
          if (items is Map &&
              items.containsKey('Transporte') &&
              items['Transporte'] is List) {
            for (var transporte in items['Transporte']) {
              if (transporte['name'] != null &&
                  transporte['instructions'] != null &&
                  transporte['instructions'] != '-') {
                contactInfo[transporte['name']] = transporte['instructions'];
              }
            }
          }

          // Sección de Transporte
          if (transporteItems.isNotEmpty) {
            widgets.add(
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 15),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Título de la sección
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: colorBrandBlue,
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                      child: pw.Row(
                        children: [
                          transportIcon != null
                              ? pw.Container(
                                  width: 16,
                                  height: 16,
                                  margin: const pw.EdgeInsets.only(right: 8),
                                  child:
                                      pw.Image(pw.MemoryImage(transportIcon)))
                              : pw.Container(),
                          pw.Text(
                            "Transporte",
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Cabecera de la tabla
                    pw.Container(
                      margin: const pw.EdgeInsets.only(top: 5),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                              flex: 2,
                              child: pw.Text("Fecha",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(
                              flex: 3,
                              child: pw.Text("Servicio",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(
                              flex: 4,
                              child: pw.Text("Tarifa",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Container(
                            width: 70, // Ancho fijo para mejor control
                            alignment: pw.Alignment.center,
                            child: pw.Text("Cantidad",
                                style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),

// Filas de ítems
                    ...List.generate(transporteItems.length, (index) {
                      final item = transporteItems[index];
                      return pw.Container(
                        margin: const pw.EdgeInsets.only(top: 3),
                        decoration: pw.BoxDecoration(
                            color: index % 2 == 0
                                ? PdfColors.grey100
                                : PdfColors.white),
                        padding: const pw.EdgeInsets.symmetric(vertical: 3),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(
                              width: 10,
                              height: 10,
                              margin: const pw.EdgeInsets.only(right: 3),
                              decoration: pw.BoxDecoration(
                                  color: colorBrandBlue,
                                  shape: pw.BoxShape.circle),
                            ),
                            pw.Expanded(
                                flex: 2,
                                child: pw.Text(item['date'] ?? "",
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Expanded(
                                flex: 3,
                                child: pw.Text(item['name'] ?? "",
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Expanded(
                                flex: 4,
                                child: pw.Text(item['rate_name'] ?? "",
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Container(
                              width: 70, // Mismo ancho fijo que en la cabecera
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                  item['quantity']?.toString() ?? "1",
                                  style: pw.TextStyle(fontSize: 9)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }
          // Sección de Hoteles
          if (hotelesItems.isNotEmpty) {
            widgets.add(
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 15),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Título de la sección
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: colorBrandBlue,
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                      child: pw.Row(
                        children: [
                          hotelIcon != null
                              ? pw.Container(
                                  width: 16,
                                  height: 16,
                                  margin: const pw.EdgeInsets.only(right: 8),
                                  child: pw.Image(pw.MemoryImage(hotelIcon)))
                              : pw.Container(),
                          pw.Text(
                            "Hoteles",
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Cabecera de la tabla
                    pw.Container(
                      margin: const pw.EdgeInsets.only(top: 5),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                              flex: 2,
                              child: pw.Text("Fecha",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(
                              flex: 4,
                              child: pw.Text("Hotel",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(
                              flex: 4,
                              child: pw.Text("Tarifa",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(
                              flex: 1,
                              child: pw.Text("Noches",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold),
                                  textAlign: pw.TextAlign.center)),
                          pw.Container(
                            width: 70, // Ancho fijo para mejor control
                            alignment: pw.Alignment.center,
                            child: pw.Text("Cantidad",
                                style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),

// Filas de ítems
                    ...List.generate(hotelesItems.length, (index) {
                      final item = hotelesItems[index];
                      String name = item['name'] ?? "";
                      String destination = item['destination'] ?? "";
                      return pw.Container(
                        margin: const pw.EdgeInsets.only(top: 3),
                        decoration: pw.BoxDecoration(
                            color: index % 2 == 0
                                ? PdfColors.grey100
                                : PdfColors.white),
                        padding: const pw.EdgeInsets.symmetric(vertical: 3),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(
                              width: 10,
                              height: 10,
                              margin: const pw.EdgeInsets.only(right: 3),
                              decoration: pw.BoxDecoration(
                                  color: colorBrandBlue,
                                  shape: pw.BoxShape.circle),
                            ),
                            pw.Expanded(
                                flex: 2,
                                child: pw.Text(item['date'] ?? "",
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Expanded(
                                flex: 4,
                                child: pw.Text("$name $destination",
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Expanded(
                                flex: 4,
                                child: pw.Text(item['rate_name'] ?? "",
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                    item['hotel_nights']?.toString() ?? "",
                                    style: pw.TextStyle(fontSize: 9),
                                    textAlign: pw.TextAlign.center)),
                            pw.Container(
                              width: 70, // Mismo ancho fijo que en la cabecera
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                  item['quantity']?.toString() ?? "1",
                                  style: pw.TextStyle(fontSize: 9)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }
          // Sección de Vuelos
          if (vuelosItems.isNotEmpty) {
            widgets.add(
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 15),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Título de la sección
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: colorBrandBlue,
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                      child: pw.Row(
                        children: [
                          flightIcon != null
                              ? pw.Container(
                                  width: 16,
                                  height: 16,
                                  margin: const pw.EdgeInsets.only(right: 8),
                                  child: pw.Image(pw.MemoryImage(flightIcon)))
                              : pw.Container(),
                          pw.Text(
                            "Vuelos",
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Cabecera de la tabla
                    pw.Container(
                      margin: const pw.EdgeInsets.only(top: 5),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                              flex: 2,
                              child: pw.Text("Fecha",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(
                              flex: 2,
                              child: pw.Text("Aerolínea",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(
                              flex: 1,
                              child: pw.Text("H. Salida",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(
                              flex: 1,
                              child: pw.Text("H.Llegada",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(
                              flex: 1,
                              child: pw.Text("Salida",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(
                              flex: 1,
                              child: pw.Text("Llegada",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Container(
                            width: 70, // Ancho fijo para mejor control
                            alignment: pw.Alignment.center,
                            child: pw.Text("Cantidad",
                                style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),

// Filas de ítems
                    ...List.generate(vuelosItems.length, (index) {
                      final item = vuelosItems[index];
                      String aerolinea = item['name'] ?? "";
                      String departureTime = item['departure_time'] ?? "";
                      String arrivalTime = item['arrival_time'] ?? "";
                      String llegada =
                          item['iata_destination'] ?? item['arrival'] ?? "";
                      String salida =
                          item['iata_departure'] ?? item['departure'] ?? "";

                      return pw.Container(
                        margin: const pw.EdgeInsets.only(top: 3),
                        decoration: pw.BoxDecoration(
                            color: index % 2 == 0
                                ? PdfColors.grey100
                                : PdfColors.white),
                        padding: const pw.EdgeInsets.symmetric(vertical: 3),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(
                              width: 10,
                              height: 10,
                              margin: const pw.EdgeInsets.only(right: 3),
                              decoration: pw.BoxDecoration(
                                  color: colorBrandBlue,
                                  shape: pw.BoxShape.circle),
                            ),
                            pw.Expanded(
                                flex: 2,
                                child: pw.Text(item['date'] ?? "",
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Expanded(
                                flex: 2,
                                child: pw.Text(aerolinea,
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(departureTime,
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(arrivalTime,
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(salida,
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(llegada,
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Container(
                              width: 70, // Mismo ancho fijo que en la cabecera
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                  item['quantity']?.toString() ?? "1",
                                  style: pw.TextStyle(fontSize: 9)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }
          // Sección de Servicios
          if (serviciosItems.isNotEmpty) {
            widgets.add(
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 15),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Título de la sección
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: colorBrandBlue,
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                      child: pw.Row(
                        children: [
                          serviceIcon != null
                              ? pw.Container(
                                  width: 16,
                                  height: 16,
                                  margin: const pw.EdgeInsets.only(right: 8),
                                  child: pw.Image(pw.MemoryImage(serviceIcon)))
                              : pw.Container(),
                          pw.Text(
                            "Servicios",
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Cabecera de la tabla
                    pw.Container(
                      margin: const pw.EdgeInsets.only(top: 5),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                              flex: 2,
                              child: pw.Text("Fecha",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(
                              flex: 3,
                              child: pw.Text("Servicio",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(
                              flex: 4,
                              child: pw.Text("Tarifa",
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Container(
                            width: 70, // Ancho fijo para mejor control
                            alignment: pw.Alignment.center,
                            child: pw.Text("Cantidad",
                                style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),

// Filas de ítems
                    ...List.generate(serviciosItems.length, (index) {
                      final item = serviciosItems[index];
                      return pw.Container(
                        margin: const pw.EdgeInsets.only(top: 3),
                        decoration: pw.BoxDecoration(
                            color: index % 2 == 0
                                ? PdfColors.grey100
                                : PdfColors.white),
                        padding: const pw.EdgeInsets.symmetric(vertical: 3),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(
                              width: 10,
                              height: 10,
                              margin: const pw.EdgeInsets.only(right: 3),
                              decoration: pw.BoxDecoration(
                                  color: colorBrandBlue,
                                  shape: pw.BoxShape.circle),
                            ),
                            pw.Expanded(
                                flex: 2,
                                child: pw.Text(item['date'] ?? "",
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Expanded(
                                flex: 3,
                                child: pw.Text(item['name'] ?? "",
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Expanded(
                                flex: 4,
                                child: pw.Text(item['rate_name'] ?? "",
                                    style: pw.TextStyle(fontSize: 9))),
                            pw.Container(
                              width: 70, // Mismo ancho fijo que en la cabecera
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                  item['quantity']?.toString() ?? "1",
                                  style: pw.TextStyle(fontSize: 9)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }
          // Información de contacto e instrucciones (si existe)
          // Información de contacto e instrucciones (si existe)
          if (contactInfo.isNotEmpty) {
            // Agregar el encabezado principal
            widgets.add(
              pw.Container(
                width: double.infinity,
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                margin: const pw.EdgeInsets.only(bottom: 10),
                decoration: pw.BoxDecoration(
                  color: colorBrandBlue,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Text(
                  "Información de contacto e instrucciones",
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            );

            int index = 0;
            for (var entry in contactInfo.entries) {
              // Añadir el título por separado
              widgets.add(
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    border: pw.Border(
                      left: pw.BorderSide(color: PdfColors.grey400),
                      right: pw.BorderSide(color: PdfColors.grey400),
                      top: pw.BorderSide(color: PdfColors.grey400),
                    ),
                  ),
                  child: pw.Text(
                    entry.key,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              );

              // Dividir el texto en fragmentos manejables
              // (aproximadamente 1000 caracteres por fragmento)
              final String content = entry.value;
              final int fragmentSize = 1000;
              final int totalFragments = (content.length / fragmentSize).ceil();

              for (int i = 0; i < totalFragments; i++) {
                final int startIndex = i * fragmentSize;
                final int endIndex = (i + 1) * fragmentSize > content.length
                    ? content.length
                    : (i + 1) * fragmentSize;
                final String fragmentText =
                    content.substring(startIndex, endIndex);

                // Crear un contenedor para cada fragmento
                widgets.add(
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color:
                          index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                      border: i == totalFragments - 1
                          // Para el último fragmento, incluye todos los bordes
                          ? pw.Border(
                              left: pw.BorderSide(color: PdfColors.grey400),
                              right: pw.BorderSide(color: PdfColors.grey400),
                              bottom: pw.BorderSide(color: PdfColors.grey400),
                            )
                          // Para fragmentos intermedios, omite el borde inferior
                          : pw.Border(
                              left: pw.BorderSide(color: PdfColors.grey400),
                              right: pw.BorderSide(color: PdfColors.grey400),
                            ),
                    ),
                    child: pw.Text(
                      fragmentText,
                      style: pw.TextStyle(fontSize: 9),
                      textAlign: pw.TextAlign.justify,
                    ),
                  ),
                );
              }

              // Añadir espacio después de cada entrada completa
              widgets.add(pw.SizedBox(height: 10));

              index++;
            }
          }
          // Sección de Pasajeros (si hay datos disponibles)
          if (passengersData.isNotEmpty) {
            widgets.add(
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 15),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Título de la sección
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: colorBrandBlue,
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                      child: pw.Text(
                        "Pasajeros",
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),

                    // Tabla de pasajeros
                    pw.Container(
                      margin: const pw.EdgeInsets.only(top: 5),
                      child: pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.grey300),
                        children: [
                          // Cabecera
                          pw.TableRow(
                            decoration:
                                pw.BoxDecoration(color: PdfColors.grey200),
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text("Nombre",
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text("Apellidos",
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text("Tipo / No. Identificación",
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text("Nacionalidad",
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text("Fecha Nacimiento",
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                            ],
                          ),
                          // Filas de pasajeros
                          ...passengersData.map((passenger) {
                            // Determinar la fila par/impar para alternar colores
                            final indexColor =
                                passengersData.indexOf(passenger) % 2 == 0
                                    ? PdfColors.grey100
                                    : PdfColors.white;

                            // Buscar campos según su formato
                            String name =
                                passenger['name'] ?? passenger['nombre'] ?? '';
                            String lastName = passenger['last_name'] ??
                                passenger['apellidos'] ??
                                '';
                            String typeId = passenger['type_id'] ??
                                passenger['tipo_id'] ??
                                passenger['tipo_documento'] ??
                                '';
                            String numberId = passenger['number_id'] ??
                                passenger['numero_id'] ??
                                '';
                            String nationality = passenger['nationality'] ??
                                passenger['nacionalidad'] ??
                                '';
                            String birthDate = passenger['birth_date'] ??
                                passenger['fecha_nacimiento'] ??
                                '';

                            return pw.TableRow(
                              decoration: pw.BoxDecoration(
                                color: indexColor,
                              ),
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(name,
                                      style: pw.TextStyle(fontSize: 9)),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(lastName,
                                      style: pw.TextStyle(fontSize: 9)),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text("$typeId $numberId",
                                      style: pw.TextStyle(fontSize: 9)),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(nationality,
                                      style: pw.TextStyle(fontSize: 9)),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(birthDate,
                                      style: pw.TextStyle(fontSize: 9)),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          // Sección de Estado de Cuenta (si hay pagos)
          if (paymentsData.isNotEmpty) {
            widgets.add(
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 15),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Título de la sección
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: colorBrandBlue,
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                      child: pw.Text(
                        "Estado de cuenta",
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),

                    // Tabla de pagos
                    pw.Container(
                      margin: const pw.EdgeInsets.only(top: 5),
                      child: pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.grey300),
                        children: [
                          // Cabecera
                          pw.TableRow(
                            decoration:
                                pw.BoxDecoration(color: PdfColors.grey200),
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text("Fecha",
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text("Num. Recibo",
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text("Forma Pago",
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text("ID Transacción",
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text("Total",
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                            ],
                          ),
                          // Filas de pagos
                          ...paymentsData.map((payment) {
                            // Determinar la fila par/impar para alternar colores
                            final indexColor =
                                paymentsData.indexOf(payment) % 2 == 0
                                    ? PdfColors.grey100
                                    : PdfColors.white;

                            // Extraer datos de diferentes formatos posibles de JSON
                            String date = payment['date'] ?? '';
                            String receiptNum = payment['receipt_number'] ?? '';
                            String paymentMethod =
                                payment['payment_method'] ?? '';
                            String transactionId =
                                payment['transaction_id'] ?? '';

                            // Manejar el valor total de diferentes fuentes
                            dynamic totalValue = payment['value'] ?? 0;

                            // IMPORTANTE: Asumimos que todas las transacciones están en la moneda base (COP en este caso)
                            // Y necesitamos convertirlas a la moneda seleccionada si es diferente a la base
                            String baseCurrency = '';
                            if (currencies.isNotEmpty) {
                              for (var currency in currencies) {
                                if (currency['type'] == 'base') {
                                  baseCurrency = currency['name'];
                                  break;
                                }
                              }
                            }

// Aplicar conversión si la moneda seleccionada es diferente a la base
                            if (currencyType != baseCurrency &&
                                currencies.isNotEmpty &&
                                baseCurrency.isNotEmpty) {
                              // Convertir a double
                              double baseValue = 0.0;
                              if (totalValue is String) {
                                baseValue = double.tryParse(
                                        totalValue.replaceAll(',', '.')) ??
                                    0.0;
                              } else if (totalValue is num) {
                                baseValue = totalValue.toDouble();
                              }

                              // Aplicar la conversión
                              totalValue = convertCurrency(
                                  baseValue, currencyType, currencies);
                            }

                            // Formatear para mostrar
                            String formattedTotal =
                                "${formatMoney(totalValue)} ${allDataJson['currency_type']}";

                            return pw.TableRow(
                              decoration: pw.BoxDecoration(color: indexColor),
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(date,
                                      style: pw.TextStyle(fontSize: 9)),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(receiptNum,
                                      style: pw.TextStyle(fontSize: 9)),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(paymentMethod,
                                      style: pw.TextStyle(fontSize: 9)),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(transactionId,
                                      style: pw.TextStyle(fontSize: 9)),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(formattedTotal,
                                      style: pw.TextStyle(fontSize: 9)),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                    // Fila de totales - USANDO FORMATO MONETARIO EN CADA VALOR
                    // Con los valores convertidos a la moneda seleccionada

                    pw.Container(
                      margin: const pw.EdgeInsets.only(top: 5),
                      padding: const pw.EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      color: colorBrandBlue,
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text("TOTAL A PAGAR",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.white)),
                          ),
                          pw.Text(
                              "${formatMoney(convertedAmount)} ${allDataJson['currency_type']}",
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white)),
                          pw.SizedBox(width: 30),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text("TOTAL PAGO",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.white)),
                          ),
                          pw.Text(
                              "${formatMoney(_calculateTotalPayments(paid, currencyType, currencies))} ${allDataJson['currency_type']}",
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white)),
                          pw.SizedBox(width: 30),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text("SALDO",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.white)),
                          ),
                          pw.Text(
                              "${formatMoney(_calculateBalance(convertedAmount, pending_paid, currencyType, currencies))} ${allDataJson['currency_type']}",
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Devolver todos los widgets
          return widgets;
        },
      ),
    );
    // Convertir el PDF a bytes
    final Uint8List bytes = await pdf.save();

    // Subir el PDF a Supabase Storage y obtener la URL firmada
    final String pdfUrl = await _uploadPDFToStorage(bytes,
        "${accountId}/invoices/voucher_${itineraryId}_${DateTime.now().millisecondsSinceEpoch}.pdf");

    // Abrir el PDF para visualización o descarga
    _openPDF(pdfUrl);

    print("✅ Voucher PDF disponible en: $pdfUrl");
  } catch (e) {
    print('Error al generar el PDF: $e');
  }
}

double _calculateTotalPayments(
    String paid, String targetCurrency, List<dynamic> currencies) {
  double paidValue = 0.0;

  // Convertir a double si el valor paid existe
  if (paid != null && paid.isNotEmpty) {
    try {
      paidValue = double.parse(paid.replaceAll(',', '.'));
    } catch (e) {
      print('Error al convertir paid a double: $e');
    }
  }

  // Determinar la moneda base del array de monedas
  String baseCurrency = '';
  if (currencies.isNotEmpty) {
    for (var currency in currencies) {
      if (currency['type'] == 'base') {
        baseCurrency = currency['name'];
        break;
      }
    }
  }

  // Aplicar conversión solo si la moneda objetivo es diferente a la base
  // y si hemos encontrado una moneda base válida
  if (targetCurrency != baseCurrency &&
      currencies.isNotEmpty &&
      baseCurrency.isNotEmpty) {
    paidValue = convertCurrency(paidValue, targetCurrency, currencies);
  }

  return paidValue;
}

double _calculateBalance(double totalAmount, String pendingPaid,
    String targetCurrency, List<dynamic> currencies) {
  double pendingValue = 0.0;

  // Convertir a double si el valor pendingPaid existe
  if (pendingPaid != null && pendingPaid.isNotEmpty) {
    try {
      pendingValue = double.parse(pendingPaid.replaceAll(',', '.'));
    } catch (e) {
      print('Error al convertir pendingPaid a double: $e');
    }
  }

  // Determinar la moneda base del array de monedas
  String baseCurrency = '';
  if (currencies.isNotEmpty) {
    for (var currency in currencies) {
      if (currency['type'] == 'base') {
        baseCurrency = currency['name'];
        break;
      }
    }
  }

  // Aplicar conversión solo si la moneda objetivo es diferente a la base
  // y si hemos encontrado una moneda base válida
  if (targetCurrency != baseCurrency &&
      currencies.isNotEmpty &&
      baseCurrency.isNotEmpty) {
    pendingValue = convertCurrency(pendingValue, targetCurrency, currencies);
  }

  return pendingValue;
}

// Función para subir el PDF a Supabase Storage con URL firmada de larga duración
Future<String> _uploadPDFToStorage(Uint8List pdfBytes, String fileName) async {
  final supabase = Supabase.instance.client;
  final bucketName =
      "images"; // Asegúrate de que este bucket existe en Supabase

  // Sube el archivo (sobrescribe si es necesario)
  await supabase.storage.from(bucketName).uploadBinary(
        fileName,
        pdfBytes,
        fileOptions: const FileOptions(upsert: true),
      );

  // Genera una URL firmada con expiración de 100 años (3153600000 segundos)
  final signedUrl = await supabase.storage
      .from(bucketName)
      .createSignedUrl(fileName, 3153600000);
  return signedUrl;
}

// Función para abrir el PDF en el navegador en Web y en Android/iOS
void _openPDF(String pdfUrl) {
  _launchURL(pdfUrl);
}

Future<void> _launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'No se pudo abrir el enlace: $url';
  }
}
