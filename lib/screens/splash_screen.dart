// lib/screens/splash_screen.dart
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ──────────────────────────────────────────────
  late AnimationController _introController;
  late AnimationController _ambientController;
  late AnimationController _loaderController;

  // ── Cinematic Animations ───────────────────────────────────────
  late Animation<double> _logoScale;
  late Animation<double> _logoRotate;
  late Animation<double> _logoOpacity;

  late Animation<double> _textSpacing;
  late Animation<double> _textBlur;
  late Animation<double> _textOpacity;
  late Animation<double> _textShimmer;

  late Animation<double> _taglineOpacity;
  late Animation<double> _lineWidth;

  @override
  void initState() {
    super.initState();

    // 1. Setup Controllers
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 3200,
      ), // Longer duration for full reveal
    );

    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // 2. Define Cinematic Tweens
    // Phase 1: Logo 3D Drop-in
    _logoScale = Tween<double>(begin: 1.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );
    _logoRotate = Tween<double>(begin: -math.pi / 3, end: 0.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutQuart),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Phase 2: Cinematic Text Snap & Sweep
    _textSpacing = Tween<double>(begin: 25.0, end: -0.5).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOutExpo),
      ),
    );
    _textBlur = Tween<double>(begin: 15.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.3, 0.5, curve: Curves.easeIn),
      ),
    );
    _textShimmer = Tween<double>(begin: -0.5, end: 1.5).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.4, 0.85, curve: Curves.easeInOutSine),
      ),
    );

    // Phase 3: Tagline & Lines Expand
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );
    _lineWidth = Tween<double>(begin: 0.0, end: 40.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // 3. Start the Show
    _introController.forward();

    // 4. Trigger Navigation to Login
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted) _navigateToLogin();
    });
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _introController.dispose();
    _ambientController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Background & Particles ──
          _buildBackground(),
          AnimatedBuilder(
            animation: _ambientController,
            builder: (_, __) => CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _ParticlePainter(_ambientController.value),
            ),
          ),

          // ── Cinematic Foreground ──
          Center(
            child: AnimatedBuilder(
              animation: _introController,
              builder: (context, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 3D Logo Reveal
                    _buildLogo(),

                    const SizedBox(height: 35),

                    // Cinematic Tracking Text
                    _buildTitleText(),

                    const SizedBox(height: 12),

                    // Expanding Tagline
                    _buildTagline(),

                    const SizedBox(height: 70),

                    // Minimalist Loader
                    _buildLoader(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // DYNAMIC WIDGET BUILDERS
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildLogo() {
    return Opacity(
      opacity: _logoOpacity.value,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..rotateX(_logoRotate.value)
          ..scale(_logoScale.value),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient glowing rings
            AnimatedBuilder(
              animation: _ambientController,
              builder: (_, __) {
                final t = _ambientController.value;
                final pulse = (math.sin(t * math.pi * 4) + 1) / 2;
                return Container(
                  width: 140 + pulse * 20,
                  height: 140 + pulse * 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.neonCyan.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                );
              },
            ),

            // Core Logo Card
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A2A4A), Color(0xFF051525)],
                ),
                border: Border.all(
                  color: AppColors.neonCyan.withOpacity(0.8),
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonCyan.withOpacity(0.4),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.grain_rounded,
                  color: AppColors.neonCyan,
                  size: 56,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    return Opacity(
      opacity: _textOpacity.value,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: _textBlur.value,
          sigmaY: _textBlur.value,
        ),
        child: ShaderMask(
          shaderCallback: (bounds) {
            // Sweeping light effect across the text
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                _textShimmer.value - 0.2,
                _textShimmer.value,
                _textShimmer.value + 0.2,
              ],
              colors: [Colors.white, AppColors.neonCyan, Colors.white],
            ).createShader(bounds);
          },
          child: Text(
            'WoolVision AI',
            style: GoogleFonts.dmSans(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: _textSpacing.value,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return Opacity(
      opacity: _taglineOpacity.value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Left expanding line
          Container(
            width: _lineWidth.value,
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.neonCyan.withOpacity(0.8),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'SMART FIBER INTELLIGENCE',
            style: GoogleFonts.dmMono(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 3.5,
            ),
          ),
          const SizedBox(width: 14),
          // Right expanding line
          Container(
            width: _lineWidth.value,
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.neonCyan.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoader() {
    return Opacity(
      opacity: _taglineOpacity.value,
      child: AnimatedBuilder(
        animation: _loaderController,
        builder: (_, __) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              final delay = index * 0.2;
              final t = (_loaderController.value - delay) % 1.0;
              final size = 6.0 + (math.sin(t * math.pi) * 4.0).clamp(0.0, 4.0);
              final opacity =
                  0.3 + (math.sin(t * math.pi) * 0.7).clamp(0.0, 0.7);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: AppColors.neonCyan.withOpacity(opacity),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonCyan.withOpacity(opacity * 0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _ambientController,
      builder: (_, __) {
        final t = _ambientController.value;
        final breathe = math.sin(t * math.pi * 2) * 0.02;

        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(color: AppColors.background),
            ),
            Positioned(
              top: -100,
              left: -100,
              child: Transform.scale(
                scale: 1.0 + breathe,
                child: Container(
                  width: 450,
                  height: 450,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.neonCyan.withOpacity(0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              right: -100,
              child: Transform.scale(
                scale: 1.0 - breathe,
                child: Container(
                  width: 550,
                  height: 550,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.neonPurple.withOpacity(0.07),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// ORGANIC PARTICLE SYSTEM
// ────────────────────────────────────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  final double t;
  final List<_Particle> particles;

  _ParticlePainter(this.t) : particles = List.generate(35, (i) => _Particle(i));

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

    for (final p in particles) {
      final dy =
          (p.y * size.height - (t * p.speedMult * size.height)) % size.height;
      final sway = math.sin(t * math.pi * 2 * p.swaySpeed + p.swayOffset) * 30;
      final dx = p.x * size.width + sway;

      paint.color = AppColors.neonCyan.withOpacity(p.opacity);
      canvas.drawCircle(Offset(dx, dy), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}

class _Particle {
  late double x, y, radius, opacity;
  late double speedMult, swaySpeed, swayOffset;

  _Particle(int seed) {
    final rng = math.Random(seed * 11 + 7);
    x = rng.nextDouble();
    y = rng.nextDouble();
    radius = 1.0 + rng.nextDouble() * 2.5;
    opacity = 0.1 + rng.nextDouble() * 0.3;

    speedMult = (rng.nextInt(3) + 1).toDouble();
    swaySpeed = (rng.nextInt(2) + 1).toDouble();
    swayOffset = rng.nextDouble() * math.pi * 2;
  }
}
