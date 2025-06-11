import 'dart:convert';
import 'package:http/http.dart' as http;

const supabaseUrl = 'https://wzlxbpicdcdvxvdcvgas.supabase.co';
const supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0NjQyODAsImV4cCI6MjA0MTA0MDI4MH0.dSh-yGzemDC7DL_rf7fwgWlMoEKv1SlBCxd8ElFs_d8';

void main() async {
  print('=== Airport Search Debug ===\n');

  // Test 1: Get all airports and check for BOG and PEI
  print('1. Fetching all airports and filtering for BOG and PEI:');
  await getAllAirports();

  // Test 2: Direct search for BOG
  print('\n2. Direct search for BOG:');
  await searchAirport('iata_code', 'eq', 'BOG');

  // Test 3: Direct search for PEI
  print('\n3. Direct search for PEI:');
  await searchAirport('iata_code', 'eq', 'PEI');

  // Test 4: Search with case-insensitive
  print('\n4. Case-insensitive search:');
  await searchAirportIlike('iata_code', 'BOG');
  await searchAirportIlike('iata_code', 'PEI');
  await searchAirportIlike('city', '%bogot%');
  await searchAirportIlike('city', '%pereira%');

  // Test 5: Combined search
  print('\n5. Combined search patterns:');
  await combinedSearch('bog');
  await combinedSearch('pei');
  await combinedSearch('bogota');
  await combinedSearch('pereira');
}

Future<void> getAllAirports() async {
  try {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/airports?select=*&order=city'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> airports = json.decode(response.body);
      print('  Total airports: ${airports.length}');

      // Filter for Colombian airports
      final colombianAirports = airports.where((airport) {
        final iata = airport['iata_code']?.toString().toUpperCase() ?? '';
        final city = airport['city']?.toString().toLowerCase() ?? '';
        final name = airport['name']?.toString().toLowerCase() ?? '';

        return iata == 'BOG' ||
            iata == 'PEI' ||
            city.contains('bogot') ||
            city.contains('pereira');
      }).toList();

      print('  Colombian airports found: ${colombianAirports.length}');
      for (var airport in colombianAirports) {
        print('\n  Airport found:');
        print('    IATA: ${airport['iata_code']}');
        print('    City: ${airport['city']}');
        print('    Name: ${airport['name']}');
        print('    Country: ${airport['country']}');
        print('    Full data: $airport');
      }
    } else {
      print('  Error: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('  Exception: $e');
  }
}

Future<void> searchAirport(String column, String operator, String value) async {
  try {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/airports?$column=$operator.$value'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      },
    );

    print('  Query: $column $operator $value');
    print('  Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
      print('  Results: ${results.length}');
      for (var airport in results) {
        print(
            '    - ${airport['iata_code']} | ${airport['city']} | ${airport['name']}');
      }
    } else {
      print('  Error: ${response.body}');
    }
  } catch (e) {
    print('  Exception: $e');
  }
}

Future<void> searchAirportIlike(String column, String value) async {
  try {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/airports?$column=ilike.$value'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      },
    );

    print('  Query: $column ilike $value');
    print('  Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
      print('  Results: ${results.length}');
      if (results.length <= 10) {
        for (var airport in results) {
          print(
              '    - ${airport['iata_code']} | ${airport['city']} | ${airport['name']}');
        }
      }
    } else {
      print('  Error: ${response.body}');
    }
  } catch (e) {
    print('  Exception: $e');
  }
}

Future<void> combinedSearch(String term) async {
  try {
    final response = await http.get(
      Uri.parse(
          '$supabaseUrl/rest/v1/airports?or=(iata_code.ilike.%$term%,city.ilike.%$term%,name.ilike.%$term%)'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      },
    );

    print('  Combined search for "$term"');
    print('  Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
      print('  Results: ${results.length}');
      if (results.length <= 10) {
        for (var airport in results) {
          print(
              '    - ${airport['iata_code']} | ${airport['city']} | ${airport['name']}');
        }
      }
    } else {
      print('  Error: ${response.body}');
    }
  } catch (e) {
    print('  Exception: $e');
  }
}
