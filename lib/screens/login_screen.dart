// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import 'package:woolvision_ai/screens/main_nav.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController(text: 'hrishi@gmail.com');
  final _passwordController = TextEditingController(text: '123');
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMsg;

  late AnimationController _entryController;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _logoFade;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _cardFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entryController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    final provider = context.read<AppProvider>();
    final success = provider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // Updated navigation to route to MainNavScreen instead of DashboardScreen
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, anim, __) => const MainNavScreen(),
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(opacity: anim, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMsg = 'Invalid credentials. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  // Logo area
                  FadeTransition(
                    opacity: _logoFade,
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0A2A4A), Color(0xFF051525)],
                            ),
                            border: Border.all(
                              color: AppColors.neonCyan.withOpacity(0.4),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonCyan.withOpacity(0.25),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.grain_rounded,
                            color: AppColors.neonCyan,
                            size: 34,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [AppColors.neonCyan, Color(0xFFE0F7FA)],
                          ).createShader(bounds),
                          child: Text(
                            'WoolVision AI',
                            style: GoogleFonts.dmSans(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Sign in to continue',
                          style: GoogleFonts.dmSans(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 44),
                  // Login card
                  FadeTransition(
                    opacity: _cardFade,
                    child: SlideTransition(
                      position: _cardSlide,
                      child: GlassCard(
                        borderColor: AppColors.neonCyan.withOpacity(0.15),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome Back',
                                style: GoogleFonts.dmSans(
                                  color: AppColors.textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Enter your credentials to access the dashboard',
                                style: GoogleFonts.dmSans(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 28),
                              // Email field
                              _buildLabel('Email Address'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _emailController,
                                hint: 'you@example.com',
                                icon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Email is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              // Password field
                              _buildLabel('Password'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _passwordController,
                                hint: '••••••••',
                                icon: Icons.lock_outline_rounded,
                                obscure: _obscurePassword,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.textSecondary,
                                    size: 18,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                              ),
                              if (_errorMsg != null) ...[
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.red.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Colors.redAccent,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _errorMsg!,
                                        style: GoogleFonts.dmSans(
                                          color: Colors.redAccent,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 28),
                              // Login button
                              _isLoading
                                  ? Center(
                                      child: SizedBox(
                                        height: 50,
                                        child: Center(
                                          child: SizedBox(
                                            width: 26,
                                            height: 26,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: AppColors.neonCyan,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : NeonButton(
                                      label: 'Sign In',
                                      icon: Icons.arrow_forward_rounded,
                                      onTap: _handleLogin,
                                      gradient: AppColors.primaryGradient,
                                      glowColor: AppColors.neonCyan,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _cardFade,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.neonCyan.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.neonCyan.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.neonCyan.withOpacity(0.7),
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Demo: hrishi@gmail.com / 123',
                            style: GoogleFonts.dmSans(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.dmSans(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.dmSans(color: AppColors.textMuted, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 18),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.neonCyan.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.withOpacity(0.5), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        errorStyle: GoogleFonts.dmSans(color: Colors.redAccent, fontSize: 12),
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Container(color: AppColors.background),
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.neonCyan.withOpacity(0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -80,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.neonPurple.withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
