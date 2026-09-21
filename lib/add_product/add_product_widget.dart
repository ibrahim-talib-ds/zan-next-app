import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'add_product_model.dart';
import 'package:image_picker/image_picker.dart' show MediaSource;
export 'add_product_model.dart';

/// Read at build time — never hardcode your real key in source.
/// Run with:  flutter run --dart-define=IMGBB_KEY=your_actual_key
const String _imgbbApiKey = String.fromEnvironment("IMGBB_KEY");

/// ZanNext — Add Product page
/// Seller flow: user has already picked Main Category + Subcategory.
/// This page collects product details, uploads photos to ImgBB,
/// then writes the doc to Firestore.
class AddProductWidget extends StatefulWidget {
  const AddProductWidget({super.key});

  static String routeName = 'AddProduct';
  static String routePath = '/addProduct';

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {
  late AddProductModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddProductModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'AddProduct'});

    _model.productNameController ??= TextEditingController();
    _model.productNameFocusNode ??= FocusNode();

    _model.productDescriptionController ??= TextEditingController();
    _model.productDescriptionFocusNode ??= FocusNode();

    _model.priceController ??= TextEditingController();
    _model.priceFocusNode ??= FocusNode();

    _model.stockController ??= TextEditingController(text: '1');
    _model.stockFocusNode ??= FocusNode();

    _model.colorController ??= TextEditingController();
    _model.colorFocusNode ??= FocusNode();

    _model.sizeController ??= TextEditingController();
    _model.sizeFocusNode ??= FocusNode();

    _model.materialController ??= TextEditingController();
    _model.materialFocusNode ??= FocusNode();

    _model.brandController ??= TextEditingController();
    _model.brandFocusNode ??= FocusNode();

    _model.locationController ??= TextEditingController();
    _model.locationFocusNode ??= FocusNode();

    _model.whatsappController ??= TextEditingController();
    _model.whatsappFocusNode ??= FocusNode();

    _model.callController ??= TextEditingController();
    _model.callFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final subCategory = FFAppState().categories;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              _buildHeader(context, subCategory),
              Expanded(
                child: Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(context, 'Photos'),
                        _buildPhotoSection(context),
                        const SizedBox(height: 22),

                        _sectionTitle(context, 'Product Details'),
                        _buildTextField(
                          context,
                          controller: _model.productNameController!,
                          focusNode: _model.productNameFocusNode!,
                          label: 'Product name',
                          hint: 'e.g. Mashuka ya laliya',
                          icon: Icons.shopping_bag_outlined,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Enter a product name'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          context,
                          controller: _model.productDescriptionController!,
                          focusNode: _model.productDescriptionFocusNode!,
                          label: 'Description',
                          hint: 'Describe your product in a few sentences',
                          icon: Icons.notes_rounded,
                          maxLines: 4,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Add a short description'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                context,
                                controller: _model.priceController!,
                                focusNode: _model.priceFocusNode!,
                                label: 'Price (TZS)',
                                hint: '0',
                                icon: Icons.attach_money_rounded,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.]')),
                                ],
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  final n = double.tryParse(v.trim());
                                  if (n == null || n <= 0) {
                                    return 'Invalid price';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                context,
                                controller: _model.stockController!,
                                focusNode: _model.stockFocusNode!,
                                label: 'Stock',
                                hint: '1',
                                icon: Icons.inventory_2_outlined,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  final n = int.tryParse(v.trim());
                                  if (n == null || n < 1) {
                                    return 'Min 1';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        _sectionTitle(context, 'Attributes (optional)'),
                        _buildTextField(
                          context,
                          controller: _model.colorController!,
                          focusNode: _model.colorFocusNode!,
                          label: 'Color',
                          hint: 'e.g. Black, Red, Multicolor',
                          icon: Icons.palette_outlined,
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          context,
                          controller: _model.sizeController!,
                          focusNode: _model.sizeFocusNode!,
                          label: 'Size',
                          hint: 'e.g. S, M, L, XL',
                          icon: Icons.straighten_rounded,
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          context,
                          controller: _model.materialController!,
                          focusNode: _model.materialFocusNode!,
                          label: 'Material',
                          hint: 'e.g. Cotton, Leather',
                          icon: Icons.layers_outlined,
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          context,
                          controller: _model.brandController!,
                          focusNode: _model.brandFocusNode!,
                          label: 'Brand',
                          hint: 'e.g. Nike, Local',
                          icon: Icons.workspace_premium_outlined,
                        ),
                        const SizedBox(height: 22),

                        _sectionTitle(context, 'Condition & Gender'),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                context,
                                label: 'Condition',
                                value: _model.conditionValue,
                                items: const [
                                  'Brand New',
                                  'Like New',
                                  'Refurbished',
                                  'Used - Good',
                                  'Used - Fair',
                                ],
                                onChanged: (v) => safeSetState(
                                    () => _model.conditionValue = v),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdown(
                                context,
                                label: 'Gender',
                                value: _model.genderValue,
                                items: const [
                                  'Men',
                                  'Women',
                                  'Unisex',
                                  'Boys',
                                  'Girls',
                                  'Baby',
                                ],
                                onChanged: (v) => safeSetState(
                                    () => _model.genderValue = v),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        _sectionTitle(context, 'Shipping'),
                        _buildDropdown(
                          context,
                          label: 'Delivery time',
                          value: _model.shippingDaysValue,
                          items: const [
                            'Same day',
                            'Next day',
                            '1-3 days',
                            '3-5 days',
                            '1 week',
                            '1-2 weeks',
                          ],
                          onChanged: (v) => safeSetState(
                              () => _model.shippingDaysValue = v),
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          context,
                          controller: _model.locationController!,
                          focusNode: _model.locationFocusNode!,
                          label: 'Location',
                          hint: 'City / Region',
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 22),

                        _sectionTitle(context, 'Contact'),
                        _buildTextField(
                          context,
                          controller: _model.whatsappController!,
                          focusNode: _model.whatsappFocusNode!,
                          label: 'WhatsApp number',
                          hint: '+255 ...',
                          icon: Icons.chat_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          context,
                          controller: _model.callController!,
                          focusNode: _model.callFocusNode!,
                          label: 'Call number',
                          hint: '+255 ...',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 22),

                        _sectionTitle(context, 'Visibility'),
                        _buildSwitchRow(
                          context,
                          icon: Icons.trending_up_rounded,
                          iconColor: const Color(0xFFFF5964),
                          label: 'Trending',
                          value: _model.trending,
                          onChanged: (v) =>
                              safeSetState(() => _model.trending = v),
                        ),
                        _buildSwitchRow(
                          context,
                          icon: Icons.fiber_new_rounded,
                          iconColor: const Color(0xFF39D2C0),
                          label: 'New Arrival',
                          value: _model.newArrival,
                          onChanged: (v) =>
                              safeSetState(() => _model.newArrival = v),
                        ),
                        _buildSwitchRow(
                          context,
                          icon: Icons.grid_view_rounded,
                          iconColor: const Color(0xFF4B39EF),
                          label: 'Show in All Products',
                          value: _model.showInAll,
                          onChanged: (v) =>
                              safeSetState(() => _model.showInAll = v),
                        ),
                        const SizedBox(height: 28),

                        _buildPostButton(context, subCategory),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget _buildHeader(BuildContext context, String subCategory) {
    final theme = FlutterFlowTheme.of(context);
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(0, topPad + 8, 0, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primary, const Color(0xFF053020)],
          stops: const [0, 1],
          begin: AlignmentDirectional(0, -1),
          end: AlignmentDirectional(0, 1),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 16, 0),
        child: Row(
          children: [
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 24,
              borderWidth: 1,
              buttonSize: 44,
              fillColor: Colors.white.withOpacity(0.15),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Product',
                  style: theme.titleLarge.override(
                    font: GoogleFonts.interTight(
                      fontWeight: FontWeight.w700,
                      fontStyle: theme.titleLarge.fontStyle,
                    ),
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w700,
                    fontStyle: theme.titleLarge.fontStyle,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  valueOrDefault<String>(subCategory, 'No category'),
                  style: theme.bodySmall.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontStyle: theme.bodySmall.fontStyle,
                    ),
                    color: Colors.white70,
                    fontSize: 11,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w400,
                    fontStyle: theme.bodySmall.fontStyle,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const SizedBox(width: 44),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================
  Widget _sectionTitle(BuildContext context, String text) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: theme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text.toUpperCase(),
            style: theme.bodySmall.override(
              font: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontStyle: theme.bodySmall.fontStyle,
              ),
              color: theme.secondaryText,
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
              fontStyle: theme.bodySmall.fontStyle,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PHOTO PICKER + GRID
  // ============================================================
  Widget _buildPhotoSection(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final photos = _model.uploadedPhotoUrls.take(10).toList();

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _pickPhotos,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: theme.primary.withOpacity(0.3),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    color: theme.primary,
                    size: 28,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _model.isUploadingPhotos
                        ? 'Uploading…'
                        : 'Tap to add photos',
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontStyle: theme.bodyMedium.fontStyle,
                      ),
                      color: theme.primaryText,
                      fontSize: 13,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle: theme.bodyMedium.fontStyle,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'First image is the cover · max 10',
                    style: theme.bodySmall.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontStyle: theme.bodySmall.fontStyle,
                      ),
                      color: theme.secondaryText,
                      fontSize: 11,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w400,
                      fontStyle: theme.bodySmall.fontStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (photos.isNotEmpty) ...[
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: photos.length,
              itemBuilder: (context, i) {
                final url = photos[i];
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (_, __, ___) => Container(
                          color: theme.secondary,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: theme.secondaryText,
                          ),
                        ),
                      ),
                    ),
                    if (i == 0)
                      Positioned(
                        left: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDB40E),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'COVER',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: GestureDetector(
                        onTap: () {
                          safeSetState(() {
                            _model.removeFromGallery(url);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // PICK PHOTOS + UPLOAD TO IMGBB
  // ============================================================
  Future<void> _pickPhotos() async {
    logFirebaseEvent('ADD_PRODUCT_pick_photos');
    try {
      final selectedMedia = await selectMedia(
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 90,
        mediaSource: MediaSource.photoGallery,
        multiImage: true,
      );

      if (selectedMedia == null || selectedMedia.isEmpty) return;

      if (!selectedMedia
          .every((m) => validateFileFormat(m.storagePath, context))) {
        return;
      }

      safeSetState(() => _model.isUploadingPhotos = true);

      final urls = <String>[];

      try {
        for (final media in selectedMedia) {
          final bytes = media.bytes;
          if (bytes == null) continue;

          final uploaded = await _uploadToImgBB(
            bytes, media.storagePath.split('/').last);
          if (uploaded != null) {
            urls.add(uploaded);
          }
        }
      } finally {
        _model.isUploadingPhotos = false;
      }

      safeSetState(() {
        _model.uploadedPhotoUrls = urls;
      });

      if (urls.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No photos uploaded. Check ImgBB key / try again.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  // ============================================================
  // ImgBB upload — returns the display_url of the uploaded image
  // ============================================================
  Future<String?> _uploadToImgBB(Uint8List bytes, String filename) async {
    if (_imgbbApiKey.isEmpty) {
      print('❌ ImgBB API key missing. Run with '
          '--dart-define=IMGBB_KEY=your_key');
      return null;
    }

    try {
      final uri = Uri.parse(
        'https://api.imgbb.com/1/upload?key=$_imgbbApiKey',
      );

      final base64Image = base64Encode(bytes);

      final response = await http
          .post(
            uri,
            body: {
              'image': base64Image,
              'name': filename,
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          return json['data']['display_url'] as String? ??
              json['data']['url'] as String?;
        }
      }

      print('ImgBB upload failed: ${response.statusCode} ${response.body}');
      return null;
    } catch (e) {
      print('ImgBB upload exception: $e');
      return null;
    }
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================
  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        validator: validator,
        style: theme.bodyMedium.override(
          font: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontStyle: theme.bodyMedium.fontStyle,
          ),
          color: theme.primaryText,
          fontSize: 14,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w500,
          fontStyle: theme.bodyMedium.fontStyle,
        ),
        cursorColor: theme.primary,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          hintText: hint,
          hintStyle: theme.bodyMedium.override(
            font: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontStyle: theme.bodyMedium.fontStyle,
            ),
            color: theme.secondaryText,
            fontSize: 14,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w400,
            fontStyle: theme.bodyMedium.fontStyle,
          ),
          labelStyle: theme.bodySmall.override(
            font: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontStyle: theme.bodySmall.fontStyle,
            ),
            color: theme.secondaryText,
            fontSize: 12,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w500,
            fontStyle: theme.bodySmall.fontStyle,
          ),
          prefixIcon: Icon(icon, color: theme.secondaryText, size: 20),
          filled: true,
          fillColor: theme.secondaryBackground,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.alternate, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.primary, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.error, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.error, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DROPDOWN
  // ============================================================
  Widget _buildDropdown(
    BuildContext context, {
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.alternate, width: 1),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(14, 4, 8, 4),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            hint: Text(
              label,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontStyle: theme.bodyMedium.fontStyle,
                ),
                color: theme.secondaryText,
                fontSize: 14,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
                fontStyle: theme.bodyMedium.fontStyle,
              ),
            ),
            dropdownColor: theme.secondaryBackground,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: theme.secondaryText,
              size: 22,
            ),
            items: items
                .map(
                  (v) => DropdownMenuItem<String>(
                    value: v,
                    child: Text(
                      v,
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontStyle: theme.bodyMedium.fontStyle,
                        ),
                        color: theme.primaryText,
                        fontSize: 14,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        fontStyle: theme.bodyMedium.fontStyle,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SWITCH ROW
  // ============================================================
  Widget _buildSwitchRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 6),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(14, 4, 6, 4),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.alternate, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontStyle: theme.bodyMedium.fontStyle,
                  ),
                  color: theme.primaryText,
                  fontSize: 14,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: theme.bodyMedium.fontStyle,
                ),
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: theme.primaryBackground,
              activeTrackColor: theme.primary,
              inactiveTrackColor: theme.alternate,
              inactiveThumbColor: theme.secondaryBackground,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // POST BUTTON
  // ============================================================
  Widget _buildPostButton(BuildContext context, String subCategory) {
    final theme = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: FFButtonWidget(
        onPressed: () => _submit(subCategory),
        text: 'Post Product',
        icon: const Icon(Icons.rocket_launch_rounded, size: 20),
        options: FFButtonOptions(
          width: double.infinity,
          height: 52,
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
          iconAlignment: IconAlignment.end,
          color: theme.primary,
          textStyle: theme.titleSmall.override(
            font: GoogleFonts.interTight(
              fontWeight: FontWeight.w700,
              fontStyle: theme.titleSmall.fontStyle,
            ),
            color: Colors.white,
            fontSize: 16,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w700,
            fontStyle: theme.titleSmall.fontStyle,
          ),
          elevation: 0,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ============================================================
  // SUBMIT
  // ============================================================
  Future<void> _submit(String subCategory) async {
    if (_model.formKey.currentState == null ||
        !_model.formKey.currentState!.validate()) {
      return;
    }

    if (_model.uploadedPhotoUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 1 photo')),
      );
      return;
    }

    if (currentUserReference == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in')),
      );
      return;
    }

    try {
      logFirebaseEvent('ADD_PRODUCT_submit');

      final docRef = InventoryRecord.collection.doc();

      final price = double.tryParse(_model.priceController!.text.trim());
      final stock = int.tryParse(_model.stockController!.text.trim()) ?? 1;

      await docRef.set({
        'inventory_name': _model.productNameController!.text.trim(),
        'inventory_description':
            _model.productDescriptionController!.text.trim(),
        'inventory_price': price ?? 0.0,
        'inventory_images': _model.uploadedPhotoUrls,
        'sellers_ref': currentUserReference,
        'seller_name': currentUserDisplayName,

        'categories': subCategory,
        'main_category': _extractMainCategory(subCategory),

        'available_colors': _splitCsv(_model.colorController!.text),
        'available_alphasize': _splitCsv(_model.sizeController!.text),
        'materials': _splitCsv(_model.materialController!.text),
        'brand': _model.brandController!.text.trim(),

        'condition': _model.conditionValue,
        'gender': _model.genderValue,

        'shipping_days': _model.shippingDaysValue,
        'location': _model.locationController!.text.trim(),

        'seller_whatsap': _model.whatsappController!.text.trim(),
        'seller_number': _model.callController!.text.trim(),

        'top_selling': _model.trending,
        'new_in': _model.newArrival,
        'all_products': _model.showInAll,

        'stock': stock,
        'view_count': 0,
        'rating': 0.0,
        'reviews': 0,
        'status': 'pending',
        'created_at': getCurrentTimestamp,
        'is_online': valueOrDefault<bool>(
            currentUserDocument?.isOnline, false),
        'last_active': currentUserDocument?.lastActive,
      });

      logFirebaseEvent('ADD_PRODUCT_success');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${_model.productNameController!.text}" posted!'),
          backgroundColor: themeOf(context).primary,
          duration: const Duration(milliseconds: 2500),
        ),
      );

      FFAppState().categories = '';

      context.pushNamed(
        SellerDashbordWidget.routeName,
        extra: <String, dynamic>{
          '__transition_info__': TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.leftToRight,
            duration: const Duration(milliseconds: 250),
          ),
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not post product: $e')),
      );
    }
  }

  // ============================================================
  // HELPERS
  // ============================================================
  List<String> _splitCsv(String text) {
    return text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  String _extractMainCategory(String sub) {
    if (sub.isEmpty) return '';
    return sub;
  }

  FlutterFlowTheme themeOf(BuildContext context) =>
      FlutterFlowTheme.of(context);
}