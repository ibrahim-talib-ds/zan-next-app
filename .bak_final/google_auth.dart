import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

/// Detect mobile web (Android/iOS browser).
bool _isMobileWeb() {
  if (!kIsWeb) return false;
  // Web on Android/iOS
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    return true;
  }
  return false;
}

Future<UserCredential?> googleSignInFunc() async {
  if (kIsWeb) {
    final provider = GoogleAuthProvider();

    // Mobile browsers → use redirect (popup is blocked)
    if (_isMobileWeb()) {
      await FirebaseAuth.instance.signInWithRedirect(provider);
      // The result comes back via getRedirectResult() in main.dart
      return null;
    }

    // Desktop browsers → popup works fine
    return await FirebaseAuth.instance.signInWithPopup(provider);
  }

  // Native mobile (Android APK / iOS app)
  await signOutWithGoogle().catchError((_) => null);
  final auth = await (await _googleSignIn.signIn())?.authentication;
  if (auth == null) return null;
  final credential = GoogleAuthProvider.credential(
    idToken: auth.idToken,
    accessToken: auth.accessToken,
  );
  return FirebaseAuth.instance.signInWithCredential(credential);
}

/// Call this on app start (web only) to handle the redirect back from Google.
Future<UserCredential?> handleGoogleRedirectResult() async {
  if (!kIsWeb) return null;
  try {
    return await FirebaseAuth.instance.getRedirectResult();
  } catch (e) {
    debugPrint('Google redirect result error: $e');
    return null;
  }
}

Future signOutWithGoogle() => _googleSignIn.signOut();
