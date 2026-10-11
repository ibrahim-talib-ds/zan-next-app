// ZanNext — OrdersRecord Shim (complete)
//
// Full API compatibility with the original Firestore OrdersRecord.
// Backed by our Order model (Postgres).
// Screens that read orders work through OrdersRecord.getDocument().

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, CollectionReference, DocumentSnapshot, FirebaseFirestore;

import '../../models/order.dart';
import '../../repositories/order_repository.dart';

class OrdersRecord {
  OrdersRecord._(this._order, DocumentReference? explicitRef)
      : _explicitRef = explicitRef;

  final Order? _order;
  final DocumentReference? _explicitRef;

  String get id => _order?.id ?? '';

  DocumentReference get reference =>
      _explicitRef ??
      FirebaseFirestore.instance.collection('orders').doc(_order?.id ?? 'unknown');

  DocumentReference get syntheticRef => reference;

  Order? get order => _order;

  // ---- Field getters (Firestore field names, backed by our Order model) ----
  DocumentReference? get buyer => _order?.buyerId != null
      ? FirebaseFirestore.instance.collection('users').doc(_order!.buyerId)
      : null;
  bool hasBuyer() => _order?.buyerId != null;

  DocumentReference? get seller => _order?.sellerId != null
      ? FirebaseFirestore.instance.collection('users').doc(_order!.sellerId)
      : null;
  bool hasSeller() => _order?.sellerId != null;

  int get totalItems => _order?.totalItems ?? 1;
  bool hasTotalItems() => _order != null;

  DateTime? get date => _order?.createdAt;
  bool hasDate() => _order?.createdAt != null;

  String get orderNo => _order?.orderNo ?? '';
  bool hasOrderNo() => (_order?.orderNo ?? '').isNotEmpty;

  double get totalPrice => _order?.price ?? 0;
  bool hasTotalPrice() => _order?.price != null;

  String get status => _order?.status ?? 'Pending';
  bool hasStatus() => _order?.status != null;

  DocumentReference? get productRef => _order?.productId != null
      ? FirebaseFirestore.instance.collection('Inventory').doc(_order!.productId)
      : null;
  bool hasProductRef() => _order?.productId != null;

  DocumentReference? get addressRef => null;
  bool hasAddressRef() => false;

  String get productName => _order?.productName ?? '';
  bool hasProductName() => (_order?.productName ?? '').isNotEmpty;

  double get price => _order?.price ?? 0;
  bool hasPrice() => _order?.price != null;

  List<String> get itemImages => _order?.itemImages ?? const <String>[];
  bool hasItemImages() =>
      (_order?.itemImages != null && _order!.itemImages!.isNotEmpty);

  dynamic get location => null;
  bool hasLocation() => false;

  String get driverName => _order?.driverName ?? '';
  bool hasDriverName() => (_order?.driverName ?? '').isNotEmpty;

  String get driverNumber => _order?.driverNumber ?? '';
  bool hasDriverNumber() => (_order?.driverNumber ?? '').isNotEmpty;

  String get address => _order?.address ?? '';
  bool hasAddress() => (_order?.address ?? '').isNotEmpty;

  // ---- Firestore-shape compatibility ----
  // Some widgets do `(o as dynamic).snapshotData` to read raw fields.
  // Return a Map with the SAME Firestore field names so _raw(o, key) works.
  Map<String, dynamic> get snapshotData {
    final o = _order;
    if (o == null) return <String, dynamic>{};
    return <String, dynamic>{
      'buyer': o.buyerId,
      'seller': o.sellerId,
      'total_items': o.totalItems,
      'date': o.createdAt,
      'order_no': o.orderNo,
      'total_price': o.price,
      'status': o.status,
      'product_ref': o.productId,
      'address_ref': null,
      'product_name': o.productName,
      'price': o.price,
      'Item_images': o.itemImages,
      'location': null,
      'driver_name': o.driverName,
      'driver_number': o.driverNumber,
      'address': o.address,
      'status_history': o.statusHistory,
      'buyer_name': o.buyerName,
      'buyer_phone': o.buyerPhone,
      'seller_name': o.sellerName,
      'seller_phone': null,
      'driver_phone': o.driverNumber,
    };
  }

  // ---- Static factory methods ----
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('orders');

  static Stream<OrdersRecord> getDocument(DocumentReference ref) {
    return Stream.fromFuture(getDocumentOnce(ref));
  }

  static Future<OrdersRecord> getDocumentOnce(DocumentReference ref) async {
    try {
      final order = await OrderRepository.get(ref.id);
      return OrdersRecord._(order, ref);
    } catch (_) {
      return OrdersRecord._(null, ref);
    }
  }

  static OrdersRecord fromSnapshot(DocumentSnapshot snapshot) =>
      OrdersRecord._(null, snapshot.reference);

  static OrdersRecord fromOrder(Order order) => OrdersRecord._(order, null);

  @override
  String toString() => 'OrdersRecord(id: ${_order?.id}, status: ${_order?.status})';
}

// =====================================================================
// Compatibility: createOrdersRecordData
// =====================================================================
Map<String, dynamic> createOrdersRecordData({
  DocumentReference? buyer,
  DocumentReference? seller,
  int? totalItems,
  DateTime? date,
  String? orderNo,
  double? totalPrice,
  String? status,
  DocumentReference? productRef,
  DocumentReference? addressRef,
  String? productName,
  double? price,
  String? address,
  String? driverName,
  String? driverNumber,
  List<String>? itemImages,
}) {
  return <String, dynamic>{
    'buyer': buyer,
    'seller': seller,
    'total_items': totalItems,
    'date': date,
    'order_no': orderNo,
    'total_price': totalPrice,
    'status': status,
    'product_ref': productRef,
    'address_ref': addressRef,
    'product_name': productName,
    'price': price,
    'address': address,
    'driver_name': driverName,
    'driver_number': driverNumber,
    'Item_images': itemImages,
  };
}
