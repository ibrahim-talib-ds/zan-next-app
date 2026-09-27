import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/internationalization.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'about_app_model.dart';
export 'about_app_model.dart';

class AboutAppWidget extends StatefulWidget {
  const AboutAppWidget({super.key});

  static String routeName = 'AboutApp';
  static String routePath = '/aboutApp';

  @override
  State<AboutAppWidget> createState() => _AboutAppWidgetState();
}

class _AboutAppWidgetState extends State<AboutAppWidget> {
  late AboutAppModel _model;

  static const String kVersion = '1.02.135';
  static const String kBuild   = '2026.09.20';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AboutAppModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 32),
                children: [
                  _buildLogoCard(context),
                  const SizedBox(height: 24),
                  _sectionTitle(context, FFLocalizations.of(context).getText('about_section_about')),
                  const SizedBox(height: 10),
                  _buildParagraph(context,
                      FFLocalizations.of(context).getText('about_desc')),
                  const SizedBox(height: 24),
                  _sectionTitle(context, FFLocalizations.of(context).getText('about_section_app_info')),
                  const SizedBox(height: 10),
                  _buildInfoCard(context, [
                    _infoRow(context, FFLocalizations.of(context).getText('about_info_version'), kVersion),
                    _infoRow(context, FFLocalizations.of(context).getText('about_info_build'), kBuild),
                    _infoRow(context, FFLocalizations.of(context).getText('about_info_platform'), 'Flutter 3.x'),
                    _infoRow(context, FFLocalizations.of(context).getText('about_info_region'), FFLocalizations.of(context).getText('about_region_value')),
                  ]),
                  const SizedBox(height: 24),
                  _sectionTitle(context, FFLocalizations.of(context).getText('about_section_legal')),
                  const SizedBox(height: 10),
                  _buildLinkCard(context, [
                    _linkRow(context, Icons.description_outlined, FFLocalizations.of(context).getText('about_terms')),
                    _linkRow(context, Icons.privacy_tip_outlined, FFLocalizations.of(context).getText('about_privacy')),
                    _linkRow(context, Icons.verified_outlined, FFLocalizations.of(context).getText('about_licenses')),
                  ]),
                  const SizedBox(height: 24),
                  _buildFooter(context),
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
              FFLocalizations.of(context).getText('about_title'),
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

  Widget _buildLogoCard(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      children: [
        Container(
          width: 96, height: 96,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primary, const Color(0xFF0A3A22)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.storefront_rounded,
              color: Colors.white, size: 48),
        ),
        const SizedBox(height: 14),
        Text('ZanNext',
            style: theme.headlineSmall.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
              color: theme.primaryText,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            )),
        const SizedBox(height: 4),
        Text('${FFLocalizations.of(context).getText('about_version_prefix')}$kVersion',
            style: theme.bodySmall.override(
              color: theme.secondaryText,
              fontSize: 12.5,
            )),
      ],
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
        Text(text.toUpperCase(),
            style: theme.bodySmall.override(
              color: theme.primaryText,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            )),
      ],
    );
  }

  Widget _buildParagraph(BuildContext context, String text) {
    final theme = FlutterFlowTheme.of(context);
    return Text(text,
        style: theme.bodyMedium.override(
          color: theme.secondaryText,
          fontSize: 14,
        ));
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        children: List.generate(children.length, (i) {
          return Column(
            children: [
              children[i],
              if (i < children.length - 1)
                Divider(height: 1, color: theme.alternate, indent: 16),
            ],
          );
        }),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: theme.bodyMedium.override(
                color: theme.secondaryText,
                fontSize: 13.5,
              )),
          Text(value,
              style: theme.bodyMedium.override(
                color: theme.primaryText,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }

  Widget _buildLinkCard(BuildContext context, List<Widget> children) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        children: List.generate(children.length, (i) {
          return Column(
            children: [
              children[i],
              if (i < children.length - 1)
                Divider(height: 1, color: theme.alternate, indent: 56),
            ],
          );
        }),
      ),
    );
  }

  Widget _linkRow(BuildContext context, IconData icon, String label) {
    final theme = FlutterFlowTheme.of(context);
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label${FFLocalizations.of(context).getText('about_coming_soon')}')),
        );
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
        child: Row(
          children: [
            Icon(icon, color: theme.primary, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: theme.bodyMedium.override(
                    color: theme.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            Icon(Icons.chevron_right_rounded,
                color: theme.secondaryText, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
      child: Column(
        children: [
          Text(FFLocalizations.of(context).getText('about_footer_made'),
              style: theme.bodySmall.override(
                color: theme.secondaryText,
                fontSize: 12,
              )),
          const SizedBox(height: 4),
          Text('${FFLocalizations.of(context).getText('about_footer_copyright_prefix')}${DateTime.now().year}${FFLocalizations.of(context).getText('about_footer_copyright_suffix')}',
              style: theme.bodySmall.override(
                color: theme.secondaryText,
                fontSize: 11,
              )),
        ],
      ),
    );
  }
}
