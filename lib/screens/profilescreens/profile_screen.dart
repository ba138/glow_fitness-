import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import 'goals_screen.dart';
import 'health_sync_screen.dart';
import 'personal_details_screen.dart';
import 'settings_screen.dart';
import 'subscription_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Get.put(ProfileController());

    return Obx(
      () => ListView(
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
                  child: const Icon(
                    Icons.person_rounded,
                    size: 52,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  profile.name.value,
                  style: const TextStyle(
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
            onTap: () => Get.to(() => const PersonalDetailsScreen()),
            child: Row(
              children: [
                _bodyStat('Weight', profile.formattedWeight, 'kg'),
                _divider(),
                _bodyStat(
                  'Height',
                  profile.formattedHeight,
                  profile.heightUnitLabel,
                ),
                _divider(),
                _bodyStat('Age', '${profile.age.value}', 'yrs'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                _tile(
                  Icons.edit_rounded,
                  'Personal details',
                  AppColors.amber,
                  onTap: () => Get.to(() => const PersonalDetailsScreen()),
                ),
                _tile(
                  Icons.flag_rounded,
                  'Goals',
                  AppColors.primary,
                  onTap: () => Get.to(() => const GoalsScreen()),
                ),
                _tile(
                  Icons.workspace_premium_rounded,
                  'Subscriptions',
                  AppColors.secondary,
                  onTap: () => Get.to(() => const SubscriptionScreen()),
                ),
                _tile(
                  Icons.favorite_rounded,
                  'Health sync',
                  AppColors.accent,
                  onTap: () => Get.to(() => const HealthSyncScreen()),
                ),
                _tile(
                  Icons.settings_rounded,
                  'Settings',
                  AppColors.lime,
                  onTap: () => Get.to(() => const SettingsScreen()),
                  last: true,
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget _tile(
    IconData icon,
    String label,
    Color color, {
    bool last = false,
    VoidCallback? onTap,
  }) {
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
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
          ),
          onTap: onTap,
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
