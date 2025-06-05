import '../database.dart';

class AccountsTable extends SupabaseTable<AccountsRow> {
  @override
  String get tableName => 'accounts';

  @override
  AccountsRow createRow(Map<String, dynamic> data) => AccountsRow(data);
}

class AccountsRow extends SupabaseDataRow {
  AccountsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AccountsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  int get idFm => getField<int>('id_fm')!;
  set idFm(int value) => setField<int>('id_fm', value);

  String? get logoImage => getField<String>('logo_image');
  set logoImage(String? value) => setField<String>('logo_image', value);

  String? get typeId => getField<String>('type_id');
  set typeId(String? value) => setField<String>('type_id', value);

  String? get numberId => getField<String>('number_id');
  set numberId(String? value) => setField<String>('number_id', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  String? get phone2 => getField<String>('phone2');
  set phone2(String? value) => setField<String>('phone2', value);

  String? get mail => getField<String>('mail');
  set mail(String? value) => setField<String>('mail', value);

  String? get location => getField<String>('location');
  set location(String? value) => setField<String>('location', value);

  String? get website => getField<String>('website');
  set website(String? value) => setField<String>('website', value);

  String? get cancellationPolicy => getField<String>('cancellation_policy');
  set cancellationPolicy(String? value) =>
      setField<String>('cancellation_policy', value);

  String? get privacyPolicy => getField<String>('privacy_policy');
  set privacyPolicy(String? value) => setField<String>('privacy_policy', value);

  String? get termsConditions => getField<String>('terms_conditions');
  set termsConditions(String? value) =>
      setField<String>('terms_conditions', value);

  List<dynamic> get currency => getListField<dynamic>('currency');
  set currency(List<dynamic>? value) =>
      setListField<dynamic>('currency', value);

  List<dynamic> get typesIncrease => getListField<dynamic>('types_increase');
  set typesIncrease(List<dynamic>? value) =>
      setListField<dynamic>('types_increase', value);

  List<dynamic> get paymentMethods => getListField<dynamic>('payment_methods');
  set paymentMethods(List<dynamic>? value) =>
      setListField<dynamic>('payment_methods', value);
}
