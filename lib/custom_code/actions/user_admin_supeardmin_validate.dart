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

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> userAdminSupeardminValidate(
  String? idCreatedBy,
  String? idUser,
) async {
  // Verificar si alguno de los parámetros es nulo
  if (idUser == null || idCreatedBy == null) {
    return false;
  }

  // Verificar si el usuario es el creador del recurso
  if (idUser == idCreatedBy) {
    return true;
  }

  try {
    // Obtener el cliente de Supabase
    final supabase = Supabase.instance.client;

    // Consultar los roles del usuario
    final response = await supabase
        .from('user_roles_view')
        .select('role_names')
        .eq('user_id', idUser)
        .maybeSingle();

    // Verificar si tiene roles de admin o super_admin
    if (response != null) {
      final String roleNames = response['role_names'] ?? '';
      if (roleNames.contains('super_admin') || roleNames.contains('admin')) {
        return true;
      }
    }

    return false;
  } catch (e) {
    print('Error verificando roles: $e');
    return false;
  }
}
