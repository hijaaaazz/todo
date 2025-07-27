import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tudu/core/theme/app_theme.dart';

class AnimatedLogoWidget extends StatefulWidget {
  const AnimatedLogoWidget({super.key});

  @override
  State<AnimatedLogoWidget> createState() => _AnimatedLogoWidgetState();
}

class _AnimatedLogoWidgetState extends State<AnimatedLogoWidget>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _tuSlideAnimation;
  late Animation<Offset> _duSlideAnimation;
  late Animation<Offset> _subtitleSlideAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Fade animation for overall appearance
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    ));

    // TU slides from left
    _tuSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    // DU slides from right
    _duSlideAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    // Subtitle slides up
    _subtitleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations with delay
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _textController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _textController]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo Section
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // "TU" part - slides from left
                  SlideTransition(
                    position: _tuSlideAnimation,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'T',
                            style: GoogleFonts.inter(
                              fontSize: 50,
                              fontWeight: FontWeight.w800,
                              color:AppTheme.highlight,
                              letterSpacing: -2,
                            ),
                          ),
                          TextSpan(
                            text: 'U',
                            style: GoogleFonts.inter(
                              fontSize: 50,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.white,
                              letterSpacing: -2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // "DU" part - slides from right
                  SlideTransition(
                    position: _duSlideAnimation,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'D',
                            style: GoogleFonts.inter(
                              fontSize: 50,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E6F9F),
                              letterSpacing: -2,
                            ),
                          ),
                          TextSpan(
                            text: 'U',
                            style: GoogleFonts.inter(
                              fontSize: 50,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.white,
                              letterSpacing: -2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Subtitle
              SlideTransition(
                position: _subtitleSlideAnimation,
                child: FadeTransition(
                  opacity: _textController,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // ignore: deprecated_member_use
                      color: AppTheme.white.withOpacity(0.05),
                    ),
                    child: Text(
                      'Manage your Tasks',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        // ignore: deprecated_member_use
                        color: AppTheme.white.withOpacity(0.8),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}