# Bukeer Flutter - Makefile
# Comandos de conveniencia para desarrollo

# Variables
WIDGETBOOK_ENTRY = lib/widgetbook/main.dart
WIDGETBOOK_BUILD_DIR = build/widgetbook

# Help
.PHONY: help
help:
	@echo "Comandos disponibles:"
	@echo "  make widgetbook         - Ejecutar Widgetbook en Chrome"
	@echo "  make widgetbook-macos   - Ejecutar Widgetbook en macOS"
	@echo "  make widgetbook-ios     - Ejecutar Widgetbook en iOS"
	@echo "  make widgetbook-android - Ejecutar Widgetbook en Android"
	@echo "  make widgetbook-build   - Construir Widgetbook para web"
	@echo "  make widgetbook-serve   - Servir Widgetbook construido"
	@echo "  make widgetbook-deploy  - Build y preparar para deploy"
	@echo "  make widgetbook-clean   - Limpiar build de Widgetbook"

# Widgetbook Commands
.PHONY: widgetbook
widgetbook:
	flutter run -t $(WIDGETBOOK_ENTRY) -d chrome

.PHONY: widgetbook-web
widgetbook-web:
	flutter run -t $(WIDGETBOOK_ENTRY) -d chrome --web-renderer html

.PHONY: widgetbook-macos
widgetbook-macos:
	flutter run -t $(WIDGETBOOK_ENTRY) -d macos

.PHONY: widgetbook-ios
widgetbook-ios:
	flutter run -t $(WIDGETBOOK_ENTRY) -d iphone

.PHONY: widgetbook-android
widgetbook-android:
	flutter run -t $(WIDGETBOOK_ENTRY) -d android

# Build Commands
.PHONY: widgetbook-build
widgetbook-build:
	flutter build web -t $(WIDGETBOOK_ENTRY) --output=$(WIDGETBOOK_BUILD_DIR)

.PHONY: widgetbook-build-release
widgetbook-build-release:
	flutter build web -t $(WIDGETBOOK_ENTRY) --release --output=$(WIDGETBOOK_BUILD_DIR)

# Serve built Widgetbook
.PHONY: widgetbook-serve
widgetbook-serve:
	@echo "Sirviendo Widgetbook en http://localhost:8000"
	cd $(WIDGETBOOK_BUILD_DIR) && python3 -m http.server 8000

# Deploy preparation
.PHONY: widgetbook-deploy
widgetbook-deploy: widgetbook-clean widgetbook-build-release
	@echo "Widgetbook listo para deploy en: $(WIDGETBOOK_BUILD_DIR)"

# Clean
.PHONY: widgetbook-clean
widgetbook-clean:
	rm -rf $(WIDGETBOOK_BUILD_DIR)

# Quick development workflow
.PHONY: wb
wb: widgetbook

.PHONY: wb-build
wb-build: widgetbook-build