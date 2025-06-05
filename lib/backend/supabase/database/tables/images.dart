import '../database.dart';

class ImagesTable extends SupabaseTable<ImagesRow> {
  @override
  String get tableName => 'images';

  @override
  ImagesRow createRow(Map<String, dynamic> data) => ImagesRow(data);
}

class ImagesRow extends SupabaseDataRow {
  ImagesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ImagesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get entityId => getField<String>('entity_id');
  set entityId(String? value) => setField<String>('entity_id', value);

  String? get url => getField<String>('url');
  set url(String? value) => setField<String>('url', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);
}
