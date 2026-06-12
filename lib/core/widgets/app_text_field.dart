import 'package:flutter/material.dart';

import '../theme.dart';

/// Label + input per the design system (mockup `.input-label` +
/// `.input-field`). Password fields get a visibility toggle. All visual
/// styling comes from the theme's InputDecorationTheme.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final bool enabled;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.inputLabel),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          obscureText: _obscured,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: widget.obscure
                ? ExcludeFocus(
                    child: IconButton(
                      onPressed: () => setState(() => _obscured = !_obscured),
                      style: IconButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                      ),
                      icon: Icon(
                        _obscured
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                      ),
                      tooltip: _obscured ? 'Show password' : 'Hide password',
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
