# Implementación de Widgetbook en Bukeer

## 1. Instalación

```bash
flutter pub add widgetbook_annotation
flutter pub add --dev widgetbook
flutter pub add --dev build_runner
flutter pub add --dev widgetbook_generator
```

## 2. Estructura sugerida

```
lib/
├── widgetbook/
│   ├── widgetbook.dart          # App principal de Widgetbook
│   ├── use_cases/              # Casos de uso por componente
│   │   ├── buttons/
│   │   ├── forms/
│   │   └── ...
│   └── themes/                 # Configuración de temas
```

## 3. Ejemplo de implementación

```dart
// lib/widgetbook/widgetbook.dart
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bukeer/design_system/index.dart';

class WidgetbookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      name: 'Bukeer Design System',
      themes: [
        WidgetbookTheme(
          name: 'Light',
          data: ThemeData.light(),
        ),
        WidgetbookTheme(
          name: 'Dark', 
          data: ThemeData.dark(),
        ),
      ],
      devices: [
        Apple.iPhone13,
        Apple.iPad,
        Desktop.desktop1080p,
      ],
      categories: [
        WidgetbookCategory(
          name: 'Buttons',
          widgets: [
            WidgetbookComponent(
              name: 'BukeerButton',
              useCases: [
                WidgetbookUseCase(
                  name: 'Primary',
                  builder: (context) => BukeerButton(
                    text: context.knobs.text(
                      label: 'Text',
                      initialValue: 'Click me',
                    ),
                    onPressed: context.knobs.boolean(
                      label: 'Enabled',
                      initialValue: true,
                    ) ? () {} : null,
                    options: BukeerButtonOptions(
                      width: context.knobs.number(
                        label: 'Width',
                        initialValue: 200,
                      ).toDouble(),
                      height: context.knobs.number(
                        label: 'Height', 
                        initialValue: 50,
                      ).toDouble(),
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Loading State',
                  builder: (context) => BukeerButton(
                    text: 'Loading...',
                    onPressed: null,
                    showLoadingIndicator: true,
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Forms',
          widgets: [
            WidgetbookComponent(
              name: 'BukeerTextField',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => Padding(
                    padding: EdgeInsets.all(16),
                    child: BukeerTextField(
                      controller: TextEditingController(),
                      hintText: context.knobs.text(
                        label: 'Hint Text',
                        initialValue: 'Enter text...',
                      ),
                      obscureText: context.knobs.boolean(
                        label: 'Obscure Text',
                        initialValue: false,
                      ),
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With Error',
                  builder: (context) => Padding(
                    padding: EdgeInsets.all(16),
                    child: BukeerTextField(
                      controller: TextEditingController(text: 'Invalid'),
                      errorText: 'This field has an error',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// Crear archivo main para Widgetbook
// lib/widgetbook/main.dart
void main() {
  runApp(WidgetbookApp());
}
```

## 4. Scripts útiles

```json
// En pubspec.yaml
scripts:
  widgetbook: flutter run -t lib/widgetbook/main.dart -d chrome
  widgetbook-build: flutter build web -t lib/widgetbook/main.dart --output=build/widgetbook
```

## 5. Componentes de Bukeer a catalogar

### Prioritarios:
- [ ] BukeerButton
- [ ] BukeerTextField
- [ ] BukeerIconButton
- [ ] BukeerModal
- [ ] WebNav
- [ ] MobileNav
- [ ] SearchBox

### Secundarios:
- [ ] DateRangePicker
- [ ] PlacePicker
- [ ] CurrencySelector
- [ ] ModalAddEditContact
- [ ] ModalAddEditItinerary

## 6. Ejemplo avanzado con addons

```dart
// Widgetbook con más funcionalidades
return Widgetbook.material(
  name: 'Bukeer Design System',
  addons: [
    // Inspector de propiedades
    InspectorAddon(),
    
    // Tester de accesibilidad
    AccessibilityAddon(),
    
    // Grid para alineación
    GridAddon(),
    
    // Vista de dispositivos
    DeviceFrameAddon(
      devices: [
        Devices.ios.iPhone13,
        Devices.android.samsungGalaxyS20,
        Devices.macos.macBookPro,
      ],
    ),
    
    // Selector de temas
    ThemeAddon(
      themes: [
        WidgetbookTheme(name: 'Light', data: lightTheme),
        WidgetbookTheme(name: 'Dark', data: darkTheme),
      ],
    ),
    
    // Selector de texto/idioma
    TextScaleAddon(scales: [1.0, 1.5, 2.0]),
  ],
  // ... resto de la configuración
);
```

## 7. Beneficios para Bukeer

1. **Desarrollo aislado**: Trabaja en componentes sin ejecutar toda la app
2. **Documentación viva**: Los casos de uso sirven como documentación
3. **Testing visual**: Previene regresiones visuales
4. **Colaboración**: Diseñadores pueden revisar implementaciones
5. **Consistencia**: Asegura que todos usen los mismos componentes

## 8. Integración con CI/CD

```yaml
# .github/workflows/widgetbook.yml
name: Deploy Widgetbook
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build web -t lib/widgetbook/main.dart
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```