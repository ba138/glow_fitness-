import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const SizedBox(height: 8),
        Center(
          child: Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.accentGradient,
                ),
                child: const Icon(Icons.person_rounded,
                    size: 52, color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                'Basit Ali',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'Premium member',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GlassCard(
          child: Row(
            children: [
              _bodyStat('Weight', '72', 'kg'),
              _divider(),
              _bodyStat('Height', '178', 'cm'),
              _divider(),
              _bodyStat('Age', '26', 'yrs'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              _tile(Icons.flag_rounded, 'Goals', AppColors.primary),
              _tile(Icons.notifications_rounded, 'Notifications',
                  AppColors.secondary),
              _tile(Icons.favorite_rounded, 'Health sync', AppColors.accent),
              _tile(Icons.settings_rounded, 'Settings', AppColors.lime,
                  last: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bodyStat(String label, String value, String unit) {
    return Expanded(
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 36,
        color: Colors.white.withValues(alpha: 0.12),
      );

  Widget _tile(IconData icon, String label, Color color, {bool last = false}) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color.withValues(alpha: 0.18),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(Icons.chevron_right_rounded,
              color: AppColors.textMuted),
          onTap: () {},
        ),
        if (!last)
          Divider(
            height: 1,
            indent: 72,
            endIndent: 16,
            color: Colors.white.withValues(alpha: 0.08),
          ),
      ],
    );
  }
}
