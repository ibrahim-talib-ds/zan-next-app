import '/flutter_flow/flutter_flow_util.dart';
import 'add_product_widget.dart' show AddProductWidget;
import 'package:flutter/material.dart';

class AddProductModel extends FlutterFlowModel<AddProductWidget> {
  ///  State fields for stateful widgets in this page.

  // Form key for validating the whole form on submit
  final formKey = GlobalKey<FormState>();

  // ---------- Photos ----------
  bool isUploadingPhotos = false;
  List<FFUploadedFile> uploadedLocalPhotos = [];
  List<String> uploadedPhotoUrls = [];

  // ---------- Basic fields ----------
  FocusNode? productNameFocusNode;
  TextEditingController? productNameController;
  String? Function(BuildContext, String?)? productNameValidator;

  FocusNode? productDescriptionFocusNode;
  TextEditingController? productDescriptionController;
  String? Function(BuildContext, String?)? productDescriptionValidator;

  FocusNode? priceFocusNode;
  TextEditingController? priceController;
  String? Function(BuildContext, String?)? priceValidator;

  FocusNode? stockFocusNode;
  TextEditingController? stockController;
  String? Function(BuildContext, String?)? stockValidator;

  // ---------- Attributes ----------
  FocusNode? colorFocusNode;
  TextEditingController? colorController;

  FocusNode? sizeFocusNode;
  TextEditingController? sizeController;

  FocusNode? materialFocusNode;
  TextEditingController? materialController;

  FocusNode? brandFocusNode;
  TextEditingController? brandController;

  // ---------- Condition / Gender ----------
  String? conditionValue;
  String? genderValue;

  // ---------- Shipping ----------
  String? shippingDaysValue;
  FocusNode? locationFocusNode;
  TextEditingController? locationController;

  // ---------- Contact ----------
  FocusNode? whatsappFocusNode;
  TextEditingController? whatsappController;

  FocusNode? callFocusNode;
  TextEditingController? callController;

  // ---------- Flags ----------
  bool trending = false;
  bool newArrival = true;
  bool showInAll = true;

  // ---------- Helpers ----------
  void addToGallery(String url) {
    if (!uploadedPhotoUrls.contains(url)) {
      uploadedPhotoUrls.add(url);
    }
  }

  void removeFromGallery(String url) {
    uploadedPhotoUrls.remove(url);
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    productNameFocusNode?.dispose();
    productNameController?.dispose();
    productDescriptionFocusNode?.dispose();
    productDescriptionController?.dispose();
    priceFocusNode?.dispose();
    priceController?.dispose();
    stockFocusNode?.dispose();
    stockController?.dispose();
    colorFocusNode?.dispose();
    colorController?.dispose();
    sizeFocusNode?.dispose();
    sizeController?.dispose();
    materialFocusNode?.dispose();
    materialController?.dispose();
    brandFocusNode?.dispose();
    brandController?.dispose();
    locationFocusNode?.dispose();
    locationController?.dispose();
    whatsappFocusNode?.dispose();
    whatsappController?.dispose();
    callFocusNode?.dispose();
    callController?.dispose();
  }
}
