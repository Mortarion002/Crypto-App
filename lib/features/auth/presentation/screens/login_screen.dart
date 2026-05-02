import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:crypto_pulse/app/router/route_names.dart';
import 'package:crypto_pulse/features/auth/presentation/controllers/auth_controller.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_spacing.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please fill in all fields.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final err = await ref.read(authControllerProvider.notifier).signIn(email, password);
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

              // ── Logo ───────────────────────────────────────────────────
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.vibrantCoral.withValues(alpha: 0.15),
                  borderRadius: AppRadius.smRadius,
                ),
                child: const Icon(LucideIcons.terminal,
                    size: 24, color: AppColors.vibrantCoral),
              ),

              const SizedBox(height: 28),

              Text(
                'SIGN IN',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
              ),

              const SizedBox(height: 8),

              Text(
                'Access your command center',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),

              const SizedBox(height: 40),

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
                hint: '••••••••',
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
                          ? AppColors.vibrantCoral.withValues(alpha: 0.5)
                          : AppColors.vibrantCoral,
                      borderRadius: AppRadius.mdRadius,
                    ),
                    alignment: Alignment.center,
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'SIGN IN',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Sign up link ───────────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: () => context.goNamed(RouteNames.signup),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                      children: [
                        const TextSpan(text: "New here? "),
                        TextSpan(
                          text: 'Create account',
                          style: const TextStyle(
                            color: AppColors.cyanHighlight,
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
