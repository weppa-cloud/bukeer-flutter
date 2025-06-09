# Referencia de Integración con Supabase - Bukeer

Este documento proporciona una referencia completa de la integración con Supabase en el proyecto Bukeer.

## 📊 Estructura de Base de Datos

### Tablas Principales

#### `itineraries` - Gestión de Itinerarios
```sql
- id: String (PK)
- name: String
- start_date: DateTime
- end_date: DateTime
- currency: String
- total: Double
- paid: Double
- status: String
- contact_id: String (FK)
- account_id: String (FK)
- visibility: String
```

#### `contacts` - Gestión de Contactos
```sql
- id: String (PK)
- name: String
- last_name: String
- email: String
- phone: String
- is_company: Boolean
- is_client: Boolean
- is_provider: Boolean
- account_id: String (FK)
```

#### `itinerary_items` - Items de Itinerario
```sql
- id: String (PK)
- itinerary_id: String (FK)
- product_type: String
- product_id: String
- quantity: Integer
- price: Double
- cost: Double
```

### Vistas Denormalizadas
- `activities_view`
- `hotels_view`
- `transfers_view`
- `airports_view`
- `user_roles_view`

## 🔌 Funciones RPC de Supabase

### Gestión de Contactos
```dart
// Buscar contactos con paginación
final response = await supabase.rpc('function_get_contacts_search', params: {
  'search_query': 'nombre',
  'p_limit': 10,
  'p_offset': 0,
  'account_id_param': 'account-id'
});

// Validar antes de eliminar
final canDelete = await supabase.rpc('function_validate_delete_contact', params: {
  'contact_id': 'contact-id'
});
```

### Gestión de Productos
```dart
// Buscar productos
final products = await supabase.rpc('function_search_products', params: {
  'search_query': 'playa',
  'product_type': 'hotels',
  'account_id_param': 'account-id'
});

// Obtener tarifas
final rates = await supabase.rpc('function_get_product_rates', params: {
  'product_id': 'product-id',
  'product_type': 'hotels'
});
```

### Gestión de Itinerarios
```dart
// Crear itinerario
final newItinerary = await supabase.rpc('function_create_itinerary', params: {
  'name': 'Viaje a Cancún',
  'start_date': '2024-01-15',
  'end_date': '2024-01-20',
  'contact_id': 'contact-id',
  'account_id': 'account-id'
});

// Obtener detalles completos
final details = await supabase.rpc('function_get_itinerary_details', params: {
  'itinerary_id_param': 'itinerary-id'
});
```

### Reportes Financieros
```dart
// Cuentas por cobrar
final receivables = await supabase.rpc('function_cuentas_por_cobrar', params: {
  'account_id_param': 'account-id'
});

// Reporte de ventas
final sales = await supabase.rpc('function_reporte_ventas', params: {
  'account_id_param': 'account-id',
  'start_date': '2024-01-01',
  'end_date': '2024-12-31'
});
```

## 🔐 Autenticación

### Configuración
```dart
// En main.dart
await SupaFlow.initialize(
  url: AppConfig.supabaseUrl,
  anonKey: AppConfig.supabaseAnonKey,
);
```

### Operaciones de Auth
```dart
// Login
final authResponse = await supabase.auth.signInWithPassword(
  email: 'user@example.com',
  password: 'password123'
);

// Registro
final authResponse = await supabase.auth.signUp(
  email: 'user@example.com',
  password: 'password123'
);

// Reset password
await supabase.auth.resetPasswordForEmail(
  email: 'user@example.com',
  redirectTo: 'https://app.bukeer.com/reset-password'
);

// Obtener token JWT actual
final token = currentJwtToken; // Variable global
```

## 💾 Storage

### Buckets Disponibles
- `images` - Almacenamiento de imágenes

### Operaciones de Storage
```dart
// Subir archivo
final path = await uploadSupabaseStorageFile(
  bucketName: 'images',
  filePath: 'itineraries/123/photo.jpg',
  file: uploadedFile
);

// Eliminar archivo
await deleteSupabaseFileFromPublicUrl(
  'https://supabase.project.co/storage/v1/object/public/images/path/to/file.jpg'
);

// Generar URL pública
final publicUrl = supabase.storage
  .from('images')
  .getPublicUrl('path/to/file.jpg');
```

## 🎯 Patrones de Uso Comunes

### 1. Llamadas API con Autenticación
```dart
final response = await YourApiCall.call(
  authToken: currentJwtToken,  // Siempre incluir el token
  // otros parámetros...
);
```

### 2. Manejo de Errores
```dart
try {
  final response = await supabase.rpc('function_name', params: {...});
  if (response.error != null) {
    // Manejar error de Supabase
  }
} catch (e) {
  // Manejar error de red u otros
}
```

### 3. Queries Directas a Tablas
```dart
// Select con filtros
final data = await supabase
  .from('contacts')
  .select()
  .eq('account_id', accountId)
  .ilike('name', '%search%')
  .limit(10);

// Insert
await supabase
  .from('notes')
  .insert({
    'content': 'Nueva nota',
    'itinerary_id': itineraryId
  });

// Update
await supabase
  .from('itineraries')
  .update({'status': 'confirmed'})
  .eq('id', itineraryId);
```

## 📝 Notas Importantes

1. **IDs como Strings**: Todas las tablas usan IDs tipo String, no Integer
2. **Multi-cuenta**: La mayoría de queries requieren `account_id` para filtrado
3. **Soft Delete**: Algunas tablas usan `deleted_at` para borrado lógico
4. **Timestamps**: Todas las tablas tienen `created_at` y `updated_at`
5. **Vistas**: Las vistas (`*_view`) son solo lectura y tienen datos denormalizados

## 🧪 Para Testing

### Configuración de Mocks
```dart
// Mock de Supabase Client
final mockSupabase = MockSupabaseClient();

// Mock de respuestas RPC
when(mockSupabase.rpc('function_name', params: any))
  .thenAnswer((_) async => {
    'data': [/* mock data */]
  });

// Mock de Auth
when(mockSupabase.auth.currentUser)
  .thenReturn(User(id: 'test-user-id'));
```

### Consideraciones para Tests
1. La versión actual de Supabase es 2.3.0
2. Los mocks deben coincidir con la API actual
3. Usar `@GenerateMocks([SupabaseClient])` para generar mocks
4. Considerar el estado global de autenticación en tests