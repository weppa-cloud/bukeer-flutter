import '../database.dart';

class UserContactInfoTable extends SupabaseTable<UserContactInfoRow> {
  @override
  String get tableName => 'user_contact_info';

  @override
  UserContactInfoRow createRow(Map<String, dynamic> data) =>
      UserContactInfoRow(data);
}

class UserContactInfoRow extends SupabaseDataRow {
  UserContactInfoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserContactInfoTable();

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  String? get userRol => getField<String>('user_rol');
  set userRol(String? value) => setField<String>('user_rol', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);

  String? get lastName => getField<String>('last_name');
  set lastName(String? value) => setField<String>('last_name', value);

  int? get idUserRol => getField<int>('id_user_rol');
  set idUserRol(int? value) => setField<int>('id_user_rol', value);

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);
}
