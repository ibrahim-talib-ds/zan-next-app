// ZanNext — firestore_util shim, Firebase-free.
//
// Public API compatible with the app. All methods are no-ops / empty results.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';

import '/backend/schema/util/schema_util.dart';
import '/flutter_flow/flutter_flow_util.dart';

typedef RecordBuilder<T> = T Function(DocumentSnapshot snapshot);

class DocumentReference {
  const DocumentReference(this.path);
  final String path;

  String get id => path.isEmpty ? '' : path.split('/').last;

  DocumentReference get parent {
    final parts = path.split('/');
    if (parts.length <= 1) return const DocumentReference('');
    return DocumentReference(parts.sublist(0, parts.length - 1).join('/'));
  }

  CollectionReference collection(String name) =>
      CollectionReference(path.isEmpty ? name : '$path/$name');

  DocumentReference doc([String? id]) => DocumentReference(
      id == null ? path : (path.isEmpty ? id : '$path/$id'));

  Future<DocumentSnapshot> get() async =>
      DocumentSnapshot(reference: this);

  Stream<DocumentSnapshot> snapshots() =>
      Stream.value(DocumentSnapshot(reference: this));

  Future<void> set(Map<String, dynamic> data, {bool merge = false}) async {}
  Future<void> update(Map<String, dynamic> data) async {}
  Future<void> delete() async {}

  @override
  bool operator ==(Object other) =>
      other is DocumentReference && other.path == path;

  @override
  int get hashCode => path.hashCode;

  @override
  String toString() => 'DocumentReference($path)';
}

class Query<T> {
  const Query();

  Query<T> where(String field, {dynamic isEqualTo, dynamic isNotEqualTo,
      dynamic isLessThan, dynamic isLessThanOrEqualTo,
      dynamic isGreaterThan, dynamic isGreaterThanOrEqualTo,
      dynamic arrayContains, dynamic arrayContainsAny,
      dynamic whereIn, dynamic whereNotIn, dynamic isNull}) => this;

  Query<T> limit(int n) => this;
  Query<T> orderBy(String field, {bool descending = false}) => this;
  Query<T> startAfterDocument(Object? doc) => this;
  Future<int> count() async => 0;
}

class CollectionReference extends Query<Map<String, dynamic>> {
  const CollectionReference(this.path) : super();
  final String path;

  String get id => path.isEmpty ? '' : path.split('/').last;
  DocumentReference get parent => DocumentReference(path);

  DocumentReference doc([String? id]) => DocumentReference(
      id == null ? path : (path.isEmpty ? id : '$path/$id'));

  Future<DocumentSnapshot> get() async =>
      DocumentSnapshot(reference: DocumentReference(path));

  Stream<DocumentSnapshot> snapshots() =>
      Stream.value(DocumentSnapshot(reference: DocumentReference(path)));
}

class DocumentSnapshot {
  const DocumentSnapshot({
    this.reference = const DocumentReference(''),
    this.dataValue,
  });

  final DocumentReference reference;
  final Map<String, dynamic>? dataValue;

  bool get exists => dataValue != null;

  Map<String, dynamic>? data() => dataValue;

  @override
  String toString() => 'DocumentSnapshot(${reference.path})';
}

class QueryDocumentSnapshot extends DocumentSnapshot {
  const QueryDocumentSnapshot({super.reference, super.dataValue});
}

class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
}

class FirebaseFirestore {
  FirebaseFirestore._();
  static final FirebaseFirestore instance = FirebaseFirestore._();

  CollectionReference collection(String name) => CollectionReference(name);
  CollectionReference collectionGroup(String name) => CollectionReference(name);
  DocumentReference doc(String path) => DocumentReference(path);
}

abstract class FirestoreRecord {
  FirestoreRecord(this.reference, this.snapshotData);
  Map<String, dynamic> snapshotData;
  DocumentReference reference;
}

abstract class FFFirebaseStruct extends BaseStruct {
  FFFirebaseStruct(this.firestoreUtilData);
  FirestoreUtilData firestoreUtilData = FirestoreUtilData();
}

class FirestoreUtilData {
  const FirestoreUtilData({
    this.fieldValues = const {},
    this.clearUnsetFields = true,
    this.create = false,
    this.delete = false,
  });
  final Map<String, dynamic> fieldValues;
  final bool clearUnsetFields;
  final bool create;
  final bool delete;
  static String get name => 'firestoreUtilData';
}

Map<String, dynamic> mapFromFirestore(Map<String, dynamic> data) =>
    mergeNestedFields(data)
        .where((k, _) => k != FirestoreUtilData.name)
        .map((key, value) {
      if (value is Map) {
        value = mapFromFirestore(value as Map<String, dynamic>);
      }
      if (value is Iterable && value.isNotEmpty && value.first is Map) {
        value = value
            .map((v) => mapFromFirestore(v as Map<String, dynamic>))
            .toList();
      }
      return MapEntry(key, value);
    });

Map<String, dynamic> mapToFirestore(Map<String, dynamic> data) =>
    data.where((k, v) => k != FirestoreUtilData.name).map((key, value) {
      if (value is LatLng) {
        value = value.toGeoPoint();
      }
      if (value is Iterable && value.isNotEmpty && value.first is LatLng) {
        value = value.map((v) => (v as LatLng).toGeoPoint()).toList();
      }
      if (value is Color) {
        value = value.toCssString();
      }
      if (value is Iterable && value.isNotEmpty && value.first is Color) {
        value = value.map((v) => (v as Color).toCssString()).toList();
      }
      if (value is Map) {
        value = mapToFirestore(value as Map<String, dynamic>);
      }
      if (value is Iterable && value.isNotEmpty && value.first is Map) {
        value = value
            .map((v) => mapToFirestore(v as Map<String, dynamic>))
            .toList();
      }
      return MapEntry(key, value);
    });

List<GeoPoint>? convertToGeoPointList(List<LatLng>? list) =>
    list?.map((e) => e.toGeoPoint()).toList();

extension GeoPointExtension on LatLng {
  GeoPoint toGeoPoint() => GeoPoint(latitude, longitude);
}

extension LatLngExtension on GeoPoint {
  LatLng toLatLng() => LatLng(latitude, longitude);
}

T? safeGet<T>(T Function() func, [Function(dynamic)? reportError]) {
  try {
    return func();
  } catch (e) {
    reportError?.call(e);
  }
  return null;
}

Map<String, dynamic> mergeNestedFields(Map<String, dynamic> data) {
  final nestedData = data.where((k, _) => k.contains('.'));
  final fieldNames = nestedData.keys.map((k) => k.split('.').first).toSet();
  data.removeWhere((k, _) => k.contains('.'));
  fieldNames.forEach((name) {
    final mergedValues = mergeNestedFields(
      nestedData
          .where((k, _) => k.split('.').first == name)
          .map((k, v) => MapEntry(k.split('.').skip(1).join('.'), v)),
    );
    final existingValue = data[name];
    data[name] = {
      if (existingValue != null && existingValue is Map)
        ...existingValue as Map<String, dynamic>,
      ...mergedValues,
    };
  });
  data.where((_, v) => v is Map).forEach((k, v) {
    data[k] = mergeNestedFields(v as Map<String, dynamic>);
  });
  return data;
}

extension _WhereMapExtension<K, V> on Map<K, V> {
  Map<K, V> where(bool Function(K, V) test) =>
      Map.fromEntries(entries.where((e) => test(e.key, e.value)));
}
