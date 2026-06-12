// Mirrors the "Login" mockup. Deviations + elevations:
// - Gradient wordmark -> solid indigo (design system bans gradients).
// - Added: staggered entrance (50ms steps), inline animated error banner
//   instead of raw error codes, in-button loading spinners, keyboard focus
//   rings, press-scale micro-interactions, autofill hints, enter-to-submit.
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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitted = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(emailSignInControllerProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final emailState = ref.watch(emailSignInControllerProvider);
    final googleState = ref.watch(googleSignInControllerProvider);
    final busy = emailState.isLoading || googleState.isLoading;
    final errorMessage = emailState.hasError
        ? friendlyAuthError(emailState.error!)
        : googleState.hasError
            ? friendlyAuthError(googleState.error!)
            : null;

    return AuthCardShell(
      children: [
        const StaggerIn(
          index: 0,
          child: AppLogo(tagline: AppConfig.appTagline),
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
                    hintText: 'Enter your password',
                    obscure: true,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    validator: Validators.password,
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                StaggerIn(
                  index: 3,
                  child: AppButton(
                    label: 'Sign In',
                    loading: emailState.isLoading,
                    onPressed: busy ? null : _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        const StaggerIn(index: 4, child: LabeledDivider(label: 'or')),
        const SizedBox(height: AppSpacing.xl),
        StaggerIn(
          index: 5,
          child: AppButton(
            label: 'Continue with Google',
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
          index: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              AppLink(
                label: 'Sign up',
                onTap: () => context.go(RoutePaths.signup),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
