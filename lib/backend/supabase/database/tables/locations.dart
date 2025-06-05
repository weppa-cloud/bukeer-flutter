import '../database.dart';

class LocationsTable extends SupabaseTable<LocationsRow> {
  @override
  String get tableName => 'locations';

  @override
  LocationsRow createRow(Map<String, dynamic> data) => LocationsRow(data);
}

class LocationsRow extends SupabaseDataRow {
  LocationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LocationsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get latlng => getField<String>('latlng');
  set latlng(String? value) => setField<String>('latlng', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get zipCode => getField<String>('zip_code');
  set zipCode(String? value) => setField<String>('zip_code', value);

  String get accountId => getField<String>('account_id')!;
  set accountId(String value) => setField<String>('account_id', value);

  String get typeEntity => getField<String>('type_entity')!;
  set typeEntity(String value) => setField<String>('type_entity', value);
}
