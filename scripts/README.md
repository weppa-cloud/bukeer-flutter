# Migration Scripts

This directory contains scripts to help migrate the Bukeer Flutter codebase to use design system constants instead of hardcoded values.

## migrate_hardcoded_values.dart

A comprehensive script that replaces common hardcoded patterns with design system constants.

### Usage

```bash
# Dry run (preview changes without modifying files)
dart scripts/migrate_hardcoded_values.dart --dry-run

# Dry run with verbose output
dart scripts/migrate_hardcoded_values.dart --dry-run --verbose

# Apply changes
dart scripts/migrate_hardcoded_values.dart
```

### What it replaces

The script replaces the following patterns:

#### EdgeInsets patterns
- `EdgeInsets.all(4)` → `EdgeInsets.all(BukeerSpacing.xs)`
- `EdgeInsets.all(8)` → `EdgeInsets.all(BukeerSpacing.s)`
- `EdgeInsets.all(12)` → `EdgeInsets.all(BukeerSpacing.sm)`
- `EdgeInsets.all(16)` → `EdgeInsets.all(BukeerSpacing.m)`
- `EdgeInsets.all(20)` → `EdgeInsets.all(BukeerSpacing.ml)`
- `EdgeInsets.all(24)` → `EdgeInsets.all(BukeerSpacing.l)`
- `EdgeInsets.all(32)` → `EdgeInsets.all(BukeerSpacing.xl)`

#### SizedBox patterns
- `SizedBox(width: 8)` → `SizedBox(width: BukeerSpacing.s)`
- `SizedBox(width: 16)` → `SizedBox(width: BukeerSpacing.m)`
- `SizedBox(height: 8)` → `SizedBox(height: BukeerSpacing.s)`
- `SizedBox(height: 16)` → `SizedBox(height: BukeerSpacing.m)`
- `SizedBox(height: 24)` → `SizedBox(height: BukeerSpacing.l)`

#### BorderRadius patterns
- `BorderRadius.circular(4)` → `BorderRadius.circular(BukeerSpacing.xs)`
- `BorderRadius.circular(8)` → `BorderRadius.circular(BukeerSpacing.s)`
- `BorderRadius.circular(12)` → `BorderRadius.circular(BukeerSpacing.sm)`
- `BorderRadius.circular(16)` → `BorderRadius.circular(BukeerSpacing.m)`
- `BorderRadius.circular(24)` → `BorderRadius.circular(BukeerSpacing.l)`

#### Duration patterns
- `Duration(milliseconds: 150)` → `UiConstants.animationDurationFast`
- `Duration(milliseconds: 200)` → `UiConstants.animationDurationFast`
- `Duration(milliseconds: 300)` → `UiConstants.animationDuration`
- `Duration(milliseconds: 400)` → `UiConstants.animationDuration`
- `Duration(milliseconds: 600)` → `UiConstants.animationDurationSlow`

### Features

- **Safe replacement**: Avoids replacing values inside strings and comments
- **Import management**: Automatically adds required imports
- **Statistics**: Provides detailed report of changes made
- **Dry run mode**: Preview changes before applying them
- **File filtering**: Skips files with too many string literals (likely not UI code)

### Last Migration Results

The script successfully processed **189 files** and modified **34 files** with **247 total replacements**:

- **BorderRadius.circular(12)**: 105 replacements
- **SizedBox(width: 8)**: 29 replacements
- **BorderRadius.circular(8)**: 23 replacements
- **Duration(milliseconds: 150)**: 12 replacements
- And many more...

This migration helps standardize spacing, animations, and border radius values across the codebase, making it more maintainable and consistent with the design system.