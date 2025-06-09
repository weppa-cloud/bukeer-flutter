import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validaciones de Formulario', () {
    // Validador de email
    String? validateEmail(String? value) {
      if (value == null || value.isEmpty) {
        return 'El correo es requerido';
      }
      final emailRegex = RegExp(r'^[\w-\.\+]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Ingrese un correo válido';
      }
      return null;
    }

    // Validador de teléfono
    String? validatePhone(String? value) {
      if (value != null && value.isNotEmpty) {
        if (value.length < 10) {
          return 'El teléfono debe tener al menos 10 dígitos';
        }
        if (!RegExp(r'^[0-9+\s-]+$').hasMatch(value)) {
          return 'Formato de teléfono inválido';
        }
      }
      return null;
    }

    // Validador de contraseña
    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'La contraseña es requerida';
      }
      if (value.length < 8) {
        return 'La contraseña debe tener al menos 8 caracteres';
      }
      if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
        return 'Debe contener mayúsculas, minúsculas y números';
      }
      return null;
    }

    group('Email Validation', () {
      test('debe retornar error si el email está vacío', () {
        expect(validateEmail(''), 'El correo es requerido');
        expect(validateEmail(null), 'El correo es requerido');
      });

      test('debe retornar error si el email es inválido', () {
        expect(validateEmail('test'), 'Ingrese un correo válido');
        expect(validateEmail('test@'), 'Ingrese un correo válido');
        expect(validateEmail('test@.com'), 'Ingrese un correo válido');
        expect(validateEmail('@test.com'), 'Ingrese un correo válido');
      });

      test('debe aceptar emails válidos', () {
        expect(validateEmail('test@example.com'), null);
        expect(validateEmail('user.name@example.com'), null);
        expect(validateEmail('user+tag@example.co.uk'), null);
      });
    });

    group('Phone Validation', () {
      test('debe aceptar campo vacío (opcional)', () {
        expect(validatePhone(''), null);
        expect(validatePhone(null), null);
      });

      test('debe retornar error si el teléfono es muy corto', () {
        expect(
            validatePhone('123'), 'El teléfono debe tener al menos 10 dígitos');
        expect(validatePhone('123456789'),
            'El teléfono debe tener al menos 10 dígitos');
      });

      test('debe retornar error si contiene caracteres inválidos', () {
        expect(validatePhone('123abc4567'), 'Formato de teléfono inválido');
        expect(validatePhone('123@456#789'), 'Formato de teléfono inválido');
      });

      test('debe aceptar teléfonos válidos', () {
        expect(validatePhone('1234567890'), null);
        expect(validatePhone('+57 300 123 4567'), null);
        expect(validatePhone('300-123-4567'), null);
      });
    });

    group('Password Validation', () {
      test('debe retornar error si la contraseña está vacía', () {
        expect(validatePassword(''), 'La contraseña es requerida');
        expect(validatePassword(null), 'La contraseña es requerida');
      });

      test('debe retornar error si la contraseña es muy corta', () {
        expect(validatePassword('Pass1'),
            'La contraseña debe tener al menos 8 caracteres');
        expect(validatePassword('1234567'),
            'La contraseña debe tener al menos 8 caracteres');
      });

      test('debe retornar error si no cumple requisitos de complejidad', () {
        expect(validatePassword('password'),
            'Debe contener mayúsculas, minúsculas y números');
        expect(validatePassword('PASSWORD'),
            'Debe contener mayúsculas, minúsculas y números');
        expect(validatePassword('12345678'),
            'Debe contener mayúsculas, minúsculas y números');
        expect(validatePassword('Password'),
            'Debe contener mayúsculas, minúsculas y números');
      });

      test('debe aceptar contraseñas válidas', () {
        expect(validatePassword('Password1'), null);
        expect(validatePassword('MyP@ssw0rd'), null);
        expect(validatePassword('Test1234'), null);
      });
    });

    group('Dropdown Validation', () {
      test('debe validar selección requerida', () {
        String? selectedValue;

        // Simulación de validación de dropdown
        String? validateDropdown() {
          if (selectedValue == null) {
            return 'Por favor seleccione una opción';
          }
          return null;
        }

        expect(validateDropdown(), 'Por favor seleccione una opción');

        selectedValue = 'Colombia';
        expect(validateDropdown(), null);
      });
    });

    group('Checkbox Validation', () {
      test('debe validar aceptación de términos', () {
        bool agreedToTerms = false;

        String? validateTerms() {
          if (!agreedToTerms) {
            return 'Debe aceptar los términos y condiciones';
          }
          return null;
        }

        expect(validateTerms(), 'Debe aceptar los términos y condiciones');

        agreedToTerms = true;
        expect(validateTerms(), null);
      });
    });
  });
}
