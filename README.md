# 🎯 Bukeer - Travel Management Platform

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Run in staging mode (recommended for development)
flutter run -d chrome --dart-define=ENVIRONMENT=staging

# Login credentials
# Email: admin@staging.com
# Password: password123
```

## 📁 Project Structure

```
bukeer-flutter/
├── lib/                    # Flutter application code
│   ├── bukeer/            # Feature modules
│   ├── backend/           # API and database
│   ├── config/            # App configuration
│   └── main.dart          # Entry point
├── docs/                  # Documentation
├── scripts/               # Utility scripts
├── test/                  # Tests
└── web/                   # Web assets
```

## 🔧 Development

### Environments
- **Staging** (default for development): Connected to staging database with production data copy
- **Production**: Live environment (never use for development)

### Key Commands
```bash
# Sync staging with production data
./scripts/sync_prod_to_staging.sh

# Run tests
flutter test

# Build for production
flutter build web --release
```

## 📚 Documentation

See [`/docs`](./docs) for detailed documentation:
- [Development Workflow](./docs/development/DEVELOPMENT_WORKFLOW_STAGING.md)
- [Staging Setup](./docs/setup/STAGING_COMPLETE_GUIDE.md)
- [Architecture](./docs/ARCHITECTURE.md)

## 🛠️ Tech Stack

- **Frontend**: Flutter Web
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **Hosting**: Firebase Hosting
- **Edge Functions**: Deno Deploy

## 🤝 Contributing

1. Create feature branch from `main`
2. Develop and test in staging
3. Submit PR with description
4. Deploy after review

---

**Questions?** Check [documentation](./docs) or create an issue.
