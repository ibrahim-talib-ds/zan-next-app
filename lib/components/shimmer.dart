// ZanNext — Shimmer loading skeletons
import 'package:flutter/material.dart';

/// A pulsing grey box. Use width/height/borderRadius to shape it.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
  });
  final double? width;
  final double? height;
  final double borderRadius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);
    final hi   = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFF3F4F6);
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2 * t, 0),
              end:   Alignment( 1.0 + 2 * t, 0),
              colors: [base, hi, base],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton row for notifications / messages / orders
class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final border = isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 46, height: 46, borderRadius: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerBox(width: 180, height: 14),
                SizedBox(height: 8),
                ShimmerBox(width: double.infinity, height: 11),
                SizedBox(height: 6),
                ShimmerBox(width: 120, height: 11),
                SizedBox(height: 8),
                ShimmerBox(width: 60, height: 9, borderRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton list (N rows)
class ShimmerListView extends StatelessWidget {
  const ShimmerListView({super.key, this.count = 4, this.padding});
  final int count;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: count,
      itemBuilder: (_, __) => const ShimmerListTile(),
    );
  }
}

/// Skeleton for product grids (2 cols, like Home)
class ShimmerProductGrid extends StatelessWidget {
  const ShimmerProductGrid({super.key, this.count = 6, this.padding});
  final int count;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final border = isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

    return GridView.builder(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 16, 16, 24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemCount: count,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(
              child: ShimmerBox(
                width: double.infinity,
                height: double.infinity,
                borderRadius: 8,
              ),
            ),
            SizedBox(height: 8),
            ShimmerBox(width: 120, height: 12),
            SizedBox(height: 6),
            ShimmerBox(width: 80, height: 12),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for horizontal product carousels (like Home's sections)
class ShimmerProductRow extends StatelessWidget {
  const ShimmerProductRow({super.key, this.height = 210});
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final border = isDark ? const Color(0xFF2A2A2C) : const Color(0xFFE5E7EB);

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, __) => Container(
          width: 160,
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: ShimmerBox(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: 8,
                ),
              ),
              SizedBox(height: 8),
              ShimmerBox(width: 120, height: 12),
              SizedBox(height: 6),
              ShimmerBox(width: 80, height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
