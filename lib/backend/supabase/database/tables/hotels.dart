import '../database.dart';

class HotelsTable extends SupabaseTable<HotelsRow> {
  @override
  String get tableName => 'hotels';

  @override
  HotelsRow createRow(Map<String, dynamic> data) => HotelsRow(data);
}

class HotelsRow extends SupabaseDataRow {
  HotelsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => HotelsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  int? get starRating => getField<int>('star_rating');
  set starRating(int? value) => setField<int>('star_rating', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  PostgresTime? get checkInTime => getField<PostgresTime>('check_in_time');
  set checkInTime(PostgresTime? value) =>
      setField<PostgresTime>('check_in_time', value);

  PostgresTime? get checkOutTime => getField<PostgresTime>('check_out_time');
  set checkOutTime(PostgresTime? value) =>
      setField<PostgresTime>('check_out_time', value);

  int? get regionId => getField<int>('region_id');
  set regionId(int? value) => setField<int>('region_id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  String? get providerId => getField<String>('provider_id');
  set providerId(String? value) => setField<String>('provider_id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get bookingType => getField<String>('booking_type');
  set bookingType(String? value) => setField<String>('booking_type', value);

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

  String? get mainImage => getField<String>('main_image');
  set mainImage(String? value) => setField<String>('main_image', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);

  String? get location => getField<String>('location');
  set location(String? value) => setField<String>('location', value);

  String? get socialImage => getField<String>('social_image');
  set socialImage(String? value) => setField<String>('social_image', value);
}
