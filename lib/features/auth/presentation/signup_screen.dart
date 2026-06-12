// Mirrors the "Signup" mockup. Deviations + elevations:
// - Gradient wordmark -> solid indigo (design system bans gradients).
// - Added: staggered entrance, inline animated error banner, confirm-password
//   match validation, 6+ character client-side check (mirrors Firebase),
//   in-button spinners, focus rings, autofill hints, enter-to-submit.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../core/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_link.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/google_logo.dart';
import '../../../core/widgets/stagger_in.dart';
import 'auth_controllers.dart';
import 'widgets/auth_card_shell.dart';
import 'widgets/error_banner.dart';
import 'widgets/labeled_divider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitted = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(emailSignUpControllerProvider.notifier).signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(emailSignUpControllerProvider);
    final googleState = ref.watch(googleSignInControllerProvider);
    final busy = signUpState.isLoading || googleState.isLoading;
    final errorMessage = signUpState.hasError
        ? friendlyAuthError(signUpState.error!)
        : googleState.hasError
            ? friendlyAuthError(googleState.error!)
            : null;

    return AuthCardShell(
      children: [
        const StaggerIn(
          index: 0,
          child: AppLogo(tagline: 'Start your sales training journey'),
        ),
        const SizedBox(height: AppSpacing.xxl),
        ErrorBanner(message: errorMessage),
        Form(
          key: _formKey,
          autovalidateMode: _submitted
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StaggerIn(
                  index: 1,
                  child: AppTextField(
                    label: 'Email',
                    controller: _emailController,
                    hintText: 'you@company.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    validator: Validators.email,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                StaggerIn(
                  index: 2,
                  child: AppTextField(
                    label: 'Password',
                    controller: _passwordController,
                    hintText: 'Create a password',
                    obscure: true,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: Validators.newPassword,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                StaggerIn(
                  index: 3,
                  child: AppTextField(
                    label: 'Confirm Password',
                    controller: _confirmController,
                    hintText: 'Confirm your password',
                    obscure: true,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: (value) => Validators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                StaggerIn(
                  index: 4,
                  child: AppButton(
                    label: 'Create Account',
                    loading: signUpState.isLoading,
                    onPressed: busy ? null : _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        const StaggerIn(index: 5, child: LabeledDivider(label: 'or')),
        const SizedBox(height: AppSpacing.xl),
        StaggerIn(
          index: 6,
          child: AppButton(
            label: 'Sign up with Google',
            variant: AppButtonVariant.outline,
            icon: const GoogleLogo(),
            loading: googleState.isLoading,
            onPressed: busy
                ? null
                : () =>
                    ref.read(googleSignInControllerProvider.notifier).signIn(),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        StaggerIn(
          index: 7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              AppLink(
                label: 'Sign in',
                onTap: () => context.go(RoutePaths.login),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
