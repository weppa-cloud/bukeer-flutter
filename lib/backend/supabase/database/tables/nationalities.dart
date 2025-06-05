import '../database.dart';

class NationalitiesTable extends SupabaseTable<NationalitiesRow> {
  @override
  String get tableName => 'nationalities';

  @override
  NationalitiesRow createRow(Map<String, dynamic> data) =>
      NationalitiesRow(data);
}

class NationalitiesRow extends SupabaseDataRow {
  NationalitiesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => NationalitiesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);
}
