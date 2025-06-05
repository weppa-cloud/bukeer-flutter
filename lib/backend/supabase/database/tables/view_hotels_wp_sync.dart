import '../database.dart';

class ViewHotelsWpSyncTable extends SupabaseTable<ViewHotelsWpSyncRow> {
  @override
  String get tableName => 'view_hotels_wp_sync';

  @override
  ViewHotelsWpSyncRow createRow(Map<String, dynamic> data) =>
      ViewHotelsWpSyncRow(data);
}

class ViewHotelsWpSyncRow extends SupabaseDataRow {
  ViewHotelsWpSyncRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewHotelsWpSyncTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get descriptionShort => getField<String>('description_short');
  set descriptionShort(String? value) =>
      setField<String>('description_short', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get mainImage => getField<String>('main_image');
  set mainImage(String? value) => setField<String>('main_image', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);

  int? get starRating => getField<int>('star_rating');
  set starRating(int? value) => setField<int>('star_rating', value);

  dynamic? get gallery => getField<dynamic>('gallery');
  set gallery(dynamic? value) => setField<dynamic>('gallery', value);

  String? get inclutions => getField<String>('inclutions');
  set inclutions(String? value) => setField<String>('inclutions', value);

  String? get exclutions => getField<String>('exclutions');
  set exclutions(String? value) => setField<String>('exclutions', value);

  String? get recomendations => getField<String>('recomendations');
  set recomendations(String? value) =>
      setField<String>('recomendations', value);

  String? get productType => getField<String>('product_type');
  set productType(String? value) => setField<String>('product_type', value);
}
