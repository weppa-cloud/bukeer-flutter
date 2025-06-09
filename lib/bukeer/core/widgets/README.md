# Core Widgets - Documentación

Este directorio contiene los componentes reutilizables compartidos en toda la aplicación Bukeer.

## 📁 Estructura

```
core/widgets/
├── navigation/      # Componentes de navegación
├── forms/           # Componentes de formulario
├── buttons/         # Botones reutilizables
├── containers/      # Contenedores genéricos (vacío por ahora)
└── index.dart       # Exports centralizados
```

## 🚀 Uso Rápido

```dart
// Importar todos los widgets core
import 'package:bukeer/bukeer/core/widgets/index.dart';

// O importar específicamente
import 'package:bukeer/bukeer/core/widgets/buttons/boton_back/boton_back_widget.dart';
```

## 📚 Componentes Disponibles

### Navigation (3 componentes)

#### 1. WebNavWidget
Barra de navegación principal para versión web/desktop.

**Uso:**
```dart
WebNavWidget()
```

**Props:** Ninguna (usa servicios internos para estado)

**Características:**
- Responsive (se oculta en móvil)
- Muestra logo, menú de navegación y acciones de usuario
- Integrado con sistema de permisos

---

#### 2. MobileNavWidget
Navegación inferior para dispositivos móviles.

**Uso:**
```dart
MobileNavWidget()
```

**Props:** Ninguna

**Características:**
- Solo visible en móvil
- Navegación tipo bottom bar
- Iconos adaptados para touch

---

#### 3. MainLogoSmallWidget
Logo compacto de Bukeer para usar en headers y navegación.

**Uso:**
```dart
MainLogoSmallWidget()
```

**Props:** Ninguna

**Características:**
- Tamaño optimizado para barras de navegación
- Clickeable (navega a home)

### Forms (6 componentes)

#### 1. ComponentDateWidget
Selector de fecha individual con calendario.

**Uso:**
```dart
ComponentDateWidget(
  dateStart: _model.selectedDate,
  callBackDate: (newDate) {
    setState(() {
      _model.selectedDate = newDate;
    });
  },
)
```

**Props:**
- `dateStart` (DateTime?): Fecha inicial seleccionada
- `callBackDate` (Function(DateTime?)): Callback cuando cambia la fecha

---

#### 2. ComponentDateRangeWidget
Selector de rango de fechas con presets predefinidos.

**Uso:**
```dart
ComponentDateRangeWidget(
  dateStart: _model.startDate,
  dateEnd: _model.endDate,
  callBackDateRange: (start, end) {
    setState(() {
      _model.startDate = start;
      _model.endDate = end;
    });
  },
)
```

**Props:**
- `dateStart` (DateTime?): Fecha de inicio
- `dateEnd` (DateTime?): Fecha de fin
- `callBackDateRange` (Function(DateTime?, DateTime?)): Callback con el rango

**Presets disponibles:**
- Hoy
- Ayer
- Últimos 7 días
- Últimos 30 días
- Este mes
- Mes pasado

---

#### 3. ComponentBirthDateWidget
Selector especializado para fechas de nacimiento.

**Uso:**
```dart
ComponentBirthDateWidget(
  birthDate: _model.birthDate,
  callBackDate: (newDate) {
    setState(() {
      _model.birthDate = newDate;
    });
  },
)
```

**Props:**
- `birthDate` (DateTime?): Fecha de nacimiento
- `callBackDate` (Function(DateTime?)): Callback al cambiar

**Características:**
- Validación de edad mínima/máxima
- Formato apropiado para fechas de nacimiento

---

#### 4. ComponentPlaceWidget
Selector de lugares con integración de Google Places.

**Uso:**
```dart
ComponentPlaceWidget(
  city: _model.selectedCity,
  country: _model.selectedCountry,
  callBackPlace: (city, country, lat, lng) {
    setState(() {
      _model.selectedCity = city;
      _model.selectedCountry = country;
      _model.coordinates = LatLng(lat, lng);
    });
  },
)
```

**Props:**
- `city` (String?): Ciudad seleccionada
- `country` (String?): País seleccionado
- `callBackPlace` (Function(String?, String?, double, double)): Callback con datos del lugar

