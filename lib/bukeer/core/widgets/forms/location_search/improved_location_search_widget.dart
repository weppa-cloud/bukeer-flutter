import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:bukeer/backend/api_requests/api_calls.dart';
import 'package:bukeer/auth/supabase_auth/auth_util.dart';
import 'package:bukeer/design_system/index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';

/// Widget mejorado para búsqueda y filtrado de ubicaciones
/// Utiliza las nuevas funciones RPC para búsqueda optimizada
class ImprovedLocationSearchWidget extends StatefulWidget {
  const ImprovedLocationSearchWidget({
    Key? key,
    required this.onLocationSelected,
    this.productType = 'hotels',
    this.showCityFilter = true,
    this.showCountryFilter = true,
    this.initialCountryCode,
    this.placeholder = 'Buscar ubicación...',
  }) : super(key: key);

  final Function(Map<String, dynamic>) onLocationSelected;
  final String productType;
  final bool showCityFilter;
  final bool showCountryFilter;
  final String? initialCountryCode;
  final String placeholder;

  @override
  State<ImprovedLocationSearchWidget> createState() =>
      _ImprovedLocationSearchWidgetState();
}

class _ImprovedLocationSearchWidgetState
    extends State<ImprovedLocationSearchWidget> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  // Estado
  List<dynamic> _searchResults = [];
  List<dynamic> _countries = [];
  List<dynamic> _cities = [];
  bool _isLoading = false;
  bool _showResults = false;
  String? _selectedCountryCode;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.initialCountryCode;
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    if (widget.showCountryFilter) {
      await _loadCountries();
    }
    if (_selectedCountryCode != null && widget.showCityFilter) {
      await _loadCities(_selectedCountryCode!);
    }
  }

  Future<void> _loadCountries() async {
    try {
      setState(() => _isLoading = true);

      // Obtener países únicos (simulado - se puede mejorar con RPC específica)
      final response = await SearchLocationsImprovedCall.call(
        productType: widget.productType,
        authToken: currentJwtToken,
        limit: 100,
      );

      if (response.succeeded) {
        final locations =
            SearchLocationsImprovedCall.locations(response.jsonBody) ?? [];

        // Extraer países únicos
        final countrySet = <String, Map<String, dynamic>>{};
        for (final location in locations) {
          final countryCode =
              getJsonField(location, r'$.country_code')?.toString();
          final countryName = getJsonField(location, r'$.country')?.toString();

          if (countryCode != null && countryName != null) {
            countrySet[countryCode] = {
              'code': countryCode,
              'name': countryName,
            };
          }
        }

        setState(() {
          _countries = countrySet.values.toList();
          _countries.sort((a, b) => a['name'].compareTo(b['name']));
        });
      }
    } catch (e) {
      print('Error loading countries: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCities(String countryCode) async {
    if (!widget.showCityFilter) return;

    try {
      setState(() => _isLoading = true);

      final response = await GetCitiesByCountryCall.call(
        countryCode: countryCode,
        productType: widget.productType,
        authToken: currentJwtToken,
      );

      if (response.succeeded) {
        final cities = GetCitiesByCountryCall.cities(response.jsonBody) ?? [];
        setState(() {
          _cities = cities;
        });
      }
    } catch (e) {
      print('Error loading cities: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchLocations(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _showResults = false;
      });
      return;
    }

    try {
      setState(() => _isLoading = true);

      final response = await SearchLocationsImprovedCall.call(
        searchTerm: query,
        productType: widget.productType,
        countryCode: _selectedCountryCode ?? '',
        authToken: currentJwtToken,
        limit: 10,
      );

      if (response.succeeded) {
        final results =
            SearchLocationsImprovedCall.locations(response.jsonBody) ?? [];

        // Filtrar por ciudad si está seleccionada
        List<dynamic> filteredResults = results;
        if (_selectedCity != null && _selectedCity!.isNotEmpty) {
          filteredResults = results.where((location) {
            final city = getJsonField(location, r'$.city')?.toString() ?? '';
            return city.toLowerCase().contains(_selectedCity!.toLowerCase());
          }).toList();
        }

        setState(() {
          _searchResults = filteredResults;
          _showResults = true;
        });
      }
    } catch (e) {
      print('Error searching locations: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _selectLocation(dynamic location) {
    final locationData = {
      'id': getJsonField(location, r'$.id')?.toString(),
      'name': getJsonField(location, r'$.name')?.toString(),
      'city': getJsonField(location, r'$.city')?.toString(),
      'country': getJsonField(location, r'$.country')?.toString(),
      'country_code': getJsonField(location, r'$.country_code')?.toString(),
      'full_name': getJsonField(location, r'$.full_name')?.toString(),
      'product_count': getJsonField(location, r'$.product_count'),
    };

    _searchController.text = locationData['full_name'] ?? '';
    setState(() => _showResults = false);
    _searchFocusNode.unfocus();

    widget.onLocationSelected(locationData);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _showResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filtros superiores
        if (widget.showCountryFilter || widget.showCityFilter) ...[
          Row(
            children: [
              // Filtro por país
              if (widget.showCountryFilter) ...[
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCountryCode,
                    decoration: InputDecoration(
                      labelText: 'País',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: BukeerSpacing.s,
                        vertical: BukeerSpacing.xs,
                      ),
                    ),
                    items: _countries.map<DropdownMenuItem<String>>((country) {
                      return DropdownMenuItem<String>(
                        value: country['code'],
                        child: Text(country['name']),
                      );
                    }).toList(),
                    onChanged: (value) async {
                      setState(() {
                        _selectedCountryCode = value;
                        _selectedCity = null;
                        _cities = [];
                      });
                      if (value != null) {
                        await _loadCities(value);
                      }
                      // Re-ejecutar búsqueda con nuevo filtro
                      if (_searchController.text.isNotEmpty) {
                        _searchLocations(_searchController.text);
                      }
                    },
                  ),
                ),
                SizedBox(width: BukeerSpacing.s),
              ],

              // Filtro por ciudad
              if (widget.showCityFilter) ...[
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCity,
                    decoration: InputDecoration(
                      labelText: 'Ciudad',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(BukeerSpacing.s),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: BukeerSpacing.s,
                        vertical: BukeerSpacing.xs,
                      ),
                    ),
                    items: _cities.map<DropdownMenuItem<String>>((city) {
                      final cityName =
                          getJsonField(city, r'$.city')?.toString() ?? '';
                      final productCount =
                          getJsonField(city, r'$.product_count') ?? 0;
                      return DropdownMenuItem<String>(
                        value: cityName,
                        child: Row(
                          children: [
                            Expanded(child: Text(cityName)),
                            Text(
                              '($productCount)',
                              style: TextStyle(
                                color: BukeerColors.secondaryText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCity = value);
                      // Re-ejecutar búsqueda con nuevo filtro
                      if (_searchController.text.isNotEmpty) {
                        _searchLocations(_searchController.text);
                      }
                    },
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: BukeerSpacing.s),
        ],

        // Campo de búsqueda principal
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BukeerSpacing.s),
            border: Border.all(color: BukeerColors.border),
          ),
          child: Column(
            children: [
              // Input de búsqueda
              TextFormField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: widget.placeholder,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(BukeerSpacing.s),
                  prefixIcon: Icon(
                    Icons.search,
                    color: BukeerColors.secondaryText,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: _clearSearch,
                        )
                      : _isLoading
                          ? Container(
                              width: 20,
                              height: 20,
                              padding: EdgeInsets.all(BukeerSpacing.xs),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : null,
                ),
                onChanged: (value) {
                  EasyDebounce.debounce(
                    'location-search',
                    Duration(milliseconds: 500),
                    () => _searchLocations(value),
                  );
                },
                onTap: () {
                  if (_searchController.text.isNotEmpty &&
                      _searchResults.isNotEmpty) {
                    setState(() => _showResults = true);
                  }
                },
              ),

              // Resultados de búsqueda
              if (_showResults && _searchResults.isNotEmpty) ...[
                Divider(height: 1, color: BukeerColors.border),
                Container(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final location = _searchResults[index];
                      final fullName =
                          getJsonField(location, r'$.full_name')?.toString() ??
                              '';
                      final productCount =
                          getJsonField(location, r'$.product_count') ?? 0;
                      final locationType =
                          getJsonField(location, r'$.location_type')
                                  ?.toString() ??
                              'city';

                      return ListTile(
                        dense: true,
                        leading: Icon(
                          _getLocationIcon(locationType),
                          size: 20,
                          color: BukeerColors.secondaryText,
                        ),
                        title: Text(
                          fullName,
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: productCount > 0
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: BukeerSpacing.xs,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: BukeerColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$productCount',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: BukeerColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : null,
                        onTap: () => _selectLocation(location),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  IconData _getLocationIcon(String type) {
    switch (type) {
      case 'resort':
        return Icons.landscape;
      case 'airport':
        return Icons.flight;
      case 'region':
        return Icons.map;
      default:
        return Icons.location_city;
    }
  }
}

/// Widget simple para casos básicos
class SimpleLocationSearchWidget extends StatelessWidget {
  const SimpleLocationSearchWidget({
    Key? key,
    required this.onLocationSelected,
    this.productType = 'hotels',
  }) : super(key: key);

  final Function(Map<String, dynamic>) onLocationSelected;
  final String productType;

  @override
  Widget build(BuildContext context) {
    return ImprovedLocationSearchWidget(
      onLocationSelected: onLocationSelected,
      productType: productType,
      showCityFilter: false,
      showCountryFilter: false,
      placeholder: 'Buscar destino...',
    );
  }
}
