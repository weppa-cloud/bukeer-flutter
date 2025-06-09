// Component templates for different types of components

const String buttonTemplate =
    '''import '\$importPath/flutter_flow/flutter_flow_theme.dart';
import '\$importPath/flutter_flow/flutter_flow_util.dart';
import '\$importPath/flutter_flow/flutter_flow_model.dart';
import '\$importPath/flutter_flow/flutter_flow_widgets.dart';
import '\$importPath/design_system/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '\$componentName_model.dart';
export '\$componentName_model.dart';

class \$widgetClassName extends StatefulWidget {
  const \$widgetClassName({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.disabled = false,
    this.width,
    this.height = 48.0,
  });

  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool loading;
  final bool disabled;
  final double? width;
  final double height;

  @override
  State<\$widgetClassName> createState() => _\$widgetClassNameState();
}

class _\$widgetClassNameState extends State<\$widgetClassName> {
  late \$modelClassName _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => \$modelClassName());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      onPressed: widget.disabled || widget.loading ? null : widget.onPressed,
      text: widget.text,
      icon: widget.icon != null ? Icon(widget.icon, size: 20) : null,
      options: FFButtonOptions(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
        color: BukeerColors.primary,
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
          fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
          color: Colors.white,
          letterSpacing: 0.0,
          useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
        ),
        elevation: 3,
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(BukeerSpacing.s),
        disabledColor: BukeerColors.getSecondaryText(context),
        disabledTextColor: BukeerColors.getSecondaryText(context),
        hoverColor: BukeerColors.primaryAccent,
        hoverBorderSide: BorderSide(
          color: BukeerColors.primary,
          width: 1,
        ),
        hoverTextColor: Colors.white,
        hoverElevation: 4,
      ),
      showLoadingIndicator: widget.loading,
    );
  }
}
''';

const String modalTemplate =
    '''import '\$importPath/flutter_flow/flutter_flow_theme.dart';
import '\$importPath/flutter_flow/flutter_flow_util.dart';
import '\$importPath/flutter_flow/flutter_flow_model.dart';
import '\$importPath/flutter_flow/flutter_flow_widgets.dart';
import '\$importPath/design_system/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '\$componentName_model.dart';
export '\$componentName_model.dart';

class \$widgetClassName extends StatefulWidget {
  const \$widgetClassName({
    super.key,
    this.title = 'Modal Title',
    this.onConfirm,
    this.onCancel,
  });

  final String title;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  @override
  State<\$widgetClassName> createState() => _\$widgetClassNameState();
}

class _\$widgetClassNameState extends State<\$widgetClassName> {
  late \$modelClassName _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => \$modelClassName());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.9,
      constraints: const BoxConstraints(
        maxWidth: 600,
        maxHeight: 800,
      ),
      decoration: BoxDecoration(
        color: BukeerColors.getBackground(context, secondary: true),
        borderRadius: BorderRadius.circular(BukeerSpacing.m),
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Color(0x3B1D2429),
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(BukeerSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: FlutterFlowTheme.of(context).headlineMedium,
                ),
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  borderWidth: 1,
                  buttonSize: 60,
                  icon: Icon(
                    Icons.close,
                    color: BukeerColors.getSecondaryText(context),
                    size: 30,
                  ),
                  onPressed: () {
                    widget.onCancel?.call();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const Divider(height: 32),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO: Add your modal content here
                    Text(
                      'Modal content goes here',
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FFButtonWidget(
                  onPressed: () {
                    widget.onCancel?.call();
                    Navigator.of(context).pop();
                  },
                  text: 'Cancelar',
                  options: FFButtonOptions(
                    height: 44,
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: BukeerColors.getBackground(context),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                      color: BukeerColors.getPrimaryText(context),
                      letterSpacing: 0.0,
                      useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                    ),
                    elevation: 0,
                    borderSide: BorderSide(
                      color: BukeerColors.alternate,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                  ),
                ),
                const SizedBox(width: BukeerSpacing.m),
                FFButtonWidget(
                  onPressed: () async {
                    // TODO: Add your confirmation logic here
                    widget.onConfirm?.call();
                    Navigator.of(context).pop();
                  },
                  text: 'Confirmar',
                  options: FFButtonOptions(
                    height: 44,
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: BukeerColors.primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                      color: Colors.white,
                      letterSpacing: 0.0,
                      useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                    ),
                    elevation: 3,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
''';

const String formTemplate =
    '''import '\$importPath/flutter_flow/flutter_flow_theme.dart';
import '\$importPath/flutter_flow/flutter_flow_util.dart';
import '\$importPath/flutter_flow/flutter_flow_model.dart';
import '\$importPath/design_system/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '\$componentName_model.dart';
export '\$componentName_model.dart';

class \$widgetClassName extends StatefulWidget {
  const \$widgetClassName({
    super.key,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.label = 'Label',
    this.hint,
    this.required = false,
  });

  final String? initialValue;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final String label;
  final String? hint;
  final bool required;

  @override
  State<\$widgetClassName> createState() => _\$widgetClassNameState();
}

class _\$widgetClassNameState extends State<\$widgetClassName> {
  late \$modelClassName _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => \$modelClassName());
    
    _model.textController ??= TextEditingController(text: widget.initialValue);
    _model.textFieldFocusNode ??= FocusNode();
    
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _model.textController,
      focusNode: _model.textFieldFocusNode,
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
      autofocus: false,
      obscureText: false,
      decoration: InputDecoration(
        labelText: widget.required ? '\${widget.label} *' : widget.label,
        labelStyle: FlutterFlowTheme.of(context).labelMedium,
        hintText: widget.hint,
        hintStyle: FlutterFlowTheme.of(context).labelMedium,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: BukeerColors.alternate,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(BukeerSpacing.s),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: BukeerColors.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(BukeerSpacing.s),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: BukeerColors.error,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(BukeerSpacing.s),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: BukeerColors.error,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(BukeerSpacing.s),
        ),
        filled: true,
        fillColor: BukeerColors.getBackground(context, secondary: true),
        contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
      ),
      style: FlutterFlowTheme.of(context).bodyMedium,
      validator: widget.validator ?? _model.textControllerValidator.asValidator(context),
    );
  }
}
''';

const Map<String, String> templates = {
  'button': buttonTemplate,
  'modal': modalTemplate,
  'form': formTemplate,
  // Other templates use the default
};

String getTemplate(String type) {
  return templates[type] ??
      '''// Default template
// TODO: Implement specific template for $type components
''';
}
