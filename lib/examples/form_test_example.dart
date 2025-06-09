import 'package:flutter/material.dart';
import '../legacy/flutter_flow/flutter_flow_theme.dart';
import '../legacy/flutter_flow/flutter_flow_widgets.dart';
import '../legacy/flutter_flow/flutter_flow_drop_down.dart';
import '../legacy/flutter_flow/form_field_controller.dart';
import 'package:bukeer/design_system/tokens/index.dart';
import 'package:bukeer/design_system/components/index.dart';

class FormTestExample extends StatefulWidget {
  const FormTestExample({super.key});

  @override
  State<FormTestExample> createState() => _FormTestExampleState();
}

class _FormTestExampleState extends State<FormTestExample> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // Dropdown values
  String? _selectedCountry;
  String? _selectedDocumentType;
  FormFieldController<String>? _countryController;
  FormFieldController<String>? _documentController;

  // Form state
  bool _isLoading = false;
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _countryController = FormFieldController<String>(null);
    _documentController = FormFieldController<String>('Cédula de ciudadanía');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    // Validar formulario
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor corrija los errores en el formulario'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    // Validaciones adicionales
    if (_selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor seleccione un país'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debe aceptar los términos y condiciones'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simular llamada API
      await Future.delayed(Duration(seconds: 2));

      // Mostrar éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Formulario enviado exitosamente!'),
            backgroundColor: FlutterFlowTheme.of(context).success,
          ),
        );

        // Limpiar formulario
        _formKey.currentState!.reset();
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _passwordController.clear();
        setState(() {
          _selectedCountry = null;
          _agreedToTerms = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: Text(
          'Prueba de Formularios',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(BukeerSpacing.l),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Formulario de Ejemplo',
                  style: FlutterFlowTheme.of(context).headlineSmall,
                ),
                SizedBox(height: BukeerSpacing.m),

                // Campo de nombre con validación
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre Completo *',
                    hintText: 'Ingrese su nombre completo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(BukeerSpacing.s),
                    ),
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es requerido';
                    }
                    if (value.length < 3) {
                      return 'El nombre debe tener al menos 3 caracteres';
                    }
                    if (value.length > 50) {
                      return 'El nombre no puede tener más de 50 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: BukeerSpacing.m),

                // Dropdown de tipo de documento
                FlutterFlowDropDown<String>(
                  controller: _documentController!,
                  options: [
                    'Cédula de ciudadanía',
                    'Cédula de extranjería',
                    'Tarjeta de identidad',
                    'NIT',
                    'Pasaporte',
                    'DNI'
                  ],
                  onChanged: (val) =>
                      setState(() => _selectedDocumentType = val),
                  width: double.infinity,
                  height: 60,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium,
                  hintText: 'Tipo de documento *',
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24,
                  ),
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  elevation: 2,
                  borderColor: BukeerColors.alternate,
                  borderWidth: 2,
                  borderRadius: 8,
                  margin: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
                  hidesUnderline: true,
                  isSearchable: true,
                ),
                SizedBox(height: BukeerSpacing.m),

                // Email con validación
                BukeerTextField(
                  controller: _emailController,
                  label: 'Correo Electrónico *',
                  hintText: 'ejemplo@correo.com',
                  type: BukeerTextFieldType.email,
                  required: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El correo es requerido';
                    }
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Ingrese un correo válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: BukeerSpacing.m),

                // Teléfono con validación
                BukeerTextField(
                  controller: _phoneController,
                  label: 'Teléfono',
                  hintText: '+57 300 123 4567',
                  type: BukeerTextFieldType.phone,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      // Solo validar si se ingresó algo
                      if (value.length < 10) {
                        return 'El teléfono debe tener al menos 10 dígitos';
                      }
                      if (!RegExp(r'^[0-9+\s-]+$').hasMatch(value)) {
                        return 'Formato de teléfono inválido';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: BukeerSpacing.m),

                // Dropdown de país
                FlutterFlowDropDown<String>(
                  controller: _countryController!,
                  options: [
                    'Colombia',
                    'México',
                    'Argentina',
                    'Perú',
                    'Chile',
                    'Ecuador',
                    'Venezuela',
                    'Brasil',
                    'Estados Unidos',
                    'España',
                  ],
                  onChanged: (val) => setState(() => _selectedCountry = val),
                  width: double.infinity,
                  height: 60,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium,
                  hintText: 'Seleccione un país *',
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24,
                  ),
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  elevation: 2,
                  borderColor: _selectedCountry == null
                      ? BukeerColors.error
                      : BukeerColors.alternate,
                  borderWidth: 2,
                  borderRadius: 8,
                  margin: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
                  hidesUnderline: true,
                  isSearchable: true,
                ),
                if (_selectedCountry == null)
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 4),
                    child: Text(
                      'Por favor seleccione un país',
                      style: TextStyle(
                        color: BukeerColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                SizedBox(height: BukeerSpacing.m),

                // Password con validación
                BukeerTextField(
                  controller: _passwordController,
                  label: 'Contraseña *',
                  hintText: 'Mínimo 8 caracteres',
                  type: BukeerTextFieldType.password,
                  required: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La contraseña es requerida';
                    }
                    if (value.length < 8) {
                      return 'La contraseña debe tener al menos 8 caracteres';
                    }
                    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
                        .hasMatch(value)) {
                      return 'Debe contener mayúsculas, minúsculas y números';
                    }
                    return null;
                  },
                ),
                SizedBox(height: BukeerSpacing.m),

                // Checkbox de términos
                CheckboxListTile(
                  value: _agreedToTerms,
                  onChanged: (value) => setState(() => _agreedToTerms = value!),
                  title: Text(
                    'Acepto los términos y condiciones',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  activeColor: BukeerColors.primary,
                  checkColor: Colors.white,
                  tileColor: _agreedToTerms
                      ? null
                      : BukeerColors.error.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                  ),
                ),
                SizedBox(height: BukeerSpacing.l),

                // Botón de envío
                FFButtonWidget(
                  onPressed: _isLoading ? null : _submitForm,
                  text: _isLoading ? 'Enviando...' : 'Enviar Formulario',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 56,
                    color: BukeerColors.primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Outfit',
                          color: Colors.white,
                        ),
                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                    disabledColor: BukeerColors.neutralLight,
                  ),
                  // loading: _isLoading, // TODO: Add loading support to FFButtonWidget
                ),

                SizedBox(height: BukeerSpacing.m),

                // Botón secundario
                FFButtonWidget(
                  onPressed: () {
                    // Limpiar formulario
                    _formKey.currentState?.reset();
                    _nameController.clear();
                    _emailController.clear();
                    _phoneController.clear();
                    _passwordController.clear();
                    setState(() {
                      _selectedCountry = null;
                      _selectedDocumentType = null;
                      _agreedToTerms = false;
                    });
                  },
                  text: 'Limpiar Formulario',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 48,
                    color: Colors.transparent,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Outfit',
                          color: BukeerColors.primary,
                        ),
                    borderSide: BorderSide(
                      color: BukeerColors.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(BukeerSpacing.s),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
