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

import '../../services/authorization_service.dart';

/// Improved authorization validation using the new AuthorizationService
/// This replaces the old string-based role checking with a robust permission system
Future<bool> userAdminSupeardminValidateImproved(
  String? idCreatedBy,
  String? idUser, {
  String? resourceType,
  String? action,
  List<String>? requiredPermissions,
}) async {
  // Null check
  if (idUser == null) {
    debugPrint('AuthValidation: User ID is null');
    return false;
  }

  try {
    final authService = AuthorizationService();
    
    // If user is the owner/creator, they have access
    if (idCreatedBy != null && idUser == idCreatedBy) {
      debugPrint('AuthValidation: User $idUser is the owner');
      return true;
    }

    // Use comprehensive authorization check
    final isAuthorized = await authService.authorize(
      userId: idUser,
      ownerId: idCreatedBy,
      requiredRoles: [RoleType.admin, RoleType.superAdmin], // Allow admin or super admin
      requiredPermissions: requiredPermissions,
      resourceType: resourceType,
      action: action,
    );

    debugPrint('AuthValidation: User $idUser authorization result: $isAuthorized');
    return isAuthorized;
    
  } catch (e) {
    debugPrint('AuthValidation Error: $e');
    // On error, deny access for security
    return false;
  }
}

/// Quick check if user is admin or super admin
Future<bool> isUserAdmin(String? userId) async {
  if (userId == null) return false;
  
  try {
    final authService = AuthorizationService();
    await authService.loadUserRoles(userId);
    return authService.isAdmin;
  } catch (e) {
    debugPrint('isUserAdmin Error: $e');
    return false;
  }
}

/// Check if user has specific permission
Future<bool> userHasPermission(String? userId, String permission) async {
  if (userId == null) return false;
  
  try {
    final authService = AuthorizationService();
    await authService.loadUserRoles(userId);
    return authService.hasPermission(permission);
  } catch (e) {
    debugPrint('userHasPermission Error: $e');
    return false;
  }
}

/// Check if user can perform action on resource
Future<bool> canUserAccessResource(
  String? userId,
  String resourceType,
  String action, {
  String? ownerId,
}) async {
  if (userId == null) return false;
  
  try {
    final authService = AuthorizationService();
    return authService.canAccessResource(
      resourceType,
      action,
      ownerId: ownerId,
      currentUserId: userId,
    );
  } catch (e) {
    debugPrint('canUserAccessResource Error: $e');
    return false;
  }
}