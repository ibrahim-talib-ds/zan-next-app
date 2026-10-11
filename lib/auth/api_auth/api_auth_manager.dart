// ZanNext — API Auth Manager
//
// Drop-in replacement for FirebaseAuthManager.
// Same interface (AuthManager + mixins), backed by our Postgres backend.
//
// Phase 1 (Session 1): Email login + signup + logout + reset password.
// Phase 2 (Session 3+): Google, Apple, Anonymous.

import 'dart:async';

import 'package:flutter/material.dart';

import '../auth_manager.dart';
import '../base_auth_user_provider.dart';
import '../../services/auth_service.dart';
import '../../services/api_client.dart';
import '../../repositories/user_repository.dart';
import '../../models/user.dart';
import 'api_user_provider.dart';

export '../base_auth_user_provider.dart';

class ApiAuthManager extends AuthManager
    with
        EmailSignInManager,
        GoogleSignInManager,
        AppleSignInManager,
        AnonymousSignInManager {
  @override
  Future signOut() async {
    await AuthService.logout();
    currentUser = null;
  }

  @override
  Future deleteUser(BuildContext context) async {
    // Deletion handled by backend later.
    await signOut();
  }

  @override
  Future updateEmail({
    required String email,
    required BuildContext context,
  }) async {
    // Not yet wired — implement later.
  }

  @override
  Future resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await AuthService.forgotPassword(email);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('If the email exists, a reset link has been sent.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Future<BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final result = await AuthService.login(email: email, password: password);
      return _toAuthUser(result);
    } on ApiException catch (e) {
      _showError(context, e.message);
      return null;
    } catch (e) {
      _showError(context, '$e');
      return null;
    }
  }

  @override
  Future<BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final result = await AuthService.signup(
        email: email,
        password: password,
        displayName: email.split('@').first,  // default display name
      );
      return _toAuthUser(result);
    } on ApiException catch (e) {
      _showError(context, e.message);
      return null;
    } catch (e) {
      _showError(context, '$e');
      return null;
    }
  }

  // Not implemented yet — return null to keep the interface satisfied.
  @override
  Future<BaseAuthUser?> signInWithGoogle(BuildContext context) async {
    _showError(context, 'Google Sign-In is coming soon.');
    return null;
  }

  @override
  Future<BaseAuthUser?> signInWithApple(BuildContext context) async {
    _showError(context, 'Apple Sign-In is coming soon.');
    return null;
  }

  @override
  Future<BaseAuthUser?> signInAnonymously(BuildContext context) async {
    _showError(context, 'Guest mode is coming soon.');
    return null;
  }

  // ---- Helpers ----

  BaseAuthUser _toAuthUser(Map<String, dynamic> result) {
    final userMap = result['user'] as Map<String, dynamic>;
    final access = result['access_token'] as String;
    final refresh = result['refresh_token'] as String;
    final user = User.fromJson(userMap);
    final authUser = ZanNextApiUser.fromUser(
      user,
      accessToken: access,
      refreshToken: refresh,
    );
    currentUser = authUser;
    return authUser;
  }

  void _showError(BuildContext context, String raw) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final msg = _friendlyAuthError(raw);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFDC0F0F),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 4),
        elevation: 4,
      ),
    );
  }

  String _friendlyAuthError(String raw) {
    final r = raw.toLowerCase();
    if (r.contains('invalid credentials') ||
        r.contains('wrong password') ||
        r.contains('incorrect') ||
        r.contains('401')) {
      return 'Wrong email or password. Please check and try again.';
    }
    if (r.contains('already exists') ||
        r.contains('already registered') ||
        r.contains('already in use') ||
        r.contains('409')) {
      return 'This email is already registered — try signing in instead.';
    }
    if (r.contains('user not found') || r.contains('account not found')) {
      return 'Account not found. Check your email or sign up.';
    }
    if (r.contains('network') ||
        r.contains('socketexception') ||
        r.contains('timeout') ||
        r.contains('connection') ||
        r.contains('failed host lookup')) {
      return 'Connection problem. Check your internet and try again.';
    }
    if (r.contains('invalid email') || r.contains('not a valid email')) {
      return 'Please enter a valid email address.';
    }
    if (r.contains('password must') ||
        r.contains('too short') ||
        r.contains('at least')) {
      return 'Password must be at least 8 characters.';
    }
    if (r.contains('email required') || r.contains('email and password')) {
      return 'Please enter both your email and password.';
    }
    if (r.contains('rate limit') || r.contains('too many')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    // Fallback: strip ApiException wrapper + show cleaned text
    final cleaned = raw
        .replaceAll(RegExp(r'^ApiException\(\d+\):\s*'), '')
        .replaceAll(RegExp(r'^Exception:\s*'), '')
        .trim();
    if (cleaned.isEmpty || cleaned.length > 120) {
      return 'Something went wrong. Please try again.';
    }
    return cleaned;
  }
}


// =====================================================================
// Extended signup with name + phone (used by SignUpWidget)
// =====================================================================
extension ApiAuthManagerSignupDetails on ApiAuthManager {
  Future<BaseAuthUser?> signUpWithDetails(
    BuildContext context, {
    required String email,
    required String password,
    required String displayName,
    String? phoneNumber,
  }) async {
    try {
      final result = await AuthService.signup(
        email: email,
        password: password,
        displayName: displayName,
        phoneNumber: phoneNumber,
      );
      final userMap = result['user'] as Map<String, dynamic>;
      final access = result['access_token'] as String;
      final refresh = result['refresh_token'] as String;
      final user = User.fromJson(userMap);
      final authUser = ZanNextApiUser.fromUser(
        user,
        accessToken: access,
        refreshToken: refresh,
      );
      currentUser = authUser;
      return authUser;
    } on ApiException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
      return null;
    }
  }
}
