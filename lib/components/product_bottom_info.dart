import 'dart:async';
import 'package:flutter/material.dart';
import '/flutter_flow/internationalization.dart';

/// Rotating 3-state bottom info row (all-green, labelled).
/// Cycles every 3s:
///   ✓ {seller}          e.g. "Students Shop"
///   🚚 Delivering {n}   e.g. "Delivering 1-3 days"
///   🕐 Added {time}     e.g. "Added 4 hours ago"
class ProductBottomInfo extends StatefulWidget {
  const ProductBottomInfo({
    super.key,
    required this.sellerName,
    required this.shippingDays,
    this.createdAt,
    this.interval = const Duration(seconds: 3),
    this.fontSize = 9.5,
  });

  final String sellerName;
  final String shippingDays;
  final DateTime? createdAt;
  final Duration interval;
  final double fontSize;

  @override
  State<ProductBottomInfo> createState() => _ProductBottomInfoState();
}

class _ProductBottomInfoState extends State<ProductBottomInfo> {
  static const Color kGreen = Color(0xFF1B7A4E);

  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.interval, (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % 3);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _timeAgo() {
    final dt = widget.createdAt;
    if (dt == null) return FFLocalizations.of(context).getText('pb_just_now');
    final d = DateTime.now().difference(dt);
    if (d.inSeconds < 60) return FFLocalizations.of(context).getText('pb_just_now');
    if (d.inMinutes < 60) {
      final n = d.inMinutes;
      final unit = n == 1
          ? FFLocalizations.of(context).getText('pb_minute')
          : FFLocalizations.of(context).getText('pb_minutes');
      return '$n $unit';
    }
    if (d.inHours < 24) {
      final n = d.inHours;
      final unit = n == 1
          ? FFLocalizations.of(context).getText('pb_hour')
          : FFLocalizations.of(context).getText('pb_hours');
      return '$n $unit';
    }
    if (d.inDays < 7) {
      final n = d.inDays;
      final unit = n == 1
          ? FFLocalizations.of(context).getText('pb_day')
          : FFLocalizations.of(context).getText('pb_days');
      return '$n $unit';
    }
    if (d.inDays < 30) {
      final n = (d.inDays / 7).floor();
      final unit = n == 1
          ? FFLocalizations.of(context).getText('pb_week')
          : FFLocalizations.of(context).getText('pb_weeks');
      return '$n $unit';
    }
    if (d.inDays < 365) {
      final n = (d.inDays / 30).floor();
      final unit = n == 1
          ? FFLocalizations.of(context).getText('pb_month')
          : FFLocalizations.of(context).getText('pb_months');
      return '$n $unit';
    }
    final n = (d.inDays / 365).floor();
    final unit = n == 1
        ? FFLocalizations.of(context).getText('pb_year')
        : FFLocalizations.of(context).getText('pb_years');
    return '$n $unit';
  }

  @override
  Widget build(BuildContext context) {
    final seller = widget.sellerName.trim().isEmpty
        ? FFLocalizations.of(context).getText('pb_unknown_seller')
        : widget.sellerName.trim();

    final ship = widget.shippingDays.trim().isEmpty
        ? FFLocalizations.of(context).getText('pb_delivered_today')
        : '${FFLocalizations.of(context).getText('pb_delivering')} ${widget.shippingDays.trim()}';

    final timeLabel =
        '${FFLocalizations.of(context).getText('pb_added')} ${_timeAgo()}';

    final states = <Widget>[
      _row(const Icon(Icons.verified_rounded,       color: kGreen, size: 11), seller,    kGreen),
      _row(const Icon(Icons.local_shipping_rounded, color: kGreen, size: 11), ship,      kGreen),
      _row(const Icon(Icons.access_time_rounded,    color: kGreen, size: 11), timeLabel, kGreen),
    ];

    return SizedBox(
      height: 16,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: KeyedSubtree(key: ValueKey(_index), child: states[_index]),
      ),
    );
  }

  Widget _row(Widget iconWidget, String text, Color color) {
    return Row(
      children: [
        iconWidget,
        const SizedBox(width: 3),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
