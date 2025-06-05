import '../database.dart';

class AirportsViewTable extends SupabaseTable<AirportsViewRow> {
  @override
  String get tableName => 'airports_view';

  @override
  AirportsViewRow createRow(Map<String, dynamic> data) => AirportsViewRow(data);
}

class AirportsViewRow extends SupabaseDataRow {
  AirportsViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AirportsViewTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);
}
