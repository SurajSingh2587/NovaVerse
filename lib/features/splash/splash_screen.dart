import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/settings_provider.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    // Load settings
    await context.read<SettingsProvider>().loadSettings();
    
    // Wait for animations
    await Future.delayed(const Duration(milliseconds: 3000));
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => 
            const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              AppColors.primary.withOpacity(0.15),
              AppColors.background,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(20, (index) => _buildParticle(index)),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.stream_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .scale(
                        duration: 800.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 500.ms),
                  
                  const SizedBox(height: 32),
                  
                  // Title
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        AppColors.accent,
                        AppColors.primary,
                        AppColors.accentPink,
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'NovaVerse',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 600.ms)
                      .slideY(begin: 0.3, duration: 600.ms),
                  
                  const SizedBox(height: 8),
                  
                  // Tagline
                  Text(
                    'Stream Anywhere, Everywhere',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary.withOpacity(0.8),
                      letterSpacing: 1,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms),
                  
                  const SizedBox(height: 60),
                  
                  // Loading indicator
                  SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            backgroundColor: AppColors.surfaceLighter,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .shimmer(
                              duration: 1500.ms,
                              color: AppColors.accent.withOpacity(0.3),
                            ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textTertiary,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 800.ms),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Version info at bottom
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Text(
                'Version 1.0.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary.withOpacity(0.5),
                ),
              )
                  .animate()
                  .fadeIn(delay: 1000.ms, duration: 500.ms),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildParticle(int index) {
    final random = index * 17 % 100;
    final size = 3.0 + (random % 5);
    final left = (random * 3.7) % 100;
    final top = (random * 2.3) % 100;
    final delay = Duration(milliseconds: random * 30);
    final duration = Duration(milliseconds: 2000 + (random * 20));
    
    return Positioned(
      left: MediaQuery.of(context).size.width * left / 100,
      top: MediaQuery.of(context).size.height * top / 100,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index % 3 == 0
              ? AppColors.primary.withOpacity(0.6)
              : index % 3 == 1
                  ? AppColors.accent.withOpacity(0.4)
                  : AppColors.accentPink.withOpacity(0.4),
          boxShadow: [
            BoxShadow(
              color: (index % 3 == 0
                      ? AppColors.primary
                      : index % 3 == 1
                          ? AppColors.accent
                          : AppColors.accentPink)
                  .withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      )
          .animate(
            delay: delay,
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .fadeIn(duration: 500.ms)
          .then()
          .moveY(
            begin: 0,
            end: -20 - (random % 30).toDouble(),
            duration: duration,
            curve: Curves.easeInOut,
          )
          .fadeOut(delay: duration - 500.ms),
    );
  }
}
