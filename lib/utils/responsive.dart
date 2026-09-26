import 'package:flutter/material.dart';

/// Responsive breakpoints + helper methods for ZanNext.
/// Makes every page adapt to phone / tablet / desktop.
class Responsive {
  // ═══════════════════════════════════════════════════════
  // BREAKPOINTS
  // ═══════════════════════════════════════════════════════
  static const double phoneMax = 600;
  static const double tabletMax = 1024;

  static bool isPhone(BuildContext c) =>
      MediaQuery.of(c).size.width < phoneMax;

  static bool isTablet(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    return w >= phoneMax && w < tabletMax;
  }

  static bool isDesktop(BuildContext c) =>
      MediaQuery.of(c).size.width >= tabletMax;

  // ═══════════════════════════════════════════════════════
  // GRID COLUMNS
  // ═══════════════════════════════════════════════════════
  static int productCols(BuildContext c) {
    if (isPhone(c)) return 2;
    if (isTablet(c)) return 3;
    return 4;
  }

  static int categoryCols(BuildContext c) {
    if (isPhone(c)) return 5;
    if (isTablet(c)) return 8;
    return 10;
  }

  static int trendingCols(BuildContext c) {
    if (isPhone(c)) return 2;
    if (isTablet(c)) return 3;
    return 4;
  }

  // ═══════════════════════════════════════════════════════
  // SPACING
  // ═══════════════════════════════════════════════════════
  static double horizontalPad(BuildContext c) {
    if (isPhone(c)) return 16;
    if (isTablet(c)) return 24;
    return 32;
  }

  static double sectionGap(BuildContext c) {
    if (isPhone(c)) return 20;
    if (isTablet(c)) return 28;
    return 32;
  }

  static double cardGap(BuildContext c) {
    if (isPhone(c)) return 8;
    if (isTablet(c)) return 12;
    return 14;
  }

  // ═══════════════════════════════════════════════════════
  // SIZING
  // ═══════════════════════════════════════════════════════
  static double categoryTileSize(BuildContext c) {
    if (isPhone(c)) return 52;
    if (isTablet(c)) return 68;
    return 76;
  }

  static double trendingItemHeight(BuildContext c) {
    if (isPhone(c)) return 245;
    if (isTablet(c)) return 300;
    return 340;
  }

  static double trendingItemWidth(BuildContext c) {
    if (isPhone(c)) return 165;
    if (isTablet(c)) return 200;
    return 230;
  }

  static double bannerHeight(BuildContext c) {
    if (isPhone(c)) return 165;
    if (isTablet(c)) return 220;
    return 260;
  }

  // ═══════════════════════════════════════════════════════
  // FONTS
  // ═══════════════════════════════════════════════════════
  static double bodySize(BuildContext c) {
    if (isPhone(c)) return 14;
    if (isTablet(c)) return 15;
    return 16;
  }

  static double titleSize(BuildContext c) {
    if (isPhone(c)) return 17;
    if (isTablet(c)) return 19;
    return 22;
  }

  static double priceSize(BuildContext c) {
    if (isPhone(c)) return 14;
    if (isTablet(c)) return 16;
    return 18;
  }

  // ═══════════════════════════════════════════════════════
  // MAX CONTENT WIDTH (for desktop — prevent stretched look)
  // ═══════════════════════════════════════════════════════
  static double maxContentWidth(BuildContext c) {
    if (isPhone(c)) return double.infinity;
    if (isTablet(c)) return double.infinity;
    return 1400; // cap at 1400px on huge monitors
  }

  static double cardAspectRatio(BuildContext c) {
    if (isPhone(c)) return 0.62;
    if (isTablet(c)) return 0.68;
    return 0.72;
  }
}
