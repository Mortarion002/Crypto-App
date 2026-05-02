import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:crypto_pulse/features/auth/presentation/controllers/auth_controller.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;
    final confirm = _confirmCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please fill in all required fields.');
      return;
    }
    if (password != confirm) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final err = await ref
        .read(authControllerProvider.notifier)
        .signUp(email, password, name.isNotEmpty ? name : null);
    if (mounted) setState(() { _loading = false; _error = err; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              // ── Back ───────────────────────────────────────────────────
              GestureDetector(
                onTap: () => context.goNamed(RouteNames.login),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.canvasLevel1,
                    borderRadius: AppRadius.smRadius,
                  ),
                  child: const Icon(LucideIcons.arrowLeft,
                      size: 18, color: AppColors.onSurfaceVariant),
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'CREATE\nACCOUNT',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      height: 1.1,
                    ),
              ),

              const SizedBox(height: 8),

              Text(
                'Start tracking the market',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),

              const SizedBox(height: 36),

              // ── Name ───────────────────────────────────────────────────
              _FieldLabel(text: 'NAME (OPTIONAL)'),
              const SizedBox(height: 8),
              _InputField(controller: _nameCtrl, hint: 'Your name'),

              const SizedBox(height: 20),

              // ── Email ──────────────────────────────────────────────────
              _FieldLabel(text: 'EMAIL'),
              const SizedBox(height: 8),
              _InputField(
                controller: _emailCtrl,
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // ── Password ───────────────────────────────────────────────
              _FieldLabel(text: 'PASSWORD'),
              const SizedBox(height: 8),
              _InputField(
                controller: _passCtrl,
                hint: '••••••••  (min 6 characters)',
                obscure: _obscure,
                suffix: IconButton(
                  icon: Icon(
                    _obscure ? LucideIcons.eye : LucideIcons.eyeOff,
                    size: 18,
                    color: AppColors.onSurfaceVariant,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                  padding: const EdgeInsets.only(right: 4),
                  constraints: const BoxConstraints(),
                ),
              ),

              const SizedBox(height: 20),

              // ── Confirm ────────────────────────────────────────────────
              _FieldLabel(text: 'CONFIRM PASSWORD'),
              const SizedBox(height: 8),
              _InputField(
                controller: _confirmCtrl,
                hint: '••••••••',
                obscure: _obscure,
                onSubmitted: (_) => _submit(),
              ),

              const SizedBox(height: 12),

              // ── Error ──────────────────────────────────────────────────
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.vibrantCoral.withValues(alpha: 0.12),
                    borderRadius: AppRadius.smRadius,
                    border: Border.all(
                        color: AppColors.vibrantCoral.withValues(alpha: 0.4), width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.circleAlert,
                          size: 15, color: AppColors.vibrantCoral),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.vibrantCoral,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              const SizedBox(height: 8),

              // ── Submit ─────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: _loading ? null : _submit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _loading
                          ? AppColors.cyanHighlight.withValues(alpha: 0.5)
                          : AppColors.cyanHighlight,
                      borderRadius: AppRadius.mdRadius,
                    ),
                    alignment: Alignment.center,
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            'CREATE ACCOUNT',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Login link ─────────────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: () => context.goNamed(RouteNames.login),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign in',
                          style: const TextStyle(
                            color: AppColors.vibrantCoral,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final ValueChanged<String>? onSubmitted;

  const _InputField({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
    this.suffix,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.canvasLevel1,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        onSubmitted: onSubmitted,
        style: const TextStyle(color: AppColors.onSurface),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
