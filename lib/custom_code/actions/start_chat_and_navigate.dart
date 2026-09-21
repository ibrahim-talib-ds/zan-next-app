// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/auth/firebase_auth/auth_util.dart';

Future<DocumentReference?> startChatAndNavigate(
  DocumentReference? otherUserRef,
) async {
  // 1. Check if the input is actually there
  if (otherUserRef == null) {
    print('DEBUG: Error - otherUserRef is NULL. Check your Product Document.');
    return null;
  }

  print('DEBUG: Starting chat process with seller: ${otherUserRef.path}');
  print('DEBUG: Current User is: ${currentUserReference?.path}');

  try {
    // 2. Create the sorted list
    List<DocumentReference> userRefs = [currentUserReference!, otherUserRef];
    userRefs.sort((a, b) => a.path.compareTo(b.path));
    print(
        'DEBUG: Sorted user list created: ${userRefs.map((e) => e.id).toList()}');

    // 3. Search for an existing chat
    print('DEBUG: Searching Firestore for existing chat...');
    final existingChat = await FirebaseFirestore.instance
        .collection('chats')
        .where('users', isEqualTo: userRefs)
        .limit(1)
        .get();

    if (existingChat.docs.isNotEmpty) {
      print('DEBUG: Found existing chat! ID: ${existingChat.docs.first.id}');
      return existingChat.docs.first.reference;
    }

    // 4. Create new chat if not found
    print('DEBUG: No existing chat found. Creating new document...');
    final newChat = await FirebaseFirestore.instance.collection('chats').add({
      'users': userRefs,
      'last_message': 'New inquiry started',
      'last_time': FieldValue.serverTimestamp(),
    });

    print('DEBUG: New chat created successfully! ID: ${newChat.id}');
    return newChat;
  } catch (e) {
    // 5. Catch any Firebase permission or connection errors
    print('DEBUG: FIREBASE ERROR - $e');
    return null;
  }
}
