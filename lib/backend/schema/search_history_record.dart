import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SearchHistoryRecord extends FirestoreRecord {
  SearchHistoryRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "search_term" field.
  String? _searchTerm;
  String get searchTerm => _searchTerm ?? '';
  bool hasSearchTerm() => _searchTerm != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  void _initializeFields() {
    _userRef = snapshotData['user_ref'] as DocumentReference?;
    _searchTerm = snapshotData['search_term'] as String?;
    _timestamp = snapshotData['timestamp'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('search_history');

  static Stream<SearchHistoryRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SearchHistoryRecord.fromSnapshot(s));

  static Future<SearchHistoryRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SearchHistoryRecord.fromSnapshot(s));

  static SearchHistoryRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SearchHistoryRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SearchHistoryRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SearchHistoryRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SearchHistoryRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SearchHistoryRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSearchHistoryRecordData({
  DocumentReference? userRef,
  String? searchTerm,
  DateTime? timestamp,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_ref': userRef,
      'search_term': searchTerm,
      'timestamp': timestamp,
    }.withoutNulls,
  );

  return firestoreData;
}

class SearchHistoryRecordDocumentEquality
    implements Equality<SearchHistoryRecord> {
  const SearchHistoryRecordDocumentEquality();

  @override
  bool equals(SearchHistoryRecord? e1, SearchHistoryRecord? e2) {
    return e1?.userRef == e2?.userRef &&
        e1?.searchTerm == e2?.searchTerm &&
        e1?.timestamp == e2?.timestamp;
  }

  @override
  int hash(SearchHistoryRecord? e) =>
      const ListEquality().hash([e?.userRef, e?.searchTerm, e?.timestamp]);

  @override
  bool isValidKey(Object? o) => o is SearchHistoryRecord;
}
