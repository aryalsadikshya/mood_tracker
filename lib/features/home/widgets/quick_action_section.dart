import 'package:flutter/material.dart';

import '../../../core/theme/app_colours.dart';
import '../../../core/theme/app_spacing.dart';
import 'dashboard_section_title.dart';
import 'quick_action_card.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        DashboardSectionTitle(title: "Quick Wellness Actions"),

        const SizedBox(height: AppSpacing.lg),

        SizedBox(
          height: 122,
          child: _QuickActionsList(),
        ),
      ],
    );
  }
}

class _QuickActionsList extends StatelessWidget {
  const _QuickActionsList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: const [
        QuickActionCard(
          title: "Breath",
          subtitle: "1 min",
          icon: Icons.air_rounded,
          color: AppColors.paleBlue,
        ),

        QuickActionCard(
          title: "Calm",
          subtitle: "Reset",
          icon: Icons.spa_rounded,
          color: AppColors.mint,
        ),
        QuickActionCard(
          title: "Rest",
          subtitle: "Pause",
          icon: Icons.nightlight_round,
          color: AppColors.lavender,
        ),
      ],
    );
  }
}