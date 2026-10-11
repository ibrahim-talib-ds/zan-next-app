// ZanNext — API User Stream
//
// Replaces zanNextFirebaseUserStream(). Watches auth state and
// emits BaseAuthUser updates to every listening screen.
//
// Uses a simple StreamController — no Firebase, no Firestore.

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../base_auth_user_provider.dart';
import '../../services/auth_service.dart';
import '../../services/api_client.dart';
import '../../repositories/user_repository.dart';
import '../../models/user.dart';
import 'api_user_provider.dart';

final _controller = StreamController<BaseAuthUser>.broadcast();

/// Broadcast stream that screens can listen to for auth state changes.
Stream<BaseAuthUser> get apiUserStream => _controller.stream;

/// Emit an update to all listeners.
void emitAuthUpdate(BaseAuthUser user) {
  _controller.add(user);
}

/// Called once at app startup — checks if there's a stored session.
Future<void> restoreSession() async {
  final accessToken = await ApiClient.getAccessToken();
  if (accessToken == null || accessToken.isEmpty) {
    currentUser = ZanNextApiUser();
    emitAuthUpdate(currentUser!);
    return;
  }

  try {
    final userJson = await AuthService.me();
    final user = User.fromJson(userJson);
    final authUser = ZanNextApiUser.fromUser(user, accessToken: accessToken);
    currentUser = authUser;
    emitAuthUpdate(authUser);
  } catch (e) {
    // Stored token invalid/expired → logged out
    await ApiClient.clearTokens();
    currentUser = ZanNextApiUser();
    emitAuthUpdate(currentUser!);
  }
}
