import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AddressRecord extends FirestoreRecord {
  AddressRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "street_address" field.
  String? _streetAddress;
  String get streetAddress => _streetAddress ?? '';
  bool hasStreetAddress() => _streetAddress != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  bool hasState() => _state != null;

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  bool hasCountry() => _country != null;

  // "zip_code" field.
  String? _zipCode;
  String get zipCode => _zipCode ?? '';
  bool hasZipCode() => _zipCode != null;

  // "full_nameString" field.
  String? _fullNameString;
  String get fullNameString => _fullNameString ?? '';
  bool hasFullNameString() => _fullNameString != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  bool hasPhone() => _phone != null;

  // "note" field.
  String? _note;
  String get note => _note ?? '';
  bool hasNote() => _note != null;

  // "is_default" field.
  bool? _isDefault;
  bool get isDefault => _isDefault ?? false;
  bool hasIsDefault() => _isDefault != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "label" field.
  String? _label;
  String get label => _label ?? '';
  bool hasLabel() => _label != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  bool hasCity() => _city != null;

  // "district" field.
  String? _district;
  String get district => _district ?? '';
  bool hasDistrict() => _district != null;

  // "landmark" field.
  String? _landmark;
  String get landmark => _landmark ?? '';
  bool hasLandmark() => _landmark != null;

  // "house_no" field.
  String? _houseNo;
  String get houseNo => _houseNo ?? '';
  bool hasHouseNo() => _houseNo != null;

  // "notes" field.
  String? _notes;
  String get notes => _notes ?? '';
  bool hasNotes() => _notes != null;

  void _initializeFields() {
    _user = snapshotData['user'] as DocumentReference?;
    _streetAddress = snapshotData['street_address'] as String?;
    _state = snapshotData['state'] as String?;
    _country = snapshotData['country'] as String?;
    _zipCode = snapshotData['zip_code'] as String?;
    _fullNameString = snapshotData['full_nameString'] as String?;
    _phone = snapshotData['phone'] as String?;
    _note = snapshotData['note'] as String?;
    _isDefault = snapshotData['is_default'] as bool?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _label = snapshotData['label'] as String?;
    _city = snapshotData['city'] as String?;
    _district = snapshotData['district'] as String?;
    _landmark = snapshotData['landmark'] as String?;
    _houseNo = snapshotData['house_no'] as String?;
    _notes = snapshotData['notes'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('address');

  static Stream<AddressRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AddressRecord.fromSnapshot(s));

  static Future<AddressRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AddressRecord.fromSnapshot(s));

  static AddressRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AddressRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AddressRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AddressRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AddressRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AddressRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAddressRecordData({
  DocumentReference? user,
  String? streetAddress,
  String? state,
  String? country,
  String? zipCode,
  String? fullNameString,
  String? phone,
  String? note,
  bool? isDefault,
  DateTime? createdTime,
  String? label,
  String? city,
  String? district,
  String? landmark,
  String? houseNo,
  String? notes,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user': user,
      'street_address': streetAddress,
      'state': state,
      'country': country,
      'zip_code': zipCode,
      'full_nameString': fullNameString,
      'phone': phone,
      'note': note,
      'is_default': isDefault,
      'created_time': createdTime,
      'label': label,
      'city': city,
      'district': district,
      'landmark': landmark,
      'house_no': houseNo,
      'notes': notes,
    }.withoutNulls,
  );

  return firestoreData;
}

class AddressRecordDocumentEquality implements Equality<AddressRecord> {
  const AddressRecordDocumentEquality();

  @override
  bool equals(AddressRecord? e1, AddressRecord? e2) {
    return e1?.user == e2?.user &&
        e1?.streetAddress == e2?.streetAddress &&
        e1?.state == e2?.state &&
        e1?.country == e2?.country &&
        e1?.zipCode == e2?.zipCode &&
        e1?.fullNameString == e2?.fullNameString &&
        e1?.phone == e2?.phone &&
        e1?.note == e2?.note &&
        e1?.isDefault == e2?.isDefault &&
        e1?.createdTime == e2?.createdTime &&
        e1?.label == e2?.label &&
        e1?.city == e2?.city &&
        e1?.district == e2?.district &&
        e1?.landmark == e2?.landmark &&
        e1?.houseNo == e2?.houseNo &&
        e1?.notes == e2?.notes;
  }

  @override
  int hash(AddressRecord? e) => const ListEquality().hash([
        e?.user,
        e?.streetAddress,
        e?.state,
        e?.country,
        e?.zipCode,
        e?.fullNameString,
        e?.phone,
        e?.note,
        e?.isDefault,
        e?.createdTime,
        e?.label,
        e?.city,
        e?.district,
        e?.landmark,
        e?.houseNo,
        e?.notes
      ]);

  @override
  bool isValidKey(Object? o) => o is AddressRecord;
}
