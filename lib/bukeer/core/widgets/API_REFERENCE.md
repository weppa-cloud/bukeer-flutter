# Core Widgets - API Reference

Referencia completa de la API para todos los componentes core de Bukeer.

## Navigation Components

### WebNavWidget

```dart
class WebNavWidget extends StatefulWidget {
  const WebNavWidget({super.key});
}
```

**Descripción:** Barra de navegación principal para versión desktop/web.

**Props:** Ninguna

**Estado interno:**
- Detecta automáticamente el usuario actual
- Gestiona menú de usuario
- Maneja navegación entre módulos

**Eventos:** Ninguno (navegación directa)

**Métodos públicos:** Ninguno

**Ejemplo:**
```dart
Scaffold(
  appBar: PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: WebNavWidget(),
  ),
)
```

---

### MobileNavWidget

```dart
class MobileNavWidget extends StatefulWidget {
  const MobileNavWidget({super.key});
}
```

**Descripción:** Barra de navegación inferior para dispositivos móviles.

**Props:** Ninguna

**Estado interno:**
- Índice de tab seleccionado
- Integración con rutas

**Ejemplo:**
```dart
Scaffold(
  bottomNavigationBar: MobileNavWidget(),
)
```

---

### MainLogoSmallWidget

```dart
class MainLogoSmallWidget extends StatefulWidget {
  const MainLogoSmallWidget({super.key});
}
```

**Descripción:** Logo compacto clickeable de Bukeer.

**Props:** Ninguna

**Comportamiento:**
- Al hacer click navega a home
- Tamaño fijo optimizado

## Form Components

### ComponentDateWidget

```dart
class ComponentDateWidget extends StatefulWidget {
  const ComponentDateWidget({
    super.key,
    this.dateStart,
    required this.callBackDate,
  });

  final DateTime? dateStart;
  final Future<dynamic> Function(DateTime?) callBackDate;
}
```

**Props:**
| Prop | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| dateStart | DateTime? | No | Fecha inicial seleccionada |
| callBackDate | Function | Sí | Callback cuando cambia la fecha |

**Estado interno:**
- Fecha seleccionada temporal
- Estado del picker

**Validaciones:**
- No permite fechas futuras para algunos contextos
- Formato localizado

---

### ComponentDateRangeWidget

```dart
class ComponentDateRangeWidget extends StatefulWidget {
  const ComponentDateRangeWidget({
    super.key,
    this.dateStart,
    this.dateEnd,
    required this.callBackDateRange,
  });

  final DateTime? dateStart;
  final DateTime? dateEnd;
  final dynamic Function(DateTime?, DateTime?) callBackDateRange;
}
```

**Props:**
| Prop | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| dateStart | DateTime? | No | Fecha de inicio del rango |
| dateEnd | DateTime? | No | Fecha de fin del rango |
| callBackDateRange | Function | Sí | Callback con ambas fechas |

**Presets disponibles:**
- Hoy
- Ayer
- Últimos 7 días
- Últimos 30 días
- Este mes
- Mes pasado
- Personalizado

**Validaciones:**
- Fecha fin >= fecha inicio
- Rango máximo configurable

---

### ComponentBirthDateWidget

```dart
class ComponentBirthDateWidget extends StatefulWidget {
  const ComponentBirthDateWidget({
    super.key,
    this.birthDate,
    required this.callBackDate,
  });

  final DateTime? birthDate;
  final Future<dynamic> Function(DateTime?) callBackDate;
}
```

**Props:**
| Prop | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| birthDate | DateTime? | No | Fecha de nacimiento |
| callBackDate | Function | Sí | Callback al cambiar |

**Validaciones:**
- Edad mínima: 0 años
- Edad máxima: 120 años
- No permite fechas futuras

---

### ComponentPlaceWidget

```dart
class ComponentPlaceWidget extends StatefulWidget {
  const ComponentPlaceWidget({
    super.key,
    this.city,
    this.country,
    required this.callBackPlace,
  });

  final String? city;
  final String? country;
  final dynamic Function(String?, String?, double, double) callBackPlace;
}
```

**Props:**
| Prop | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| city | String? | No | Ciudad seleccionada |
| country | String? | No | País seleccionado |
| callBackPlace | Function | Sí | Callback con lugar y coordenadas |

**Integración:**
- Google Places API
- Autocompletado inteligente
- Coordenadas GPS incluidas

**Callback retorna:**
1. city (String?)
2. country (String?)
3. latitude (double)
4. longitude (double)

---

### ComponentAddCurrencyWidget

