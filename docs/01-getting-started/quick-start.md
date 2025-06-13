# 🚀 Bukeer - Unified Setup Guide

## 📋 Prerequisites

Before starting, ensure you have:
- **Flutter 3.32.0** or higher
- **Dart 3.4.0** or higher
- **Git**
- **VS Code** or Android Studio
- **Chrome** (for web development)
- **Node.js** (for testing tools)

Verify installations:
```bash
flutter --version
dart --version
git --version
node --version
```

## 🛠️ Initial Setup

### 1. Clone Repository
```bash
git clone https://github.com/weppa-cloud/bukeer-flutter.git
cd bukeer-flutter
```

### 2. Configure Git
```bash
# Set your information
git config user.name "Your Name"
git config user.email "your-email@example.com"

# Setup git hooks
./scripts/setup_git_hooks.sh
```

### 3. Environment Configuration
```bash
# Copy environment template
cp .env.example .env

# Request real credentials from team lead for:
# - SUPABASE_URL
# - SUPABASE_ANON_KEY
# - GOOGLE_MAPS_API_KEY
```

### 4. Install Dependencies
```bash
# Flutter packages
flutter pub get

# Node dependencies (for testing)
npm install
```

## 🏃 Running the Application

### Using flow.sh (Recommended)

```bash
# Make flow.sh executable
chmod +x flow.sh

# Run in development (default)
./flow.sh run

# Run in staging
./flow.sh staging
# Or specify device and environment
./flow.sh run chrome staging
./flow.sh run ios staging
```

### Manual Flutter Commands

#### Local Development
```bash
flutter run -d chrome
```

#### Staging Development
```bash
# Using flow.sh is recommended instead
flutter run -d chrome --dart-define=environment=staging
```

#### Production (Never for Development)
```bash
# WARNING: Only for production deployments
flutter build web --release
```

## 🔑 Login Credentials

### Staging Environment
- **Email**: `admin@staging.com`
- **Password**: `password123`
- **Dashboard**: https://supabase.com/dashboard/project/wrgkiastpqituocblopg

### Production Environment
- Request from team lead (never use for development)
- **Dashboard**: https://supabase.com/dashboard/project/wzlxbpicdcdvxvdcvgas

## 📁 Project Structure

```
bukeer-flutter/
├── lib/
│   ├── bukeer/            # Feature modules
│   │   ├── agenda/        # Scheduling management
│   │   ├── contacts/      # Clients and accounts
│   │   ├── dashboard/     # Reports and analytics
│   │   ├── itineraries/   # Travel itineraries
│   │   ├── products/      # Tourism products
│   │   └── users/         # User management
│   ├── backend/           # API and database
│   ├── config/            # App configuration
│   ├── services/          # Centralized services
│   ├── design_system/     # UI components
│   ├── navigation/        # Routing
│   └── main.dart          # Entry point
├── docs/                  # Documentation
├── scripts/               # Utility scripts
├── test/                  # Tests
└── web/                   # Web assets
```

## 🔄 Development Workflow

### 1. Create Feature Branch
```bash
# Update main
git checkout main
git pull origin main

# Create branch
git checkout -b feature/descriptive-name

# Make changes...

# Commit
git add .
git commit -m "feat: description of changes"

# Push
git push -u origin feature/descriptive-name

# Create Pull Request on GitHub
```

### 2. Commit Message Format
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Code style changes
- `refactor:` Code refactoring
- `test:` Test updates
- `chore:` Maintenance tasks

## 🗄️ Database & Staging

### Staging Details
- **Project ID**: wrgkiastpqituocblopg
- **URL**: https://wrgkiastpqituocblopg.supabase.co
- **Anon Key**: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndyZ2tpYXN0cHFpdHVvY2Jsb3BnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3OTE0NjIsImV4cCI6MjA0OTM2NzQ2Mn0.J7fLWMhMQiRvRr8mPQ0h-YZ7JTQMUVwNkROOSTU8MZU

### Sync Staging with Production
```bash
# Sync data from production to staging
./scripts/sync_prod_to_staging.sh

# This script:
# 1. Backs up current staging
# 2. Exports production data
# 3. Cleans staging database
# 4. Imports fresh data
# 5. Recreates test user
```

### Sync Frequency
- **Weekly**: Normal development
- **Daily**: Intensive development
- **On-demand**: Specific testing needs

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run specific test
flutter test test/path/to/test.dart

# Analyze code
flutter analyze

# Format code
dart format lib/
```

## 🔨 Useful Commands

### Development
```bash
# Hot reload (automatic when running)
r

# Hot restart
R

# Print widget tree
p

# Quit
q
```

### Build Commands
```bash
# Build for web
flutter build web

# Build for production
flutter build web --release

# Clean build
flutter clean && flutter pub get
```

## 🛠️ Accessing Services

```dart
// Import services
import '/services/app_services.dart';

// Get instance
final appServices = AppServices();

// Available services:
appServices.ui        // UI state management
appServices.user      // User data
appServices.product   // Products management
appServices.itinerary // Itineraries
appServices.contact   // Contacts
```

## 🐛 Troubleshooting

### Login Issues
```bash
# Recreate staging user
psql $STAGING_DB -f scripts/create_complete_user_staging.sql
```

### Outdated Data
```bash
# Sync with production
./scripts/sync_prod_to_staging.sh
```

### Connection Issues
```bash
# Test database connection
psql "postgresql://postgres.wrgkiastpqituocblopg:[PASSWORD]@aws-0-us-east-2.pooler.supabase.com:6543/postgres" -c "SELECT 1;"
```

### Flutter Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub upgrade
```

### Chrome CORS Issues
```bash
# Run with web security disabled (development only)
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

## 📚 Important Documentation

Essential reading:
- `/docs/ARCHITECTURE.md` - System architecture
- `/docs/CONTRIBUTING.md` - Contribution guidelines
- `/docs/CLAUDE.md` - Technical project summary
- `/docs/development/DEVELOPMENT_WORKFLOW_STAGING.md` - Detailed workflow

## ⚠️ Important Rules

**DO:**
- Always create feature branches
- Use staging for development
- Follow commit message format
- Test before pushing
- Ask questions when unsure

**DON'T:**
- Commit directly to `main`
- Use production for development
- Upload `.env` files
- Modify `/flutter_flow/` (legacy)
- Skip code review

## 🤝 Getting Help

- Check documentation in `/docs/`
- Review existing code examples
- Ask team lead for clarification
- Create GitHub issues for bugs

## 🌟 Tech Stack

- **Frontend**: Flutter Web
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **Hosting**: Firebase Hosting
- **Edge Functions**: Deno Deploy
- **Maps**: Google Maps API
- **Flight Data**: Duffel API

## 📱 Next Steps

1. Run the app in staging mode
2. Login with test credentials
3. Explore the codebase starting with `/lib/bukeer/`
4. Read the architecture documentation
5. Pick a small task to get familiar

---

Welcome to the team! 🎉

*For specific setup scenarios, refer to the individual guides in `/docs/setup/`*