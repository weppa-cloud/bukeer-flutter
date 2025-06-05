// ignore_for_file: unnecessary_getters_setters

import '../util/schema_util.dart';

import 'index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';

class ItemsStruct extends BaseStruct {
  ItemsStruct({
    String? trackingId,
    String? description,
    int? qtyOrdered,
    int? qtyShipped,
    String? imageUrl,
  })  : _trackingId = trackingId,
        _description = description,
        _qtyOrdered = qtyOrdered,
        _qtyShipped = qtyShipped,
        _imageUrl = imageUrl;

  // "tracking_id" field.
  String? _trackingId;
  String get trackingId => _trackingId ?? '';
  set trackingId(String? val) => _trackingId = val;

  bool hasTrackingId() => _trackingId != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "qty_ordered" field.
  int? _qtyOrdered;
  int get qtyOrdered => _qtyOrdered ?? 0;
  set qtyOrdered(int? val) => _qtyOrdered = val;

  void incrementQtyOrdered(int amount) => qtyOrdered = qtyOrdered + amount;

  bool hasQtyOrdered() => _qtyOrdered != null;

  // "qty_shipped" field.
  int? _qtyShipped;
  int get qtyShipped => _qtyShipped ?? 0;
  set qtyShipped(int? val) => _qtyShipped = val;

  void incrementQtyShipped(int amount) => qtyShipped = qtyShipped + amount;

  bool hasQtyShipped() => _qtyShipped != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  static ItemsStruct fromMap(Map<String, dynamic> data) => ItemsStruct(
        trackingId: data['tracking_id'] as String?,
        description: data['description'] as String?,
        qtyOrdered: castToType<int>(data['qty_ordered']),
        qtyShipped: castToType<int>(data['qty_shipped']),
        imageUrl: data['image_url'] as String?,
      );

  static ItemsStruct? maybeFromMap(dynamic data) =>
      data is Map ? ItemsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'tracking_id': _trackingId,
        'description': _description,
        'qty_ordered': _qtyOrdered,
        'qty_shipped': _qtyShipped,
        'image_url': _imageUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'tracking_id': serializeParam(
          _trackingId,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'qty_ordered': serializeParam(
          _qtyOrdered,
          ParamType.int,
        ),
        'qty_shipped': serializeParam(
          _qtyShipped,
          ParamType.int,
        ),
        'image_url': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static ItemsStruct fromSerializableMap(Map<String, dynamic> data) =>
      ItemsStruct(
        trackingId: deserializeParam(
          data['tracking_id'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        qtyOrdered: deserializeParam(
          data['qty_ordered'],
          ParamType.int,
          false,
        ),
        qtyShipped: deserializeParam(
          data['qty_shipped'],
          ParamType.int,
          false,
        ),
        imageUrl: deserializeParam(
          data['image_url'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ItemsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ItemsStruct &&
        trackingId == other.trackingId &&
        description == other.description &&
        qtyOrdered == other.qtyOrdered &&
        qtyShipped == other.qtyShipped &&
        imageUrl == other.imageUrl;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([trackingId, description, qtyOrdered, qtyShipped, imageUrl]);
}

ItemsStruct createItemsStruct({
  String? trackingId,
  String? description,
  int? qtyOrdered,
  int? qtyShipped,
  String? imageUrl,
}) =>
    ItemsStruct(
      trackingId: trackingId,
      description: description,
      qtyOrdered: qtyOrdered,
      qtyShipped: qtyShipped,
      imageUrl: imageUrl,
    );
