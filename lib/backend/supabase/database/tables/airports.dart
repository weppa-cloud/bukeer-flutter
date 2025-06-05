import '../database.dart';

class AirportsTable extends SupabaseTable<AirportsRow> {
  @override
  String get tableName => 'airports';

  @override
  AirportsRow createRow(Map<String, dynamic> data) => AirportsRow(data);
}

class AirportsRow extends SupabaseDataRow {
  AirportsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AirportsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get duffelId => getField<String>('duffel_id')!;
  set duffelId(String value) => setField<String>('duffel_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get icaoCode => getField<String>('icao_code');
  set icaoCode(String? value) => setField<String>('icao_code', value);

  String? get iataCode => getField<String>('iata_code');
  set iataCode(String? value) => setField<String>('iata_code', value);

  String? get iataCountryCode => getField<String>('iata_country_code');
  set iataCountryCode(String? value) =>
      setField<String>('iata_country_code', value);

  String? get iataCityCode => getField<String>('iata_city_code');
  set iataCityCode(String? value) => setField<String>('iata_city_code', value);

  String? get cityName => getField<String>('city_name');
  set cityName(String? value) => setField<String>('city_name', value);

  double? get longitude => getField<double>('longitude');
  set longitude(double? value) => setField<double>('longitude', value);

  double? get latitude => getField<double>('latitude');
  set latitude(double? value) => setField<double>('latitude', value);

  String? get timeZone => getField<String>('time_zone');
  set timeZone(String? value) => setField<String>('time_zone', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
