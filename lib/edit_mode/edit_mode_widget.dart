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
import 'package:image_picker/image_picker.dart' show MediaSource;
import 'package:provider/provider.dart';

import 'edit_mode_model.dart';
export 'edit_mode_model.dart';

const String _imgbbApiKey = String.fromEnvironment('IMGBB_KEY');

class EditModeWidget extends StatefulWidget {
  const EditModeWidget({
    super.key,
    required this.targetProduct,
  });

  final DocumentReference? targetProduct;

  static String routeName = 'EditMode';
  static String routePath = '/EditMode';

  @override
  State<EditModeWidget> createState() => _EditModeWidgetState();
}

class _EditModeWidgetState extends State<EditModeWidget> {
  late EditModeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loadedInitial = false;
  bool _isUploadingPhotos = false;
  bool _trending = false;
  bool _newArrival = false;
  bool _showInAll = true;

  String? _conditionValue;
  String? _genderValue;
  String? _shippingDaysValue;

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _colorController;
  late TextEditingController _sizeController;
  late TextEditingController _materialController;
  late TextEditingController _brandController;
  late TextEditingController _locationController;
  late TextEditingController _whatsappController;
  late TextEditingController _callController;

  List<String> _photoUrls = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditModeModel());

    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController(text: '1');
    _colorController = TextEditingController();
    _sizeController = TextEditingController();
    _materialController = TextEditingController();
    _brandController = TextEditingController();
    _locationController = TextEditingController();
    _whatsappController = TextEditingController();
    _callController = TextEditingController(
      text: currentPhoneNumber,
    );

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'EditMode'});
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _colorController.dispose();
    _sizeController.dispose();
    _materialController.dispose();
    _brandController.dispose();
    _locationController.dispose();
    _whatsappController.dispose();
    _callController.dispose();
    _model.dispose();
    super.dispose();
  }

  void _hydrateFrom(InventoryRecord p) {
    if (_loadedInitial) return;
    _loadedInitial = true;

    _nameController.text = p.inventoryName;
    _descriptionController.text = p.inventoryDescription;
    _priceController.text = p.inventoryPrice.toStringAsFixed(0);
    _stockController.text = '1'; // stock field not in schema yet

    _colorController.text = p.availableColors.join(', ');
    _sizeController.text = p.availableAlphasize.join(', ');
    _materialController.text = p.materials.join(', ');
    _brandController.text = ''; // brand field not in schema yet

    _locationController.text = p.location ?? '';
    _whatsappController.text = p.sellerWhatsap ?? '';
    if (_callController.text.isEmpty) {
      _callController.text = p.sellerNumber ?? '';
    }

    _conditionValue = p.condition;
    _genderValue = p.gender;
    _shippingDaysValue = p.shippingDays;

    _trending = p.topSelling;
    _newArrival = p.newIn;
    _showInAll = p.allProducts;

    _photoUrls = List<String>.from(p.inventoryImages);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.targetProduct == null) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: const Center(child: Text('Product not found')),
      );
    }

    final theme = FlutterFlowTheme.of(context);

    return StreamBuilder<InventoryRecord>(
      stream: InventoryRecord.getDocument(widget.targetProduct!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: theme.primaryBackground,
            body: const Center(child: Text('Could not load product')),
          );
        }
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: theme.primaryBackground,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final product = snapshot.data!;
        _hydrateFrom(product);

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
                  _buildHeader(context, product),
                  Expanded(
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
                          _textField(
                            context,
                            controller: _nameController,
                            label: 'Product name',
                            hint: 'e.g. Mashuka ya laliya',
                            icon: Icons.shopping_bag_outlined,
                          ),
                          const SizedBox(height: 14),
                          _textField(
                            context,
                            controller: _descriptionController,
                            label: 'Description',
                            hint: 'Describe your product',
                            icon: Icons.notes_rounded,
                            maxLines: 4,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _textField(
                                  context,
                                  controller: _priceController,
                                  label: 'Price (TZS)',
                                  hint: '0',
                                  icon: Icons.attach_money_rounded,
                                  keyboardType: const TextInputType
                                      .numberWithOptions(decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9.]')),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _textField(
                                  context,
                                  controller: _stockController,
                                  label: 'Stock',
                                  hint: '1',
                                  icon: Icons.inventory_2_outlined,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),

                          _sectionTitle(context, 'Attributes'),
                          _textField(
                            context,
                            controller: _colorController,
                            label: 'Color',
                            hint: 'e.g. Black, Red',
                            icon: Icons.palette_outlined,
                          ),
                          const SizedBox(height: 14),
                          _textField(
                            context,
                            controller: _sizeController,
                            label: 'Size',
                            hint: 'e.g. S, M, L',
                            icon: Icons.straighten_rounded,
                          ),
                          const SizedBox(height: 14),
                          _textField(
                            context,
                            controller: _materialController,
                            label: 'Material',
                            hint: 'e.g. Cotton',
                            icon: Icons.layers_outlined,
                          ),
                          const SizedBox(height: 14),
                          _textField(
                            context,
                            controller: _brandController,
                            label: 'Brand',
                            hint: 'e.g. Nike',
                            icon: Icons.workspace_premium_outlined,
                          ),
                          const SizedBox(height: 22),

                          _sectionTitle(context, 'Condition & Gender'),
                          Row(
                            children: [
                              Expanded(
                                child: _dropdown(
                                  context,
                                  label: 'Condition',
                                  value: _conditionValue,
                                  items: const [
                                    'Brand New',
                                    'Like New',
                                    'Refurbished',
                                    'Used - Good',
                                    'Used - Fair',
                                  ],
                                  onChanged: (v) => safeSetState(
                                      () => _conditionValue = v),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _dropdown(
                                  context,
                                  label: 'Gender',
                                  value: _genderValue,
                                  items: const [
                                    'Men',
                                    'Women',
                                    'Unisex',
                                    'Boys',
                                    'Girls',
                                    'Baby',
                                  ],
                                  onChanged: (v) =>
                                      safeSetState(() => _genderValue = v),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),

                          _sectionTitle(context, 'Shipping'),
                          _dropdown(
                            context,
                            label: 'Delivery time',
                            value: _shippingDaysValue,
                            items: const [
                              'Same day',
                              'Next day',
                              '1-3 days',
                              '3-5 days',
                              '1 week',
                              '1-2 weeks',
                            ],
                            onChanged: (v) =>
                                safeSetState(() => _shippingDaysValue = v),
                          ),
                          const SizedBox(height: 14),
                          _textField(
                            context,
                            controller: _locationController,
                            label: 'Location',
                            hint: 'City / Region',
                            icon: Icons.location_on_outlined,
                          ),
                          const SizedBox(height: 22),

                          _sectionTitle(context, 'Contact'),
                          _textField(
                            context,
                            controller: _whatsappController,
                            label: 'WhatsApp number',
                            hint: '+255 ...',
                            icon: Icons.chat_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 14),
                          _textField(
                            context,
                            controller: _callController,
                            label: 'Call number',
                            hint: '+255 ...',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 22),

                          _sectionTitle(context, 'Visibility'),
                          _switchRow(
                            context,
                            icon: Icons.trending_up_rounded,
                            iconColor: const Color(0xFFFF5964),
                            label: 'Trending',
                            value: _trending,
                            onChanged: (v) =>
                                safeSetState(() => _trending = v),
                          ),
                          _switchRow(
                            context,
                            icon: Icons.fiber_new_rounded,
                            iconColor: const Color(0xFF39D2C0),
                            label: 'New Arrival',
                            value: _newArrival,
                            onChanged: (v) =>
                                safeSetState(() => _newArrival = v),
                          ),
                          _switchRow(
                            context,
                            icon: Icons.grid_view_rounded,
                            iconColor: const Color(0xFF4B39EF),
                            label: 'Show in All Products',
                            value: _showInAll,
                            onChanged: (v) =>
                                safeSetState(() => _showInAll = v),
                          ),
                          const SizedBox(height: 28),

                          _saveButton(context, product),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget _buildHeader(BuildContext context, InventoryRecord product) {
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
                  'Edit Product',
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
                  valueOrDefault<String>(product.categories, 'No category'),
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
  // PHOTO SECTION — shows existing + allows adding new
  // ============================================================
  Widget _buildPhotoSection(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final photos = _photoUrls.take(10).toList();

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
                    _isUploadingPhotos ? 'Uploading…' : 'Add more photos',
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
                            _photoUrls.remove(url);
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

  Future<void> _pickPhotos() async {
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

      safeSetState(() => _isUploadingPhotos = true);

      final urls = <String>[];

      try {
        for (final media in selectedMedia) {
          final bytes = media.bytes;
          if (bytes == null) continue;
          final uploaded = await _uploadToImgBB(
              bytes, media.storagePath.split('/').last);
          if (uploaded != null) urls.add(uploaded);
        }
      } finally {
        _isUploadingPhotos = false;
      }

      safeSetState(() {
        _photoUrls.addAll(urls);
      });

      if (urls.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No photos uploaded')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  Future<String?> _uploadToImgBB(Uint8List bytes, String filename) async {
    if (_imgbbApiKey.isEmpty) {
      print('❌ ImgBB API key missing.');
      return null;
    }
    try {
      final uri = Uri.parse(
        'https://api.imgbb.com/1/upload?key=$_imgbbApiKey',
      );
      final base64Image = base64Encode(bytes);
      final response = await http
          .post(uri, body: {'image': base64Image, 'name': filename})
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          return json['data']['display_url'] as String? ??
              json['data']['url'] as String?;
        }
      }
      print('ImgBB upload failed: ${response.statusCode}');
      return null;
    } catch (e) {
      print('ImgBB upload exception: $e');
      return null;
    }
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================
  Widget _textField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
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

  Widget _dropdown(
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
            value: items.contains(value) ? value : null,
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
                .map((v) => DropdownMenuItem<String>(
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
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _switchRow(
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
  // SAVE BUTTON
  // ============================================================
  Widget _saveButton(BuildContext context, InventoryRecord product) {
    final theme = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: FFButtonWidget(
        onPressed: () => _save(product),
        text: 'Save Changes',
        icon: const Icon(Icons.save_rounded, size: 20),
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

  Future<void> _save(InventoryRecord product) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product name cannot be empty')),
      );
      return;
    }
    if (_photoUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 1 photo')),
      );
      return;
    }

    try {
      final price = double.tryParse(_priceController.text.trim());
      final stock = int.tryParse(_stockController.text.trim()) ?? 1;

      await product.reference.update({
        'inventory_name': name,
        'inventory_description': _descriptionController.text.trim(),
        'inventory_price': price ?? product.inventoryPrice,
        'inventory_images': _photoUrls,
        'available_colors': _splitCsv(_colorController.text),
        'available_alphasize': _splitCsv(_sizeController.text),
        'materials': _splitCsv(_materialController.text),
        // 'brand': _brandController.text.trim(),  // schema has no brand field
        'condition': _conditionValue,
        'gender': _genderValue,
        'shipping_days': _shippingDaysValue,
        'location': _locationController.text.trim(),
        'seller_whatsap': _whatsappController.text.trim(),
        'seller_number': _callController.text.trim(),
        'top_selling': _trending,
        'new_in': _newArrival,
        'all_products': _showInAll,
        // 'stock': stock,  // schema has no stock field
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully')),
      );

      context.safePop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save: $e')),
      );
    }
  }

  List<String> _splitCsv(String text) {
    return text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
}