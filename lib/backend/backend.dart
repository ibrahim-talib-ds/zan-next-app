import '../auth/firebase_auth/auth_util.dart';
import '../services/api_client.dart' as zannext_api;
import '../models/chat_message.dart';
import '../repositories/product_repository.dart';

import '../flutter_flow/flutter_flow_util.dart';
import 'schema/util/firestore_util.dart';

import 'schema/users_record.dart';
import 'schema/inventory_record.dart';
import 'schema/notifications_record.dart';
import 'schema/reviews_record.dart';
import 'schema/cart_record.dart';
import 'schema/orders_record.dart';
import 'schema/address_record.dart';
import 'schema/payent_record.dart';
import 'schema/wishlist_record.dart';
import 'schema/chats_record.dart';
import 'schema/chat_messages_record.dart';
import 'schema/search_history_record.dart';
import 'schema/last_seen_record.dart';
import 'schema/sellers_record.dart';

export 'dart:async' show StreamSubscription;
export 'schema/index.dart';
export 'schema/util/firestore_util.dart';
export 'schema/util/schema_util.dart';

export 'schema/users_record.dart';
export 'schema/inventory_record.dart';
export 'schema/notifications_record.dart';
export 'schema/reviews_record.dart';
export 'schema/cart_record.dart';
export 'schema/orders_record.dart';
export 'schema/address_record.dart';
export 'schema/payent_record.dart';
export 'schema/wishlist_record.dart';
export 'schema/chats_record.dart';
export 'schema/chat_messages_record.dart';
export 'schema/search_history_record.dart';
export 'schema/last_seen_record.dart';
export 'schema/sellers_record.dart';

/// Legacy Firestore query helpers — STUBBED.
/// Real data now flows through lib/repositories/* (Postgres + FastAPI).
/// Kept only so the ~150 files that still *reference* these symbols compile.
/// None are on a live code path.

