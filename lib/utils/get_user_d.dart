import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/presentation/bloc/auth/auth_cubit.dart';
import 'package:tudu/presentation/bloc/auth/auth_state.dart';

String? getAuthenticatedUserId(BuildContext context) {
  final authState = context.read<AuthCubit>().state;
  final userId = authState is Authenticated ? authState.user.id : null;
  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User not authenticated')),
    );
  }
  return userId;
}