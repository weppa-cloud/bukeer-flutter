import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/index.dart';

/// Standardized text field component for the Bukeer application
/// Replaces inconsistent TextFormField implementations
///
/// Features:
/// - Consistent styling and behavior
/// - Built-in validation states
/// - Multiple field types (text, email, password, etc.)
/// - Icon support
/// - Helper text and error messages
/// - Responsive sizing
class BukeerTextField extends StatefulWidget {
  /// Text field label
  final String? label;

  /// Placeholder text
  final String? hintText;

  /// Help text displayed below the field
  final String? helperText;

  /// Error text (overrides helperText when present)
  final String? errorText;

  /// Text field controller
  final TextEditingController? controller;

  /// Initial value (used if controller is not provided)
  final String? initialValue;

  /// Field type for appropriate keyboard and validation
  final BukeerTextFieldType type;

  /// Whether field is required (shows * in label)
  final bool required;

  /// Whether field is enabled
  final bool enabled;

  /// Whether field is read-only
  final bool readOnly;

  /// Maximum number of lines (1 for single line, null for unlimited)
  final int? maxLines;

  /// Maximum character length
  final int? maxLength;

  /// Leading icon
  final IconData? leadingIcon;

  /// Trailing icon (optional action)
  final IconData? trailingIcon;

  /// Trailing icon callback
  final VoidCallback? onTrailingIconPressed;

  /// Text change callback
  final Function(String)? onChanged;

  /// Form validation callback
  final String? Function(String?)? validator;

  /// Field submission callback
  final Function(String)? onSubmitted;

  /// Focus node for managing focus
  final FocusNode? focusNode;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  const BukeerTextField({
    Key? key,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.type = BukeerTextFieldType.text,
    this.required = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.leadingIcon,
    this.trailingIcon,
    this.onTrailingIconPressed,
    this.onChanged,
    this.validator,
    this.onSubmitted,
    this.focusNode,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  /// Email text field with appropriate keyboard and validation
  const BukeerTextField.email({
    Key? key,
    String? label = 'Correo Electrónico',
    String? hintText = 'ejemplo@correo.com',
    String? helperText,
    String? errorText,
    TextEditingController? controller,
    String? initialValue,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    IconData? leadingIcon = Icons.email_outlined,
    IconData? trailingIcon,
    VoidCallback? onTrailingIconPressed,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    Function(String)? onSubmitted,
    FocusNode? focusNode,
  }) : this(
          key: key,
          label: label,
          hintText: hintText,
          helperText: helperText,
          errorText: errorText,
          controller: controller,
          initialValue: initialValue,
          type: BukeerTextFieldType.email,
          required: required,
          enabled: enabled,
          readOnly: readOnly,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          onTrailingIconPressed: onTrailingIconPressed,
          onChanged: onChanged,
          validator: validator,
          onSubmitted: onSubmitted,
          focusNode: focusNode,
        );

  /// Password text field with visibility toggle
  const BukeerTextField.password({
    Key? key,
    String? label = 'Contraseña',
    String? hintText = 'Ingresa tu contraseña',
    String? helperText,
    String? errorText,
    TextEditingController? controller,
    String? initialValue,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    IconData? leadingIcon = Icons.lock_outlined,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    Function(String)? onSubmitted,
    FocusNode? focusNode,
  }) : this(
          key: key,
          label: label,
          hintText: hintText,
          helperText: helperText,
          errorText: errorText,
          controller: controller,
          initialValue: initialValue,
          type: BukeerTextFieldType.password,
          required: required,
          enabled: enabled,
          readOnly: readOnly,
          leadingIcon: leadingIcon,
          onChanged: onChanged,
          validator: validator,
          onSubmitted: onSubmitted,
          focusNode: focusNode,
        );

  /// Phone number text field with appropriate formatting
  const BukeerTextField.phone({
    Key? key,
    String? label = 'Teléfono',
    String? hintText = '+57 300 123 4567',
    String? helperText,
    String? errorText,
    TextEditingController? controller,
    String? initialValue,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    IconData? leadingIcon = Icons.phone_outlined,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    Function(String)? onSubmitted,
    FocusNode? focusNode,
  }) : this(
          key: key,
          label: label,
          hintText: hintText,
          helperText: helperText,
          errorText: errorText,
          controller: controller,
          initialValue: initialValue,
          type: BukeerTextFieldType.phone,
          required: required,
          enabled: enabled,
          readOnly: readOnly,
          leadingIcon: leadingIcon,
          onChanged: onChanged,
          validator: validator,
          onSubmitted: onSubmitted,
          focusNode: focusNode,
        );

  /// Multi-line text area
  const BukeerTextField.textArea({
    Key? key,
    String? label,
    String? hintText,
    String? helperText,
    String? errorText,
    TextEditingController? controller,
    String? initialValue,
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    int? maxLines = 5,
    int? maxLength,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    FocusNode? focusNode,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
  }) : this(
          key: key,
          label: label,
          hintText: hintText,
          helperText: helperText,
          errorText: errorText,
          controller: controller,
          initialValue: initialValue,
          type: BukeerTextFieldType.text,
          required: required,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          validator: validator,
          focusNode: focusNode,
          textCapitalization: textCapitalization,
        );

  @override
  State<BukeerTextField> createState() => _BukeerTextFieldState();
}

class _BukeerTextFieldState extends State<BukeerTextField> {
  late bool _obscureText;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isControllerManaged = false;
  bool _isFocusNodeManaged = false;

  @override
  void initState() {
    super.initState();

    // Initialize obscure text for password fields
    _obscureText = widget.type == BukeerTextFieldType.password;

    // Initialize controller
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _isControllerManaged = true;
    }

    // Initialize focus node
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _isFocusNodeManaged = true;
    }
  }

