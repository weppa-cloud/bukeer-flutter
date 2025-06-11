import 'package:bukeer/backend/supabase/supabase.dart';

void main() async {
  print('🔍 Quick Airport Test - Checking BOG and PEI directly\n');

  try {
    // Initialize Supabase
    SupaFlow.initialize();

    // Load airports using the same method as the app
    final airports = await AirportsTable().queryRows(
      queryFn: (q) => q.order('city_name').limit(1000),
    );

    final airportsData = airports.map((row) => row.data).toList();
    print('✅ Loaded ${airportsData.length} airports');

    // Search for BOG specifically
    final bogAirports = airportsData
        .where((airport) =>
            airport['iata_code']?.toString()?.toUpperCase() == 'BOG')
        .toList();

    print('\n🔍 BOG Airport Search Results:');
    print('Found ${bogAirports.length} BOG airports');
    for (var airport in bogAirports) {
      print('  ✅ ${airport}');
    }

    // Search for PEI specifically
    final peiAirports = airportsData
        .where((airport) =>
            airport['iata_code']?.toString()?.toUpperCase() == 'PEI')
        .toList();

    print('\n🔍 PEI Airport Search Results:');
    print('Found ${peiAirports.length} PEI airports');
    for (var airport in peiAirports) {
      print('  ✅ ${airport}');
    }

    // Show first 5 airports to understand structure
    print('\n📊 First 5 airports data structure:');
    for (int i = 0; i < 5 && i < airportsData.length; i++) {
      final airport = airportsData[i];
      print(
          '  [$i] IATA: ${airport['iata_code']} | City: ${airport['city_name']} | Name: ${airport['name']}');
    }

    // Count Colombian airports
    final colombianAirports = airportsData
        .where((airport) => airport['iata_country_code'] == 'CO')
        .toList();
    print('\n🇨🇴 Colombian airports: ${colombianAirports.length}');

    // Show first few Colombian airports
    print('First 5 Colombian airports:');
    for (var airport in colombianAirports.take(5)) {
      print(
          '  - ${airport['iata_code']} | ${airport['city_name']} | ${airport['name']}');
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}
