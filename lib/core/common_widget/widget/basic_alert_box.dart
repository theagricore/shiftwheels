import 'package:flutter/material.dart';
import 'basic_elevated_app_button.dart';

void showLogoutConfirmationDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are you sure you want to logout?'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actions: [
        Column(
          children: [
            TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        BasicElevatedAppButton(
          title: 'Sign Out',
          onPressed: () {
            Navigator.of(context).pop(); 
            onConfirm(); 
          },
          height: 45,
        ),
          ],
        )
      ],
    ),
  );
}

void showDeleteConfirmationDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete'),
      content: const Text('Are you sure you want to Delete?'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actions: [
        Column(
          children: [
            TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        BasicElevatedAppButton(
          title: 'Delete',
          onPressed: () {
            Navigator.of(context).pop(); 
            onConfirm(); 
          },
          height: 45,
        ),
          ],
        )
      ],
    ),
  );
}

