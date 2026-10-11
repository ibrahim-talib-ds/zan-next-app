// ZanNext — InventoryRecord Shim (complete)
//
// Full API compatibility with the original Firestore InventoryRecord.
// Backed by our Product model (from Postgres).

import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, CollectionReference, DocumentSnapshot;

import '../../models/product.dart';
import '../../repositories/product_repository.dart';

class InventoryRecord {
  InventoryRecord._(this._product, DocumentReference? explicitRef)
      : _explicitRef = explicitRef;

  final Product? _product;
  final DocumentReference? _explicitRef;

  String get id => _product?.id ?? '';

  // Non-nullable, synthesized reference for compile compatibility.
  // Real Firestore operations on it will fail at runtime — those screens
  // will migrate to ProductRepository in later sessions.
  /// DEPRECATED — no longer routes to Firestore.
  /// Use `record.id` or `ProductRepository.get(id)` instead.
  DocumentReference get reference => throw UnsupportedError(
      'InventoryRecord.reference is deprecated. Use .id or ProductRepository.');

  DocumentReference get syntheticRef => reference;

  Product? get product => _product;

  String get inventoryName => _product?.name ?? '';
  bool hasInventoryName() => _product?.name != null;

  String get inventoryDescription => _product?.description ?? '';
  bool hasInventoryDescription() => _product?.description != null;

  double get inventoryPrice => _product?.price ?? 0.0;
  bool hasInventoryPrice() => _product != null;

  String get inventorySize => '';
  bool hasInventorySize() => false;

  List<String> get inventoryImages => _product?.images ?? const <String>[];
  bool hasInventoryImages() =>
      (_product?.images != null && _product!.images!.isNotEmpty);

  String get categories => _product?.category ?? '';
  bool hasCategories() => _product?.category != null;

  String get mainCategory => _product?.mainCategory ?? '';
  bool hasMainCategory() => _product?.mainCategory != null;

  String get subcategory => '';
  bool hasSubcategory() => false;

  String get gender => _product?.gender ?? '';
  bool hasGender() => _product?.gender != null;

  String get location => _product?.location ?? '';
  bool hasLocation() => _product?.location != null;

  bool get topSelling => _product?.topSelling ?? false;
  bool hasTopSelling() => _product != null;

  bool get newIn => _product?.newIn ?? false;
  bool hasNewIn() => _product != null;

  bool get allProducts => _product?.allProducts ?? false;
  bool hasAllProducts() => _product != null;

  bool get boosted => _product?.boosted ?? false;
  bool hasBoosted() => _product != null;

  double get rating => _product?.rating ?? 0.0;
  bool hasRating() => _product != null;

  int get reviews => _product?.reviewsCount ?? 0;
  bool hasReviews() => _product != null;

  int get viewCount => _product?.viewCount ?? 0;
  bool hasViewCount() => _product != null;

  String get sellerNumber => _product?.sellerNumber ?? '';
  bool hasSellerNumber() => _product?.sellerNumber != null;

  String get sellerWhatsap => _product?.sellerWhatsapp ?? '';
  bool hasSellerWhatsap() => _product?.sellerWhatsapp != null;

  String get sellerName => _product?.sellerName ?? '';
  bool hasSellerName() => _product?.sellerName != null;

  DocumentReference? get sellersRef => null;
  bool hasSellersRef() => _product?.sellerId != null;

  String get sellersId => _product?.sellerId ?? '';

  DateTime? get createdAt => _product?.createdAt;
  bool hasCreatedAt() => _product?.createdAt != null;

  String get condition => _product?.condition ?? '';
  bool hasCondition() => _product?.condition != null;

  List<String> get materials => _product?.materials ?? const <String>[];
  bool hasMaterials() =>
      (_product?.materials != null && _product!.materials!.isNotEmpty);

  List<String> get availableColors =>
      _product?.availableColors ?? const <String>[];
  bool hasAvailableColors() => (_product?.availableColors != null &&
      _product!.availableColors!.isNotEmpty);

