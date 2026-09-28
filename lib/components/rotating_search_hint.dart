import 'dart:async';
import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/internationalization.dart';

/// Rotating placeholder text for the Home search bar.
/// Pulls real product names from Boosted + Trending, merges them,
/// dedupes by document ID, sorts newest first, and cycles one
/// name every 4 seconds. Wraps at end. Falls back to a static hint
/// when there are no boosted / trending products.
class RotatingSearchHint extends StatefulWidget {
  const RotatingSearchHint({
    super.key,
    this.interval = const Duration(seconds: 4),
    this.maxNames = 30,
  });

  final Duration interval;
  final int maxNames;

  @override
  State<RotatingSearchHint> createState() => _RotatingSearchHintState();
}

class _RotatingSearchHintState extends State<RotatingSearchHint> {
  List<String> _names = <String>[];
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (_) {
      if (!mounted || _names.length <= 1) return;
      setState(() => _index = (_index + 1) % _names.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<List<String>> _loadNames() async {
    try {
      final boosted = await queryInventoryRecordOnce(
        queryBuilder: (r) => r.where('boosted', isEqualTo: true),
        limit: widget.maxNames,
      );
      final trending = await queryInventoryRecordOnce(
        queryBuilder: (r) => r.where('top_selling', isEqualTo: true),
        limit: widget.maxNames,
      );

      final seen = <String>{};
      final items = <InventoryRecord>[];
      for (final r in [...boosted, ...trending]) {
        if (seen.add(r.reference.id)) items.add(r);
      }

      DateTime stamp(InventoryRecord r) {
        try {
          final data = (r as dynamic).snapshotData;
          if (data is Map) {
            final v = data['created_at'] ??
                data['created_time'] ??
                data['createdAt'];
            if (v is DateTime) return v;
            if (v is String) return DateTime.tryParse(v) ?? DateTime(1970);
            if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
            if (v != null &&
                v.runtimeType.toString().contains('Timestamp')) {
              try { return (v as dynamic).toDate() as DateTime; } catch (_) {}
            }
          }
        } catch (_) {}
        return DateTime(1970);
      }

      items.sort((a, b) => stamp(b).compareTo(stamp(a)));

      return items
          .map((r) => r.inventoryName.trim())
          .where((n) => n.isNotEmpty)
          .take(widget.maxNames)
          .toList();
    } catch (_) {
      return <String>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return FutureBuilder<List<String>>(
      future: _loadNames(),
      builder: (context, snap) {
        final fetched = snap.data;
        if (fetched != null && fetched.isNotEmpty && _names.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() {
              _names = fetched;
              _index = 0;
            });
          });
        }

        final fallback =
            FFLocalizations.of(context).getText('home_search_hint');

        final hasNames = _names.isNotEmpty;
        final shownName = hasNames ? _names[_index % _names.length] : '';

        if (hasNames) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: Text(
              shownName,
              key: ValueKey(_index),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.bodyMedium.override(
                color: theme.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        return Text(
          fallback,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.bodyMedium.override(
            color: theme.secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}
