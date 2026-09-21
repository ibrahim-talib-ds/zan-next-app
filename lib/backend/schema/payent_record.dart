import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PayentRecord extends FirestoreRecord {
  PayentRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "cardholder_name" field.
  String? _cardholderName;
  String get cardholderName => _cardholderName ?? '';
  bool hasCardholderName() => _cardholderName != null;

  // "ccv" field.
  String? _ccv;
  String get ccv => _ccv ?? '';
  bool hasCcv() => _ccv != null;

  // "exp" field.
  DateTime? _exp;
  DateTime? get exp => _exp;
  bool hasExp() => _exp != null;

  // "cardholder_number" field.
  String? _cardholderNumber;
  String get cardholderNumber => _cardholderNumber ?? '';
  bool hasCardholderNumber() => _cardholderNumber != null;

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "owner_name" field.
  String? _ownerName;
  String get ownerName => _ownerName ?? '';
  bool hasOwnerName() => _ownerName != null;

  // "simcard_name" field.
  String? _simcardName;
  String get simcardName => _simcardName ?? '';
  bool hasSimcardName() => _simcardName != null;

  void _initializeFields() {
    _cardholderName = snapshotData['cardholder_name'] as String?;
    _ccv = snapshotData['ccv'] as String?;
    _exp = snapshotData['exp'] as DateTime?;
    _cardholderNumber = snapshotData['cardholder_number'] as String?;
    _user = snapshotData['user'] as DocumentReference?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _ownerName = snapshotData['owner_name'] as String?;
    _simcardName = snapshotData['simcard_name'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('payent');

  static Stream<PayentRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PayentRecord.fromSnapshot(s));

  static Future<PayentRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PayentRecord.fromSnapshot(s));

  static PayentRecord fromSnapshot(DocumentSnapshot snapshot) => PayentRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PayentRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PayentRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PayentRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PayentRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPayentRecordData({
  String? cardholderName,
  String? ccv,
  DateTime? exp,
  String? cardholderNumber,
  DocumentReference? user,
  String? phoneNumber,
  String? ownerName,
  String? simcardName,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'cardholder_name': cardholderName,
      'ccv': ccv,
      'exp': exp,
      'cardholder_number': cardholderNumber,
      'user': user,
      'phone_number': phoneNumber,
      'owner_name': ownerName,
      'simcard_name': simcardName,
    }.withoutNulls,
  );

  return firestoreData;
}

class PayentRecordDocumentEquality implements Equality<PayentRecord> {
  const PayentRecordDocumentEquality();

  @override
  bool equals(PayentRecord? e1, PayentRecord? e2) {
    return e1?.cardholderName == e2?.cardholderName &&
        e1?.ccv == e2?.ccv &&
        e1?.exp == e2?.exp &&
        e1?.cardholderNumber == e2?.cardholderNumber &&
        e1?.user == e2?.user &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.ownerName == e2?.ownerName &&
        e1?.simcardName == e2?.simcardName;
  }

  @override
  int hash(PayentRecord? e) => const ListEquality().hash([
        e?.cardholderName,
        e?.ccv,
        e?.exp,
        e?.cardholderNumber,
        e?.user,
        e?.phoneNumber,
        e?.ownerName,
        e?.simcardName
      ]);

  @override
  bool isValidKey(Object? o) => o is PayentRecord;
}
