import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReviewsRecord extends FirestoreRecord {
  ReviewsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "reviews" field.
  String? _reviews;
  String get reviews => _reviews ?? '';
  bool hasReviews() => _reviews != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "seller" field.
  DocumentReference? _seller;
  DocumentReference? get seller => _seller;
  bool hasSeller() => _seller != null;

  // "reviewers_image" field.
  String? _reviewersImage;
  String get reviewersImage => _reviewersImage ?? '';
  bool hasReviewersImage() => _reviewersImage != null;

  // "reviewers_name" field.
  String? _reviewersName;
  String get reviewersName => _reviewersName ?? '';
  bool hasReviewersName() => _reviewersName != null;

  // "rating" field.
  int? _rating;
  int get rating => _rating ?? 0;
  bool hasRating() => _rating != null;

  // "Reviews_message" field.
  String? _reviewsMessage;
  String get reviewsMessage => _reviewsMessage ?? '';
  bool hasReviewsMessage() => _reviewsMessage != null;

  // "product_ref" field.
  DocumentReference? _productRef;
  DocumentReference? get productRef => _productRef;
  bool hasProductRef() => _productRef != null;

  // "quick_tags" field.
  List<String>? _quickTags;
  List<String> get quickTags => _quickTags ?? const [];
  bool hasQuickTags() => _quickTags != null;

  void _initializeFields() {
    _reviews = snapshotData['reviews'] as String?;
    _date = snapshotData['date'] as DateTime?;
    _seller = snapshotData['seller'] as DocumentReference?;
    _reviewersImage = snapshotData['reviewers_image'] as String?;
    _reviewersName = snapshotData['reviewers_name'] as String?;
    _rating = castToType<int>(snapshotData['rating']);
    _reviewsMessage = snapshotData['Reviews_message'] as String?;
    _productRef = snapshotData['product_ref'] as DocumentReference?;
    _quickTags = getDataList(snapshotData['quick_tags']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('reviews');

  static Stream<ReviewsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ReviewsRecord.fromSnapshot(s));

  static Future<ReviewsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ReviewsRecord.fromSnapshot(s));

  static ReviewsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ReviewsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ReviewsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ReviewsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ReviewsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ReviewsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createReviewsRecordData({
  String? reviews,
  DateTime? date,
  DocumentReference? seller,
  String? reviewersImage,
  String? reviewersName,
  int? rating,
  String? reviewsMessage,
  DocumentReference? productRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'reviews': reviews,
      'date': date,
      'seller': seller,
      'reviewers_image': reviewersImage,
      'reviewers_name': reviewersName,
      'rating': rating,
      'Reviews_message': reviewsMessage,
      'product_ref': productRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class ReviewsRecordDocumentEquality implements Equality<ReviewsRecord> {
  const ReviewsRecordDocumentEquality();

  @override
  bool equals(ReviewsRecord? e1, ReviewsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.reviews == e2?.reviews &&
        e1?.date == e2?.date &&
        e1?.seller == e2?.seller &&
        e1?.reviewersImage == e2?.reviewersImage &&
        e1?.reviewersName == e2?.reviewersName &&
        e1?.rating == e2?.rating &&
        e1?.reviewsMessage == e2?.reviewsMessage &&
        e1?.productRef == e2?.productRef &&
        listEquality.equals(e1?.quickTags, e2?.quickTags);
  }

  @override
  int hash(ReviewsRecord? e) => const ListEquality().hash([
        e?.reviews,
        e?.date,
        e?.seller,
        e?.reviewersImage,
        e?.reviewersName,
        e?.rating,
        e?.reviewsMessage,
        e?.productRef,
        e?.quickTags
      ]);

  @override
  bool isValidKey(Object? o) => o is ReviewsRecord;
}
