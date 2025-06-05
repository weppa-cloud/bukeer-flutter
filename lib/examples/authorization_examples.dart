import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../components/authorization_widget.dart';
import '../services/authorization_service.dart';

/// Examples of how to use the new authorization system
/// These examples show best practices for different scenarios

class AuthorizationExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Authorization Examples')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRoleBasedExamples(),
            SizedBox(height: 24),
            _buildPermissionBasedExamples(),
            SizedBox(height: 24),
            _buildResourceBasedExamples(),
            SizedBox(height: 24),
            _buildButtonExamples(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleBasedExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Role-Based Authorization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        
        // Admin only section
        AdminOnlyWidget(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('🔧 Esta sección solo es visible para administradores'),
          ),
          fallback: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('📝 Contenido estándar para usuarios regulares'),
          ),
        ),
        
        SizedBox(height: 12),
        
        // Super admin only section
        SuperAdminOnlyWidget(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('⚡ Esta sección solo es visible para super administradores'),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionBasedExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Permission-Based Authorization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        
        // User creation permission
        AuthorizedWidget(
          requiredPermissions: [Permissions.userCreate],
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('👤 Puede crear usuarios'),
          ),
          fallback: Text('❌ No puede crear usuarios'),
        ),
        
        SizedBox(height: 12),
        
        // Multiple permissions required
        AuthorizedWidget(
          requiredPermissions: [
            Permissions.itineraryCreate,
            Permissions.contactCreate,
          ],
          requireAll: true,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('✈️ Puede crear itinerarios y contactos'),
          ),
        ),
      ],
    );
  }

  Widget _buildResourceBasedExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resource-Based Authorization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        
        // Itinerary access example
        ResourceAccessWidget(
          resourceType: 'itinerary',
          ownerId: 'user123', // Simulated owner ID
          ownerChild: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text('🏠 Eres el dueño de este itinerario'),
                Row(
                  children: [
                    FFButtonWidget(
                      onPressed: () {},
                      text: 'Editar',
                      options: FFButtonOptions(height: 32),
                    ),
                    SizedBox(width: 8),
                    FFButtonWidget(
                      onPressed: () {},
                      text: 'Eliminar',
                      options: FFButtonOptions(height: 32),
                    ),
                  ],
                ),
              ],
            ),
          ),
          adminChild: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text('🔧 Acceso de administrador'),
                FFButtonWidget(
                  onPressed: () {},
                  text: 'Editar como Admin',
                  options: FFButtonOptions(height: 32),
                ),
              ],
            ),
          ),
          readOnlyChild: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text('👁️ Solo lectura'),
                FFButtonWidget(
                  onPressed: () {},
                  text: 'Ver Detalles',
                  options: FFButtonOptions(height: 32),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Authorized Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // Delete button - admin only
            AuthorizedButton(
              onPressed: () => _showMessage('Eliminando...'),
              requiredRoles: [RoleType.admin, RoleType.superAdmin],
              tooltip: 'Eliminar elemento',
              child: Text('🗑️ Eliminar'),
            ),
            
            // Create button - specific permission
            AuthorizedButton(
              onPressed: () => _showMessage('Creando...'),
              requiredPermissions: [Permissions.itineraryCreate],
              tooltip: 'Crear nuevo itinerario',
              child: Text('➕ Crear Itinerario'),
            ),
            
            // Edit button - resource based
            AuthorizedButton(
              onPressed: () => _showMessage('Editando...'),
              resourceType: 'itinerary',
              action: 'update',
              ownerId: 'user123',
              tooltip: 'Editar itinerario',
              child: Text('✏️ Editar'),
            ),
          ],
        ),
      ],
    );
  }

  void _showMessage(String message) {
    // Placeholder for showing messages
    debugPrint(message);
  }
}

/// Example usage in existing widgets
class ItineraryListItemWithAuth extends StatelessWidget {
  final dynamic itinerary;

  const ItineraryListItemWithAuth({Key? key, required this.itinerary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itineraryId = itinerary['id']?.toString();
    final ownerId = itinerary['created_by']?.toString();
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              itinerary['name'] ?? 'Sin nombre',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            
            // Action buttons based on permissions
            Row(
              children: [
                // View button - everyone can see
                FFButtonWidget(
                  onPressed: () => _viewItinerary(itineraryId),
                  text: 'Ver',
                  options: FFButtonOptions(height: 32),
                ),
                
                SizedBox(width: 8),
                
                // Edit button - owner or admin
                AuthorizedButton(
                  onPressed: () => _editItinerary(itineraryId),
                  resourceType: 'itinerary',
                  action: 'update',
                  ownerId: ownerId,
                  child: Text('Editar'),
                ),
                
                SizedBox(width: 8),
                
                // Delete button - admin only
                AuthorizedButton(
                  onPressed: () => _deleteItinerary(itineraryId),
                  requiredRoles: [RoleType.admin, RoleType.superAdmin],
                  child: Text('Eliminar'),
                ),
                
                Spacer(),
                
                // User role badge
                if (ownerId != null)
                  UserRoleBadge(userId: ownerId),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _viewItinerary(String? id) {
    debugPrint('Viewing itinerary: $id');
  }

  void _editItinerary(String? id) {
    debugPrint('Editing itinerary: $id');
  }

  void _deleteItinerary(String? id) {
    debugPrint('Deleting itinerary: $id');
  }
}