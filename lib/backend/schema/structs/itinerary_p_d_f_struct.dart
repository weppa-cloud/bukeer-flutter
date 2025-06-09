// ignore_for_file: unnecessary_getters_setters

import '../util/schema_util.dart';

import 'index.dart';
import 'package:bukeer/legacy/flutter_flow/flutter_flow_util.dart';

class ItineraryPDFStruct extends BaseStruct {
  ItineraryPDFStruct({
    String? orderNumber,
    String? orderDate,
    String? shipDate,
    String? currency,
    String? companyName,
    String? email,
    String? customerName,
    String? shipTo,
    String? shipToAddress,
    String? shipToAddress2,
    String? shipToAddress3,
    bool? isPartialOrder,
    List<ItemsStruct>? items,
    int? grossTotal,
  })  : _orderNumber = orderNumber,
        _orderDate = orderDate,
        _shipDate = shipDate,
        _currency = currency,
        _companyName = companyName,
        _email = email,
        _customerName = customerName,
        _shipTo = shipTo,
        _shipToAddress = shipToAddress,
        _shipToAddress2 = shipToAddress2,
        _shipToAddress3 = shipToAddress3,
        _isPartialOrder = isPartialOrder,
        _items = items,
        _grossTotal = grossTotal;

  // "order_number" field.
  String? _orderNumber;
  String get orderNumber => _orderNumber ?? '';
  set orderNumber(String? val) => _orderNumber = val;

  bool hasOrderNumber() => _orderNumber != null;

  // "order_date" field.
  String? _orderDate;
  String get orderDate => _orderDate ?? '';
  set orderDate(String? val) => _orderDate = val;

  bool hasOrderDate() => _orderDate != null;

  // "ship_date" field.
  String? _shipDate;
  String get shipDate => _shipDate ?? '';
  set shipDate(String? val) => _shipDate = val;

  bool hasShipDate() => _shipDate != null;

  // "currency" field.
  String? _currency;
  String get currency => _currency ?? '';
  set currency(String? val) => _currency = val;

  bool hasCurrency() => _currency != null;

  // "company_name" field.
  String? _companyName;
  String get companyName => _companyName ?? '';
  set companyName(String? val) => _companyName = val;

  bool hasCompanyName() => _companyName != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "customer_name" field.
  String? _customerName;
  String get customerName => _customerName ?? '';
  set customerName(String? val) => _customerName = val;

  bool hasCustomerName() => _customerName != null;

  // "ship_to" field.
  String? _shipTo;
  String get shipTo => _shipTo ?? '';
  set shipTo(String? val) => _shipTo = val;

  bool hasShipTo() => _shipTo != null;

  // "ship_to_address" field.
  String? _shipToAddress;
  String get shipToAddress => _shipToAddress ?? '';
  set shipToAddress(String? val) => _shipToAddress = val;

  bool hasShipToAddress() => _shipToAddress != null;

  // "ship_to_address2" field.
  String? _shipToAddress2;
  String get shipToAddress2 => _shipToAddress2 ?? '';
  set shipToAddress2(String? val) => _shipToAddress2 = val;

  bool hasShipToAddress2() => _shipToAddress2 != null;

  // "ship_to_address3" field.
  String? _shipToAddress3;
  String get shipToAddress3 => _shipToAddress3 ?? '';
  set shipToAddress3(String? val) => _shipToAddress3 = val;

  bool hasShipToAddress3() => _shipToAddress3 != null;

  // "is_partial_order" field.
  bool? _isPartialOrder;
  bool get isPartialOrder => _isPartialOrder ?? false;
  set isPartialOrder(bool? val) => _isPartialOrder = val;

  bool hasIsPartialOrder() => _isPartialOrder != null;

  // "items" field.
  List<ItemsStruct>? _items;
  List<ItemsStruct> get items => _items ?? const [];
  set items(List<ItemsStruct>? val) => _items = val;

  void updateItems(Function(List<ItemsStruct>) updateFn) {
    updateFn(_items ??= []);
  }

  bool hasItems() => _items != null;

  // "gross_total" field.
  int? _grossTotal;
  int get grossTotal => _grossTotal ?? 0;
  set grossTotal(int? val) => _grossTotal = val;

  void incrementGrossTotal(int amount) => grossTotal = grossTotal + amount;

  bool hasGrossTotal() => _grossTotal != null;

  static ItineraryPDFStruct fromMap(Map<String, dynamic> data) =>
      ItineraryPDFStruct(
        orderNumber: data['order_number'] as String?,
        orderDate: data['order_date'] as String?,
        shipDate: data['ship_date'] as String?,
        currency: data['currency'] as String?,
        companyName: data['company_name'] as String?,
        email: data['email'] as String?,
        customerName: data['customer_name'] as String?,
        shipTo: data['ship_to'] as String?,
        shipToAddress: data['ship_to_address'] as String?,
        shipToAddress2: data['ship_to_address2'] as String?,
        shipToAddress3: data['ship_to_address3'] as String?,
        isPartialOrder: data['is_partial_order'] as bool?,
        items: getStructList(
          data['items'],
          ItemsStruct.fromMap,
        ),
        grossTotal: castToType<int>(data['gross_total']),
      );