  @override
  void dispose() {
    if (_isControllerManaged) {
      _controller.dispose();
    }
    if (_isFocusNodeManaged) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) _buildLabel(),

        if (widget.label != null) SizedBox(height: BukeerSpacing.xs),

        // Text field
        _buildTextField(),

        // Helper/Error text
        if (widget.helperText != null || widget.errorText != null)
          _buildHelperText(),
      ],
    );
  }

  Widget _buildLabel() {
    return RichText(
      text: TextSpan(
        text: widget.label!,
        style: BukeerTypography.formFieldLabel,
        children: [
          if (widget.required)
            TextSpan(
              text: ' *',
              style: BukeerTypography.formFieldLabel.copyWith(
                color: BukeerColors.error,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      obscureText: _obscureText,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textCapitalization: widget.textCapitalization,
      keyboardType: _getKeyboardType(),
      textInputAction: _getTextInputAction(),
      inputFormatters: widget.inputFormatters ?? _getInputFormatters(),
      style: BukeerTypography.formField,
      decoration: _buildInputDecoration(),
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
    );
  }

  Widget _buildHelperText() {
    final text = widget.errorText ?? widget.helperText;
    final isError = widget.errorText != null;

    return Padding(
      padding: EdgeInsets.only(top: BukeerSpacing.xs),
      child: Text(
        text!,
        style: BukeerTypography.bodySmall.copyWith(
          color: isError ? BukeerColors.error : BukeerColors.textTertiary,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    final hasError = widget.errorText != null;

    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: BukeerTypography.formFieldHint,
      filled: true,
      fillColor: widget.enabled
          ? BukeerColors.getFormFieldBackground(context)
          : BukeerColors.neutral200,
      contentPadding: BukeerSpacing.formFieldPadding,

      // Borders
      border: OutlineInputBorder(
        borderRadius: BukeerBorderRadius.mediumRadius,
        borderSide: BorderSide(
          color: BukeerColors.borderPrimary,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BukeerBorderRadius.mediumRadius,
        borderSide: BorderSide(
          color: BukeerColors.borderPrimary,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BukeerBorderRadius.mediumRadius,
        borderSide: BorderSide(
          color: hasError ? BukeerColors.error : BukeerColors.borderFocus,
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BukeerBorderRadius.mediumRadius,
        borderSide: BorderSide(
          color: BukeerColors.borderError,
          width: 2.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BukeerBorderRadius.mediumRadius,
        borderSide: BorderSide(
          color: BukeerColors.borderError,
          width: 2.0,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BukeerBorderRadius.mediumRadius,
        borderSide: BorderSide(
          color: BukeerColors.neutral300,
          width: 1.0,
        ),
      ),

      // Icons
      prefixIcon: widget.leadingIcon != null
          ? Icon(
              widget.leadingIcon,
              color: hasError ? BukeerColors.error : BukeerColors.textSecondary,
              size: 20.0,
            )
          : null,
      suffixIcon: _buildSuffixIcon(),

      // Counter
      counterStyle: BukeerTypography.bodySmall.copyWith(
        color: BukeerColors.textTertiary,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    // Password visibility toggle
    if (widget.type == BukeerTextFieldType.password) {
      return IconButton(
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: BukeerColors.textSecondary,
          size: 20.0,
        ),
      );
    }

    // Custom trailing icon
    if (widget.trailingIcon != null) {
      return IconButton(
        onPressed: widget.onTrailingIconPressed,
        icon: Icon(
          widget.trailingIcon,
          color: BukeerColors.textSecondary,
          size: 20.0,
        ),
      );
    }

    return null;
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case BukeerTextFieldType.email:
        return TextInputType.emailAddress;
      case BukeerTextFieldType.phone:
        return TextInputType.phone;
      case BukeerTextFieldType.number:
        return TextInputType.number;
      case BukeerTextFieldType.decimal:
        return const TextInputType.numberWithOptions(decimal: true);
      case BukeerTextFieldType.url:
        return TextInputType.url;
      case BukeerTextFieldType.text:
      case BukeerTextFieldType.password:
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _getTextInputAction() {
    if (widget.maxLines != null && widget.maxLines! > 1) {
      return TextInputAction.newline;
    }
    return TextInputAction.next;
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.type) {
      case BukeerTextFieldType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          // Add phone formatting here if needed
        ];
      case BukeerTextFieldType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      case BukeerTextFieldType.decimal:
        return [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))];
      default:
        return null;
    }
  }
}

/// Text field type enumeration
enum BukeerTextFieldType {
  text,
  email,
  password,
  phone,
  number,
  decimal,
  url,
}
