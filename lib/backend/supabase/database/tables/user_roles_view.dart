import '../database.dart';

class UserRolesViewTable extends SupabaseTable<UserRolesViewRow> {
  @override
  String get tableName => 'user_roles_view';

  @override
  UserRolesViewRow createRow(Map<String, dynamic> data) =>
      UserRolesViewRow(data);
}

class UserRolesViewRow extends SupabaseDataRow {
  UserRolesViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserRolesViewTable();

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get roleNames => getField<String>('role_names');
  set roleNames(String? value) => setField<String>('role_names', value);
}
