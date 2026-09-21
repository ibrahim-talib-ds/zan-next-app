import '/flutter_flow/flutter_flow_util.dart';
import 'mens_wear_widget.dart' show MensWearWidget;
import 'package:flutter/material.dart';

class MensWearModel extends FlutterFlowModel<MensWearWidget> {
  ///  State fields for stateful widgets on this page.

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  // Photo upload (multiple images)
  bool isDataUploading_men = false;
  List<FFUploadedFile> uploadedLocalFiles_men = [];
  List<String> uploadedFileUrls_men = [];

  // Text fields: focus node + controller + validator
  // (validators are null = no validation; the widget calls
  //  `.asValidator(context)` on them, which returns null safely)
  FocusNode? productNameFocusNode;
  TextEditingController? productNameTextController;
  String? Function(BuildContext, String?)? productNameTextControllerValidator;

  FocusNode? productdescriptionFocusNode;
  TextEditingController? productdescriptionTextController;
  String? Function(BuildContext, String?)?
      productdescriptionTextControllerValidator;

  FocusNode? productCategoryFocusNode;
  TextEditingController? productCategoryTextController;
  String? Function(BuildContext, String?)?
      productCategoryTextControllerValidator;

  FocusNode? priceFocusNode;
  TextEditingController? priceTextController;
  String? Function(BuildContext, String?)? priceTextControllerValidator;

  FocusNode? callFocusNode;
  TextEditingController? callTextController;
  String? Function(BuildContext, String?)? callTextControllerValidator;

  FocusNode? wasapFocusNode;
  TextEditingController? wasapTextController;
  String? Function(BuildContext, String?)? wasapTextControllerValidator;

  // Switches (the widget sets these in initState)
  bool tredingValue = false;
  bool newArrivalValue = false;
  bool showinAllValue = true;

  // Dropdown / size selections: value + controller.
  // Typed `dynamic` on purpose so the page compiles whatever the dropdowns'
  // generic types are. Works the same at runtime. Can be tightened later
  // (e.g. String? / List<String>? and FormFieldController<...>?).
  dynamic itemCategoryValue;
  dynamic itemCategoryValueController;

  dynamic colorValue;
  dynamic colorValueController;

  dynamic materiaValue;
  dynamic materiaValueController;

  dynamic fitValue;
  dynamic fitValueController;

  dynamic patternValue;
  dynamic patternValueController;

  dynamic alphaSizesValue;
  dynamic alphaSizesValueController;

  dynamic numericalSizesValue;
  dynamic numericalSizesValueController;

  dynamic newinValue;
  dynamic newinValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    productNameFocusNode?.dispose();
    productNameTextController?.dispose();

    productdescriptionFocusNode?.dispose();
    productdescriptionTextController?.dispose();

    productCategoryFocusNode?.dispose();
    productCategoryTextController?.dispose();

    priceFocusNode?.dispose();
    priceTextController?.dispose();

    callFocusNode?.dispose();
    callTextController?.dispose();

    wasapFocusNode?.dispose();
    wasapTextController?.dispose();
  }
}