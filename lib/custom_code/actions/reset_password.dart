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

import 'index.dart';
import 'package:bukeer/legacy/flutter_flow/custom_functions.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<String?> resetPassword(String? newPassword) async {
  // Handle null or empty password
  if (newPassword == null || newPassword.trim().isEmpty) {
    return 'Password cannot be empty';
  }

  try {
    // Use the Supabase client to update the user's password
    final response = await SupaFlow.client.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    // Check if the update was successful
    if (response.user != null) {
      // Success case
      return null;
    } else {
      // Something went wrong but no exception was thrown
      return 'Failed to update password. Please try again.';
    }
  } catch (error) {
    // Log the error but return a simple message to prevent UI issues
    print('Password reset error: $error');
    return 'Error updating password: ${error.toString()}';
  }
}
