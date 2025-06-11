import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/backend/supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUpAll(() async {
    // Initialize Supabase with test configuration
    await Supabase.initialize(
      url: 'https://wtpmtylovqrzxvefoqxd.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind0cG10eWxvdnFyenh2ZWZvcXhkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAxMDQzNjAsImV4cCI6MjAzNTY4MDM2MH0.8NIn2yiWQ_fyO6msOJLX3fYePvCDa_MxSKIDe0qhwzs',
    );
  });

  test('Debug airport search - BOG and PEI', () async {
    print('\n=== Airport Search Debug Test ===\n');

    // Test 1: Search by exact IATA codes
    print('1. Searching by exact IATA codes:');
    await searchByIataCode('BOG');
    await searchByIataCode('PEI');
    await searchByIataCode('bog'); // lowercase test
    await searchByIataCode('pei'); // lowercase test

    // Test 2: Search by city names
    print('\n2. Searching by city names:');
    await searchByCityName('Bogotá');
    await searchByCityName('Bogota'); // without accent
    await searchByCityName('bogota'); // lowercase
    await searchByCityName('BOGOTA'); // uppercase
    await searchByCityName('Pereira');
    await searchByCityName('pereira'); // lowercase

    // Test 3: Get all airports and filter locally
    print('\n3. Getting all airports and filtering locally:');
    await getAllAirportsAndFilter();

    // Test 4: Check the actual search implementation
    print('\n4. Testing different search patterns:');
    await testSearchPatterns();
  });
}

Future<void> searchByIataCode(String code) async {
  try {
    final result =
        await SupaFlow.client.from('airports').select().eq('iata_code', code);

    print('  IATA code "$code": ${result.length} results');
    if (result.isNotEmpty) {
      for (var airport in result) {
        print(
            '    - ${airport['iata_code']} | ${airport['city']} | ${airport['name']}');
        print('      Full data: $airport');
      }
    }
  } catch (e) {
    print('  Error searching IATA "$code": $e');
  }
}

Future<void> searchByCityName(String city) async {
  try {
    final result =
        await SupaFlow.client.from('airports').select().eq('city', city);

    print('  City exact match "$city": ${result.length} results');
    if (result.isNotEmpty) {
      for (var airport in result) {
        print(
            '    - ${airport['iata_code']} | ${airport['city']} | ${airport['name']}');
      }
    }

    // Try with ilike for case-insensitive
    final ilikeResult = await SupaFlow.client
        .from('airports')
        .select()
        .ilike('city', '%$city%');

    print('  City ilike match "%$city%": ${ilikeResult.length} results');
    if (ilikeResult.isNotEmpty && ilikeResult.length <= 5) {
      for (var airport in ilikeResult) {
        print(
            '    - ${airport['iata_code']} | ${airport['city']} | ${airport['name']}');
      }
    }
  } catch (e) {
    print('  Error searching city "$city": $e');
  }
}

Future<void> getAllAirportsAndFilter() async {
  try {
    final allAirports =
        await SupaFlow.client.from('airports').select().order('city');

    print('  Total airports in database: ${allAirports.length}');

    // Filter for Colombian airports
    final colombianAirports = allAirports.where((airport) {
      final city = airport['city']?.toString().toLowerCase() ?? '';
      final iata = airport['iata_code']?.toString().toLowerCase() ?? '';
      final name = airport['name']?.toString().toLowerCase() ?? '';

      return city.contains('bogot') ||
          city.contains('pereira') ||
          iata == 'bog' ||
          iata == 'pei' ||
          name.contains('bogot') ||
          name.contains('pereira');
    }).toList();

    print('  Colombian airports found: ${colombianAirports.length}');
    for (var airport in colombianAirports) {
      print(
          '    - ${airport['iata_code']} | ${airport['city']} | ${airport['name']}');
      print('      Country: ${airport['country']}');
      print('      Full data: $airport');
    }
  } catch (e) {
    print('  Error getting all airports: $e');
  }
}

Future<void> testSearchPatterns() async {
  final searchTerms = ['bog', 'BOG', 'pei', 'PEI', 'bogot', 'pereir'];

  for (var term in searchTerms) {
    try {
      // Test combined search (IATA or city or name)
      final result = await SupaFlow.client
          .from('airports')
          .select()
          .or('iata_code.ilike.%$term%,city.ilike.%$term%,name.ilike.%$term%');

      print('  Search term "$term": ${result.length} results');
      if (result.isNotEmpty && result.length <= 5) {
        for (var airport in result) {
          print(
              '    - ${airport['iata_code']} | ${airport['city']} | ${airport['name']}');
        }
      }
    } catch (e) {
      print('  Error with search term "$term": $e');
    }
  }

  // Test the exact query that might be used in the app
  print('\n5. Testing exact query patterns that might be used:');
  try {
    // Case-insensitive IATA code search
    final bogResult = await SupaFlow.client
        .from('airports')
        .select()
        .ilike('iata_code', 'BOG');
    print('  ilike IATA "BOG": ${bogResult.length} results');

    final peiResult = await SupaFlow.client
        .from('airports')
        .select()
        .ilike('iata_code', 'PEI');
    print('  ilike IATA "PEI": ${peiResult.length} results');

    // Check table structure
    print('\n6. Checking table structure:');
    if (bogResult.isNotEmpty) {
      print('  Column names: ${bogResult.first.keys.toList()}');
    }
  } catch (e) {
    print('  Error in exact query test: $e');
  }
}
