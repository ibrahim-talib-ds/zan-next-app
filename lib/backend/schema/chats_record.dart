import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// This represents the "Room" or the "Conversation" between two people.
class ChatsRecord extends FirestoreRecord {
  ChatsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "users" field.
  List<DocumentReference>? _users;
  List<DocumentReference> get users => _users ?? const [];
  bool hasUsers() => _users != null;

  // "last_message" field.
  String? _lastMessage;
  String get lastMessage => _lastMessage ?? '';
  bool hasLastMessage() => _lastMessage != null;

  // "last_message_time" field.
  DateTime? _lastMessageTime;
  DateTime? get lastMessageTime => _lastMessageTime;
  bool hasLastMessageTime() => _lastMessageTime != null;

  // "product_ref" field.
  DocumentReference? _productRef;
  DocumentReference? get productRef => _productRef;
  bool hasProductRef() => _productRef != null;

  // "buyer_ref" field.
  DocumentReference? _buyerRef;
  DocumentReference? get buyerRef => _buyerRef;
  bool hasBuyerRef() => _buyerRef != null;

  // "seller_ref" field.
  DocumentReference? _sellerRef;
  DocumentReference? get sellerRef => _sellerRef;
  bool hasSellerRef() => _sellerRef != null;

  // "unread_count" field.
  int? _unreadCount;
  int get unreadCount => _unreadCount ?? 0;
  bool hasUnreadCount() => _unreadCount != null;

  // "last_message_seen_by" field.
  List<DocumentReference>? _lastMessageSeenBy;
  List<DocumentReference> get lastMessageSeenBy =>
      _lastMessageSeenBy ?? const [];
  bool hasLastMessageSeenBy() => _lastMessageSeenBy != null;

  // "User_name" field.
  List<String>? _userName;
  List<String> get userName => _userName ?? const [];
  bool hasUserName() => _userName != null;

  // "user_photos" field.
  List<String>? _userPhotos;
  List<String> get userPhotos => _userPhotos ?? const [];
  bool hasUserPhotos() => _userPhotos != null;

  // "items_images" field.
  List<String>? _itemsImages;
  List<String> get itemsImages => _itemsImages ?? const [];
  bool hasItemsImages() => _itemsImages != null;

  // "product_name" field.
  String? _productName;
  String get productName => _productName ?? '';
  bool hasProductName() => _productName != null;

  // "Price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  void _initializeFields() {
    _users = getDataList(snapshotData['users']);
    _lastMessage = snapshotData['last_message'] as String?;
    _lastMessageTime = snapshotData['last_message_time'] as DateTime?;
    _productRef = snapshotData['product_ref'] as DocumentReference?;
    _buyerRef = snapshotData['buyer_ref'] as DocumentReference?;
    _sellerRef = snapshotData['seller_ref'] as DocumentReference?;
    _unreadCount = castToType<int>(snapshotData['unread_count']);
    _lastMessageSeenBy = getDataList(snapshotData['last_message_seen_by']);
    _userName = getDataList(snapshotData['User_name']);
    _userPhotos = getDataList(snapshotData['user_photos']);
    _itemsImages = getDataList(snapshotData['items_images']);
    _productName = snapshotData['product_name'] as String?;
    _price = castToType<double>(snapshotData['Price']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Chats');

  static Stream<ChatsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChatsRecord.fromSnapshot(s));

  static Future<ChatsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChatsRecord.fromSnapshot(s));

  static ChatsRecord fromSnapshot(DocumentSnapshot snapshot) => ChatsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChatsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChatsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChatsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChatsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChatsRecordData({
  List<DocumentReference>? users,
  String? lastMessage,
  DateTime? lastMessageTime,
  DocumentReference? productRef,
  DocumentReference? buyerRef,
  DocumentReference? sellerRef,
  int? unreadCount,
  List<DocumentReference>? lastMessageSeenBy,
  List<String>? userName,
  List<String>? userPhotos,
  List<String>? itemsImages,
  String? productName,
  double? price,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'users': users,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'product_ref': productRef,
      'buyer_ref': buyerRef,
      'seller_ref': sellerRef,
      'unread_count': unreadCount,
      'last_message_seen_by': lastMessageSeenBy,
      'User_name': userName,
      'user_photos': userPhotos,
      'items_images': itemsImages,
      'product_name': productName,
      'Price': price,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChatsRecordDocumentEquality implements Equality<ChatsRecord> {
  const ChatsRecordDocumentEquality();

  @override
  bool equals(ChatsRecord? e1, ChatsRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.users, e2?.users) &&
        e1?.lastMessage == e2?.lastMessage &&
        e1?.lastMessageTime == e2?.lastMessageTime &&
        e1?.productRef == e2?.productRef &&
        e1?.buyerRef == e2?.buyerRef &&
        e1?.sellerRef == e2?.sellerRef &&
        e1?.unreadCount == e2?.unreadCount &&
        listEquality.equals(e1?.lastMessageSeenBy, e2?.lastMessageSeenBy) &&
        listEquality.equals(e1?.userName, e2?.userName) &&
        listEquality.equals(e1?.userPhotos, e2?.userPhotos) &&
        listEquality.equals(e1?.itemsImages, e2?.itemsImages) &&
        e1?.productName == e2?.productName &&
        e1?.price == e2?.price;
  }

  @override
  int hash(ChatsRecord? e) => const ListEquality().hash([
        e?.users,
        e?.lastMessage,
        e?.lastMessageTime,
        e?.productRef,
        e?.buyerRef,
        e?.sellerRef,
        e?.unreadCount,
        e?.lastMessageSeenBy,
        e?.userName,
        e?.userPhotos,
        e?.itemsImages,
        e?.productName,
        e?.price
      ]);

  @override
  bool isValidKey(Object? o) => o is ChatsRecord;
}
