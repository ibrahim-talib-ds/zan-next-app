import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class InventoryRecord extends FirestoreRecord {
  InventoryRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "inventory_name" field.
  String? _inventoryName;
  String get inventoryName => _inventoryName ?? '';
  bool hasInventoryName() => _inventoryName != null;

  // "inventory_description" field.
  String? _inventoryDescription;
  String get inventoryDescription => _inventoryDescription ?? '';
  bool hasInventoryDescription() => _inventoryDescription != null;

  // "inventory_price" field.
  double? _inventoryPrice;
  double get inventoryPrice => _inventoryPrice ?? 0.0;
  bool hasInventoryPrice() => _inventoryPrice != null;

  // "top_selling" field.
  bool? _topSelling;
  bool get topSelling => _topSelling ?? false;
  bool hasTopSelling() => _topSelling != null;

  // "new_in" field.
  bool? _newIn;
  bool get newIn => _newIn ?? false;
  bool hasNewIn() => _newIn != null;

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  bool hasRating() => _rating != null;

  // "sellers_ref" field.
  DocumentReference? _sellersRef;
  DocumentReference? get sellersRef => _sellersRef;
  bool hasSellersRef() => _sellersRef != null;

  // "reviews" field.
  int? _reviews;
  int get reviews => _reviews ?? 0;
  bool hasReviews() => _reviews != null;

  // "inventory_size" field.
  String? _inventorySize;
  String get inventorySize => _inventorySize ?? '';
  bool hasInventorySize() => _inventorySize != null;

  // "categories" field.
  String? _categories;
  String get categories => _categories ?? '';
  bool hasCategories() => _categories != null;

  // "all_products" field.
  bool? _allProducts;
  bool get allProducts => _allProducts ?? false;
  bool hasAllProducts() => _allProducts != null;

  // "gender" field.
  String? _gender;
  String get gender => _gender ?? '';
  bool hasGender() => _gender != null;

  // "searchTem" field.
  String? _searchTem;
  String get searchTem => _searchTem ?? '';
  bool hasSearchTem() => _searchTem != null;

  // "deal" field.
  bool? _deal;
  bool get deal => _deal ?? false;
  bool hasDeal() => _deal != null;

  // "inventory_images" field.
  List<String>? _inventoryImages;
  List<String> get inventoryImages => _inventoryImages ?? const [];
  bool hasInventoryImages() => _inventoryImages != null;

  // "location" field.
  String? _location;
  String get location => _location ?? '';
  bool hasLocation() => _location != null;

  // "product_liked_by" field.
  List<DocumentReference>? _productLikedBy;
  List<DocumentReference> get productLikedBy => _productLikedBy ?? const [];
  bool hasProductLikedBy() => _productLikedBy != null;

  // "dicount_percent" field.
  String? _dicountPercent;
  String get dicountPercent => _dicountPercent ?? '';
  bool hasDicountPercent() => _dicountPercent != null;

  // "is_discount" field.
  bool? _isDiscount;
  bool get isDiscount => _isDiscount ?? false;
  bool hasIsDiscount() => _isDiscount != null;

  // "hali_bidha" field.
  String? _haliBidha;
  String get haliBidha => _haliBidha ?? '';
  bool hasHaliBidha() => _haliBidha != null;

  // "imefunguliwa" field.
  String? _imefunguliwa;
  String get imefunguliwa => _imefunguliwa ?? '';
  bool hasImefunguliwa() => _imefunguliwa != null;

  // "Rangi" field.
  String? _rangi;
  String get rangi => _rangi ?? '';
  bool hasRangi() => _rangi != null;

  // "Muda_wakurudisha" field.
  String? _mudaWakurudisha;
  String get mudaWakurudisha => _mudaWakurudisha ?? '';
  bool hasMudaWakurudisha() => _mudaWakurudisha != null;

  // "harama_usafishaji" field.
  String? _haramaUsafishaji;
  String get haramaUsafishaji => _haramaUsafishaji ?? '';
  bool hasHaramaUsafishaji() => _haramaUsafishaji != null;

  // "muda_wakufika" field.
  String? _mudaWakufika;
  String get mudaWakufika => _mudaWakufika ?? '';
  bool hasMudaWakufika() => _mudaWakufika != null;

  // "njiya_usafirshaji" field.
  String? _njiyaUsafirshaji;
  String get njiyaUsafirshaji => _njiyaUsafirshaji ?? '';
  bool hasNjiyaUsafirshaji() => _njiyaUsafirshaji != null;

  // "seller_number" field.
  String? _sellerNumber;
  String get sellerNumber => _sellerNumber ?? '';
  bool hasSellerNumber() => _sellerNumber != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "ina_kasoro" field.
  bool? _inaKasoro;
  bool get inaKasoro => _inaKasoro ?? false;
  bool hasInaKasoro() => _inaKasoro != null;

  // "risiti" field.
  bool? _risiti;
  bool get risiti => _risiti ?? false;
  bool hasRisiti() => _risiti != null;

  // "upatikanaji" field.
  bool? _upatikanaji;
  bool get upatikanaji => _upatikanaji ?? false;
  bool hasUpatikanaji() => _upatikanaji != null;

  // "seller_whatsap" field.
  String? _sellerWhatsap;
  String get sellerWhatsap => _sellerWhatsap ?? '';
  bool hasSellerWhatsap() => _sellerWhatsap != null;

  // "Shipping_cost" field.
  double? _shippingCost;
  double get shippingCost => _shippingCost ?? 0.0;
  bool hasShippingCost() => _shippingCost != null;

  // "search_keywords" field.
  List<String>? _searchKeywords;
  List<String> get searchKeywords => _searchKeywords ?? const [];
  bool hasSearchKeywords() => _searchKeywords != null;

  // "view_count" field.
  int? _viewCount;
  int get viewCount => _viewCount ?? 0;
  bool hasViewCount() => _viewCount != null;

  // "is_active" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  bool hasIsActive() => _isActive != null;

  // "Is_highlighted" field.
  bool? _isHighlighted;
  bool get isHighlighted => _isHighlighted ?? false;
  bool hasIsHighlighted() => _isHighlighted != null;

  // "is_new" field.
  String? _isNew;
  String get isNew => _isNew ?? '';
  bool hasIsNew() => _isNew != null;

  // "buyer_ref" field.
  DocumentReference? _buyerRef;
  DocumentReference? get buyerRef => _buyerRef;
  bool hasBuyerRef() => _buyerRef != null;

  // "seller_name" field.
  String? _sellerName;
  String get sellerName => _sellerName ?? '';
  bool hasSellerName() => _sellerName != null;

  // "subcategory" field.
  String? _subcategory;
  String get subcategory => _subcategory ?? '';
  bool hasSubcategory() => _subcategory != null;

  // "numericsize" field.
  String? _numericsize;
  String get numericsize => _numericsize ?? '';
  bool hasNumericsize() => _numericsize != null;

  // "fit" field.
  String? _fit;
  String get fit => _fit ?? '';
  bool hasFit() => _fit != null;

  // "pattern" field.
  String? _pattern;
  String get pattern => _pattern ?? '';
  bool hasPattern() => _pattern != null;

  // "available_colors" field.
  List<String>? _availableColors;
  List<String> get availableColors => _availableColors ?? const [];
  bool hasAvailableColors() => _availableColors != null;

  // "available_alphasize" field.
  List<String>? _availableAlphasize;
  List<String> get availableAlphasize => _availableAlphasize ?? const [];
  bool hasAvailableAlphasize() => _availableAlphasize != null;

  // "available_numericsize" field.
  List<String>? _availableNumericsize;
  List<String> get availableNumericsize => _availableNumericsize ?? const [];
  bool hasAvailableNumericsize() => _availableNumericsize != null;

  // "references" field.
  DocumentReference? _references;
  DocumentReference? get references => _references;
  bool hasReferences() => _references != null;

  // "driver_name" field.
  String? _driverName;
  String get driverName => _driverName ?? '';
  bool hasDriverName() => _driverName != null;

  // "driver_number" field.
  String? _driverNumber;
  String get driverNumber => _driverNumber ?? '';
  bool hasDriverNumber() => _driverNumber != null;

  // "shipping_days" field.
  String? _shippingDays;
  String get shippingDays => _shippingDays ?? '';
  bool hasShippingDays() => _shippingDays != null;

  // "features" field.
  List<String>? _features;
  List<String> get features => _features ?? const [];
  bool hasFeatures() => _features != null;

  // "materials" field.
  List<String>? _materials;
  List<String> get materials => _materials ?? const [];
  bool hasMaterials() => _materials != null;

  // "condition" field.
  String? _condition;
  String get condition => _condition ?? '';
  bool hasCondition() => _condition != null;

  void _initializeFields() {
    _inventoryName = snapshotData['inventory_name'] as String?;
    _inventoryDescription = snapshotData['inventory_description'] as String?;
    _inventoryPrice = castToType<double>(snapshotData['inventory_price']);
    _topSelling = snapshotData['top_selling'] as bool?;
    _newIn = snapshotData['new_in'] as bool?;
    _rating = castToType<double>(snapshotData['rating']);
    _sellersRef = snapshotData['sellers_ref'] as DocumentReference?;
    _reviews = castToType<int>(snapshotData['reviews']);
    _inventorySize = snapshotData['inventory_size'] as String?;
    _categories = snapshotData['categories'] as String?;
    _allProducts = snapshotData['all_products'] as bool?;
    _gender = snapshotData['gender'] as String?;
    _searchTem = snapshotData['searchTem'] as String?;
    _deal = snapshotData['deal'] as bool?;
    _inventoryImages = getDataList(snapshotData['inventory_images']);
    _location = snapshotData['location'] as String?;
    _productLikedBy = getDataList(snapshotData['product_liked_by']);
    _dicountPercent = snapshotData['dicount_percent'] as String?;
    _isDiscount = snapshotData['is_discount'] as bool?;
    _haliBidha = snapshotData['hali_bidha'] as String?;
    _imefunguliwa = snapshotData['imefunguliwa'] as String?;
    _rangi = snapshotData['Rangi'] as String?;
    _mudaWakurudisha = snapshotData['Muda_wakurudisha'] as String?;
    _haramaUsafishaji = snapshotData['harama_usafishaji'] as String?;
    _mudaWakufika = snapshotData['muda_wakufika'] as String?;
    _njiyaUsafirshaji = snapshotData['njiya_usafirshaji'] as String?;
    _sellerNumber = snapshotData['seller_number'] as String?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _inaKasoro = snapshotData['ina_kasoro'] as bool?;
    _risiti = snapshotData['risiti'] as bool?;
    _upatikanaji = snapshotData['upatikanaji'] as bool?;
    _sellerWhatsap = snapshotData['seller_whatsap'] as String?;
    _shippingCost = castToType<double>(snapshotData['Shipping_cost']);
    _searchKeywords = getDataList(snapshotData['search_keywords']);
    _viewCount = castToType<int>(snapshotData['view_count']);
    _isActive = snapshotData['is_active'] as bool?;
    _isHighlighted = snapshotData['Is_highlighted'] as bool?;
    _isNew = snapshotData['is_new'] as String?;
    _buyerRef = snapshotData['buyer_ref'] as DocumentReference?;
    _sellerName = snapshotData['seller_name'] as String?;
    _subcategory = snapshotData['subcategory'] as String?;
    _numericsize = snapshotData['numericsize'] as String?;
    _fit = snapshotData['fit'] as String?;
    _pattern = snapshotData['pattern'] as String?;
    _availableColors = getDataList(snapshotData['available_colors']);
    _availableAlphasize = getDataList(snapshotData['available_alphasize']);
    _availableNumericsize = getDataList(snapshotData['available_numericsize']);
    _references = snapshotData['references'] as DocumentReference?;
    _driverName = snapshotData['driver_name'] as String?;
    _driverNumber = snapshotData['driver_number'] as String?;
    _shippingDays = snapshotData['shipping_days'] as String? ?? snapshotData['shippingDays'] as String?;
    _features = getDataList(snapshotData['features']);
    _materials = getDataList(snapshotData['materials']);
    _condition = snapshotData['condition'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Inventory');

  static Stream<InventoryRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => InventoryRecord.fromSnapshot(s));

  static Future<InventoryRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => InventoryRecord.fromSnapshot(s));

  static InventoryRecord fromSnapshot(DocumentSnapshot snapshot) =>
      InventoryRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static InventoryRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      InventoryRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'InventoryRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is InventoryRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createInventoryRecordData({
  String? inventoryName,
  String? inventoryDescription,
  double? inventoryPrice,
  bool? topSelling,
  bool? newIn,
  double? rating,
  DocumentReference? sellersRef,
  int? reviews,
  String? inventorySize,
  String? categories,
  bool? allProducts,
  String? gender,
  String? searchTem,
  bool? deal,
  String? location,
  String? dicountPercent,
  bool? isDiscount,
  String? haliBidha,
  String? imefunguliwa,
  String? rangi,
  String? mudaWakurudisha,
  String? haramaUsafishaji,
  String? mudaWakufika,
  String? njiyaUsafirshaji,
  String? sellerNumber,
  DateTime? createdAt,
  bool? inaKasoro,
  bool? risiti,
  bool? upatikanaji,
  String? sellerWhatsap,
  double? shippingCost,
  int? viewCount,
  bool? isActive,
  bool? isHighlighted,
  String? isNew,
  DocumentReference? buyerRef,
  String? sellerName,
  String? subcategory,
  String? numericsize,
  String? fit,
  String? pattern,
  DocumentReference? references,
  String? driverName,
  String? driverNumber,
  String? shippingDays,
  List<String>? features,
  List<String>? materials,
  String? condition,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'inventory_name': inventoryName,
      'inventory_description': inventoryDescription,
      'inventory_price': inventoryPrice,
      'top_selling': topSelling,
      'new_in': newIn,
      'rating': rating,
      'sellers_ref': sellersRef,
      'reviews': reviews,
      'inventory_size': inventorySize,
      'categories': categories,
      'all_products': allProducts,
      'gender': gender,
      'searchTem': searchTem,
      'deal': deal,
      'location': location,
      'dicount_percent': dicountPercent,
      'is_discount': isDiscount,
      'hali_bidha': haliBidha,
      'imefunguliwa': imefunguliwa,
      'Rangi': rangi,
      'Muda_wakurudisha': mudaWakurudisha,
      'harama_usafishaji': haramaUsafishaji,
      'muda_wakufika': mudaWakufika,
      'njiya_usafirshaji': njiyaUsafirshaji,
      'seller_number': sellerNumber,
      'created_at': createdAt,
      'ina_kasoro': inaKasoro,
      'risiti': risiti,
      'upatikanaji': upatikanaji,
      'seller_whatsap': sellerWhatsap,
      'Shipping_cost': shippingCost,
      'view_count': viewCount,
      'is_active': isActive,
      'Is_highlighted': isHighlighted,
      'is_new': isNew,
      'buyer_ref': buyerRef,
      'seller_name': sellerName,
      'subcategory': subcategory,
      'numericsize': numericsize,
      'fit': fit,
      'pattern': pattern,
      'references': references,
      'driver_name': driverName,
      'driver_number': driverNumber,
      'shipping_days': shippingDays,
      'features': features,
      'materials': materials,
      'condition': condition,
    }.withoutNulls,
  );

  return firestoreData;
}

