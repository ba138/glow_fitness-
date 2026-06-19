import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GlassNavItem {
  const GlassNavItem(this.icon, this.label);
  final IconData icon;
  final String label;
}

/// Floating frosted-glass bottom navigation bar.
class GlassBottomNav extends StatelessWidget {
  const GlassBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<GlassNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white.withValues(alpha: 0.10),
              border: Border.all(color: AppColors.glassStroke, width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < items.length; i++)
                  _NavButton(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final GlassNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: selected ? 18 : 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: selected ? AppColors.primaryGradient : null,
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 24,
              color: selected ? Colors.white : AppColors.textMuted,
            ),
            if (selected) ...[
              const SizedBox(width: 8),
              Text(
                item.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
