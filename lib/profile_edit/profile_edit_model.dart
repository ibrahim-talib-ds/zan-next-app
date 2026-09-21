import '/flutter_flow/flutter_flow_util.dart';
import 'profile_edit_widget.dart' show ProfileEditWidget;
import 'package:flutter/material.dart';

class ProfileEditModel extends FlutterFlowModel<ProfileEditWidget> {
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;

  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;

  FocusNode? phoneFocusNode;
  TextEditingController? phoneTextController;

  FocusNode? birthdayFocusNode;
  TextEditingController? birthdayTextController;

  String? choiceChipsValue;

  bool isDataUploading_uploadDataDr6 = false;
  FFUploadedFile uploadedLocalFile_uploadDataDr6 =
      FFUploadedFile(bytes: Uint8List(0));
  String uploadedFileUrl_uploadDataDr6 = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nameFocusNode?.dispose();
    nameTextController?.dispose();
    emailFocusNode?.dispose();
    emailTextController?.dispose();
    phoneFocusNode?.dispose();
    phoneTextController?.dispose();
    birthdayFocusNode?.dispose();
    birthdayTextController?.dispose();
  }
}
