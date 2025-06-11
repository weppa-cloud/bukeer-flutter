import 'dart:convert';
import 'package:http/http.dart' as http;

const supabaseUrl = 'https://wzlxbpicdcdvxvdcvgas.supabase.co';
const supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0NjQyODAsImV4cCI6MjA0MTA0MDI4MH0.dSh-yGzemDC7DL_rf7fwgWlMoEKv1SlBCxd8ElFs_d8';

void main() async {
  print('=== Checking Airport Table Structure ===\n');

  // Get a sample airport to see available columns
  try {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/airports?iata_code=eq.BOG'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
      if (results.isNotEmpty) {
        final airport = results.first;
        print('Available columns in airports table:');
        airport.forEach((key, value) {
          print(
              '  - $key: ${value?.toString() ?? 'null'} (${value.runtimeType})');
        });

        print('\n\nFull BOG airport data:');
        print(const JsonEncoder.withIndent('  ').convert(airport));

        // Now check PEI
        print('\n\nChecking PEI airport:');
        final peiResponse = await http.get(
          Uri.parse('$supabaseUrl/rest/v1/airports?iata_code=eq.PEI'),
          headers: {
            'apikey': supabaseAnonKey,
            'Authorization': 'Bearer $supabaseAnonKey',
          },
        );

        if (peiResponse.statusCode == 200) {
          final peiResults = json.decode(peiResponse.body);
          if (peiResults.isNotEmpty) {
            print(const JsonEncoder.withIndent('  ').convert(peiResults.first));
          }
        }

        // Try to find fields that might contain city information
        print('\n\nSearching for fields that might contain city info:');
        final searchableFields = [];
        airport.forEach((key, value) {
          if (value != null && value is String && value.isNotEmpty) {
            searchableFields.add(key);
          }
        });

        print('Searchable string fields: ${searchableFields.join(', ')}');

        // Test search on available fields
        print('\n\nTesting search on available fields:');
        for (final field in searchableFields) {
          await testFieldSearch(field, 'bogot');
          await testFieldSearch(field, 'pereir');
        }
      }
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> testFieldSearch(String field, String searchTerm) async {
  try {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/airports?$field=ilike.%$searchTerm%'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      },
    );

    if (response.statusCode == 200) {
      final results = json.decode(response.body);
      if (results.isNotEmpty) {
        print(
            '  ✓ Field "$field" contains "$searchTerm": ${results.length} results');
        for (var airport in results.take(3)) {
          print('    - ${airport['iata_code']}: ${airport[field]}');
        }
      }
    } else if (response.statusCode != 400) {
      print('  ✗ Field "$field" search error: ${response.statusCode}');
    }
  } catch (e) {
    print('  ✗ Field "$field" search exception: $e');
  }
}
