import '../database.dart';

class ItinerariesTable extends SupabaseTable<ItinerariesRow> {
  @override
  String get tableName => 'itineraries';

  @override
  ItinerariesRow createRow(Map<String, dynamic> data) => ItinerariesRow(data);
}

class ItinerariesRow extends SupabaseDataRow {
  ItinerariesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ItinerariesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get idCreatedBy => getField<String>('id_created_by');
  set idCreatedBy(String? value) => setField<String>('id_created_by', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  DateTime get startDate => getField<DateTime>('start_date')!;
  set startDate(DateTime value) => setField<DateTime>('start_date', value);

  DateTime get endDate => getField<DateTime>('end_date')!;
  set endDate(DateTime value) => setField<DateTime>('end_date', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get idContact => getField<String>('id_contact');
  set idContact(String? value) => setField<String>('id_contact', value);

  double? get passengerCount => getField<double>('passenger_count');
  set passengerCount(double? value) =>
      setField<double>('passenger_count', value);

  String? get currencyType => getField<String>('currency_type');
  set currencyType(String? value) => setField<String>('currency_type', value);

  DateTime? get validUntil => getField<DateTime>('valid_until');
  set validUntil(DateTime? value) => setField<DateTime>('valid_until', value);

  String? get requestType => getField<String>('request_type');
  set requestType(String? value) => setField<String>('request_type', value);

  double? get totalAmount => getField<double>('total_amount');
  set totalAmount(double? value) => setField<double>('total_amount', value);

  double? get totalMarkup => getField<double>('total_markup');
  set totalMarkup(double? value) => setField<double>('total_markup', value);

  double? get totalCost => getField<double>('total_cost');
  set totalCost(double? value) => setField<double>('total_cost', value);

  String? get agent => getField<String>('agent');
  set agent(String? value) => setField<String>('agent', value);

  double? get totalProviderPayment =>
      getField<double>('total_provider_payment');
  set totalProviderPayment(double? value) =>
      setField<double>('total_provider_payment', value);

  String? get idFm => getField<String>('id_fm');
  set idFm(String? value) => setField<String>('id_fm', value);

  String? get language => getField<String>('language');
  set language(String? value) => setField<String>('language', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);

  double? get totalHotels => getField<double>('total_hotels');
  set totalHotels(double? value) => setField<double>('total_hotels', value);

  double? get totalFlights => getField<double>('total_flights');
  set totalFlights(double? value) => setField<double>('total_flights', value);

  double? get totalActivities => getField<double>('total_activities');
  set totalActivities(double? value) =>
      setField<double>('total_activities', value);

  double? get totalTransfer => getField<double>('total_transfer');
  set totalTransfer(double? value) => setField<double>('total_transfer', value);

  double? get paid => getField<double>('paid');
  set paid(double? value) => setField<double>('paid', value);

  double? get pendingPaid => getField<double>('pending_paid');
  set pendingPaid(double? value) => setField<double>('pending_paid', value);

  dynamic? get currency => getField<dynamic>('currency');
  set currency(dynamic? value) => setField<dynamic>('currency', value);

  bool? get itineraryVisibility => getField<bool>('itinerary_visibility');
  set itineraryVisibility(bool? value) =>
      setField<bool>('itinerary_visibility', value);

  bool? get ratesVisibility => getField<bool>('rates_visibility');
  set ratesVisibility(bool? value) => setField<bool>('rates_visibility', value);

  dynamic? get typesIncrease => getField<dynamic>('types_increase');
  set typesIncrease(dynamic? value) =>
      setField<dynamic>('types_increase', value);

  double? get totalAmountRate => getField<double>('total_amount_rate');
  set totalAmountRate(double? value) =>
      setField<double>('total_amount_rate', value);

  String? get personalizedMessage => getField<String>('personalized_message');
  set personalizedMessage(String? value) =>
      setField<String>('personalized_message', value);

  String? get mainImage => getField<String>('main_image');
  set mainImage(String? value) => setField<String>('main_image', value);

  DateTime? get confirmationDate => getField<DateTime>('confirmation_date');
  set confirmationDate(DateTime? value) =>
      setField<DateTime>('confirmation_date', value);
}
