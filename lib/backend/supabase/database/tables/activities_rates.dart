import '../database.dart';

class ActivitiesRatesTable extends SupabaseTable<ActivitiesRatesRow> {
  @override
  String get tableName => 'activities_rates';

  @override
  ActivitiesRatesRow createRow(Map<String, dynamic> data) =>
      ActivitiesRatesRow(data);
}

class ActivitiesRatesRow extends SupabaseDataRow {
  ActivitiesRatesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ActivitiesRatesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  double? get unitCost => getField<double>('unit_cost');
  set unitCost(double? value) => setField<double>('unit_cost', value);

  double? get profit => getField<double>('profit');
  set profit(double? value) => setField<double>('profit', value);

  double? get price => getField<double>('price');
  set price(double? value) => setField<double>('price', value);

  String? get idProduct => getField<String>('id_product');
  set idProduct(String? value) => setField<String>('id_product', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);
}
