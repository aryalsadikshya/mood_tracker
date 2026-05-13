import 'package:flutter/material.dart';
import '../../core/theme/app_colours.dart';

class AvatarOption {
  final String id;
  final IconData icon;
  final Color color;

  const AvatarOption({
    required this.id,
    required this.icon,
    required this.color,
  });
}

const List<AvatarOption> mindBloomAvatars = [
  AvatarOption(
    id: "flower",
    icon: Icons.local_florist_rounded,
    color: AppColors.softPink,
  ),
  AvatarOption(
    id: "leaf",
    icon: Icons.eco_rounded,
    color: AppColors.mint,
  ),
  AvatarOption(
    id: "moon",
    icon: Icons.nightlight_round,
    color: AppColors.lavender,
  ),
  AvatarOption(
    id: "star",
    icon: Icons.auto_awesome_rounded,
    color: AppColors.paleBlue,
  ),
  AvatarOption(
    id: "sun",
    icon: Icons.wb_sunny_rounded,
    color: AppColors.warmYellow,
  ),
  AvatarOption(
    id: "calm",
    icon: Icons.spa_rounded,
    color: AppColors.blush,
  ),
];

AvatarOption getAvatarById(String? avatarId) {
  return mindBloomAvatars.firstWhere(
        (avatar) => avatar.id == avatarId,
    orElse: () => mindBloomAvatars.first,
  );
}