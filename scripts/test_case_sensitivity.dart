void main() {
  // Test the exact filtering logic from the app
  print('=== Testing Case Sensitivity Issue ===\n');

  // This is mock data matching what we found in the database
  final airports = [
    {
      'iata_code': 'BOG',
      'city_name': 'Bogota', // Capital B, no accent
      'name': 'El Dorado International Airport'
    },
    {
      'iata_code': 'PEI',
      'city_name': 'Pereira', // Capital P
      'name': 'Matecaña International Airport'
    }
  ];

  final searchTerms = ['bogota', 'pereira', 'BOG', 'PEI', 'bog', 'pei'];

  for (final searchTerm in searchTerms) {
    print('🔍 Testing search for "$searchTerm":');

    // This is the EXACT filtering logic from the app (lines 605-613)
    final filteredAirports = airports.where((airport) {
      final name = airport['name']?.toLowerCase() ?? '';
      final cityName = airport['city_name']?.toLowerCase() ?? '';
      final iataCode = airport['iata_code']?.toLowerCase() ?? '';
      final searchLower = searchTerm.toLowerCase();
      return name.contains(searchLower) ||
          cityName.contains(searchLower) ||
          iataCode.contains(searchLower);
    }).toList();

    print('  Results: ${filteredAirports.length}');
    if (filteredAirports.isNotEmpty) {
      for (var airport in filteredAirports) {
        print(
            '    ✓ ${airport['iata_code']} - ${airport['city_name']} - ${airport['name']}');
      }
    } else {
      print('    ❌ No results found');
    }

    // Let's debug the matching step by step
    print('  Debug:');
    for (var airport in airports) {
      final name = airport['name']?.toLowerCase() ?? '';
      final cityName = airport['city_name']?.toLowerCase() ?? '';
      final iataCode = airport['iata_code']?.toLowerCase() ?? '';
      final searchLower = searchTerm.toLowerCase();

      final nameMatch = name.contains(searchLower);
      final cityMatch = cityName.contains(searchLower);
      final codeMatch = iataCode.contains(searchLower);

      print(
          '    ${airport['iata_code']}: name="$name".contains("$searchLower")=$nameMatch, city="$cityName".contains("$searchLower")=$cityMatch, code="$iataCode".contains("$searchLower")=$codeMatch');
    }
    print('');
  }
}
