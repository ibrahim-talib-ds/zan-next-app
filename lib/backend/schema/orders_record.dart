import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrdersRecord extends FirestoreRecord {
  OrdersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "buyer" field.
  DocumentReference? _buyer;
  DocumentReference? get buyer => _buyer;
  bool hasBuyer() => _buyer != null;

  // "seller" field.
  DocumentReference? _seller;
  DocumentReference? get seller => _seller;
  bool hasSeller() => _seller != null;

  // "total_items" field.
  int? _totalItems;
  int get totalItems => _totalItems ?? 0;
  bool hasTotalItems() => _totalItems != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "order_no" field.
  String? _orderNo;
  String get orderNo => _orderNo ?? '';
  bool hasOrderNo() => _orderNo != null;

  // "total_price" field.
  double? _totalPrice;
  double get totalPrice => _totalPrice ?? 0.0;
  bool hasTotalPrice() => _totalPrice != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "product_ref" field.
  DocumentReference? _productRef;
  DocumentReference? get productRef => _productRef;
  bool hasProductRef() => _productRef != null;

  // "address_ref" field.
  DocumentReference? _addressRef;
  DocumentReference? get addressRef => _addressRef;
  bool hasAddressRef() => _addressRef != null;

  // "product_name" field.
  String? _productName;
  String get productName => _productName ?? '';
  bool hasProductName() => _productName != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  // "Item_images" field.
  List<String>? _itemImages;
  List<String> get itemImages => _itemImages ?? const [];
  bool hasItemImages() => _itemImages != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "driver_name" field.
  String? _driverName;
  String get driverName => _driverName ?? '';
  bool hasDriverName() => _driverName != null;

  // "driver_number" field.
  String? _driverNumber;
  String get driverNumber => _driverNumber ?? '';
  bool hasDriverNumber() => _driverNumber != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  void _initializeFields() {
    _buyer = snapshotData['buyer'] as DocumentReference?;
    _seller = snapshotData['seller'] as DocumentReference?;
    _totalItems = castToType<int>(snapshotData['total_items']);
    _date = snapshotData['date'] as DateTime?;
    _orderNo = snapshotData['order_no'] as String?;
    _totalPrice = castToType<double>(snapshotData['total_price']);
    _status = snapshotData['status'] as String?;
    _productRef = snapshotData['product_ref'] as DocumentReference?;
    _addressRef = snapshotData['address_ref'] as DocumentReference?;
    _productName = snapshotData['product_name'] as String?;
    _price = castToType<double>(snapshotData['price']);
    _itemImages = getDataList(snapshotData['Item_images']);
    _location = snapshotData['location'] as LatLng?;
    _driverName = snapshotData['driver_name'] as String?;
    _driverNumber = snapshotData['driver_number'] as String?;
    _address = snapshotData['address'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('orders');

  static Stream<OrdersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OrdersRecord.fromSnapshot(s));

  static Future<OrdersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OrdersRecord.fromSnapshot(s));

  static OrdersRecord fromSnapshot(DocumentSnapshot snapshot) => OrdersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OrdersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrdersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrdersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrdersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

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
  LatLng? location,
  String? driverName,
  String? driverNumber,
  String? address,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
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
      'location': location,
      'driver_name': driverName,
      'driver_number': driverNumber,
      'address': address,
    }.withoutNulls,
  );

  return firestoreData;
}

class OrdersRecordDocumentEquality implements Equality<OrdersRecord> {
  const OrdersRecordDocumentEquality();

  @override
  bool equals(OrdersRecord? e1, OrdersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.buyer == e2?.buyer &&
        e1?.seller == e2?.seller &&
        e1?.totalItems == e2?.totalItems &&
        e1?.date == e2?.date &&
        e1?.orderNo == e2?.orderNo &&
        e1?.totalPrice == e2?.totalPrice &&
        e1?.status == e2?.status &&
        e1?.productRef == e2?.productRef &&
        e1?.addressRef == e2?.addressRef &&
        e1?.productName == e2?.productName &&
        e1?.price == e2?.price &&
        listEquality.equals(e1?.itemImages, e2?.itemImages) &&
        e1?.location == e2?.location &&
        e1?.driverName == e2?.driverName &&
        e1?.driverNumber == e2?.driverNumber &&
        e1?.address == e2?.address;
  }

  @override
  int hash(OrdersRecord? e) => const ListEquality().hash([
        e?.buyer,
        e?.seller,
        e?.totalItems,
        e?.date,
        e?.orderNo,
        e?.totalPrice,
        e?.status,
        e?.productRef,
        e?.addressRef,
        e?.productName,
        e?.price,
        e?.itemImages,
        e?.location,
        e?.driverName,
        e?.driverNumber,
        e?.address
      ]);

  @override
  bool isValidKey(Object? o) => o is OrdersRecord;
}