```dart
class ComponentAddCurrencyWidget extends StatefulWidget {
  const ComponentAddCurrencyWidget({
    super.key,
    this.amount,
    this.currency,
    required this.onAmountChanged,
    required this.onCurrencyChanged,
  });

  final double? amount;
  final String? currency;
  final Function(double?) onAmountChanged;
  final Function(String?) onCurrencyChanged;
}
```

**Props:**
| Prop | Tipo | Requerido | Default | Descripción |
|------|------|-----------|---------|-------------|
| amount | double? | No | null | Monto actual |
| currency | String? | No | 'USD' | Código de moneda |
| onAmountChanged | Function | Sí | - | Callback para monto |
| onCurrencyChanged | Function | Sí | - | Callback para moneda |

**Monedas soportadas:**
- USD - Dólar estadounidense
- EUR - Euro
- COP - Peso colombiano
- MXN - Peso mexicano
- ARS - Peso argentino
- BRL - Real brasileño
- PEN - Sol peruano
- CLP - Peso chileno

**Validaciones:**
- Solo números positivos
- Máximo 2 decimales
- Formato con separadores de miles

---

### SearchBoxWidget

```dart
class SearchBoxWidget extends StatefulWidget {
  const SearchBoxWidget({super.key});
}
```

**Descripción:** Caja de búsqueda con debounce y gestión de estado global.

**Props:** Ninguna (usa `appServices.ui.searchQuery`)

**Características:**
- Debounce de 300ms
- Botón de limpiar
- Placeholder contextual
- Sincronización automática con UiStateService

**Estado global:**
```dart
// Leer valor actual
final query = appServices.ui.searchQuery;

// Escuchar cambios
appServices.ui.searchQueryStream.listen((query) {
  // Reaccionar a cambios
});
```

## Button Components

### BotonBackWidget

```dart
class BotonBackWidget extends StatefulWidget {
  const BotonBackWidget({super.key});
}
```

**Descripción:** Botón de navegación hacia atrás.

**Props:** Ninguna

**Comportamiento:**
- Ejecuta `context.pop()` al presionar
- Icono estándar de flecha atrás
- Tooltip "Volver"

---

### BotonCrearWidget

```dart
class BotonCrearWidget extends StatefulWidget {
  const BotonCrearWidget({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;
}
```

**Props:**
| Prop | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| onPressed | VoidCallback | Sí | Acción al presionar |

**Estilo:**
- FloatingActionButton estándar
- Icono "+" 
- Color primario del tema
- Elevación y sombra

---

### BotonMenuMobileWidget

```dart
class BotonMenuMobileWidget extends StatefulWidget {
  const BotonMenuMobileWidget({super.key});
}
```

**Descripción:** Botón hamburguesa para abrir drawer en móvil.

**Props:** Ninguna

**Comportamiento:**
- Abre el drawer lateral
- Solo visible en móvil
- Animación de hamburguesa

## Patrones Comunes

### Callbacks Asíncronos

Algunos componentes usan callbacks asíncronos:
```dart
Future<dynamic> Function(DateTime?) callBackDate
```

Permite operaciones asíncronas en el callback:
```dart
callBackDate: (date) async {
  // Guardar en base de datos
  await saveDate(date);
  
  // Actualizar estado local
  setState(() {
    _selectedDate = date;
  });
}
```

### Integración con Servicios

Los componentes pueden integrarse con servicios globales:
```dart
ComponentPlaceWidget(
  callBackPlace: (city, country, lat, lng) {
    // Actualizar servicio global
    appServices.ui.setSelectedLocation(
      name: city ?? '',
      city: city ?? '',
      country: country ?? '',
    );
  },
)
```

### Responsive Visibility

Usa los helpers de FlutterFlow:
```dart
responsiveVisibility(
  context: context,
  phone: false,    // Ocultar en teléfono
  tablet: true,    // Mostrar en tablet
  desktop: true,   // Mostrar en desktop
)
```

## Temas y Estilos

### Acceso al tema
```dart
final theme = Theme.of(context);
final primaryColor = theme.colorScheme.primary;
final textTheme = theme.textTheme;
```

### Espaciado consistente
```dart
import 'package:bukeer/design_system/index.dart';

Padding(
  padding: EdgeInsets.all(BukeerSpacing.m), // 16px
)
```

### Colores del sistema
```dart
BukeerColors.primary      // #7C57B3
BukeerColors.secondary    // #102877
BukeerColors.tertiary     // #4098F8
BukeerColors.alternate    // #B7BAC3
```