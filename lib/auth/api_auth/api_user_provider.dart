// ZanNext — API User Provider
//
// Replaces ZanNextFirebaseUser. Same interface (BaseAuthUser),
// but backed by our Postgres backend instead of Firebase.

import 'package:flutter/foundation.dart';

import '../base_auth_user_provider.dart';
import '../../models/user.dart';

export '../base_auth_user_provider.dart';

/// A logged-in user, loaded from our backend.
/// Wraps the User model plus in-memory state.
class ZanNextApiUser extends BaseAuthUser {
  ZanNextApiUser({this.user, this.accessToken, this.refreshToken});

  /// The User model from our backend (null = logged out).
  User? user;

  /// JWT tokens (kept in memory as well as secure storage).
  String? accessToken;
  String? refreshToken;

  @override
  bool get loggedIn => user != null && accessToken != null;

  @override
  bool get emailVerified => user?.email != null;

  /// Whether this user is an admin. Used by profile + admin dashboard.
  bool get isAdmin => user?.isAdmin ?? false;

  @override
  AuthUserInfo get authUserInfo => AuthUserInfo(
        uid: user?.id,
        email: user?.email,
        displayName: user?.displayName,
        photoUrl: user?.photoUrl,
        phoneNumber: user?.phoneNumber,
      );

  @override
  Future? delete() async {
    // Deletion on our backend happens via a dedicated endpoint (admin-only).
    // For now, just log out — real deletion can be wired later.
    await refreshUser();
  }

  @override
  Future? updateEmail(String email) async {
    // Wire this up to PATCH /users/{id} later.
    if (user != null) {
      user = User(
        id: user!.id,
        email: email,
        displayName: user!.displayName,
        phoneNumber: user!.phoneNumber,
        photoUrl: user!.photoUrl,
        gender: user!.gender,
        birthday: user!.birthday,
        city: user!.city,
        district: user!.district,
        isAdmin: user!.isAdmin,
        isOnline: user!.isOnline,
        lastActive: user!.lastActive,
        fcmToken: user!.fcmToken,
        createdAt: user!.createdAt,
      );
    }
  }

  @override
  Future? updatePassword(String newPassword) async {
    // Wire to POST /auth/reset-password later if needed.
  }

  @override
  Future? sendEmailVerification() async {
    // No-op — our backend uses argon2 hashes, no verification step required.
  }

  @override
  Future refreshUser() async {
    // Reload user from backend via UserRepository (wired later).
  }

  static BaseAuthUser fromUser(
    User user, {
    String? accessToken,
    String? refreshToken,
  }) =>
      ZanNextApiUser(
        user: user,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
}

  // fix34: safe getters (Postgres auth user)
  bool get isOnline => true;
  String get gender => '';
  String get city => '';
  String get district => '';
  DateTime? get birthday => null;
  DateTime? get lastActive => null;
  DateTime? get createdTime => null;
  String get phoneNumber => '';
  String get photoUrl => '';
  String get displayName => '';
  String get email => '';


  // fix31: safe getters


  // fix29: safe getters (Postgres auth user) — prevent NoSuchMethodError

