// ZanNext — Auth Util (API-backed)
//
// Replaces the Firebase version. Same public API — the ~150 screens
// that import this file keep working unchanged.
//
// Behind the scenes: uses ApiAuthManager + apiUserStream instead of
// FirebaseAuthManager + zanNextFirebaseUserStream.

import 'dart:async';

import 'package:flutter/material.dart';

import '../auth_manager.dart';
import '../base_auth_user_provider.dart';
import '../api_auth/api_auth_manager.dart';
import '../api_auth/api_user_provider.dart';
import '../api_auth/api_user_stream.dart';

import '/models/user.dart';

export '../base_auth_user_provider.dart';
export '../api_auth/api_auth_manager.dart';
export '../api_auth/api_user_provider.dart';
export '../api_auth/api_user_stream.dart';

// ---- Global auth manager (single instance) ----
final _authManager = ApiAuthManager();
ApiAuthManager get authManager => _authManager;

// ---- currentUser global + helpers ----
// These are the public names every screen uses.
// We keep the exact same names — only the internals changed.

User? _currentUserModel;
User? get currentUserModel => _currentUserModel;
set currentUserModel(User? v) => _currentUserModel = v;

String get currentUserEmail =>
    _currentUserModel?.email ?? currentUser?.email ?? '';

String get currentUserUid =>
    _currentUserModel?.id ?? currentUser?.uid ?? '';

String get currentUserDisplayName =>
    _currentUserModel?.displayName ?? currentUser?.displayName ?? '';

String get currentUserPhoto =>
    _currentUserModel?.photoUrl ?? currentUser?.photoUrl ?? '';

String get currentPhoneNumber =>
    _currentUserModel?.phoneNumber ?? currentUser?.phoneNumber ?? '';

bool get currentUserEmailVerified => currentUser?.emailVerified ?? false;

/// Compatibility: returns the current user's full data as a document-like
/// object. Exposes `.isAdmin`, `.email`, `.displayName`, `.photoUrl` etc.
/// Falls back to currentUser (ZanNextApiUser) which also has isAdmin.
dynamic get currentUserDocument {
  if (_currentUserModel != null) return _currentUserModel;
  return currentUser;
}

/// Firebase-free shim. Returns the user's UID as a String, or null if not
/// logged in. Screens that only use `== currentUserReference` or `.id` keep
/// working: comparison against currentUserUid, `.id` returns the uid itself.
class _UidRef {
  const _UidRef(this.id);
  final String id;
  String get path => 'users/$id';
  @override
  bool operator ==(Object other) =>
      other is _UidRef ? other.id == id : other == id;
  @override
  int get hashCode => id.hashCode;
  @override
  String toString() => 'users/$id';
}

dynamic get currentUserReference {
  final uid = currentUserUid;
  if (uid.isEmpty) return null;
  return _UidRef(uid);
}

/// Stream that screens can listen to for auth state updates.
/// Wraps the apiUserStream so existing code that used
/// authenticatedUserStream keeps working.
final authenticatedUserStream = apiUserStream;

// ---- Backwards-compat widget ----
class AuthUserStreamWidget extends StatelessWidget {
  const AuthUserStreamWidget({Key? key, required this.builder})
      : super(key: key);

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => StreamBuilder<BaseAuthUser>(
        stream: apiUserStream,
        builder: (context, _) => builder(context),
      );
}

// ---- JWT helpers (kept for code that expects them) ----
String get currentJwtToken => '';
String? get _currentJwtToken => null;
final jwtTokenStream = const Stream<String>.empty();

// ---- Setter for backwards compatibility with backend.dart ----
// backend.dart writes to currentUserDocument after login/signup.
// Our version ignores the write (data lives in currentUserModel).
set currentUserDocument(dynamic _) {
  // no-op — our user data is managed by currentUserModel
}
