import 'dart:convert';
import 'package:http/http.dart' as http;

const supabaseUrl = 'https://wzlxbpicdcdvxvdcvgas.supabase.co';
const supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0NjQyODAsImV4cCI6MjA0MTA0MDI4MH0.dSh-yGzemDC7DL_rf7fwgWlMoEKv1SlBCxd8ElFs_d8';

void main() async {
  print('=== Testing Exact Search Logic from App ===\n');

  // First, get all airports
  final allAirports = await getAllAirports();
  if (allAirports.isEmpty) {
    print('❌ No airports found');
    return;
  }

  print('✅ Total airports loaded: ${allAirports.length}\n');

  // Test the exact search logic from the app
  final searchTerms = ['bogota', 'pereira', 'BOG', 'PEI', 'bog', 'pei'];

  for (final searchTerm in searchTerms) {
    print('🔍 Testing search for "$searchTerm":');

    // This is the exact filtering logic from the app (lines 605-613 and 643-651)
    final filteredAirports = allAirports
        .where((airport) {
          final name = airport['name']?.toLowerCase() ?? '';
          final cityName = airport['city_name']?.toLowerCase() ?? '';
          final iataCode = airport['iata_code']?.toLowerCase() ?? '';
          final searchLower = searchTerm.toLowerCase();
          return name.contains(searchLower) ||
              cityName.contains(searchLower) ||
              iataCode.contains(searchLower);
        })
        .take(50)
        .toList(); // Limit to 50 results for performance

    print('  Results: ${filteredAirports.length}');
    if (filteredAirports.isNotEmpty) {
      for (var airport in filteredAirports.take(10)) {
        print(
            '    ✓ ${airport['iata_code']} - ${airport['city_name']} - ${airport['name']}');
      }
    } else {
      print('    ❌ No results found');
    }
    print('');
  }

  // Test Colombian airports only (default view)
  print('🇨🇴 Testing Colombian airports (default view):');
  final colombianAirports = allAirports
      .where((airport) => airport['iata_country_code'] == 'CO')
      .toList();

  print('  Colombian airports: ${colombianAirports.length}');
  print('  Colombian airports with BOG or PEI:');
  for (var airport in colombianAirports) {
    if (airport['iata_code'] == 'BOG' || airport['iata_code'] == 'PEI') {
      print(
          '    ✓ ${airport['iata_code']} - ${airport['city_name']} - ${airport['name']}');
    }
  }
}

Future<List<dynamic>> getAllAirports() async {
  try {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/airports?select=*'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(
          'Error loading airports: ${response.statusCode} - ${response.body}');
      return [];
    }
  } catch (e) {
    print('Exception loading airports: $e');
    return [];
  }
}
