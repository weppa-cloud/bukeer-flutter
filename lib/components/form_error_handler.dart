import 'package:flutter/material.dart';
import '../design_system/index.dart';
import '../services/error_service.dart';
import 'error_feedback_system.dart';

/// Form validation and error handling helper
class FormErrorHandler {
  final Map<String, String?> _fieldErrors = {};
  final Map<String, bool> _fieldTouched = {};
  String? _generalError;
  bool _isSubmitting = false;

  /// Check if form has any errors
  bool get hasErrors => _fieldErrors.values.any((error) => error != null) || _generalError != null;

  /// Check if form is currently submitting
  bool get isSubmitting => _isSubmitting;

  /// Get error for specific field
  String? getFieldError(String fieldName) => _fieldErrors[fieldName];

  /// Get general form error
  String? get generalError => _generalError;

  /// Check if field has been touched
  bool isFieldTouched(String fieldName) => _fieldTouched[fieldName] ?? false;

  /// Mark field as touched
  void touchField(String fieldName) {
    _fieldTouched[fieldName] = true;
  }

  /// Set error for specific field
  void setFieldError(String fieldName, String? error) {
    _fieldErrors[fieldName] = error;
  }

  /// Set general form error
  void setGeneralError(String? error) {
    _generalError = error;
  }

  /// Clear error for specific field
  void clearFieldError(String fieldName) {
    _fieldErrors[fieldName] = null;
  }

  /// Clear all errors
  void clearAllErrors() {
    _fieldErrors.clear();
    _generalError = null;
  }

  /// Clear all form state
  void clearAll() {
    _fieldErrors.clear();
    _fieldTouched.clear();
    _generalError = null;
    _isSubmitting = false;
  }

  /// Set submitting state
  void setSubmitting(bool submitting) {
    _isSubmitting = submitting;
  }

  /// Handle form submission with error management
  Future<T?> handleSubmission<T>(
    Future<T> Function() action, {
    VoidCallback? onSuccess,
    void Function(String error)? onError,
    String? context,
  }) async {
    setSubmitting(true);
    clearAllErrors();

    try {
      ErrorService().setLastAction(
        () => handleSubmission(action, onSuccess: onSuccess, onError: onError),
        context: {'description': context ?? 'Form submission'},
      );

      final result = await action();
      onSuccess?.call();
      return result;
    } catch (e) {
      final errorMessage = _extractErrorMessage(e);
      setGeneralError(errorMessage);
      onError?.call(errorMessage);
      
      ErrorService().handleError(
        e,
        context: context ?? 'Form submission',
        type: ErrorType.business,
        severity: ErrorSeverity.medium,
      );
      
      return null;
    } finally {
      setSubmitting(false);
    }
  }

  String _extractErrorMessage(dynamic error) {
    if (error is String) return error;
    if (error.toString().contains('SocketException')) {
      return 'Error de conexión. Verifica tu internet.';
    }
    if (error.toString().contains('TimeoutException')) {
      return 'La operación tardó demasiado. Inténtalo de nuevo.';
    }
    return 'Error al procesar el formulario';
  }
}

