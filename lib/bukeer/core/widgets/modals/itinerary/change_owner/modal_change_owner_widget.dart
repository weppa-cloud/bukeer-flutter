import 'package:flutter/material.dart';
import 'package:bukeer/design_system/index.dart';
import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';
import '../../../../../../backend/supabase/supabase.dart';
import '../../../../../../backend/api_requests/api_calls.dart';
import '../../../../../../services/app_services.dart';

class ModalChangeOwnerWidget extends StatefulWidget {
  const ModalChangeOwnerWidget({
    Key? key,
    required this.itineraryId,
    required this.currentOwnerId,
    required this.itineraryName,
  }) : super(key: key);

  final String itineraryId;
  final String currentOwnerId;
  final String itineraryName;

  @override
  State<ModalChangeOwnerWidget> createState() => _ModalChangeOwnerWidgetState();
}

class _ModalChangeOwnerWidgetState extends State<ModalChangeOwnerWidget> {
  String? _selectedUserId;
  bool _isLoading = false;
  List<dynamic> _agents = [];
  List<dynamic> _filteredAgents = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAgents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAgents() async {
    setState(() => _isLoading = true);

    try {
      // Get all users from user_roles table for the current account
      final accountId = appServices.account.accountId;
      if (accountId == null) {
        print('No account ID available');
        return;
      }

      // Query user_roles to get all users in the account
      final userRoles = await UserRolesTable().queryRows(
        queryFn: (q) => q.eq('account_id', accountId),
      );

      // Extract unique user IDs
      final userIds = userRoles
          .map((role) => role.userId)
          .where((id) => id != null)
          .toSet()
          .toList();

      // Now get user details for each user ID
      List<dynamic> allAgents = [];
      for (String? userId in userIds) {
        if (userId == null) continue;
        if (userId == widget.currentOwnerId) continue; // Skip current owner

        try {
          final response = await GetAgentCall.call(
            authToken: currentJwtToken,
            id: userId,
            accountIdParam: accountId,
          );

          if (response.succeeded) {
            final agentData = getJsonField(response.jsonBody, r'$[:]');
            if (agentData != null) {
              final agent = agentData is List ? agentData.first : agentData;
              allAgents.add(agent);
            }
          }
        } catch (e) {
          print('Error loading agent $userId: $e');
        }
      }

      setState(() {
        _agents = allAgents;
        _filteredAgents = allAgents;
      });
    } catch (e) {
      print('Error loading agents: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterAgents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredAgents = _agents.where((agent) {
          final agentId = getJsonField(agent, r'$.id')?.toString();
          return agentId != widget.currentOwnerId;
        }).toList();
      } else {
        _filteredAgents = _agents.where((agent) {
          final agentId = getJsonField(agent, r'$.id')?.toString();
          if (agentId == widget.currentOwnerId) return false;

          final name = getJsonField(agent, r'$.name')?.toString() ?? '';
          final lastName =
              getJsonField(agent, r'$.last_name')?.toString() ?? '';
          final email = getJsonField(agent, r'$.email')?.toString() ?? '';
          final fullName = '$name $lastName'.toLowerCase();
          final searchLower = query.toLowerCase();

          return fullName.contains(searchLower) ||
              email.toLowerCase().contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> _changeOwner() async {
    if (_selectedUserId == null) return;

    setState(() => _isLoading = true);

    try {
      // Update the itinerary owner
      await ItinerariesTable().update(
        data: {
          'id_created_by': _selectedUserId,
        },
        matchingRows: (rows) => rows.eq('id', widget.itineraryId),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Propietario cambiado exitosamente'),
          backgroundColor: BukeerColors.success,
        ),
      );

      // Close modal with result
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error changing owner: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cambiar el propietario: $e'),
          backgroundColor: BukeerColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: isDark
            ? BukeerColors.surfacePrimaryDark
            : BukeerColors.surfacePrimary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(BukeerSpacing.l),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      isDark ? BukeerColors.dividerDark : BukeerColors.divider,
                  width: BukeerBorders.widthThin,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cambiar Propietario',
                      style: BukeerTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? BukeerColors.textPrimaryDark
                            : BukeerColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: BukeerSpacing.xs),
                    Text(
                      'Itinerario: ${widget.itineraryName}',
                      style: BukeerTypography.bodySmall.copyWith(
                        color: isDark
                            ? BukeerColors.textSecondaryDark
                            : BukeerColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                BukeerIconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(false),
                  variant: BukeerIconButtonVariant.ghost,
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading && _agents.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // Search field
                      Padding(
                        padding: EdgeInsets.all(BukeerSpacing.l),
                        child: BukeerTextField(
                          controller: _searchController,
                          hintText: 'Buscar usuario por nombre o email...',
                          leadingIcon: Icons.search,
                          onChanged: _filterAgents,
                        ),
                      ),

                      // Agents list
                      Expanded(
                        child: _filteredAgents.isEmpty
                            ? Center(
                                child: Text(
                                  _searchController.text.isEmpty
                                      ? 'No hay usuarios disponibles'
                                      : 'No se encontraron usuarios para "${_searchController.text}"',
                                  style: BukeerTypography.bodyMedium.copyWith(
                                    color: isDark
                                        ? BukeerColors.textSecondaryDark
                                        : BukeerColors.textSecondary,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: BukeerSpacing.l),
                                itemCount: _filteredAgents.length,
                                itemBuilder: (context, index) {
                                  final agent = _filteredAgents[index];
                                  final agentId = getJsonField(agent, r'$.id')
                                          ?.toString() ??
                                      '';
                                  final name = getJsonField(agent, r'$.name')
                                          ?.toString() ??
                                      '';
                                  final lastName =
                                      getJsonField(agent, r'$.last_name')
                                              ?.toString() ??
                                          '';
                                  final fullName = '$name $lastName'.trim();
                                  final email = getJsonField(agent, r'$.email')
                                          ?.toString() ??
                                      '';
                                  final mainImage =
                                      getJsonField(agent, r'$.main_image')
                                          ?.toString();
                                  final isSelected = _selectedUserId == agentId;

                                  return Container(
                                    margin: EdgeInsets.only(
                                        bottom: BukeerSpacing.m),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? BukeerColors.primary
                                              .withOpacity(0.1)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected
                                            ? BukeerColors.primary
                                            : (isDark
                                                ? BukeerColors.dividerDark
                                                : BukeerColors.divider),
                                        width: isSelected
                                            ? BukeerBorders.widthMedium
                                            : BukeerBorders.widthThin,
                                      ),
                                      borderRadius: BukeerBorders.radiusMedium,
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          _selectedUserId = agentId;
                                        });
                                      },
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BukeerBorders.radiusFull,
                                          border: Border.all(
                                            color: isSelected
                                                ? BukeerColors.primary
                                                : BukeerColors.divider,
                                            width: BukeerBorders.widthThin,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BukeerBorders.radiusFull,
                                          child: mainImage != null &&
                                                  mainImage.isNotEmpty
                                              ? Image.network(
                                                  mainImage,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      color: BukeerColors
                                                          .primary
                                                          .withOpacity(0.1),
                                                      child: Center(
                                                        child: Text(
                                                          fullName.isNotEmpty
                                                              ? fullName[0]
                                                                  .toUpperCase()
                                                              : 'U',
                                                          style:
                                                              BukeerTypography
                                                                  .titleMedium
                                                                  .copyWith(
                                                            color: BukeerColors
                                                                .primary,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Container(
                                                  color: BukeerColors.primary
                                                      .withOpacity(0.1),
                                                  child: Center(
                                                    child: Text(
                                                      fullName.isNotEmpty
                                                          ? fullName[0]
                                                              .toUpperCase()
                                                          : 'U',
                                                      style: BukeerTypography
                                                          .titleMedium
                                                          .copyWith(
                                                        color: BukeerColors
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                      title: Text(
                                        fullName.isNotEmpty
                                            ? fullName
                                            : 'Sin nombre',
                                        style: BukeerTypography.titleMedium
                                            .copyWith(
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          color: isDark
                                              ? BukeerColors.textPrimaryDark
                                              : BukeerColors.textPrimary,
                                        ),
                                      ),
                                      subtitle: Text(
                                        email,
                                        style:
                                            BukeerTypography.bodySmall.copyWith(
                                          color: isDark
                                              ? BukeerColors.textSecondaryDark
                                              : BukeerColors.textSecondary,
                                        ),
                                      ),
                                      trailing: isSelected
                                          ? Icon(
                                              Icons.check_circle,
                                              color: BukeerColors.primary,
                                              size: 24,
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          ),

          // Footer
          Container(
            padding: EdgeInsets.all(BukeerSpacing.l),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color:
                      isDark ? BukeerColors.dividerDark : BukeerColors.divider,
                  width: BukeerBorders.widthThin,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BukeerButton(
                  text: 'Cancelar',
                  onPressed: () => Navigator.of(context).pop(false),
                  variant: BukeerButtonVariant.secondary,
                ),
                SizedBox(width: BukeerSpacing.m),
                BukeerButton(
                  text: 'Cambiar Propietario',
                  onPressed: _selectedUserId != null ? _changeOwner : null,
                  variant: BukeerButtonVariant.primary,
                  icon: Icons.swap_horiz,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
