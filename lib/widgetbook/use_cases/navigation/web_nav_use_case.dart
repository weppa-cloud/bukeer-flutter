import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bukeer/bukeer/core/widgets/navigation/web_nav/web_nav_widget.dart';
import 'package:bukeer/services/app_services.dart';
import 'package:bukeer/services/authorization_service.dart';
import 'package:provider/provider.dart';

WidgetbookComponent getWebNavUseCases() {
  return WidgetbookComponent(
    name: 'WebNav',
    useCases: [
      WidgetbookUseCase(
        name: 'Dashboard Selected',
        builder: (context) => _WebNavWrapper(
          selectedNav: 1,
          userRole: context.knobs.list(
            label: 'User Role',
            options: ['Agent', 'Admin', 'Super Admin'],
            initialOption: 'Agent',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Itineraries Selected',
        builder: (context) => _WebNavWrapper(
          selectedNav: 2,
          userRole: 'Agent',
        ),
      ),
      WidgetbookUseCase(
        name: 'Products Selected',
        builder: (context) => _WebNavWrapper(
          selectedNav: 3,
          userRole: 'Agent',
        ),
      ),
      WidgetbookUseCase(
        name: 'Contacts Selected',
        builder: (context) => _WebNavWrapper(
          selectedNav: 4,
          userRole: 'Agent',
        ),
      ),
      WidgetbookUseCase(
        name: 'Admin View - Users Menu Visible',
        builder: (context) => _WebNavWrapper(
          selectedNav: 5,
          userRole: 'Admin',
        ),
      ),
      WidgetbookUseCase(
        name: 'Super Admin View',
        builder: (context) => _WebNavWrapper(
          selectedNav: 1,
          userRole: 'Super Admin',
        ),
      ),
      WidgetbookUseCase(
        name: 'Settings Selected',
        builder: (context) => _WebNavWrapper(
          selectedNav: 6,
          userRole: 'Agent',
        ),
      ),
      WidgetbookUseCase(
        name: 'No Selection',
        builder: (context) => _WebNavWrapper(
          selectedNav: null,
          userRole: 'Agent',
        ),
      ),
    ],
  );
}

class _WebNavWrapper extends StatefulWidget {
  final int? selectedNav;
  final String userRole;

  const _WebNavWrapper({
    this.selectedNav,
    required this.userRole,
  });

  @override
  State<_WebNavWrapper> createState() => _WebNavWrapperState();
}

class _WebNavWrapperState extends State<_WebNavWrapper> {
  @override
  void initState() {
    super.initState();
    // Configurar datos de usuario mock
    _setupMockUserData();
  }

  void _setupMockUserData() {
    // Configurar servicios mock
    final userService = appServices.user;
    final authService = appServices.authorization;

    // Simular datos de usuario
    userService.setAgentInfo({
      'name': 'John',
      'last_name': 'Doe',
      'main_image': 'https://picsum.photos/200/200',
    });

    // Configurar rol según el parámetro
    switch (widget.userRole) {
      case 'Admin':
        authService.setMockRole(RoleType.admin);
        userService.setIsAdmin(true);
        userService.setIsSuperAdmin(false);
        break;
      case 'Super Admin':
        authService.setMockRole(RoleType.superAdmin);
        userService.setIsAdmin(false);
        userService.setIsSuperAdmin(true);
        break;
      default:
        authService.setMockRole(RoleType.agent);
        userService.setIsAdmin(false);
        userService.setIsSuperAdmin(false);
    }

    // Marcar como datos cargados
    userService.setHasLoadedData(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // WebNav
          WebNavWidget(
            selectedNav: widget.selectedNav,
          ),
          // Contenido principal
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getIconForSelection(widget.selectedNav),
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getLabelForSelection(widget.selectedNav),
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Role: ${widget.userRole}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[500],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForSelection(int? selection) {
    switch (selection) {
      case 1:
        return Icons.dashboard_rounded;
      case 2:
        return Icons.event_note_rounded;
      case 3:
        return Icons.inventory_2_rounded;
      case 4:
        return Icons.people_rounded;
      case 5:
        return Icons.supervised_user_circle_rounded;
      case 6:
        return Icons.settings_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  String _getLabelForSelection(int? selection) {
    switch (selection) {
      case 1:
        return 'Dashboard';
      case 2:
        return 'Itinerarios';
      case 3:
        return 'Productos';
      case 4:
        return 'Contactos';
      case 5:
        return 'Usuarios';
      case 6:
        return 'Configuración';
      default:
        return 'Home';
    }
  }
}