class InventoryRecordDocumentEquality implements Equality<InventoryRecord> {
  const InventoryRecordDocumentEquality();

  @override
  bool equals(InventoryRecord? e1, InventoryRecord? e2) {
    const listEquality = ListEquality();
    return e1?.inventoryName == e2?.inventoryName &&
        e1?.inventoryDescription == e2?.inventoryDescription &&
        e1?.inventoryPrice == e2?.inventoryPrice &&
        e1?.topSelling == e2?.topSelling &&
        e1?.newIn == e2?.newIn &&
        e1?.rating == e2?.rating &&
        e1?.sellersRef == e2?.sellersRef &&
        e1?.reviews == e2?.reviews &&
        e1?.inventorySize == e2?.inventorySize &&
        e1?.categories == e2?.categories &&
        e1?.allProducts == e2?.allProducts &&
        e1?.gender == e2?.gender &&
        e1?.searchTem == e2?.searchTem &&
        e1?.deal == e2?.deal &&
        listEquality.equals(e1?.inventoryImages, e2?.inventoryImages) &&
        e1?.location == e2?.location &&
        listEquality.equals(e1?.productLikedBy, e2?.productLikedBy) &&
        e1?.dicountPercent == e2?.dicountPercent &&
        e1?.isDiscount == e2?.isDiscount &&
        e1?.haliBidha == e2?.haliBidha &&
        e1?.imefunguliwa == e2?.imefunguliwa &&
        e1?.rangi == e2?.rangi &&
        e1?.mudaWakurudisha == e2?.mudaWakurudisha &&
        e1?.haramaUsafishaji == e2?.haramaUsafishaji &&
        e1?.mudaWakufika == e2?.mudaWakufika &&
        e1?.njiyaUsafirshaji == e2?.njiyaUsafirshaji &&
        e1?.sellerNumber == e2?.sellerNumber &&
        e1?.createdAt == e2?.createdAt &&
        e1?.inaKasoro == e2?.inaKasoro &&
        e1?.risiti == e2?.risiti &&
        e1?.upatikanaji == e2?.upatikanaji &&
        e1?.sellerWhatsap == e2?.sellerWhatsap &&
        e1?.shippingCost == e2?.shippingCost &&
        listEquality.equals(e1?.searchKeywords, e2?.searchKeywords) &&
        e1?.viewCount == e2?.viewCount &&
        e1?.isActive == e2?.isActive &&
        e1?.isHighlighted == e2?.isHighlighted &&
        e1?.isNew == e2?.isNew &&
        e1?.buyerRef == e2?.buyerRef &&
        e1?.sellerName == e2?.sellerName &&
        e1?.subcategory == e2?.subcategory &&
        e1?.numericsize == e2?.numericsize &&
        e1?.fit == e2?.fit &&
        e1?.pattern == e2?.pattern &&
        listEquality.equals(e1?.availableColors, e2?.availableColors) &&
        listEquality.equals(e1?.availableAlphasize, e2?.availableAlphasize) &&
        listEquality.equals(
            e1?.availableNumericsize, e2?.availableNumericsize) &&
        e1?.references == e2?.references &&
        e1?.driverName == e2?.driverName &&
        e1?.driverNumber == e2?.driverNumber &&
        e1?.shippingDays == e2?.shippingDays &&
        listEquality.equals(e1?.features, e2?.features) &&
        listEquality.equals(e1?.materials, e2?.materials) &&
        e1?.condition == e2?.condition;
  }

