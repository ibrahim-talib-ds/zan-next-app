import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'help_center_model.dart';
export 'help_center_model.dart';

class HelpCenterWidget extends StatefulWidget {
  const HelpCenterWidget({super.key});

  static String routeName = 'HelpCenter';
  static String routePath = '/helpCenter';

  @override
  State<HelpCenterWidget> createState() => _HelpCenterWidgetState();
}

class _HelpCenterWidgetState extends State<HelpCenterWidget> {
  late HelpCenterModel _model;

  static const Color kGreen = Color(0xFF1B7A4E);

  final List<Map<String, dynamic>> _faqs = const [
    {
      'icon': Icons.shopping_bag_outlined,
      'category': 'Buying',
      'q': 'How do I place an order?',
      'a': 'Browse products, tap the one you want, and click "Buy Now". Choose your delivery address and payment method, then confirm. You will get a notification when the seller accepts.',
    },
    {
      'icon': Icons.storefront_outlined,
      'category': 'Selling',
      'q': 'How do I become a seller?',
      'a': 'Go to your Profile, tap "Add Product", and follow the steps. You will need to verify your phone number. Once approved, your products go live within minutes.',
    },
    {
      'icon': Icons.local_shipping_outlined,
      'category': 'Delivery',
      'q': 'How long does delivery take?',
      'a': 'Delivery times vary by location. Inside Dar es Salaam: 1-2 days. Upcountry: 3-5 days. You will see an estimate at checkout before confirming your order.',
    },
    {
      'icon': Icons.payments_outlined,
      'category': 'Payments',
      'q': 'What payment methods are accepted?',
      'a': 'We accept M-Pesa, Tigo Pesa, Airtel Money, Halopesa, bank transfer, and card payments. Cash on delivery is available for select items.',
    },
    {
      'icon': Icons.assignment_return_outlined,
      'category': 'Returns',
      'q': 'Can I return a product?',
      'a': 'Yes. You can request a return within 3 days of delivery if the product is unused and in original packaging. Open the order, tap "Request Return", and follow the steps.',
    },
    {
      'icon': Icons.security_outlined,
      'category': 'Safety',
      'q': 'How do I know a seller is trustworthy?',
      'a': 'Look for the verified badge, check their ratings, and read buyer reviews. Always keep conversations inside the ZanNext chat — never share OTPs or personal PINs.',
    },
    {
      'icon': Icons.account_balance_wallet_outlined,
      'category': 'Wallet',
      'q': 'When do sellers get paid?',
      'a': 'Sellers receive payment within 24 hours after the buyer confirms delivery. Payouts go to the mobile money account registered on the seller profile.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HelpCenterModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 32),
                children: [
                  _buildContactRow(context),
                  const SizedBox(height: 24),
                  _sectionTitle(context, 'Frequently asked questions'),
                  const SizedBox(height: 12),
                  ...List.generate(_faqs.length, (i) {
                    final f = _faqs[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _faqCard(context, i, f),
                    );
                  }),
                  const SizedBox(height: 24),
                  _sectionTitle(context, 'Still need help?'),
                  const SizedBox(height: 12),
                  _buildContactCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(0, topPad + 8, 0, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primary, const Color(0xFF053020)],
          begin: AlignmentDirectional(0, -1),
          end: AlignmentDirectional(0, 1),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
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
              icon: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 22),
              onPressed: () => context.safePop(),
            ),
            const Spacer(),
            Text(
              'Help Center',
              style: theme.titleLarge.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 44),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _contactTile(
            context,
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Live Chat',
            sub: 'Reply in minutes',
            color: const Color(0xFF2563EB),
            onTap: () => context.pushNamed(SupportChatWidget.routeName),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _contactTile(
            context,
            icon: Icons.email_outlined,
            label: 'Email',
            sub: 'ibrahimutalibu@gmail.com',
            color: kGreen,
            onTap: () async {
              final uri = Uri.parse(
                'mailto:ibrahimutalibu@gmail.com'
                '?subject=ZanNext%20Support%20Request'
                '&body=Hello%20ZanNext%20team%2C%0A%0A'
                'My%20account%3A%20${Uri.encodeComponent(currentUserEmail)}',
              );
              try {
                await launchUrl(uri);
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not open email app'),
                    ),
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _contactTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String sub,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.alternate),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 10),
            Text(label,
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                  color: theme.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 2),
            Text(sub,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.bodySmall.override(
                  color: theme.secondaryText,
                  fontSize: 11.5,
                )),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
      children: [
        Container(width: 4, height: 16,
            decoration: BoxDecoration(
              color: theme.primary,
              borderRadius: BorderRadius.circular(2),
            )),
        const SizedBox(width: 8),
        Text(text,
            style: theme.titleMedium.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
              color: theme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
      ],
    );
  }

  Widget _faqCard(BuildContext context, int index, Map<String, dynamic> f) {
    final theme = FlutterFlowTheme.of(context);
    final expanded = _model.expandedIndex == index;
    final color = theme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => safeSetState(
          () => _model.expandedIndex = expanded ? null : index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: expanded ? color.withOpacity(0.4) : theme.alternate,
            width: expanded ? 1.4 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(f['icon'] as IconData, color: color, size: 17),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (f['category'] as String).toUpperCase(),
                        style: theme.bodySmall.override(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        f['q'] as String,
                        style: theme.bodyMedium.override(
                          color: theme.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: theme.secondaryText,
                  size: 22,
                ),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: 12),
              Container(height: 1, color: theme.alternate),
              const SizedBox(height: 12),
              Text(
                f['a'] as String,
                style: theme.bodyMedium.override(
                  color: theme.secondaryText,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primary, const Color(0xFF053020)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.support_agent_rounded, color: Colors.white, size: 30),
          const SizedBox(height: 10),
          const Text('Talk to a human',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 4),
          Text(
            'Our support team is available 24/7. Typical reply time is under 5 minutes.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.pushNamed(MessagelistWidget.routeName),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1.4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline,
                      color: Colors.white, size: 18),
                  label: const Text('Start Chat',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
