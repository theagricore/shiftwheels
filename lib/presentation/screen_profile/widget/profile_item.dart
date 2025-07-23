import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class NotificationListItem extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationListItem({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.zGrey.withOpacity(0.3),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1.2),
        child: Row(
          children: [
            Icon(
              Icons.notifications_none,
              color: AppColors.zPrimaryColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.zPrimaryColor,
              activeTrackColor: AppColors.zPrimaryColor.withOpacity(0.3),
              inactiveThumbColor: AppColors.zGrey[400],
              inactiveTrackColor: AppColors.zGrey[200],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDestructive
              ? AppColors.zred.withOpacity(0.5)
              : AppColors.zGrey.withOpacity(0.3),
          width: 0.8,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDestructive ? AppColors.zred : AppColors.zPrimaryColor,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}