  @override
  int hash(InventoryRecord? e) => const ListEquality().hash([
        e?.inventoryName,
        e?.inventoryDescription,
        e?.inventoryPrice,
        e?.topSelling,
        e?.newIn,
        e?.rating,
        e?.sellersRef,
        e?.reviews,
        e?.inventorySize,
        e?.categories,
        e?.allProducts,
        e?.gender,
        e?.searchTem,
        e?.deal,
        e?.inventoryImages,
        e?.location,
        e?.productLikedBy,
        e?.dicountPercent,
        e?.isDiscount,
        e?.haliBidha,
        e?.imefunguliwa,
        e?.rangi,
        e?.mudaWakurudisha,
        e?.haramaUsafishaji,
        e?.mudaWakufika,
        e?.njiyaUsafirshaji,
        e?.sellerNumber,
        e?.createdAt,
        e?.inaKasoro,
        e?.risiti,
        e?.upatikanaji,
        e?.sellerWhatsap,
        e?.shippingCost,
        e?.searchKeywords,
        e?.viewCount,
        e?.isActive,
        e?.isHighlighted,
        e?.isNew,
        e?.buyerRef,
        e?.sellerName,
        e?.subcategory,
        e?.numericsize,
        e?.fit,
        e?.pattern,
        e?.availableColors,
        e?.availableAlphasize,
        e?.availableNumericsize,
        e?.references,
        e?.driverName,
        e?.driverNumber,
        e?.shippingDays,
        e?.features,
        e?.materials,
        e?.condition
      ]);

  @override
  bool isValidKey(Object? o) => o is InventoryRecord;
}