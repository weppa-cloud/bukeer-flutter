import '../database.dart';

class TransactionsTable extends SupabaseTable<TransactionsRow> {
  @override
  String get tableName => 'transactions';

  @override
  TransactionsRow createRow(Map<String, dynamic> data) => TransactionsRow(data);
}

class TransactionsRow extends SupabaseDataRow {
  TransactionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TransactionsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get idItinerary => getField<String>('id_itinerary');
  set idItinerary(String? value) => setField<String>('id_itinerary', value);

  DateTime? get date => getField<DateTime>('date');
  set date(DateTime? value) => setField<DateTime>('date', value);

  double? get value => getField<double>('value');
  set value(double? value) => setField<double>('value', value);

  String? get paymentMethod => getField<String>('payment_method');
  set paymentMethod(String? value) => setField<String>('payment_method', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);

  String get type => getField<String>('type')!;
  set type(String value) => setField<String>('type', value);

  String? get voucherUrl => getField<String>('voucher_url');
  set voucherUrl(String? value) => setField<String>('voucher_url', value);

  String? get idItemItinerary => getField<String>('id_item_itinerary');
  set idItemItinerary(String? value) =>
      setField<String>('id_item_itinerary', value);

  String? get referenceField => getField<String>('reference');
  set referenceField(String? value) => setField<String>('reference', value);
}
