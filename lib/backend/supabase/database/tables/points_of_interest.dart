import '../database.dart';

class PointsOfInterestTable extends SupabaseTable<PointsOfInterestRow> {
  @override
  String get tableName => 'points_of_interest';

  @override
  PointsOfInterestRow createRow(Map<String, dynamic> data) =>
      PointsOfInterestRow(data);
}

class PointsOfInterestRow extends SupabaseDataRow {
  PointsOfInterestRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PointsOfInterestTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get city => getField<String>('city')!;
  set city(String value) => setField<String>('city', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  double? get estimatedEntranceFee =>
      getField<double>('estimated_entrance_fee');
  set estimatedEntranceFee(double? value) =>
      setField<double>('estimated_entrance_fee', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);
}
