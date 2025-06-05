// Automatic FlutterFlow imports
import '../../backend/schema/structs/index.dart';
import '../../backend/supabase/supabase.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'package:bukeer/design_system/index.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '../actions/index.dart'; // Imports custom actions
import '../../flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '../actions/index.dart'; // Imports other custom actions

// Asegúrate de tener esta dependencia en Pubspec Dependencies:
// intl_phone_field: ^3.2.0 (o superior)
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/countries.dart'; // Necesario para el tipo Country

class InternationalPhoneInput extends StatefulWidget {
  const InternationalPhoneInput({
    Key? key,
    this.width,
    this.height,
    this.initialValue, // Idealmente en formato E.164: +573001234567
    required this.labelText,
    required this.onPhoneNumberChanged, // Callback que recibe String (E.164)
    this.isRequired =
        false, // Parámetro opcional para validación de campo requerido
    this.requiredMessage =
        'Este campo es requerido', // Mensaje si es requerido y vacío
    this.invalidLengthMessage =
        'Longitud de número inválida para', // Mensaje base para longitud inválida
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? initialValue;
  final String labelText;
  final Future<void> Function(String phoneNumberE164) onPhoneNumberChanged;
  final bool isRequired;
  final String requiredMessage;
  final String invalidLengthMessage;

  @override
  _InternationalPhoneInputState createState() =>
      _InternationalPhoneInputState();
}

class _InternationalPhoneInputState extends State<InternationalPhoneInput> {
  // Variable para almacenar el país seleccionado actualmente
  Country? _selectedCountry;
  // Controlador para poder limpiar el campo si cambia el país y queremos resetear
  final TextEditingController _controller = TextEditingController();
  // Variable para almacenar el número completo actual (E.164)
  String _currentE164Number = '';

  @override
  void initState() {
    super.initState();
    // Intentamos inicializar el país si hay un valor inicial
    // Nota: `intl_phone_field` maneja esto internamente bastante bien,
    // pero tener `_selectedCountry` ayuda en el validator inicial.
    // No es estrictamente necesario pre-calcularlo aquí si el onCountryChanged
    // se llama al inicio.
    if (widget.initialValue != null && widget.initialValue!.startsWith('+')) {
      try {
        PhoneNumber initialPhone = PhoneNumber.fromCompleteNumber(
            completeNumber: widget.initialValue!);
        // Buscamos el país correspondiente al código ISO
        _selectedCountry =
            countries.firstWhere((c) => c.code == initialPhone.countryISOCode);
        _controller.text = initialPhone
            .number; // Asignar solo el número nacional al controlador
        _currentE164Number = widget.initialValue!;
      } catch (e) {
        print("Error parsing initial value country: $e");
        // Si falla, la librería intentará detectarlo o usará el default
      }
    } else if (widget.initialValue != null) {
      _controller.text = widget.initialValue!; // Asignar si no es E.164
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ffTheme = FlutterFlowTheme.of(context);

    return Container(
      width: widget.width,
      child: IntlPhoneField(
        controller: _controller, // Usar el controlador
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: ffTheme.labelMedium,
          hintStyle: ffTheme.labelMedium,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ffTheme.alternate,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ffTheme.primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ffTheme.error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ffTheme.error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
          ),
          contentPadding:
              EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
        ),
        style: ffTheme.bodyMedium,

        // Asignamos el país inicial detectado (si existe) o dejamos que la librería elija
        initialCountryCode: _selectedCountry?.code,
        // NO usamos initialValue aquí porque ya lo manejamos con el controller

        disableLengthCheck:
            true, // <-- Añadido para deshabilitar la validación de longitud interna

        onChanged: (phone) {
          // phone es un objeto PhoneNumber
          print('Phone changed: ${phone.completeNumber}'); // Debug
          // Actualizamos el número E.164 actual
          _currentE164Number = phone.completeNumber;
          // Llama al callback principal con el número E.164
          // Es importante llamarlo aquí para que FF reciba el valor mientras se escribe
          widget.onPhoneNumberChanged(phone.completeNumber ?? '');
        },
        onCountryChanged: (country) {
          print('Country changed to: ' + country.name);
          setState(() {
            _selectedCountry = country;
          });
          // Opcional: Limpiar el campo de número al cambiar de país
          // _controller.clear();
          // _currentE164Number = '';
          // widget.onPhoneNumberChanged(''); // Notificar el cambio a vacío

          // Re-validar el formulario si está dentro de uno
          // (Puede ser necesario si la validación depende del país y el número ya estaba escrito)
          Form.of(context)?.validate();
        },

        // --- IMPLEMENTACIÓN DEL VALIDATOR ---
        validator: (PhoneNumber? phone) {
          // 1. Validación de campo requerido (si está activado)
          if (widget.isRequired && (phone == null || phone.number.isEmpty)) {
            return widget.requiredMessage;
          }
          // Si no es requerido y está vacío, es válido (null)
          if (phone == null || phone.number.isEmpty) {
            return null;
          }

          // 2. Validación de longitud flexible (+/- 1)
          if (_selectedCountry != null) {
            final numberLength =
                phone.number.length; // Longitud del número nacional
            final minLength = _selectedCountry!.minLength;
            final maxLength = _selectedCountry!.maxLength;

            // Comprobamos si la longitud está dentro del rango flexible
            // Usamos >= minLength - 1 y <= maxLength + 1
            // Hay que tener cuidado con minLength siendo 0 o -1 en algunos datos de países
            final lowerBound = (minLength > 0) ? minLength - 1 : 0;
            final upperBound = (maxLength > 0)
                ? maxLength + 1
                : numberLength +
                    1; // Si no hay maxLength, no limitamos superiormente

            if (numberLength >= lowerBound && numberLength <= upperBound) {
              // Longitud válida dentro del rango flexible
              return null; // Válido
            } else {
              // Longitud inválida
              return '${widget.invalidLengthMessage} ${_selectedCountry!.name} (${lowerBound}-${upperBound} dígitos)';
            }
          } else {
            // No debería pasar si onCountryChanged funciona bien, pero por si acaso
            // Podríamos intentar una validación genérica o simplemente permitirlo
            print(
                "Advertencia: _selectedCountry es nulo durante la validación.");
            return null; // Permitir si no tenemos información del país
            // O podrías retornar un error genérico: return 'Seleccione un país primero';
          }
        },
        // --- FIN DEL VALIDATOR ---

        // AutovalidateMode para mostrar errores mientras se escribe (opcional)
        autovalidateMode: AutovalidateMode.onUserInteraction,

        flagsButtonPadding: EdgeInsets.only(left: 8),
        dropdownIconPosition: IconPosition.leading,
        showDropdownIcon: true,
        dropdownIcon: Icon(Icons.arrow_drop_down, color: ffTheme.secondaryText),
        dropdownTextStyle: ffTheme.bodyMedium,
      ),
    );
  }
}
// DO NOT REMOVE OR MODIFY THE CODE BELOW!
