import '../database.dart';

class ActivitiesViewTable extends SupabaseTable<ActivitiesViewRow> {
  @override
  String get tableName => 'activities_view';

  @override
  ActivitiesViewRow createRow(Map<String, dynamic> data) =>
      ActivitiesViewRow(data);
}

class ActivitiesViewRow extends SupabaseDataRow {
  ActivitiesViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ActivitiesViewTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get descriptionShort => getField<String>('description_short');
  set descriptionShort(String? value) =>
      setField<String>('description_short', value);

  String? get mainImage => getField<String>('main_image');
  set mainImage(String? value) => setField<String>('main_image', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get idContact => getField<String>('id_contact');
  set idContact(String? value) => setField<String>('id_contact', value);

  String? get inclutions => getField<String>('inclutions');
  set inclutions(String? value) => setField<String>('inclutions', value);

  String? get exclutions => getField<String>('exclutions');
  set exclutions(String? value) => setField<String>('exclutions', value);

  String? get recomendations => getField<String>('recomendations');
  set recomendations(String? value) =>
      setField<String>('recomendations', value);

  String? get instructions => getField<String>('instructions');
  set instructions(String? value) => setField<String>('instructions', value);

  String? get nameProvider => getField<String>('name_provider');
  set nameProvider(String? value) => setField<String>('name_provider', value);
}
