// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tudu/core/theme/app_theme.dart';
import 'package:tudu/presentation/bloc/auth/auth_cubit.dart';
import 'package:tudu/presentation/bloc/auth/auth_state.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonWidth = size.width * 0.55;
    final buttonHeight = size.height * 0.04;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final isError = state is AuthError;
        final errorMessage = isError ? (state).message : "";

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Divider
            Container(
              margin: EdgeInsets.symmetric(vertical: size.height * 0.04),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppTheme.transparent,
                            AppTheme.white.withOpacity(0.2),
                            AppTheme.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Google Button & Error Message
            SizedBox(
              width: buttonWidth,
              child: Column(
                children: [
                  // Button or Loader
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: isLoading
                        ? Container(
                            key: const ValueKey("loader"),
                            height: buttonHeight,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.white.withOpacity(0.1),
                                width: 1,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.white.withOpacity(0.08),
                                  AppTheme.white.withOpacity(0.04),
                                ],
                              ),
                            ),
                            child:  SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppTheme.highlight,
                                strokeWidth: 2.5,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                          )
                        : InkWell(
                            key: const ValueKey("google_button"),
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              context.read<AuthCubit>().signInWithGoogle();
                            },
                            child: Container(
                              height: buttonHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.white.withOpacity(0.1),
                                  width: 1,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.white.withOpacity(0.08),
                                    AppTheme.white.withOpacity(0.04),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                        'https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/google-color-icon.png',
                                        width: 16,
                                        height: 16,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return  Icon(
                                            Icons.account_circle,
                                            color: AppTheme.highlight,
                                            size: 12,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'Continue with Google',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.white,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),

                  // Error message container
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: size.height * 0.05,
                    margin: EdgeInsets.only(top: size.height * 0.01),
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.012,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.highlight.withOpacity(isError ? 0.1 : 0.0),
                      border: Border.all(
                        color: AppTheme.highlight.withOpacity(isError ? 0.3 : 0.0),
                        width: 1,
                      ),
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: isError ? 1.0 : 0.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Icon(
                            Icons.error_outline,
                            color: AppTheme.red,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage,
                              style: GoogleFonts.inter(
                                color: AppTheme.red,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
