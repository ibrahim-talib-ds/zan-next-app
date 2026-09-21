import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LastSeenRecord extends FirestoreRecord {
  LastSeenRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "product_ref" field.
  DocumentReference? _productRef;
  DocumentReference? get productRef => _productRef;
  bool hasProductRef() => _productRef != null;

  // "viewed_at" field.
  DateTime? _viewedAt;
  DateTime? get viewedAt => _viewedAt;
  bool hasViewedAt() => _viewedAt != null;

  void _initializeFields() {
    _userRef = snapshotData['user_ref'] as DocumentReference?;
    _productRef = snapshotData['product_ref'] as DocumentReference?;
    _viewedAt = snapshotData['viewed_at'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('last_seen');

  static Stream<LastSeenRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => LastSeenRecord.fromSnapshot(s));

  static Future<LastSeenRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => LastSeenRecord.fromSnapshot(s));

  static LastSeenRecord fromSnapshot(DocumentSnapshot snapshot) =>
      LastSeenRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static LastSeenRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      LastSeenRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'LastSeenRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is LastSeenRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createLastSeenRecordData({
  DocumentReference? userRef,
  DocumentReference? productRef,
  DateTime? viewedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_ref': userRef,
      'product_ref': productRef,
      'viewed_at': viewedAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class LastSeenRecordDocumentEquality implements Equality<LastSeenRecord> {
  const LastSeenRecordDocumentEquality();

  @override
  bool equals(LastSeenRecord? e1, LastSeenRecord? e2) {
    return e1?.userRef == e2?.userRef &&
        e1?.productRef == e2?.productRef &&
        e1?.viewedAt == e2?.viewedAt;
  }

  @override
  int hash(LastSeenRecord? e) =>
      const ListEquality().hash([e?.userRef, e?.productRef, e?.viewedAt]);

  @override
  bool isValidKey(Object? o) => o is LastSeenRecord;
}
