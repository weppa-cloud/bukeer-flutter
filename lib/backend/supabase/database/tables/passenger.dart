import '../database.dart';

class PassengerTable extends SupabaseTable<PassengerRow> {
  @override
  String get tableName => 'passenger';

  @override
  PassengerRow createRow(Map<String, dynamic> data) => PassengerRow(data);
}

class PassengerRow extends SupabaseDataRow {
  PassengerRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PassengerTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get lastName => getField<String>('last_name')!;
  set lastName(String value) => setField<String>('last_name', value);

  String get typeId => getField<String>('type_id')!;
  set typeId(String value) => setField<String>('type_id', value);

  String get numberId => getField<String>('number_id')!;
  set numberId(String value) => setField<String>('number_id', value);

  String get nationality => getField<String>('nationality')!;
  set nationality(String value) => setField<String>('nationality', value);

  DateTime get birthDate => getField<DateTime>('birth_date')!;
  set birthDate(DateTime value) => setField<DateTime>('birth_date', value);

  String get itineraryId => getField<String>('itinerary_id')!;
  set itineraryId(String value) => setField<String>('itinerary_id', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);
}