---

#### 5. ComponentAddCurrencyWidget
Selector e input para montos con moneda.

**Uso:**
```dart
ComponentAddCurrencyWidget(
  amount: _model.amount,
  currency: _model.currency,
  onAmountChanged: (value) {
    setState(() {
      _model.amount = value;
    });
  },
  onCurrencyChanged: (currency) {
    setState(() {
      _model.currency = currency;
    });
  },
)
```

**Props:**
- `amount` (double?): Monto actual
- `currency` (String?): Código de moneda (USD, EUR, etc.)
- `onAmountChanged` (Function(double?)): Callback para cambio de monto
- `onCurrencyChanged` (Function(String?)): Callback para cambio de moneda

**Monedas soportadas:**
- USD (Dólar)
- EUR (Euro)
- COP (Peso Colombiano)
- MXN (Peso Mexicano)
- Y más...

---

#### 6. SearchBoxWidget
Caja de búsqueda con debounce integrado.

**Uso:**
```dart
SearchBoxWidget()
```

**Props:** Ninguna (usa `appServices.ui.searchQuery`)

**Características:**
- Debounce automático de 300ms
- Integrado con UiStateService
- Placeholder contextual
- Botón de limpiar

### Buttons (3 componentes)

#### 1. BotonBackWidget
Botón de retroceso/volver consistente.

**Uso:**
```dart
BotonBackWidget()
```

**Props:** Ninguna

**Características:**
- Icono y estilo consistente
- Navegación automática con `context.pop()`
- Tooltip "Volver"

---

#### 2. BotonCrearWidget
Botón flotante de acción (FAB) para crear nuevos items.

**Uso:**
```dart
BotonCrearWidget(
  onPressed: () {
    // Abrir modal o navegar
  },
)
```

**Props:**
- `onPressed` (VoidCallback): Acción al presionar

**Características:**
- Estilo FAB consistente
- Icono de "+"
- Elevación y sombras

---

#### 3. BotonMenuMobileWidget
Botón de menú hamburguesa para móvil.

**Uso:**
```dart
BotonMenuMobileWidget()
```

**Props:** Ninguna

**Características:**
- Solo visible en móvil
- Abre drawer lateral
- Animación de hamburguesa

## 🎨 Guías de Estilo

### Colores
Los componentes usan el tema de FlutterFlow:
- Primary: `#7C57B3` (morado)
- Secondary: `#102877` (azul oscuro)
- Tertiary: `#4098F8` (azul claro)

### Espaciado
Usa las constantes de `BukeerSpacing`:
- `xs`: 4.0
- `s`: 8.0
- `m`: 16.0
- `l`: 24.0
- `xl`: 32.0

### Tipografía
- Headers: `outfitSemiBold`
- Body: `Plus Jakarta Sans`

## 🔧 Creando Nuevos Componentes Core

1. Determina la categoría correcta (navigation, forms, buttons, etc.)
2. Crea una carpeta con el nombre del componente
3. Incluye `[nombre]_widget.dart` y `[nombre]_model.dart`
4. Agrega el export en `index.dart`
5. Documenta aquí con ejemplos

## 💡 Mejores Prácticas

1. **Mantén los componentes genéricos** - Sin lógica de negocio específica
2. **Props claras** - Documenta qué hace cada prop
3. **Callbacks consistentes** - Usa el patrón `onChanged`, `onTap`, etc.
4. **Estado mínimo** - Solo el necesario para la UI
5. **Accesibilidad** - Incluye Semantics cuando sea apropiado

## 🧪 Testing

Cada componente debe tener tests en `/test/widgets/core/`:

```dart
testWidgets('ComponentDateWidget muestra fecha inicial', (tester) async {
  final date = DateTime(2024, 1, 15);
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ComponentDateWidget(
          dateStart: date,
          callBackDate: (_) {},
        ),
      ),
    ),
  );
  
  expect(find.text('15/01/2024'), findsOneWidget);
});
```

## 📈 Roadmap

- [ ] Agregar más variantes de botones
- [ ] Componentes de loading/skeleton
- [ ] Componentes de feedback (snackbars, toasts)
- [ ] Componentes de datos (tablas, listas)
- [ ] Temas alternativos