Future<int> queryUsersRecordCount({dynamic queryBuilder, int limit = -1}) async => 0;
Stream<List<UsersRecord>> queryUsersRecord({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) => Stream.value(const []);
Future<List<UsersRecord>> queryUsersRecordOnce({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) async => const [];

Future<int> queryInventoryRecordCount({
  dynamic queryBuilder,
  String? filterCategory,
  String? filterSeller,
  int limit = -1,
}) async => 0;
Stream<List<InventoryRecord>> queryInventoryRecord({
  dynamic queryBuilder,
  String? filterCategory,
  String? filterMainCategory,
  String? filterSubcategory,
  String? filterSeller,
  bool? filterBoosted,
  bool? filterNewIn,
  bool? filterTopSelling,
  bool? filterAllProducts,
  bool? filterDeal,
  bool? filterAvailable,
  int limit = -1,
  bool singleRecord = false,
}) => Stream.value(const <InventoryRecord>[]);
Future<List<InventoryRecord>> queryInventoryRecordOnce({
  dynamic queryBuilder,
  String? filterCategory,
  String? filterMainCategory,
  String? filterSeller,
  bool? filterBoosted,
  bool? filterNewIn,
  bool? filterTopSelling,
  int limit = -1,
  bool singleRecord = false,
}) async => const <InventoryRecord>[];

Future<int> queryNotificationsRecordCount({dynamic queryBuilder, int limit = -1}) async => 0;
Stream<List<NotificationsRecord>> queryNotificationsRecord({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) => Stream.value(const []);
Future<List<NotificationsRecord>> queryNotificationsRecordOnce({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) async => const [];

Future<int> queryReviewsRecordCount({dynamic queryBuilder, int limit = -1}) async => 0;
Stream<List<ReviewsRecord>> queryReviewsRecord({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) => Stream.value(const []);
Future<List<ReviewsRecord>> queryReviewsRecordOnce({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) async => const [];

Future<int> queryCartRecordCount({dynamic queryBuilder, int limit = -1}) async => 0;
Stream<List<CartRecord>> queryCartRecord({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) => Stream.value(const []);
Future<List<CartRecord>> queryCartRecordOnce({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) async => const [];

Future<int> queryOrdersRecordCount({dynamic queryBuilder, int limit = -1}) async => 0;
Stream<List<OrdersRecord>> queryOrdersRecord({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) => Stream.value(const []);
Future<List<OrdersRecord>> queryOrdersRecordOnce({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) async => const [];

Future<int> queryAddressRecordCount({dynamic queryBuilder, int limit = -1}) async => 0;
Stream<List<AddressRecord>> queryAddressRecord({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) => Stream.value(const []);
Future<List<AddressRecord>> queryAddressRecordOnce({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) async => const [];

Future<int> queryPayentRecordCount({dynamic queryBuilder, int limit = -1}) async => 0;
Stream<List<PayentRecord>> queryPayentRecord({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) => Stream.value(const []);
Future<List<PayentRecord>> queryPayentRecordOnce({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) async => const [];

Future<int> queryWishlistRecordCount({dynamic queryBuilder, int limit = -1}) async => 0;
Stream<List<WishlistRecord>> queryWishlistRecord({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) => Stream.value(const []);
Future<List<WishlistRecord>> queryWishlistRecordOnce({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) async => const [];

Future<int> queryChatsRecordCount({dynamic queryBuilder, int limit = -1}) async => 0;
Stream<List<ChatsRecord>> queryChatsRecord({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) => Stream.value(const []);
Future<List<ChatsRecord>> queryChatsRecordOnce({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) async => const [];

Future<int> queryChatMessagesRecordCount({dynamic queryBuilder, int limit = -1}) async => 0;
Stream<List<ChatMessagesRecord>> queryChatMessagesRecord({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) => Stream.value(const []);
Future<List<ChatMessagesRecord>> queryChatMessagesRecordOnce({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) async => const [];

Future<int> querySearchHistoryRecordCount({dynamic queryBuilder, int limit = -1}) async => 0;
Stream<List<SearchHistoryRecord>> querySearchHistoryRecord({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) => Stream.value(const []);
Future<List<SearchHistoryRecord>> querySearchHistoryRecordOnce({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) async => const [];

Future<int> queryLastSeenRecordCount({dynamic queryBuilder, int limit = -1}) async => 0;
Stream<List<LastSeenRecord>> queryLastSeenRecord({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) => Stream.value(const []);
Future<List<LastSeenRecord>> queryLastSeenRecordOnce({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) async => const [];

Future<int> querySellersRecordCount({dynamic queryBuilder, int limit = -1}) async => 0;
Stream<List<SellersRecord>> querySellersRecord({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) => Stream.value(const []);
Future<List<SellersRecord>> querySellersRecordOnce({dynamic queryBuilder, int limit = -1, bool singleRecord = false}) async => const [];

// ---------- generic stubs ----------

Future<int> queryCollectionCount(dynamic collection, {dynamic queryBuilder, int limit = -1}) async => 0;
Stream<List<T>> queryCollection<T>(dynamic collection, dynamic recordBuilder, {dynamic queryBuilder, int limit = -1, bool singleRecord = false}) => Stream.value(const []);
Future<List<T>> queryCollectionOnce<T>(dynamic collection, dynamic recordBuilder, {dynamic queryBuilder, int limit = -1, bool singleRecord = false}) async => const [];

class FFFirestorePage<T> {
  final List<T> data;
  final Stream<List<T>>? dataStream;
  final Object? nextPageMarker;
  FFFirestorePage(this.data, this.dataStream, this.nextPageMarker);
}

Future<FFFirestorePage<T>> queryCollectionPage<T>(dynamic collection, dynamic recordBuilder, {dynamic queryBuilder, Object? nextPageMarker, required int pageSize, required bool isStream}) async =>
    FFFirestorePage<T>(const [], isStream ? Stream.value(const []) : null, null);

Future<void> maybeCreateUser(dynamic user) async {}
Future<void> updateUserDocument({String? email}) async {}
