import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'uploadphoto_widget.dart' show UploadphotoWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UploadphotoModel extends FlutterFlowModel<UploadphotoWidget> {
  ///  State fields for stateful widgets in this component.

  bool isDataUploading_uploadDataZvc = false;
  FFUploadedFile uploadedLocalFile_uploadDataZvc =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataZvc = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
