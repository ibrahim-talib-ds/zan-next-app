// ZanNext — Product badge helper
//
// Returns the correct badge widget for a product based on its flags.
// Priority: BOOSTED > TRENDING > NEW.
// Returns null if none apply.

import 'package:flutter/material.dart';
import '/backend/schema/inventory_record.dart';

Widget? productBadge(BuildContext context, InventoryRecord r) {
  if (r.boosted) return _badge(
    icon: Icons.star_rounded,
    text: 'BOOSTED',
    bg: const Color(0xFFFFB300),
  );
  if (r.topSelling) return _badge(
    icon: Icons.trending_up_rounded,
    text: 'TRENDING',
    bg: const Color(0xFFDC0F0F),
  );
  if (r.newIn) return _badge(
    icon: Icons.fiber_new_rounded,
    text: 'NEW',
    bg: const Color(0xFF1B7A4E),
  );
  return null;
}

Widget _badge({
  required IconData icon,
  required String text,
  required Color bg,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 9),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
          ),
        ),
      ],
    ),
  );
}
