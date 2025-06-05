import '../database.dart';

class FlightsTable extends SupabaseTable<FlightsRow> {
  @override
  String get tableName => 'flights';

  @override
  FlightsRow createRow(Map<String, dynamic> data) => FlightsRow(data);
}

class FlightsRow extends SupabaseDataRow {
  FlightsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FlightsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get airline => getField<String>('airline')!;
  set airline(String value) => setField<String>('airline', value);

  String get flightNumber => getField<String>('flight_number')!;
  set flightNumber(String value) => setField<String>('flight_number', value);

  String get departureAirport => getField<String>('departure_airport')!;
  set departureAirport(String value) =>
      setField<String>('departure_airport', value);

  String get arrivalAirport => getField<String>('arrival_airport')!;
  set arrivalAirport(String value) =>
      setField<String>('arrival_airport', value);

  DateTime get departureTime => getField<DateTime>('departure_time')!;
  set departureTime(DateTime value) =>
      setField<DateTime>('departure_time', value);

  DateTime get arrivalTime => getField<DateTime>('arrival_time')!;
  set arrivalTime(DateTime value) => setField<DateTime>('arrival_time', value);

  double? get estimatedPrice => getField<double>('estimated_price');
  set estimatedPrice(double? value) =>
      setField<double>('estimated_price', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  String? get providerName => getField<String>('provider_name');
  set providerName(String? value) => setField<String>('provider_name', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  dynamic? get providerSpecificData =>
      getField<dynamic>('provider_specific_data');
  set providerSpecificData(dynamic? value) =>
      setField<dynamic>('provider_specific_data', value);

  double? get price => getField<double>('price');
  set price(double? value) => setField<double>('price', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);
}
