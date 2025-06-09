# Bukeer - Travel Management Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.29.2-blue.svg)](https://flutter.dev/)
[![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20iOS%20%7C%20Android%20%7C%20macOS-green.svg)](https://flutter.dev/)
[![Architecture](https://img.shields.io/badge/Architecture-Modern%20Services-orange.svg)](#architecture)
[![Tests](https://img.shields.io/badge/Tests-92%25%20Passing-brightgreen.svg)](#testing)
[![Coverage](https://img.shields.io/badge/Coverage-60%25-yellow.svg)](#testing)

A comprehensive travel and tourism management platform built with Flutter. Designed for travel agencies needing to manage personalized itineraries, tourism products, clients, bookings, and payments.

## 📋 Documentation Index

- **[Architecture Guide](./docs/NEW_ARCHITECTURE_GUIDE.md)** - Complete system architecture
- **[Development Workflow](./docs/DEVELOPMENT_WORKFLOW.md)** - Development process and guidelines
- **[Performance Guide](./docs/PERFORMANCE_GUIDE.md)** - Optimization strategies and metrics
- **[Testing Guide](./docs/TESTING_GUIDE.md)** - Testing strategy and best practices
- **[Contributing](./docs/CONTRIBUTING.md)** - How to contribute to the project
- **[Migration Patterns](./docs/MIGRATION_PATTERNS_GUIDE.md)** - Patterns for migrating legacy code

## 🚀 Project Status

**✅ Architecture Migration Completed (January 2025)**

The project has successfully completed a massive architectural migration from monolithic state (FFAppState) to a modern modular service system, achieving:

- 🎯 **0 compilation errors**
- 📊 **94% reduction** in global state complexity  
- 🔒 **100% type safety** in navigation
- 🧪 **585 automated tests** (92.3% passing)
- ⚡ **50-70% improvement** in UI performance
- 📁 **100% English** codebase consistency

## 🏗️ Modern Architecture

### Core Services
```dart
// Global access to all services
final appServices = AppServices();

// Available services:
appServices.ui           // UiStateService - Temporary UI state
appServices.user         // UserService - User data management
appServices.account      // AccountService - Account management
appServices.itinerary    // ItineraryService - Itinerary management
appServices.product      // ProductService - Product management
appServices.contact      // ContactService - Contact management
appServices.authorization // AuthorizationService - Access control
appServices.error        // ErrorService - Error handling
```

### Technology Stack
- **Frontend**: Flutter 3.29.2 (Cross-platform)
- **Backend**: Supabase (BaaS)
- **Database**: PostgreSQL
- **Authentication**: Supabase Auth
- **Storage**: Supabase Storage
- **Navigation**: GoRouter with type-safe routes
- **State Management**: Modular service architecture
- **UI Components**: Custom design system

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.29.2 or higher
- Dart SDK 3.2.0 or higher
- Git
- IDE (VS Code or Android Studio recommended)

### Installation
```bash
# Clone the repository
git clone https://github.com/your-org/bukeer-flutter.git
cd bukeer-flutter

# Install dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Run the application
flutter run -d chrome  # For web
flutter run           # For connected device
```

### Configuration
1. Copy `web/config.example.js` to `web/config.js`
2. Set up Supabase environment variables
3. Configure your Supabase project URL and anon key
4. Run `flutter run`

## 📱 Core Features

### 🗓️ Itinerary Management
- Create personalized itineraries
- Add services (flights, hotels, activities, transfers)
- Manage passengers and documents
- Client/provider payment control
- Generate PDFs and vouchers
- Shareable URLs for clients

### 🏨 Product Management
- **Hotels**: Rates by room type
- **Activities**: Tours and experiences
- **Flights**: Airline information
- **Transfers**: Transportation services
- Margin calculation system
- Multiple images per product
- Dynamic pricing

### 👥 Contact Management
- Clients, providers, and users
- Complete contact information
- Identity documents
- Role and permission system
- Contact history tracking

### 📊 Dashboard & Reports
- Executive dashboard
- Sales reports
- Accounts receivable/payable
- Performance metrics
- Real-time analytics

### 💳 Payment Processing
- Multiple payment methods
- Installment payments
- Provider payments tracking
- Commission calculations
- Currency conversion

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/services/user_service_test.dart

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

Current test coverage: **60%** (Target: 80%)

## 📂 Project Structure

```
lib/
├── app_state.dart           # Global app state (legacy)
├── auth/                    # Authentication
├── backend/                 # API and database
├── bukeer/                  # Main business modules
│   ├── agenda/             # Calendar features
│   ├── components/         # Shared components
│   ├── contacts/           # Contact management
│   ├── core/              # Core utilities and widgets
│   ├── dashboard/         # Dashboard and reports
│   ├── itineraries/       # Itinerary management
│   ├── products/          # Product management
│   └── users/             # User management
├── components/             # Legacy components
├── config/                 # App configuration
├── custom_code/           # Custom actions and widgets
├── design_system/         # Unified design system
├── legacy/                # Legacy FlutterFlow code
│   └── flutter_flow/
├── navigation/            # GoRouter navigation
├── providers/             # State providers
└── services/              # Modern service architecture
```

## 🛠️ Development

### Code Generation
```bash
# Generate mocks for testing
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for development
flutter pub run build_runner watch
```

### Linting
```bash
# Analyze code
flutter analyze

# Fix formatting
dart format .
```

### Git Hooks
```bash
# Install git hooks
./scripts/setup_git_hooks.sh
```

## 🚢 Deployment

### Web (PWA)
```bash
flutter build web --release
# Deploy build/web directory
```

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
# Open in Xcode for distribution
```

## 🤝 Contributing

Please read our [Contributing Guide](./docs/CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

### Development Guidelines
1. Follow the established architecture patterns
2. Write tests for new features (minimum 80% coverage)
3. Update documentation as needed
4. Use conventional commits
5. Ensure all tests pass before submitting PR

## 📄 License

This project is proprietary software. All rights reserved.

## 🆘 Support

- **Documentation**: See `/docs` directory
- **Issues**: GitHub Issues
- **Email**: support@bukeer.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for the backend infrastructure
- All contributors who have helped shape this project

---

**Last Updated**: January 9, 2025