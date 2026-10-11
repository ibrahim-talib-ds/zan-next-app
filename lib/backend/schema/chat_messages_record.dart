// ZanNext — ChatMessagesRecord Shim
//
// Full API compatibility with the original Firestore ChatMessagesRecord.
// Backed by our ChatMessage model (Postgres).

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, Query, DocumentSnapshot, FirebaseFirestore;

import '../../models/chat_message.dart';
import '../../repositories/chat_repository.dart';

class ChatMessagesRecord {
  ChatMessagesRecord._(this._msg, DocumentReference? explicitRef)
      : _explicitRef = explicitRef;

  final ChatMessage? _msg;
  final DocumentReference? _explicitRef;

  String get id => _msg?.id ?? '';

  DocumentReference get reference =>
      _explicitRef ??
      FirebaseFirestore.instance.collection('Chats').doc(_msg?.chatId ?? 'unknown')
          .collection('chat_messages').doc(_msg?.id ?? 'unknown');

  DocumentReference get syntheticRef => reference;

  ChatMessage? get msg => _msg;

  DocumentReference? get user => _msg?.senderId != null
      ? FirebaseFirestore.instance.collection('users').doc(_msg!.senderId)
      : null;
  bool hasUser() => _msg?.senderId != null && _msg!.senderId.isNotEmpty;

  String get text => _msg?.text ?? '';
  bool hasText() => (_msg?.text ?? '').isNotEmpty;

  DateTime? get timestamp => _msg?.createdAt;
  bool hasTimestamp() => _msg?.createdAt != null;

  DocumentReference? get chat => _msg?.chatId != null
      ? FirebaseFirestore.instance.collection('Chats').doc(_msg!.chatId)
      : null;
  bool hasChat() => _msg?.chatId != null;

  String get nameSender => _msg?.senderName ?? '';
  bool hasNameSender() => (_msg?.senderName ?? '').isNotEmpty;

  DocumentReference get parentReference => reference.parent.parent!;

  // ---- Raw snapshot data for compat ----
  Map<String, dynamic> get snapshotData {
    final m = _msg;
    if (m == null) return <String, dynamic>{};
    return <String, dynamic>{
      'user': m.senderId,
      'text': m.text,
      'timestamp': m.createdAt,
      'chat': m.chatId,
      'name_sender': m.senderName,
    };
  }

  // ---- Static factory methods ----
  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) {
    final fs = FirebaseFirestore.instance;
    return parent != null
        ? parent.collection('chat_messages')
        : fs.collectionGroup('chat_messages');
  }

  static DocumentReference createDoc(DocumentReference parent, {String? id}) {
    return parent.collection('chat_messages').doc(id);
  }

  static Stream<ChatMessagesRecord> getDocument(DocumentReference ref) =>
      const Stream<ChatMessagesRecord>.empty();

  static ChatMessagesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ChatMessagesRecord._(null, snapshot.reference);

  static ChatMessagesRecord fromMessage(ChatMessage msg) =>
      ChatMessagesRecord._(msg, null);

  @override
  String toString() => 'ChatMessagesRecord(id: ${_msg?.id})';
}

// =====================================================================
// Compatibility: createChatMessagesRecordData
// =====================================================================
Map<String, dynamic> createChatMessagesRecordData({
  DocumentReference? user,
  String? text,
  DateTime? timestamp,
  DocumentReference? chat,
  String? nameSender,
}) {
  return <String, dynamic>{
    'user': user,
    'text': text,
    'timestamp': timestamp,
    'chat': chat,
    'name_sender': nameSender,
  };
}
