import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

List<DocumentReference> generatelistofusers(
  DocumentReference authUsers,
  DocumentReference otherUsers,
) {
  return [authUsers, otherUsers];
}

List<String> generatelistofnames(
  String authUserName,
  String otherUserNames,
) {
  // Create a list containing both names
  List<String> namesList = [authUserName, otherUserNames];

  // Sort the list alphabetically for consistency
  namesList.sort();

  return namesList;
}

DocumentReference getOtherUserRef(
  List<DocumentReference> listOfUserRefs,
  DocumentReference authUserRef,
) {
  return authUserRef == listOfUserRefs.first
      ? listOfUserRefs.last
      : listOfUserRefs.first;
}

String getOtherUserName(
  List<String> listOfNames,
  String authUserName,
) {
  return authUserName == listOfNames.first
      ? listOfNames.last
      : listOfNames.first;
}

String getOtherUserPhoto(
  List<String> listOfPhotos,
  String authUserPhoto,
) {
  return authUserPhoto == listOfPhotos.first
      ? listOfPhotos.last
      : listOfPhotos.first;
}
