import '../database.dart';

class ActivitiesTable extends SupabaseTable<ActivitiesRow> {
  @override
  String get tableName => 'activities';

  @override
  ActivitiesRow createRow(Map<String, dynamic> data) => ActivitiesRow(data);
}

class ActivitiesRow extends SupabaseDataRow {
  ActivitiesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ActivitiesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get bookingType => getField<String>('booking_type');
  set bookingType(String? value) => setField<String>('booking_type', value);

  int? get durationMinutes => getField<int>('duration_minutes');
  set durationMinutes(int? value) => setField<int>('duration_minutes', value);

  dynamic? get metadata => getField<dynamic>('metadata');
  set metadata(dynamic? value) => setField<dynamic>('metadata', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

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

  List<dynamic> get scheduleData => getListField<dynamic>('schedule_data');
  set scheduleData(List<dynamic>? value) =>
      setListField<dynamic>('schedule_data', value);

  String? get socialImage => getField<String>('social_image');
  set socialImage(String? value) => setField<String>('social_image', value);
}