/// Form field with integrated error handling
class ErrorHandledFormField extends StatefulWidget {
  final String fieldName;
  final FormErrorHandler errorHandler;
  final String? label;
  final String? hint;
  final bool required;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const ErrorHandledFormField({
    Key? key,
    required this.fieldName,
    required this.errorHandler,
    this.label,
    this.hint,
    this.required = false,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.suffixIcon,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<ErrorHandledFormField> createState() => _ErrorHandledFormFieldState();
}

class _ErrorHandledFormFieldState extends State<ErrorHandledFormField> {
  late TextEditingController _controller;
  bool _wasInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fieldError = widget.errorHandler.getFieldError(widget.fieldName);
    final hasError = fieldError != null && widget.errorHandler.isFieldTouched(widget.fieldName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          enabled: widget.enabled,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            errorText: null, // We handle errors separately
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? BukeerColors.error : Colors.grey.shade300,
                width: hasError ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(BukeerSpacing.xs),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? BukeerColors.error : BukeerColors.primary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(BukeerSpacing.xs),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: BukeerColors.error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(BukeerSpacing.xs),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: BukeerColors.error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(BukeerSpacing.xs),
            ),
            filled: true,
            fillColor: hasError 
                ? BukeerColors.error.withOpacity(0.05)
                : Colors.grey.shade50,
            contentPadding: EdgeInsets.symmetric(
              horizontal: BukeerSpacing.s,
              vertical: BukeerSpacing.s,
            ),
          ),
          validator: (value) {
            // Mark field as touched when validation runs
            widget.errorHandler.touchField(widget.fieldName);
            
            // Required field validation
            if (widget.required && (value == null || value.isEmpty)) {
              final error = '${widget.label ?? widget.fieldName} es requerido';
              widget.errorHandler.setFieldError(widget.fieldName, error);
              return error;
            }
            
            // Custom validation
            if (widget.validator != null) {
              final error = widget.validator!(value);
              widget.errorHandler.setFieldError(widget.fieldName, error);
              return error;
            }
            
            // Clear error if validation passes
            widget.errorHandler.clearFieldError(widget.fieldName);
            return null;
          },
          onChanged: (value) {
            if (!_wasInitialized) {
              _wasInitialized = true;
              widget.errorHandler.touchField(widget.fieldName);
            }
            
            // Clear error on change
            if (widget.errorHandler.getFieldError(widget.fieldName) != null) {
              widget.errorHandler.clearFieldError(widget.fieldName);
              setState(() {}); // Rebuild to update UI
            }
            
            widget.onChanged?.call(value);
          },
          onSaved: widget.onSaved,
          onTap: () {
            widget.errorHandler.touchField(widget.fieldName);
          },
        ),
        
        // Error message
        if (hasError)
          ErrorFeedbackSystem.buildInlineError(
            fieldError,
            onDismiss: () {
              widget.errorHandler.clearFieldError(widget.fieldName);
              setState(() {});
            },
          ),
      ],
    );
  }
}

/// Submit button with loading and error states
class ErrorHandledSubmitButton extends StatefulWidget {
  final FormErrorHandler errorHandler;
  final VoidCallback? onPressed;
  final String text;
  final String? loadingText;
  final IconData? icon;
  final bool fullWidth;

  const ErrorHandledSubmitButton({
    Key? key,
    required this.errorHandler,
    this.onPressed,
    this.text = 'Enviar',
    this.loadingText = 'Enviando...',
    this.icon,
    this.fullWidth = true,
  }) : super(key: key);

  @override
  State<ErrorHandledSubmitButton> createState() => _ErrorHandledSubmitButtonState();
}

class _ErrorHandledSubmitButtonState extends State<ErrorHandledSubmitButton> {
  @override
  Widget build(BuildContext context) {
    final isLoading = widget.errorHandler.isSubmitting;
    final hasErrors = widget.errorHandler.hasErrors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // General error display
        if (widget.errorHandler.generalError != null)
          ErrorFeedbackSystem.buildInlineError(
            widget.errorHandler.generalError,
            onRetry: widget.onPressed,
            onDismiss: () {
              widget.errorHandler.setGeneralError(null);
              setState(() {});
            },
          ),
        
        SizedBox(height: BukeerSpacing.s),
        
        // Submit button
        SizedBox(
          width: widget.fullWidth ? double.infinity : null,
          child: ElevatedButton(
            onPressed: isLoading || hasErrors ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: BukeerColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: BukeerSpacing.m,
                vertical: BukeerSpacing.s,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BukeerSpacing.xs),
              ),
            ),
            child: Row(
              mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else if (widget.icon != null)
                  Icon(widget.icon!, size: 20),
                
                if ((isLoading && widget.loadingText != null) || 
                    (!isLoading && widget.icon != null))
                  SizedBox(width: BukeerSpacing.xs),
                
                Text(
                  isLoading ? (widget.loadingText ?? widget.text) : widget.text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}