import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A reusable form input component that standardizes input styling and behavior.
///
/// This widget provides consistent form input patterns across all features with
/// proper validation, responsive sizing, and accessibility support.
///
/// **Usage:**
/// ```dart
/// FormInput(
///   label: 'Username',
///   hintText: 'Enter your username',
///   controller: _usernameController,
///   validator: (value) => value?.isEmpty ?? true ? 'Username is required' : null,
///   inputType: FormInputType.text,
/// )
/// ```
class FormInput extends StatefulWidget {
  /// The label text for the input field.
  final String label;

  /// Optional hint text to display when the field is empty.
  final String? hintText;

  /// Controller for the text input.
  final TextEditingController? controller;

  /// Initial value for the input.
  final String? initialValue;

  /// Validation function for the input.
  final String? Function(String?)? validator;

  /// Callback when the text changes.
  final void Function(String)? onChanged;

  /// Callback when the field is saved.
  final void Function(String?)? onSaved;

  /// Callback when the field gains focus.
  final void Function()? onFocus;

  /// Callback when the field loses focus.
  final void Function()? onBlur;

  /// The type of form input (affects keyboard and validation).
  final FormInputType inputType;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether the field should obscure text (for passwords).
  final bool obscureText;

  /// Maximum number of lines for multiline input.
  final int? maxLines;

  /// Minimum number of lines for multiline input.
  final int? minLines;

  /// Maximum length of input text.
  final int? maxLength;

  /// Text capitalization behavior.
  final TextCapitalization textCapitalization;

  /// Text input action for the keyboard.
  final TextInputAction? textInputAction;

  /// Input formatters for the field.
  final List<TextInputFormatter>? inputFormatters;

  /// Custom decoration for the input field.
  final InputDecoration? decoration;

  /// Custom style for the input text.
  final TextStyle? style;

  /// Prefix icon for the input.
  final Widget? prefixIcon;

  /// Suffix icon for the input.
  final Widget? suffixIcon;

  /// Custom padding for the input.
  final EdgeInsetsGeometry? padding;

  /// Whether to use responsive spacing.
  final bool useResponsiveSpacing;

  /// Whether to show a character counter.
  final bool showCounter;

  /// Whether to autofocus the field.
  final bool autofocus;

  /// Custom focus node for the field.
  final FocusNode? focusNode;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Whether to enable suggestions.
  final bool enableSuggestions;

  const FormInput({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onFocus,
    this.onBlur,
    this.inputType = FormInputType.text,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.inputFormatters,
    this.decoration,
    this.style,
    this.prefixIcon,
    this.suffixIcon,
    this.padding,
    this.useResponsiveSpacing = true,
    this.showCounter = false,
    this.autofocus = false,
    this.focusNode,
    this.autocorrect = true,
    this.enableSuggestions = true,
  });

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(_handleFocusChange);

    // Set initial value if provided and controller is empty
    if (widget.initialValue != null &&
        (widget.controller?.text.isEmpty ?? true)) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(FormInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controller text if initial value changed
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != null &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue!;
    }
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      widget.onFocus?.call();
    } else {
      widget.onBlur?.call();
      // Validate on blur
      if (widget.validator != null) {
        setState(() {
          _errorText = widget.validator!(_controller.text);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use responsive spacing if enabled
    final effectivePadding =
        widget.padding ??
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);

    final effectiveDecoration =
        widget.decoration ??
        InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
          ),
          errorText: _errorText,
          counterText: widget.showCounter && widget.maxLength != null
              ? null
              : '',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
        );

    final effectiveStyle =
        widget.style ??
        theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface);

    final effectiveInputFormatters =
        widget.inputFormatters ?? _getInputFormatters();
    final effectiveKeyboardType = _getKeyboardType();
    final effectiveTextInputAction =
        widget.textInputAction ?? _getTextInputAction();

    return Padding(
      padding: effectivePadding,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: effectiveDecoration,
        style: effectiveStyle,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onSaved: widget.onSaved,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        textCapitalization: widget.textCapitalization,
        textInputAction: effectiveTextInputAction,
        inputFormatters: effectiveInputFormatters,
        autofocus: widget.autofocus,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        keyboardType: effectiveKeyboardType,
        buildCounter: widget.showCounter && widget.maxLength != null
            ? (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) {
                return Text(
                  '$currentLength/$maxLength',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: currentLength > maxLength!
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                );
              }
            : null,
      ),
    );
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.inputType) {
      case FormInputType.email:
        return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]'))];
      case FormInputType.phone:
        return [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]'))];
      case FormInputType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      case FormInputType.password:
        return [
          FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]'),
          ),
        ];
      default:
        return null;
    }
  }

  TextInputType _getKeyboardType() {
    switch (widget.inputType) {
      case FormInputType.email:
        return TextInputType.emailAddress;
      case FormInputType.phone:
        return TextInputType.phone;
      case FormInputType.number:
        return TextInputType.number;
      case FormInputType.url:
        return TextInputType.url;
      case FormInputType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _getTextInputAction() {
    switch (widget.inputType) {
      case FormInputType.email:
      case FormInputType.phone:
      case FormInputType.text:
        return TextInputAction.next;
      case FormInputType.password:
      case FormInputType.multiline:
        return TextInputAction.done;
      case FormInputType.number:
        return TextInputAction.next;
      case FormInputType.url:
        return TextInputAction.next;
    }
  }
}

/// Types of form inputs that affect keyboard and validation behavior.
enum FormInputType {
  /// Standard text input.
  text,

  /// Email address input with appropriate keyboard.
  email,

  /// Phone number input.
  phone,

  /// Numeric input only.
  number,

  /// Password input with security considerations.
  password,

  /// URL input.
  url,

  /// Multiline text input.
  multiline,
}
