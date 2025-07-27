// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/core/theme/app_theme.dart';
import 'package:tudu/presentation/bloc/auth/auth_cubit.dart';
import 'package:tudu/presentation/widgets/bottom_sheet/action_button.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  void _logout(BuildContext context) {
    context.read<AuthCubit>().logOut();
    Navigator.of(context).pop(); // Close the dialog
  }

  void _cancel(BuildContext context) {
    Navigator.of(context).pop(); // Just close the dialog
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.red.withOpacity(0.2),
                  AppTheme.red.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child:  Icon(
              Icons.logout_rounded,
              color: AppTheme.red,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
           Text(
            'Logout',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Are you sure you want to log out? You will need to sign in again.',
            style: TextStyle(
              color: AppTheme.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ActionButtons(
            cancelText: 'Cancel',
            actionText: 'Logout',
            actionColor: AppTheme.red,
            onCancel: () => _cancel(context),
            onAction: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
