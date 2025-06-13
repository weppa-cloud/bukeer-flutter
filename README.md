# 🎯 Bukeer - Travel Management Platform

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Use flow.sh for all development (recommended)
chmod +x flow.sh
./flow.sh run        # Run in development
./flow.sh staging    # Run in staging

# Login credentials (staging)
# Email: admin@staging.com
# Password: password123
```

See [Development Workflow](./docs/02-development/workflow.md) for complete flow.sh usage.

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
- **Development**: Local development environment
- **Staging**: Connected to staging API (https://bukeer-staging.bukeerpro.com/api)
- **Production**: Live environment (never use for development)

### Key Commands
```bash
# Run in different environments
./flow.sh run              # Development (default)
./flow.sh staging          # Staging environment
./flow.sh run ios staging  # iOS with staging

# Sync staging with production data
./scripts/sync_prod_to_staging.sh

# Run tests
./flow.sh test             # Or flutter test

# Build for production
flutter build web --release
```

## 📚 Documentation

Organized documentation in [`/docs`](./docs):
- [Quick Start Guide](./docs/01-getting-started/quick-start.md)
- [Development Workflow with flow.sh](./docs/02-development/workflow.md)
- [Architecture Overview](./docs/ARCHITECTURE.md)
- [Junior Developer Onboarding](./docs/04-guides/junior-onboarding.md)

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
