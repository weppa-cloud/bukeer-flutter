// Archivo de prueba para el pre-commit hook
import 'package:flutter/material.dart';

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Test con ñáéíóú'),
    );
  }
}
