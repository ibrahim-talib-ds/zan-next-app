import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'buy_now_sheet_model.dart';
export 'buy_now_sheet_model.dart';

/// Advanced "Buy Now" sheet — collects delivery address + phone,
/// creates the order, then navigates to the tracking screen.
class BuyNowSheetWidget extends StatefulWidget {
  const BuyNowSheetWidget({super.key, required this.product});

  final InventoryRecord product;

  @override
  State<BuyNowSheetWidget> createState() => _BuyNowSheetWidgetState();
}

class _BuyNowSheetWidgetState extends State<BuyNowSheetWidget> {
  late BuyNowSheetModel _model;

  static const Color kGreen = Color(0xFF1B7A4E);
  static const Color kGreenDeep = Color(0xFF0A3A22);
  static const Color kRed = Color(0xFFDC0F0F);
  static const Color kAmber = Color(0xFFFFB300);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg     => _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F8);
  Color get _card   => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _soft   => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFF0F2F5);
  Color get _text   => _isDark ? Colors.white : const Color(0xFF111827);
  Color get _muted  => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get _border => _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

  String _imgUrl(String? url) {
    final u = (url ?? '').trim();
    if (u.isEmpty) return '';
    return u.startsWith('http://') ? u.replaceFirst('http://', 'https://') : u;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BuyNowSheetModel());
    _model.phoneController ??=
        TextEditingController(text: currentPhoneNumber);
    _model.phoneFocusNode ??= FocusNode();
    _model.notesController ??= TextEditingController();
    _model.notesFocusNode ??= FocusNode();
    _model.customPhone = currentPhoneNumber;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: Container(
        color: _bg,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(),
              _buildHeader(),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16, 8, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductSummary(),
                      const SizedBox(height: 20),
                      _buildAddressSection(),
                      const SizedBox(height: 20),
                      _buildPhoneSection(),
                      const SizedBox(height: 20),
                      _buildNotesSection(),
                      const SizedBox(height: 20),
                      _buildPriceSummary(),
                      const SizedBox(height: 20),
                      _buildPlaceOrderBtn(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HANDLE + HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _buildHandle() => Container(
        margin: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 4),
        width: 44,
        height: 4,
        decoration: BoxDecoration(
          color: _border,
          borderRadius: BorderRadius.circular(2),
        ),
      );

  Widget _buildHeader() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.shopping_cart_checkout_rounded,
                  color: kGreen, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Confirm Order',
                      style: TextStyle(
                        color: kGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      )),
                  const SizedBox(height: 2),
                  Text(
                    'Review before placing',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            FlutterFlowIconButton(
              borderRadius: 8,
              buttonSize: 40,
              fillColor: Colors.transparent,
              icon: Icon(Icons.close_rounded, color: _text, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

  // ═══════════════════════════════════════════════════════════
  // PRODUCT SUMMARY
  // ═══════════════════════════════════════════════════════════
  Widget _buildProductSummary() {
    final p = widget.product;
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _soft,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(4),
            child: Image.network(
              _imgUrl(valueOrDefault<String>(
                  p.inventoryImages.firstOrNull, '')),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  color: _muted,
                  size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valueOrDefault<String>(p.inventoryName, 'Product'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  valueOrDefault<String>(
                    formatNumber(
                      p.inventoryPrice,
                      formatType: FormatType.decimal,
                      decimalType: DecimalType.automatic,
                      currency: 'TZS ',
                    ),
                    'TZS 0',
                  ),
                  style: const TextStyle(
                    color: kGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ADDRESS SECTION — live from address collection
  // ═══════════════════════════════════════════════════════════
  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Delivery Address'),
        const SizedBox(height: 10),
        StreamBuilder<List<AddressRecord>>(
          stream: queryAddressRecord(
            queryBuilder: (r) => r.where('user',
                isEqualTo: currentUserReference),
          ),
          builder: (context, snap) {
            if (!snap.hasData) {
              return Container(
                height: 60,
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _border),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(kGreen),
                    ),
                  ),
                ),
              );
            }
            final addresses = snap.data!;
            if (addresses.isEmpty) {
              return Container(
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kAmber.withOpacity(0.4), width: 1.4),
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: kAmber, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('No address yet',
                              style: TextStyle(
                                color: _text,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              )),
                          const SizedBox(height: 2),
                          Text('Add one to continue',
                              style: TextStyle(
                                  color: _muted, fontSize: 11.5)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await context
                            .pushNamed(AddNewadressWidget.routeName);
                        safeSetState(() {});
                      },
                      child: const Text('Add',
                          style: TextStyle(
                            color: kGreen,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                  ],
                ),
              );
            }

            // Auto-select first address
            if (_model.selectedAddress == null) {
              _model.selectedAddress = addresses.first;
            }

            return Column(
              children: addresses.map((a) {
                final selected = _model.selectedAddress?.reference ==
                    a.reference;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => safeSetState(
                        () => _model.selectedAddress = a),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: selected
                            ? kGreen.withOpacity(0.08)
                            : _card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? kGreen : _border,
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: selected ? kGreen : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected ? kGreen : _muted,
                                width: 2,
                              ),
                            ),
                            child: selected
                                ? const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 13)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      a.label == 'Office'
                                          ? Icons.work_outline_rounded
                                          : Icons.home_rounded,
                                      size: 14,
                                      color: kGreen,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      valueOrDefault<String>(
                                          a.label, 'Address'),
                                      style: TextStyle(
                                        color: _text,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  [
                                    a.city,
                                    a.district,
                                    a.streetAddress,
                                    a.houseNo,
                                  ]
                                      .where((s) => s.isNotEmpty)
                                      .join(', '),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: _muted,
                                    fontSize: 12,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PHONE SECTION
  // ═══════════════════════════════════════════════════════════
  Widget _buildPhoneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Contact Phone'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
          ),
          padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
          child: Row(
            children: [
              const Icon(Icons.phone_outlined, color: kGreen, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _model.phoneController,
                  focusNode: _model.phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: _text, fontSize: 14.5),
                  cursorColor: kGreen,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: '712 345 678',
                    hintStyle: TextStyle(color: _muted, fontSize: 14),
                    contentPadding: const EdgeInsetsDirectional.fromSTEB(
                        0, 16, 0, 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // NOTES
  // ═══════════════════════════════════════════════════════════
  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Delivery Notes (optional)'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
          ),
          child: TextField(
            controller: _model.notesController,
            focusNode: _model.notesFocusNode,
            maxLines: 3,
            minLines: 2,
            maxLength: 150,
            style: TextStyle(color: _text, fontSize: 13.5, height: 1.4),
            cursorColor: kGreen,
            decoration: InputDecoration(
              isDense: true,
              hintText: 'e.g. Blue house near the mosque',
              hintStyle: TextStyle(color: _muted, fontSize: 13.5),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsetsDirectional.fromSTEB(14, 14, 14, 14),
              counterStyle: TextStyle(color: _muted, fontSize: 10.5),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PRICE SUMMARY
  // ═══════════════════════════════════════════════════════════
  Widget _buildPriceSummary() {
    final price = widget.product.inventoryPrice;
    const deliveryFee = 0.0;
    final total = price + deliveryFee;

    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _priceRow('Product price',
              formatNumber(price,
                  formatType: FormatType.decimal,
                  decimalType: DecimalType.automatic,
                  currency: 'TZS ')),
          const SizedBox(height: 6),
          _priceRow('Delivery', 'Free'),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: TextStyle(
                    color: _text,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  )),
              Text(
                formatNumber(total,
                    formatType: FormatType.decimal,
                    decimalType: DecimalType.automatic,
                    currency: 'TZS '),
                style: const TextStyle(
                  color: kGreen,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: kAmber.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payments_outlined, color: kAmber, size: 14),
                SizedBox(width: 6),
                Text('Cash on Delivery',
                    style: TextStyle(
                      color: kAmber,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(color: _muted, fontSize: 13)),
        Text(value,
            style: TextStyle(
              color: _text,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            )),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PLACE ORDER
  // ═══════════════════════════════════════════════════════════
  Widget _buildPlaceOrderBtn() {
    final enabled = _model.selectedAddress != null &&
        !_model.isPlacing;

    return GestureDetector(
      onTap: enabled ? _placeOrder : null,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: enabled ? kGreen : _muted,
          borderRadius: BorderRadius.circular(14),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: kGreen.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: _model.isPlacing
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text('Place Order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        )),
                  ],
                ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PLACE ORDER LOGIC
  // ═══════════════════════════════════════════════════════════
  Future<void> _placeOrder() async {
    if (_model.selectedAddress == null) return;
    if (currentUserReference == null) return;

    // 🚫 Block buying your own product
    if (widget.product.sellersRef == currentUserReference) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You can't buy your own product."),
          backgroundColor: Color(0xFFDC0F0F),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final phone = _model.phoneController?.text.trim() ?? '';
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Enter a valid phone number'),
          backgroundColor: kRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    safeSetState(() => _model.isPlacing = true);

    try {
      final p = widget.product;
      final address = _model.selectedAddress!;

      // Build full address string
      final addressString = [
        address.houseNo,
        address.streetAddress,
        address.district,
        address.city,
      ].where((s) => s.isNotEmpty).join(', ');

      // 1. Create the order
      final orderRef = OrdersRecord.collection.doc();
      await orderRef.set({
        ...createOrdersRecordData(
          buyer: currentUserReference,
          seller: p.sellersRef,
          productRef: p.reference,
          productName: p.inventoryName,
          price: p.inventoryPrice,
          status: 'Pending',
          date: getCurrentTimestamp,
          address: addressString,
        ),
        ...mapToFirestore({
          'Item_images': [
            valueOrDefault<String>(
              p.inventoryImages.firstOrNull,
              'https://static.thenounproject.com/png/4974686-200.png',
            )
          ],
          'buyer_phone': phone,
          'buyer_notes': _model.notesController?.text.trim() ?? '',
          'buyer_name': currentUserDisplayName,
          'seller_name': p.sellerName,
          'status_history': [
            {
              'status': 'Pending',
              'timestamp': DateTime.now().toIso8601String(),
              'note': 'Order placed',
            }
          ],
        }),
      });

      // 2. Notify the seller
      if (p.sellersRef != null) {
        await NotificationsRecord.collection.doc().set({
          ...createNotificationsRecordData(
            title: 'New Order Received',
            notificationText:
                '${currentUserDisplayName} ordered "${p.inventoryName}"',
            userRef: p.sellersRef,
            isRead: false,
            date: getCurrentTimestamp,
            createdTime: getCurrentTimestamp,
            avater: currentUserPhoto,
            productId: orderRef.id,
          ),
        });
      }

      // 3. Also notify the buyer
      await NotificationsRecord.collection.doc().set({
        ...createNotificationsRecordData(
          title: 'Order Placed',
          notificationText:
              'Your order for "${p.inventoryName}" was placed successfully.',
          userRef: currentUserReference,
          isRead: false,
          date: getCurrentTimestamp,
          createdTime: getCurrentTimestamp,
          avater: '',
          productId: orderRef.id,
        ),
      });

      if (!mounted) return;

      // 4. Success → navigate to tracking screen
      Navigator.pop(context); // close sheet
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;

      context.pushNamed(
        Order1Widget.routeName,
        queryParameters: {
          'orderRef':
              serializeParam(orderRef, ParamType.DocumentReference),
        }.withoutNulls,
      );
    } catch (e) {
      if (!mounted) return;
      safeSetState(() => _model.isPlacing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
          backgroundColor: kRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════
  Widget _sectionTitle(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: kGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(text,
            style: TextStyle(
              color: _text,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            )),
      ],
    );
  }
}