  static ItineraryPDFStruct? maybeFromMap(dynamic data) => data is Map
      ? ItineraryPDFStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'order_number': _orderNumber,
        'order_date': _orderDate,
        'ship_date': _shipDate,
        'currency': _currency,
        'company_name': _companyName,
        'email': _email,
        'customer_name': _customerName,
        'ship_to': _shipTo,
        'ship_to_address': _shipToAddress,
        'ship_to_address2': _shipToAddress2,
        'ship_to_address3': _shipToAddress3,
        'is_partial_order': _isPartialOrder,
        'items': _items?.map((e) => e.toMap()).toList(),
        'gross_total': _grossTotal,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'order_number': serializeParam(
          _orderNumber,
          ParamType.String,
        ),
        'order_date': serializeParam(
          _orderDate,
          ParamType.String,
        ),
        'ship_date': serializeParam(
          _shipDate,
          ParamType.String,
        ),
        'currency': serializeParam(
          _currency,
          ParamType.String,
        ),
        'company_name': serializeParam(
          _companyName,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'customer_name': serializeParam(
          _customerName,
          ParamType.String,
        ),
        'ship_to': serializeParam(
          _shipTo,
          ParamType.String,
        ),
        'ship_to_address': serializeParam(
          _shipToAddress,
          ParamType.String,
        ),
        'ship_to_address2': serializeParam(
          _shipToAddress2,
          ParamType.String,
        ),
        'ship_to_address3': serializeParam(
          _shipToAddress3,
          ParamType.String,
        ),
        'is_partial_order': serializeParam(
          _isPartialOrder,
          ParamType.bool,
        ),
        'items': serializeParam(
          _items,
          ParamType.DataStruct,
          isList: true,
        ),
        'gross_total': serializeParam(
          _grossTotal,
          ParamType.int,
        ),
      }.withoutNulls;

  static ItineraryPDFStruct fromSerializableMap(Map<String, dynamic> data) =>
      ItineraryPDFStruct(
        orderNumber: deserializeParam(
          data['order_number'],
          ParamType.String,
          false,
        ),
        orderDate: deserializeParam(
          data['order_date'],
          ParamType.String,
          false,
        ),
        shipDate: deserializeParam(
          data['ship_date'],
          ParamType.String,
          false,
        ),
        currency: deserializeParam(
          data['currency'],
          ParamType.String,
          false,
        ),
        companyName: deserializeParam(
          data['company_name'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        customerName: deserializeParam(
          data['customer_name'],
          ParamType.String,
          false,
        ),
        shipTo: deserializeParam(
          data['ship_to'],
          ParamType.String,
          false,
        ),
        shipToAddress: deserializeParam(
          data['ship_to_address'],
          ParamType.String,
          false,
        ),
        shipToAddress2: deserializeParam(
          data['ship_to_address2'],
          ParamType.String,
          false,
        ),
        shipToAddress3: deserializeParam(
          data['ship_to_address3'],
          ParamType.String,
          false,
        ),
        isPartialOrder: deserializeParam(
          data['is_partial_order'],
          ParamType.bool,
          false,
        ),
        items: deserializeStructParam<ItemsStruct>(
          data['items'],
          ParamType.DataStruct,
          true,
          structBuilder: ItemsStruct.fromSerializableMap,
        ),
        grossTotal: deserializeParam(
          data['gross_total'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'ItineraryPDFStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ItineraryPDFStruct &&
        orderNumber == other.orderNumber &&
        orderDate == other.orderDate &&
        shipDate == other.shipDate &&
        currency == other.currency &&
        companyName == other.companyName &&
        email == other.email &&
        customerName == other.customerName &&
        shipTo == other.shipTo &&
        shipToAddress == other.shipToAddress &&
        shipToAddress2 == other.shipToAddress2 &&
        shipToAddress3 == other.shipToAddress3 &&
        isPartialOrder == other.isPartialOrder &&
        listEquality.equals(items, other.items) &&
        grossTotal == other.grossTotal;
  }

  @override
  int get hashCode => const ListEquality().hash([
        orderNumber,
        orderDate,
        shipDate,
        currency,
        companyName,
        email,
        customerName,
        shipTo,
        shipToAddress,
        shipToAddress2,
        shipToAddress3,
        isPartialOrder,
        items,
        grossTotal
      ]);
}

ItineraryPDFStruct createItineraryPDFStruct({
  String? orderNumber,
  String? orderDate,
  String? shipDate,
  String? currency,
  String? companyName,
  String? email,
  String? customerName,
  String? shipTo,
  String? shipToAddress,
  String? shipToAddress2,
  String? shipToAddress3,
  bool? isPartialOrder,
  int? grossTotal,
}) =>
    ItineraryPDFStruct(
      orderNumber: orderNumber,
      orderDate: orderDate,
      shipDate: shipDate,
      currency: currency,
      companyName: companyName,
      email: email,
      customerName: customerName,
      shipTo: shipTo,
      shipToAddress: shipToAddress,
      shipToAddress2: shipToAddress2,
      shipToAddress3: shipToAddress3,
      isPartialOrder: isPartialOrder,
      grossTotal: grossTotal,
    );
