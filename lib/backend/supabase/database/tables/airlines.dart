import '../database.dart';

class AirlinesTable extends SupabaseTable<AirlinesRow> {
  @override
  String get tableName => 'airlines';

  @override
  AirlinesRow createRow(Map<String, dynamic> data) => AirlinesRow(data);
}

class AirlinesRow extends SupabaseDataRow {
  AirlinesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AirlinesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get duffelId => getField<String>('duffel_id')!;
  set duffelId(String value) => setField<String>('duffel_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get iataCode => getField<String>('iata_code');
  set iataCode(String? value) => setField<String>('iata_code', value);

  String? get conditionsOfCarriageUrl =>
      getField<String>('conditions_of_carriage_url');
  set conditionsOfCarriageUrl(String? value) =>
      setField<String>('conditions_of_carriage_url', value);

  String? get logoSymbolUrl => getField<String>('logo_symbol_url');
  set logoSymbolUrl(String? value) =>
      setField<String>('logo_symbol_url', value);

  String? get logoLockupUrl => getField<String>('logo_lockup_url');
  set logoLockupUrl(String? value) =>
      setField<String>('logo_lockup_url', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);

  bool? get feature => getField<bool>('feature');
  set feature(bool? value) => setField<bool>('feature', value);

  String? get logoPng => getField<String>('logo_png');
  set logoPng(String? value) => setField<String>('logo_png', value);
}
