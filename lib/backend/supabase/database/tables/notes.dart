import '../database.dart';

class NotesTable extends SupabaseTable<NotesRow> {
  @override
  String get tableName => 'notes';

  @override
  NotesRow createRow(Map<String, dynamic> data) => NotesRow(data);
}

class NotesRow extends SupabaseDataRow {
  NotesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => NotesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get itineraryItemId => getField<String>('itinerary_item_id');
  set itineraryItemId(String? value) =>
      setField<String>('itinerary_item_id', value);

  String get content => getField<String>('content')!;
  set content(String value) => setField<String>('content', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);
}
