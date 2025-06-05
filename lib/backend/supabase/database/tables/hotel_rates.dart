import '../database.dart';

class HotelRatesTable extends SupabaseTable<HotelRatesRow> {
  @override
  String get tableName => 'hotel_rates';

  @override
  HotelRatesRow createRow(Map<String, dynamic> data) => HotelRatesRow(data);
}

class HotelRatesRow extends SupabaseDataRow {
  HotelRatesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => HotelRatesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get hotelId => getField<String>('hotel_id')!;
  set hotelId(String value) => setField<String>('hotel_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  int? get capacity => getField<int>('capacity');
  set capacity(int? value) => setField<int>('capacity', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  double? get unitCost => getField<double>('unit_cost');
  set unitCost(double? value) => setField<double>('unit_cost', value);

  double? get profit => getField<double>('profit');
  set profit(double? value) => setField<double>('profit', value);

  double? get price => getField<double>('price');
  set price(double? value) => setField<double>('price', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);
}
