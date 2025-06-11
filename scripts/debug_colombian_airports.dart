import 'dart:convert';
import 'package:http/http.dart' as http;

const supabaseUrl = 'https://wzlxbpicdcdvxvdcvgas.supabase.co';
const supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0NjQyODAsImV4cCI6MjA0MTA0MDI4MH0.dSh-yGzemDC7DL_rf7fwgWlMoEKv1SlBCxd8ElFs_d8';

void main() async {
  print('=== Debugging Colombian Airports Issue ===\n');

  // 1. Check BOG and PEI directly
  print('1. Direct check for BOG and PEI:');
  await checkAirportDirectly('BOG');
  await checkAirportDirectly('PEI');

  // 2. Get all Colombian airports
  print('\n2. All Colombian airports:');
  await getAllColombianAirports();

  // 3. Search for airports containing "Bogota" and "Pereira"
  print('\n3. Search for city names:');
  await searchByCityName('Bogota');
  await searchByCityName('Pereira');

  // 4. Check if BOG and PEI are actually in database with different case
  print('\n4. Case variations check:');
  final searchTerms = ['BOG', 'bog', 'Bog', 'PEI', 'pei', 'Pei'];
  for (final term in searchTerms) {
    await searchByIataCode(term);
  }

  // 5. Get full data for BOG and PEI to understand their structure
  print('\n5. Full airport data:');
  await getFullAirportData('BOG');
  await getFullAirportData('PEI');
}

Future<void> checkAirportDirectly(String iataCode) async {
  try {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/airports?iata_code=eq.$iataCode'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      },
    );

    if (response.statusCode == 200) {
      final results = json.decode(response.body);
      print('  $iataCode: ${results.length} results');
      if (results.isNotEmpty) {
        final airport = results.first;
        print(
            '    ✓ Found: ${airport['city_name']} (${airport['iata_country_code']})');
      }
    }
  } catch (e) {
    print('  Error checking $iataCode: $e');
  }
}

Future<void> getAllColombianAirports() async {
  try {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/airports?iata_country_code=eq.CO'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      },
    );

    if (response.statusCode == 200) {
      final results = json.decode(response.body);
      print('  Found ${results.length} Colombian airports:');
      for (var airport in results) {
        print(
            '    - ${airport['iata_code']} | ${airport['city_name']} | ${airport['name']}');
      }
    }
  } catch (e) {
    print('  Error getting Colombian airports: $e');
  }
}

Future<void> searchByCityName(String cityName) async {
  try {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/airports?city_name=ilike.*${cityName}*'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      },
    );

    if (response.statusCode == 200) {
      final results = json.decode(response.body);
      print('  City "$cityName": ${results.length} results');
      for (var airport in results.take(5)) {
        print(
            '    - ${airport['iata_code']} | ${airport['city_name']} | ${airport['iata_country_code']}');
      }
    }
  } catch (e) {
    print('  Error searching city $cityName: $e');
  }
}

Future<void> searchByIataCode(String iataCode) async {
  try {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/airports?iata_code=ilike.*${iataCode}*'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      },
    );

    if (response.statusCode == 200) {
      final results = json.decode(response.body);
      print('  IATA "$iataCode": ${results.length} results');
      for (var airport in results.take(3)) {
        print('    - ${airport['iata_code']} | ${airport['city_name']}');
      }
    }
  } catch (e) {
    print('  Error searching IATA $iataCode: $e');
  }
}

Future<void> getFullAirportData(String iataCode) async {
  try {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/airports?iata_code=eq.$iataCode'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      },
    );

    if (response.statusCode == 200) {
      final results = json.decode(response.body);
      if (results.isNotEmpty) {
        print('  $iataCode full data:');
        final airport = results.first;
        print('    IATA Code: "${airport['iata_code']}"');
        print('    City Name: "${airport['city_name']}"');
        print('    Airport Name: "${airport['name']}"');
        print('    Country Code: "${airport['iata_country_code']}"');
        print(
            '    Full JSON: ${const JsonEncoder.withIndent('    ').convert(airport)}');
      }
    }
  } catch (e) {
    print('  Error getting full data for $iataCode: $e');
  }
}
