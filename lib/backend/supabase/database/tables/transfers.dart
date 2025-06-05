import '../database.dart';

class TransfersTable extends SupabaseTable<TransfersRow> {
  @override
  String get tableName => 'transfers';

  @override
  TransfersRow createRow(Map<String, dynamic> data) => TransfersRow(data);
}

class TransfersRow extends SupabaseDataRow {
  TransfersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TransfersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get fromLocation => getField<String>('from_location');
  set fromLocation(String? value) => setField<String>('from_location', value);

  String? get toLocation => getField<String>('to_location');
  set toLocation(String? value) => setField<String>('to_location', value);

  DateTime? get departureTime => getField<DateTime>('departure_time');
  set departureTime(DateTime? value) =>
      setField<DateTime>('departure_time', value);

  DateTime? get arrivalTime => getField<DateTime>('arrival_time');
  set arrivalTime(DateTime? value) => setField<DateTime>('arrival_time', value);

  double? get estimatedPrice => getField<double>('estimated_price');
  set estimatedPrice(double? value) =>
      setField<double>('estimated_price', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  String? get providerId => getField<String>('provider_id');
  set providerId(String? value) => setField<String>('provider_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get bookingType => getField<String>('booking_type');
  set bookingType(String? value) => setField<String>('booking_type', value);

  int? get durationMinutes => getField<int>('duration_minutes');
  set durationMinutes(int? value) => setField<int>('duration_minutes', value);

  dynamic? get metadata => getField<dynamic>('metadata');
  set metadata(dynamic? value) => setField<dynamic>('metadata', value);

  String? get descriptionShort => getField<String>('description_short');
  set descriptionShort(String? value) =>
      setField<String>('description_short', value);

  String? get inclutions => getField<String>('inclutions');
  set inclutions(String? value) => setField<String>('inclutions', value);

  String? get exclutions => getField<String>('exclutions');
  set exclutions(String? value) => setField<String>('exclutions', value);

  String? get recomendations => getField<String>('recomendations');
  set recomendations(String? value) =>
      setField<String>('recomendations', value);

  String? get instructions => getField<String>('instructions');
  set instructions(String? value) => setField<String>('instructions', value);

  String? get idContact => getField<String>('id_contact');
  set idContact(String? value) => setField<String>('id_contact', value);

  String? get experienceType => getField<String>('experience_type');
  set experienceType(String? value) =>
      setField<String>('experience_type', value);

  String? get mainImage => getField<String>('main_image');
  set mainImage(String? value) => setField<String>('main_image', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);

  String? get location => getField<String>('location');
  set location(String? value) => setField<String>('location', value);
}
