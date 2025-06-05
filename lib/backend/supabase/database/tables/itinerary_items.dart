import '../database.dart';

class ItineraryItemsTable extends SupabaseTable<ItineraryItemsRow> {
  @override
  String get tableName => 'itinerary_items';

  @override
  ItineraryItemsRow createRow(Map<String, dynamic> data) =>
      ItineraryItemsRow(data);
}

class ItineraryItemsRow extends SupabaseDataRow {
  ItineraryItemsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ItineraryItemsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get idItinerary => getField<String>('id_itinerary');
  set idItinerary(String? value) => setField<String>('id_itinerary', value);

  DateTime? get startTime => getField<DateTime>('start_time');
  set startTime(DateTime? value) => setField<DateTime>('start_time', value);

  DateTime? get endTime => getField<DateTime>('end_time');
  set endTime(DateTime? value) => setField<DateTime>('end_time', value);

  int? get dayNumber => getField<int>('day_number');
  set dayNumber(int? value) => setField<int>('day_number', value);

  int? get order => getField<int>('order');
  set order(int? value) => setField<int>('order', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  double? get unitCost => getField<double>('unit_cost');
  set unitCost(double? value) => setField<double>('unit_cost', value);

  double? get quantity => getField<double>('quantity');
  set quantity(double? value) => setField<double>('quantity', value);

  double? get totalCost => getField<double>('total_cost');
  set totalCost(double? value) => setField<double>('total_cost', value);

  DateTime? get date => getField<DateTime>('date');
  set date(DateTime? value) => setField<DateTime>('date', value);

  String? get destination => getField<String>('destination');
  set destination(String? value) => setField<String>('destination', value);

  String? get productName => getField<String>('product_name');
  set productName(String? value) => setField<String>('product_name', value);

  String? get rateName => getField<String>('rate_name');
  set rateName(String? value) => setField<String>('rate_name', value);

  String? get productType => getField<String>('product_type');
  set productType(String? value) => setField<String>('product_type', value);

  int? get hotelNights => getField<int>('hotel_nights');
  set hotelNights(int? value) => setField<int>('hotel_nights', value);

  double? get profitPercentage => getField<double>('profit_percentage');
  set profitPercentage(double? value) =>
      setField<double>('profit_percentage', value);

  double? get profit => getField<double>('profit');
  set profit(double? value) => setField<double>('profit', value);

  double? get totalPrice => getField<double>('total_price');
  set totalPrice(double? value) => setField<double>('total_price', value);

  String? get flightDeparture => getField<String>('flight_departure');
  set flightDeparture(String? value) =>
      setField<String>('flight_departure', value);

  String? get flightArrival => getField<String>('flight_arrival');
  set flightArrival(String? value) => setField<String>('flight_arrival', value);

  String? get departureTime => getField<String>('departure_time');
  set departureTime(String? value) => setField<String>('departure_time', value);

  String? get arrivalTime => getField<String>('arrival_time');
  set arrivalTime(String? value) => setField<String>('arrival_time', value);

  String? get flightNumber => getField<String>('flight_number');
  set flightNumber(String? value) => setField<String>('flight_number', value);

  String? get airline => getField<String>('airline');
  set airline(String? value) => setField<String>('airline', value);

  double? get unitPrice => getField<double>('unit_price');
  set unitPrice(double? value) => setField<double>('unit_price', value);

  String? get idProduct => getField<String>('id_product');
  set idProduct(String? value) => setField<String>('id_product', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);

  double? get paidCost => getField<double>('paid_cost');
  set paidCost(double? value) => setField<double>('paid_cost', value);

  double? get pendingPaidCost => getField<double>('pending_paid_cost');
  set pendingPaidCost(double? value) =>
      setField<double>('pending_paid_cost', value);

  bool get reservationStatus => getField<bool>('reservation_status')!;
  set reservationStatus(bool value) =>
      setField<bool>('reservation_status', value);

  String? get personalizedMessage => getField<String>('personalized_message');
  set personalizedMessage(String? value) =>
      setField<String>('personalized_message', value);

  List<dynamic> get reservationMessages =>
      getListField<dynamic>('reservation_messages');
  set reservationMessages(List<dynamic>? value) =>
      setListField<dynamic>('reservation_messages', value);
}
