import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/responsive.dart';
import '../providers/auth_provider.dart';

/// Student Login Screen enforcing:
/// - Registration pattern: 24B91AXXXX (case-insensitive, 10 characters)
/// - Password match requirement: Password must be identical to the Registration Number
/// - High-vibrancy modern campus aesthetic with chromatic demo credentials.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _regNoController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _regNoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemo(String regNo) {
    setState(() {
      _regNoController.text = regNo;
      _passwordController.text = regNo;
      _errorMessage = null;
    });
  }

  Future<void> _handleLogin() async {
    final authProvider = context.read<AuthProvider>();
    final regNo = _regNoController.text.trim().toUpperCase();
    final password = _passwordController.text.trim();

    // Reset local error
    setState(() => _errorMessage = null);

    // Validate empty
    if (regNo.isEmpty) {
      setState(() => _errorMessage = 'Please enter your Registration Number.');
      return;
    }

    if (password.isEmpty) {
      setState(() => _errorMessage = 'Please enter your Password.');
      return;
    }

    // Pattern validation (24B91AXXXX)
    if (!AppConstants.studentRegNoRegex.hasMatch(regNo)) {
      setState(() {
        _errorMessage =
            'Registration number must follow the pattern: 24B91AXXXX\n'
            '(Must start with "24B91A" followed by 4 alphanumeric characters).';
      });
      return;
    }

    // Password matching validation
    if (password.toUpperCase() != regNo) {
      setState(() {
        _errorMessage =
            'Password must match your Registration Number ($regNo).';
      });
      return;
    }

    final error = await authProvider.login(regNo: regNo, password: password);
    if (error != null) {
      setState(() => _errorMessage = error);
    } else {
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Student Authentication',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.isMobile ? 20 : 32,
              vertical: context.isMobile ? 16 : 32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Container(
                padding: context.isMobile ? EdgeInsets.zero : const EdgeInsets.all(32),
                decoration: context.isMobile
                    ? null
                    : BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.cardBorderIndigo.withValues(alpha: 0.5), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      // Top Header Branding
                      Center(
                        child: Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.cardBorderIndigo, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/srkr_campus.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.school_rounded, color: AppColors.primary, size: 44),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'SRKR Engineering College',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Text(
                        'Student Transit Portal • Bhimavaram',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                      ),

                      const SizedBox(height: 24),

                      // Authentication Rules Alert Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFC7D2FE), width: 1.2),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 22),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Login Requirements:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '• Reg No Format: 24B91AXXXX (e.g. 24B91A0501)\n'
                                    '• Password: Same as your Registration Number\n'
                                    '• Display: Strictly displays only your designated bus',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textPrimary,
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Error Message Banner
                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF87171)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: Color(0xFFB91C1C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Field 1: Registration Number
                      const Text(
                        'Student Registration Number',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _regNoController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: 'e.g. 24B91A0501',
                          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                          prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.primary),
                          suffixIcon: _regNoController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () => setState(() => _regNoController.clear()),
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.cardBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.cardBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: 16),

                      // Field 2: Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                          if (_regNoController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _passwordController.text = _regNoController.text.trim().toUpperCase();
                                });
                              },
                              child: const Text(
                                'Fill Same as Reg No',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: 'Enter Registration Number as Password',
                          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.cardBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.cardBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Login Button with Vibrant Gradient
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: authProvider.isLoading ? null : _handleLogin,
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text(
                                  'AUTHENTICATE & VIEW ASSIGNED BUS',
                                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.6),
                                ),
                        ),
                      ),

                      const SizedBox(height: 26),

                      // Quick Demo Test Credentials
                      const Row(
                        children: [
                          Expanded(child: Divider(color: AppColors.cardBorder)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '1-Tap Demo Student Logins',
                              style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(child: Divider(color: AppColors.cardBorder)),
                        ],
                      ),
                      const SizedBox(height: 14),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildDemoChip('24B91A0501', 'Palakollu (Bus 01)', AppColors.routePalakollu),
                          _buildDemoChip('24B91A0502', 'Tanuku (Bus 02)', AppColors.routeTanuku),
                          _buildDemoChip('24B91A0503', 'TPG (Bus 03)', AppColors.routeTadepalligudem),
                          _buildDemoChip('24B91A0504', 'Narsapur (Bus 04)', AppColors.routeNarsapur),
                          _buildDemoChip('24B91A0505', 'Akividu (Bus 05)', AppColors.routeAkividu),
                          _buildDemoChip('24B91A0506', 'Undi (Bus 06)', AppColors.routeUndi),
                          _buildDemoChip('24B91A0507', 'Maruteru (Bus 07)', AppColors.routeMaruteru),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Back to Intro link
                      Center(
                        child: TextButton.icon(
                          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_rounded, size: 16),
                          label: const Text('Return to College Transit Intro', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoChip(String regNo, String label, Color chipColor) {
    return ActionChip(
      backgroundColor: Colors.white,
      side: BorderSide(color: chipColor.withValues(alpha: 0.35)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      avatar: Icon(Icons.touch_app_rounded, size: 14, color: chipColor),
      label: Text(
        '$regNo ($label)',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: chipColor),
      ),
      onPressed: () => _fillDemo(regNo),
    );
  }
}
