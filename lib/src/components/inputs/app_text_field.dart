import 'package:flutter/material.dart';

import '../../theme/app_motion.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../theme/citexa_colors.dart';

/// Standard text input for every Citexa app.
///
/// The error state is red ([CitexaColors.error]): a red border and a red
/// message underneath. It must never share the brand purple (the focus color),
/// or an error looks like a normal focused field — see [errorText].
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.errorText,
    this.helperText,
    this.obscureText = false,
    this.enabled = true,
    this.leadingIcon,
    this.trailing,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final bool obscureText;
  final bool enabled;
  final IconData? leadingIcon;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final int maxLines;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final Color borderColor = !widget.enabled
        ? colors.disabled
        : _hasError
        ? colors.error
        : _focused
        ? colors.primary
        : colors.outline;
    final double borderWidth = _hasError || _focused ? 1.5 : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: CitexaTypography.bodySecondary.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
        ],
        AnimatedContainer(
          duration: AppMotion.fast,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            children: [
              if (widget.leadingIcon != null) ...[
                Icon(widget.leadingIcon, size: 20, color: colors.textSecondary),
                const SizedBox(width: AppSpacing.xs),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  autofocus: widget.autofocus,
                  maxLines: widget.maxLines,
                  style: CitexaTypography.bodyPrimary.copyWith(
                    color: colors.textPrimary,
                  ),
                  cursorColor: colors.primary,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: CitexaTypography.bodyPrimary.copyWith(
                      color: colors.textSecondary,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
        if (_hasError || widget.helperText != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            _hasError ? widget.errorText! : widget.helperText!,
            style: CitexaTypography.label.copyWith(
              color: _hasError ? colors.error : colors.textSecondary,
              fontWeight: _hasError ? FontWeight.w600 : null,
            ),
          ),
        ],
      ],
    );
  }
}
