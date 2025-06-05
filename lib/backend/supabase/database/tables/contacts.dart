import '../database.dart';

class ContactsTable extends SupabaseTable<ContactsRow> {
  @override
  String get tableName => 'contacts';

  @override
  ContactsRow createRow(Map<String, dynamic> data) => ContactsRow(data);
}

class ContactsRow extends SupabaseDataRow {
  ContactsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ContactsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get lastName => getField<String>('last_name');
  set lastName(String? value) => setField<String>('last_name', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  String? get managedByUserId => getField<String>('managed_by_user_id');
  set managedByUserId(String? value) =>
      setField<String>('managed_by_user_id', value);

  dynamic? get additionalInfo => getField<dynamic>('additional_info');
  set additionalInfo(dynamic? value) =>
      setField<dynamic>('additional_info', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get nationality => getField<String>('nationality');
  set nationality(String? value) => setField<String>('nationality', value);

  String? get typeId => getField<String>('type_id');
  set typeId(String? value) => setField<String>('type_id', value);

  String? get numberId => getField<String>('number_id');
  set numberId(String? value) => setField<String>('number_id', value);

  String? get idItinerary => getField<String>('id_itinerary');
  set idItinerary(String? value) => setField<String>('id_itinerary', value);

  DateTime? get birthDate => getField<DateTime>('birth_date');
  set birthDate(DateTime? value) => setField<DateTime>('birth_date', value);

  String? get idFm => getField<String>('id_fm');
  set idFm(String? value) => setField<String>('id_fm', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get userRol => getField<String>('user_rol');
  set userRol(String? value) => setField<String>('user_rol', value);

  String? get website => getField<String>('website');
  set website(String? value) => setField<String>('website', value);

  String? get idRelatedContact => getField<String>('id_related_contact');
  set idRelatedContact(String? value) =>
      setField<String>('id_related_contact', value);

  bool? get isCompany => getField<bool>('is_company');
  set isCompany(bool? value) => setField<bool>('is_company', value);

  bool? get isProvider => getField<bool>('is_provider');
  set isProvider(bool? value) => setField<bool>('is_provider', value);

  String? get phone2 => getField<String>('phone2');
  set phone2(String? value) => setField<String>('phone2', value);

  String? get userImage => getField<String>('user_image');
  set userImage(String? value) => setField<String>('user_image', value);

  bool? get isClient => getField<bool>('is_client');
  set isClient(bool? value) => setField<bool>('is_client', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);

  String? get location => getField<String>('location');
  set location(String? value) => setField<String>('location', value);

  String? get position => getField<String>('position');
  set position(String? value) => setField<String>('position', value);

  bool? get notify => getField<bool>('notify');
  set notify(bool? value) => setField<bool>('notify', value);
}
