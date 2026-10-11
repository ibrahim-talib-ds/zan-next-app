// ZanNext — ChatsRecord Shim
//
// Full API compatibility with the original Firestore ChatsRecord.
// Backed by our Chat model (Postgres).

import 'dart:async';

import '/backend/schema/util/firestore_util.dart';

import '../../models/chat.dart';
import '../../repositories/chat_repository.dart';

class ChatsRecord {
  ChatsRecord._(this._chat, DocumentReference? explicitRef)
      : _explicitRef = explicitRef;

  final Chat? _chat;
  final DocumentReference? _explicitRef;

  String get id => _chat?.id ?? '';

  DocumentReference get reference =>
      _explicitRef ??
      FirebaseFirestore.instance.collection('Chats').doc(_chat?.id ?? 'unknown');

  DocumentReference get syntheticRef => reference;

  Chat? get chat => _chat;

  // ---- Field getters ----
  List<DocumentReference> get users {
    final c = _chat;
    if (c == null) return const <DocumentReference>[];
    final refs = <DocumentReference>[];
    if (c.buyerId.isNotEmpty) {
      refs.add(FirebaseFirestore.instance.collection('users').doc(c.buyerId));
    }
    if (c.sellerId.isNotEmpty) {
      refs.add(FirebaseFirestore.instance.collection('users').doc(c.sellerId));
    }
    return refs;
  }
  bool hasUsers() => _chat != null;

  String get lastMessage => _chat?.lastMessage ?? '';
  bool hasLastMessage() => (_chat?.lastMessage ?? '').isNotEmpty;

  DateTime? get lastMessageTime => _chat?.lastMessageTime;
  bool hasLastMessageTime() => _chat?.lastMessageTime != null;

  DocumentReference? get productRef => _chat?.productId != null
      ? FirebaseFirestore.instance.collection('Inventory').doc(_chat!.productId)
      : null;
  bool hasProductRef() => _chat?.productId != null;

  DocumentReference? get buyerRef => _chat?.buyerId != null
      ? FirebaseFirestore.instance.collection('users').doc(_chat!.buyerId)
      : null;
  bool hasBuyerRef() => _chat?.buyerId != null;

  DocumentReference? get sellerRef => _chat?.sellerId != null
      ? FirebaseFirestore.instance.collection('users').doc(_chat!.sellerId)
      : null;
  bool hasSellerRef() => _chat?.sellerId != null;

  int get unreadCount => 0;
  bool hasUnreadCount() => false;

  List<DocumentReference> get lastMessageSeenBy {
    final seen = _chat?.lastMessageSeenBy;
    if (seen == null) return const <DocumentReference>[];
    return seen
        .map((uid) => FirebaseFirestore.instance.collection('users').doc(uid))
        .toList();
  }
  bool hasLastMessageSeenBy() =>
      _chat?.lastMessageSeenBy != null && _chat!.lastMessageSeenBy!.isNotEmpty;

  String get productName => _chat?.productName ?? '';
  bool hasProductName() => (_chat?.productName ?? '').isNotEmpty;

  double get price => _chat?.price ?? 0;
  bool hasPrice() => _chat?.price != null;

  List<String> get itemImages => _chat?.itemImages ?? const <String>[];
  bool hasItemImages() =>
      (_chat?.itemImages != null && _chat!.itemImages!.isNotEmpty);

  // Alias: widget reads `itemsImages` (matching Firestore field `items_images`)
  List<String> get itemsImages => itemImages;
  bool hasItemsImages() => hasItemImages();

  // Alias: widget reads `userName` (array of display names)
  List<String> get userName {
    // Return placeholder names from the two user IDs
    final c = _chat;
    if (c == null) return const <String>[];
    return <String>[c.buyerId, c.sellerId];
  }
  bool hasUserName() => _chat != null;

  // ---- Raw snapshot data for compat ----
  Map<String, dynamic> get snapshotData {
    final c = _chat;
    if (c == null) return <String, dynamic>{};
    return <String, dynamic>{
      'buyer_ref': c.buyerId,
      'seller_ref': c.sellerId,
      'product_ref': c.productId,
      'product_name': c.productName,
      'price': c.price,
      'item_images': c.itemImages,
      'last_message': c.lastMessage,
      'last_message_time': c.lastMessageTime,
      'last_message_seen_by': c.lastMessageSeenBy,
    };
  }

  // ---- Static factory methods ----
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Chats');

  static Stream<ChatsRecord> getDocument(DocumentReference ref) =>
      Stream.fromFuture(getDocumentOnce(ref));

  static Future<ChatsRecord> getDocumentOnce(DocumentReference ref) async {
    try {
      final chat = await ChatRepository.get(ref.id);
      return ChatsRecord._(chat, ref);
    } catch (_) {
      return ChatsRecord._(null, ref);
    }
  }

  static ChatsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ChatsRecord._(null, snapshot.reference);

  static ChatsRecord fromChat(Chat chat) => ChatsRecord._(chat, null);

  @override
  String toString() => 'ChatsRecord(id: ${_chat?.id})';
}

// =====================================================================
// Compatibility: createChatsRecordData (FlutterFlow helper)
// Returns a Firestore-style map. Screens migrate to real API calls later.
// =====================================================================
Map<String, dynamic> createChatsRecordData({
  List<DocumentReference>? users,
  String? lastMessage,
  DateTime? lastMessageTime,
  DocumentReference? productRef,
  DocumentReference? buyerRef,
  DocumentReference? sellerRef,
  int? unreadCount,
  List<DocumentReference>? lastMessageSeenBy,
  String? productName,
  double? price,
  List<String>? itemImages,
  List<String>? itemsImages,
}) {
  return <String, dynamic>{
    'users': users,
    'last_message': lastMessage,
    'last_message_time': lastMessageTime,
    'product_ref': productRef,
    'buyer_ref': buyerRef,
    'seller_ref': sellerRef,
    'unread_count': unreadCount,
    'last_message_seen_by': lastMessageSeenBy,
    'product_name': productName,
    'price': price,
    'items_images': itemsImages ?? itemImages,
  };
}
