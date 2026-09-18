import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    _startTimer();
  }

  Future<void> _startTimer() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.flightSearch,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientMiddle,
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // =========================
              // BACKGROUND CIRCLES
              // =========================

              Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),

              Positioned(
                bottom: -100,
                left: -80,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
              ),

              // =========================
              // MAIN CONTENT
              // =========================
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // =========================
                        // LOGO CONTAINER
                        // =========================

                        Container(
                          width: 125,
                          height: 125,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.18),
                                blurRadius: 30,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.flight_takeoff_rounded,
                            size: 65,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // =========================
                        // APP NAME
                        // =========================
                        const Text(
                          AppStrings.appName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // =========================
                        // TAGLINE
                        // =========================
                        Text(
                          AppStrings.appTagline,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 45),

                        // =========================
                        // LOADER
                        // =========================
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withValues(alpha: 0.95),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'Loading...',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.80),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // =========================
              // BOTTOM TEXT
              // =========================
              Positioned(
                left: 0,
                right: 0,
                bottom: 25,
                child: Text(
                  'Safe journey starts with SafMarg',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
