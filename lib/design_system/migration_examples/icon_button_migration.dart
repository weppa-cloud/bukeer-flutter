/// Guía de Migración: FlutterFlowIconButton → BukeerIconButton
///
/// Este archivo muestra ejemplos de cómo migrar de FlutterFlowIconButton
/// al nuevo BukeerIconButton del sistema de diseño.

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/design_system/components/buttons/bukeer_icon_button.dart';

class IconButtonMigrationExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ANTES - FlutterFlowIconButton:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 16),

        // Ejemplo 1: Botón básico
        _buildExample(
          'Botón básico',
          before: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            buttonSize: 48,
            icon: Icon(
              Icons.edit,
              color: Color(0xFF1976D2),
              size: 24,
            ),
            onPressed: () {
              print('Edit pressed');
            },
          ),
          after: BukeerIconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              print('Edit pressed');
            },
            size: BukeerIconButtonSize.large,
            variant: BukeerIconButtonVariant.ghost,
          ),
        ),

        // Ejemplo 2: Botón con fondo
        _buildExample(
          'Botón con fondo',
          before: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 20,
            buttonSize: 40,
            fillColor: Color(0xFF1976D2),
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              print('Add pressed');
            },
          ),
          after: BukeerIconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print('Add pressed');
            },
            size: BukeerIconButtonSize.medium,
            variant: BukeerIconButtonVariant.filled,
          ),
        ),

        // Ejemplo 3: Botón con borde
        _buildExample(
          'Botón con borde',
          before: FlutterFlowIconButton(
            borderColor: Color(0xFF1976D2),
            borderRadius: 8,
            borderWidth: 1,
            buttonSize: 40,
            fillColor: Colors.transparent,
            icon: Icon(
              Icons.close,
              color: Color(0xFF1976D2),
              size: 20,
            ),
            onPressed: () {
              print('Close pressed');
            },
          ),
          after: BukeerIconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              print('Close pressed');
            },
            size: BukeerIconButtonSize.medium,
            variant: BukeerIconButtonVariant.outlined,
          ),
        ),

        // Ejemplo 4: Botón pequeño con FontAwesome
        _buildExample(
          'Botón pequeño con FontAwesome',
          before: FlutterFlowIconButton(
            borderRadius: 30,
            buttonSize: 32,
            icon: FaIcon(
              FontAwesomeIcons.heart,
              color: Color(0xFFF44336),
              size: 16,
            ),
            onPressed: () {
              print('Heart pressed');
            },
          ),
          after: BukeerIconButton(
            icon: FaIcon(FontAwesomeIcons.heart),
            iconColor: Colors.red,
            onPressed: () {
              print('Heart pressed');
            },
            size: BukeerIconButtonSize.small,
            variant: BukeerIconButtonVariant.ghost,
          ),
        ),

        // Ejemplo 5: Botón con loading
        _buildExample(
          'Botón con loading indicator',
          before: FlutterFlowIconButton(
            borderRadius: 30,
            buttonSize: 48,
            icon: Icon(
              Icons.save,
              color: Colors.white,
              size: 24,
            ),
            fillColor: Color(0xFF1976D2),
            showLoadingIndicator: true,
            onPressed: () async {
              await Future.delayed(Duration(seconds: 2));
              print('Save completed');
            },
          ),
          after: BukeerIconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              await Future.delayed(Duration(seconds: 2));
              print('Save completed');
            },
            size: BukeerIconButtonSize.large,
            variant: BukeerIconButtonVariant.filled,
            showLoadingIndicator: true,
          ),
        ),

        // Ejemplo 6: Botón con tooltip
        _buildExample(
          'Botón con tooltip',
          before: Tooltip(
            message: 'Eliminar',
            child: FlutterFlowIconButton(
              borderRadius: 30,
              buttonSize: 40,
              icon: Icon(
                Icons.delete,
                color: Color(0xFFF44336),
                size: 20,
              ),
              onPressed: () {
                print('Delete pressed');
              },
            ),
          ),
          after: BukeerIconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              print('Delete pressed');
            },
            size: BukeerIconButtonSize.medium,
            variant: BukeerIconButtonVariant.danger,
            tooltip: 'Eliminar',
          ),
        ),

        // Ejemplo 7: Botón deshabilitado
        _buildExample(
          'Botón deshabilitado',
          before: FlutterFlowIconButton(
            borderRadius: 30,
            buttonSize: 40,
            icon: Icon(
              Icons.send,
              color: Colors.grey,
              size: 20,
            ),
            fillColor: Color(0xFFE0E0E0),
            disabledColor: Color(0xFFE0E0E0),
            disabledIconColor: Colors.grey,
            onPressed: null,
          ),
          after: BukeerIconButton(
            icon: Icon(Icons.send),
            onPressed: null,
            size: BukeerIconButtonSize.medium,
            variant: BukeerIconButtonVariant.filled,
          ),
        ),
      ],
    );
  }

  Widget _buildExample(String title,
      {required Widget before, required Widget after}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('Antes:', style: TextStyle(color: Colors.red)),
                    SizedBox(height: 8),
                    before,
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('Después:', style: TextStyle(color: Colors.green)),
                    SizedBox(height: 8),
                    after,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Resumen de cambios principales:
///
/// 1. **Importación**:
///    - Antes: import '/flutter_flow/flutter_flow_icon_button.dart';
///    - Después: import '/design_system/components/buttons/bukeer_icon_button.dart';
///
/// 2. **Tamaños consistentes**:
///    - Antes: buttonSize: 32/40/48 (valores arbitrarios)
///    - Después: size: BukeerIconButtonSize.small/medium/large
///
/// 3. **Variantes visuales**:
///    - Antes: Configurar fillColor, borderColor, etc. manualmente
///    - Después: variant: BukeerIconButtonVariant.filled/outlined/ghost/danger
///
/// 4. **Colores del sistema**:
///    - Antes: Color(0xFF1976D2), Colors.white, etc.
///    - Después: Se usan automáticamente los colores del design system
///
/// 5. **Simplificación**:
///    - Menos propiedades necesarias
///    - Comportamiento consistente por defecto
///    - Tooltip integrado como propiedad
///
/// 6. **Beneficios**:
///    - Consistencia visual automática
///    - Menos código para mantener
///    - Accesibilidad mejorada
///    - Estados (hover, disabled) manejados automáticamente