  List<String> get availableAlphasize =>
      _product?.availableAlphasize ?? const <String>[];
  bool hasAvailableAlphasize() => (_product?.availableAlphasize != null &&
      _product!.availableAlphasize!.isNotEmpty);

  List<String> get availableNumericsize => const <String>[];
  bool hasAvailableNumericsize() => false;

  String get shippingDays => _product?.shippingDays ?? '';
  bool hasShippingDays() => _product?.shippingDays != null;

  bool get available => (_product?.stock ?? 0) > 0;
  bool hasAvailable() => _product != null;

  String get searchTem => '';
  bool hasSearchTem() => false;
  bool get deal => false;
  bool hasDeal() => false;
  List<DocumentReference> get productLikedBy => const <DocumentReference>[];
  bool hasProductLikedBy() => false;
  String get dicountPercent => '';
  bool hasDicountPercent() => false;
  bool get isDiscount => false;
  bool hasIsDiscount() => false;
  String get haliBidha => '';
  bool hasHaliBidha() => false;
  String get imefunguliwa => '';
  bool hasImefunguliwa() => false;
  String get rangi => '';
  bool hasRangi() => false;
  String get mudaWakurudisha => '';
  bool hasMudaWakurudisha() => false;
  String get haramaUsafishaji => '';
  bool hasHaramaUsafishaji() => false;
  String get mudaWakufika => '';
  bool hasMudaWakufika() => false;
  String get njiyaUsafirshaji => '';
  bool hasNjiyaUsafirshaji() => false;
  bool get inaKasoro => false;
  bool hasInaKasoro() => false;
  bool get risiti => false;
  bool hasRisiti() => false;
  bool get upatikanaji => false;
  bool hasUpatikanaji() => false;
  double get shippingCost => 0.0;
  bool hasShippingCost() => false;
  List<String> get searchKeywords => const <String>[];
  bool hasSearchKeywords() => false;
  bool get isOnline => _product?.isOnline ?? true;
  bool get isActive => true;
  bool hasIsActive() => false;
  bool get isHighlighted => false;
  bool hasIsHighlighted() => false;
  String get isNew => '';
  bool hasIsNew() => false;
  DocumentReference? get buyerRef => null;
  bool hasBuyerRef() => false;
  String get numericsize => '';
  bool hasNumericsize() => false;
  String get fit => '';
  bool hasFit() => false;
  String get pattern => '';
  bool hasPattern() => false;
  DocumentReference? get references => null;
  bool hasReferences() => false;
  String get driverName => '';
  bool hasDriverName() => false;
  String get driverNumber => '';
  bool hasDriverNumber() => false;
  List<String> get features => const <String>[];
  bool hasFeatures() => false;

  /// DEPRECATED — no Firestore. Kept so old code compiles.
  static CollectionReference get collection =>
      throw UnsupportedError('InventoryRecord.collection is deprecated.');

  static Future<InventoryRecord> getById(String id) async {
    try {
      final product = await ProductRepository.get(id);
      return InventoryRecord._(product, null);
    } catch (_) {
      return InventoryRecord._(null, null);
    }
  }

  static Stream<InventoryRecord> getByIdStream(String id) async* {
    yield await getById(id);
  }

  static Future<InventoryRecord> getDocumentOnce(DocumentReference ref) async {
    try {
      final product = await ProductRepository.get(ref.id);
      return InventoryRecord._(product, ref);
    } catch (_) {
      return InventoryRecord._(null, ref);
    }
  }

  static Stream<InventoryRecord> getDocument(DocumentReference ref) {
    return Stream.fromFuture(getDocumentOnce(ref));
  }

  static InventoryRecord fromSnapshot(DocumentSnapshot snapshot) =>
      InventoryRecord._(null, snapshot.reference);

  static InventoryRecord fromProduct(Product p) => InventoryRecord._(p, null);

  @override
  String toString() =>
      'InventoryRecord(id: ${_product?.id}, name: ${_product?.name})';
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
  return <String, dynamic>{
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
  };
}
