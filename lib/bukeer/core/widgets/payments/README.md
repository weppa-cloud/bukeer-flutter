# Payment Components

This directory contains all payment-related components for the Bukeer application. These components have been migrated from various locations to create a centralized payment module.

## Components

### 1. payment_add
**Original Location**: `/lib/bukeer/itinerarios/pagos/payment_add/`
**Description**: Component for adding payment records to itineraries. Handles customer payments and tracks payment status.

**Key Features**:
- Add new payment entries
- Select payment methods
- Track payment amounts and dates
- Update itinerary payment status

### 2. payment_provider
**Original Location**: `/lib/bukeer/itinerarios/proveedores/payment_provider/`
**Description**: Component for managing provider/supplier payments. Tracks payments to hotels, airlines, and other service providers.

**Key Features**:
- Record provider payments
- Track payment due dates
- Manage provider payment status
- Calculate outstanding balances

### 3. edit_payment_methods
**Original Location**: `/lib/bukeer/productos/edit_payment_methods/`
**Description**: Component for configuring and managing available payment methods for products and services.

**Key Features**:
- Add/edit payment method options
- Configure payment method settings
- Set default payment methods
- Enable/disable payment options

## Migration Status

| Component | Migration Status | Notes |
|-----------|-----------------|-------|
| payment_add | Pending | Requires integration with new payment service |
| payment_provider | Pending | Needs provider service integration |
| edit_payment_methods | Pending | Requires product service updates |

## Architecture

All payment components follow the new service-based architecture:

```dart
// Access payment functionality through services
final paymentService = appServices.payment; // Future service
final itineraryService = appServices.itinerary;
final productService = appServices.product;
```

## Usage Guidelines

1. **State Management**: Use the new service architecture instead of FFAppState
2. **Error Handling**: Implement proper error handling with ErrorService
3. **Validation**: Ensure all payment amounts and data are validated
4. **Security**: Follow security best practices for payment data
5. **Testing**: Write comprehensive tests for all payment functionality

## Dependencies

- **Services**: ItineraryService, ProductService, UserService
- **Database**: Supabase tables (transactions, itineraries, itinerary_items)
- **UI Components**: BukeerTextField, BukeerButton, BukeerModal

## Future Enhancements

- [ ] Create dedicated PaymentService
- [ ] Implement payment gateway integrations
- [ ] Add payment reporting features
- [ ] Enhance payment security measures
- [ ] Add multi-currency support