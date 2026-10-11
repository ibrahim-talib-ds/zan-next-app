import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBN9eBEJkmF4eQhONzkIAPRRTLfsGbOuT4",
            authDomain: "zannext-f6ff1.firebaseapp.com",
            projectId: "zannext-f6ff1",
            storageBucket: "zannext-f6ff1.firebasestorage.app",
            messagingSenderId: "129014154360",
            appId: "1:129014154360:web:8c1839a9595df16a2f598d",
            measurementId: "G-BW73Y9LKHM"));
  } else {
    await Firebase.initializeApp();
  }
}
