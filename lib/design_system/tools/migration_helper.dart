// Design System Migration Helper
// Esta utilidad ayuda a migrar valores hardcodeados a design tokens

import 'dart:io';

class MigrationHelper {
  static const Map<String, String> spacingMigrations = {
    'EdgeInsets.all(2.0)': 'EdgeInsets.all(BukeerSpacing.xs)',
    'EdgeInsets.all(4.0)': 'EdgeInsets.all(BukeerSpacing.xs)',
    'EdgeInsets.all(8.0)': 'EdgeInsets.all(BukeerSpacing.s)',
    'EdgeInsets.all(12.0)': 'EdgeInsets.all(BukeerSpacing.s)',
    'EdgeInsets.all(16.0)': 'EdgeInsets.all(BukeerSpacing.m)',
    'EdgeInsets.all(20.0)': 'EdgeInsets.all(BukeerSpacing.m)',
    'EdgeInsets.all(24.0)': 'EdgeInsets.all(BukeerSpacing.l)',
    'EdgeInsets.all(32.0)': 'EdgeInsets.all(BukeerSpacing.xl)',
    
    // EdgeInsetsDirectional patterns
    'EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0)': 'EdgeInsets.only(bottom: BukeerSpacing.xs)',
    'EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0)': 'EdgeInsets.only(bottom: BukeerSpacing.s)',
    'EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0)': 'EdgeInsets.only(bottom: BukeerSpacing.s)',
    'EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0)': 'EdgeInsets.only(bottom: BukeerSpacing.m)',
    'EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0)': 'EdgeInsets.only(bottom: BukeerSpacing.l)',
    
    'EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0)': 'EdgeInsets.only(left: BukeerSpacing.s)',
    'EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0)': 'EdgeInsets.only(left: BukeerSpacing.s)',
    'EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0)': 'EdgeInsets.only(left: BukeerSpacing.m)',
    
    'EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0)': 'EdgeInsets.only(top: BukeerSpacing.xs)',
    'EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0)': 'EdgeInsets.only(top: BukeerSpacing.s)',
    'EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0)': 'EdgeInsets.only(top: BukeerSpacing.s)',
    'EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0)': 'EdgeInsets.only(top: BukeerSpacing.m)',
    
    'EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0)': 'EdgeInsets.only(right: BukeerSpacing.xs)',
    'EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0)': 'EdgeInsets.only(right: BukeerSpacing.s)',
    'EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0)': 'EdgeInsets.only(right: BukeerSpacing.m)',
    
    // EdgeInsets symmetric patterns
    'EdgeInsets.symmetric(horizontal: 8.0)': 'EdgeInsets.symmetric(horizontal: BukeerSpacing.s)',
    'EdgeInsets.symmetric(horizontal: 16.0)': 'EdgeInsets.symmetric(horizontal: BukeerSpacing.m)',
    'EdgeInsets.symmetric(horizontal: 24.0)': 'EdgeInsets.symmetric(horizontal: BukeerSpacing.l)',
    
    'EdgeInsets.symmetric(vertical: 8.0)': 'EdgeInsets.symmetric(vertical: BukeerSpacing.s)',
    'EdgeInsets.symmetric(vertical: 16.0)': 'EdgeInsets.symmetric(vertical: BukeerSpacing.m)',
    'EdgeInsets.symmetric(vertical: 24.0)': 'EdgeInsets.symmetric(vertical: BukeerSpacing.l)',
    
    // SizedBox patterns
    'SizedBox(width: 4.0)': 'SizedBox(width: BukeerSpacing.xs)',
    'SizedBox(width: 8.0)': 'SizedBox(width: BukeerSpacing.s)',
    'SizedBox(width: 12.0)': 'SizedBox(width: BukeerSpacing.s)',
    'SizedBox(width: 16.0)': 'SizedBox(width: BukeerSpacing.m)',
    'SizedBox(width: 24.0)': 'SizedBox(width: BukeerSpacing.l)',
    
    'SizedBox(height: 4.0)': 'SizedBox(height: BukeerSpacing.xs)',
    'SizedBox(height: 8.0)': 'SizedBox(height: BukeerSpacing.s)',
    'SizedBox(height: 12.0)': 'SizedBox(height: BukeerSpacing.s)',
    'SizedBox(height: 16.0)': 'SizedBox(height: BukeerSpacing.m)',
    'SizedBox(height: 24.0)': 'SizedBox(height: BukeerSpacing.l)',
    
    // BorderRadius patterns
    'BorderRadius.circular(4.0)': 'BorderRadius.circular(BukeerSpacing.xs)',
    'BorderRadius.circular(8.0)': 'BorderRadius.circular(BukeerSpacing.s)',
    'BorderRadius.circular(12.0)': 'BorderRadius.circular(BukeerSpacing.s)',
    'BorderRadius.circular(16.0)': 'BorderRadius.circular(BukeerSpacing.m)',
    'BorderRadius.circular(20.0)': 'BorderRadius.circular(BukeerSpacing.m)',
    'BorderRadius.circular(24.0)': 'BorderRadius.circular(BukeerSpacing.l)',
  };

  static const Map<String, String> colorMigrations = {
    'Color(0x34000000)': 'BukeerColors.overlay',
    'Color(0x66000000)': 'BukeerColors.overlay',
    'Color(0x33000000)': 'BukeerColors.overlay',
    'Color(0xFF757575)': 'BukeerColors.textSecondary',
    'Color(0xFF9E9E9E)': 'BukeerColors.textSecondary',
    'Color(0xFFBDBDBD)': 'BukeerColors.textSecondary',
    'Color(0xFFE0E0E0)': 'BukeerColors.borderLight',
    'Color(0xFFF5F5F5)': 'BukeerColors.surfaceSecondary',
    'Color(0xFFFFFFFF)': 'BukeerColors.surfacePrimary',
    'Color(0xFF000000)': 'BukeerColors.textPrimary',
    'Color(0xFF1976D2)': 'BukeerColors.primaryMain',
    'Color(0xFF2196F3)': 'BukeerColors.primaryMain',
    'Color(0xFFBBDEFB)': 'BukeerColors.primaryLight',
    'Color(0xFF0D47A1)': 'BukeerColors.primaryDark',
    'Color(0xFFF44336)': 'BukeerColors.errorMain',
    'Color(0xFF4CAF50)': 'BukeerColors.successMain',
    'Color(0xFFFF9800)': 'BukeerColors.warningMain',
  };

  static const Map<String, String> fontSizeMigrations = {
    'fontSize: 11.0': 'fontSize: BukeerTypography.captionSize',
    'fontSize: 12.0': 'fontSize: BukeerTypography.captionSize',
    'fontSize: 14.0': 'fontSize: BukeerTypography.bodySmallSize',
    'fontSize: 16.0': 'fontSize: BukeerTypography.bodyMediumSize',
    'fontSize: 18.0': 'fontSize: BukeerTypography.bodyLargeSize',
    'fontSize: 20.0': 'fontSize: BukeerTypography.headlineSmallSize',
    'fontSize: 24.0': 'fontSize: BukeerTypography.headlineMediumSize',
    'fontSize: 28.0': 'fontSize: BukeerTypography.headlineLargeSize',
    'fontSize: 32.0': 'fontSize: BukeerTypography.displaySmallSize',
    'fontSize: 36.0': 'fontSize: BukeerTypography.displayMediumSize',
    'fontSize: 48.0': 'fontSize: BukeerTypography.displayLargeSize',
  };

  /// Migra un archivo Dart aplicando los design tokens
  static Future<String> migrateFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found: $filePath');
    }

    String content = await file.readAsString();
    
    // Agregar import del design system si no existe
    if (!content.contains("import '../../../design_system/index.dart';") && 
        !content.contains("import '../../design_system/index.dart';") &&
        !content.contains("import '../design_system/index.dart';") &&
        !content.contains("import 'package:bukeer/design_system/index.dart';")) {
      
      // Buscar la línea de import de FlutterFlow theme
      final lines = content.split('\n');
      int insertIndex = -1;
      
      for (int i = 0; i < lines.length; i++) {
        if (lines[i].contains("import '../../../flutter_flow/flutter_flow_theme.dart';") ||
            lines[i].contains("import '../../flutter_flow/flutter_flow_theme.dart';") ||
            lines[i].contains("import '../flutter_flow/flutter_flow_theme.dart';")) {
          insertIndex = i + 1;
          break;
        }
      }
      
      if (insertIndex != -1) {
        // Determinar el path correcto basado en la ubicación del archivo
        String designSystemImport;
        if (filePath.contains('lib/bukeer/')) {
          designSystemImport = "import '../../../design_system/index.dart';";
        } else if (filePath.contains('lib/components/')) {
          designSystemImport = "import '../design_system/index.dart';";
        } else {
          designSystemImport = "import 'package:bukeer/design_system/index.dart';";
        }
        
        lines.insert(insertIndex, designSystemImport);
        content = lines.join('\n');
      }
    }

    // Aplicar migraciones de espaciado
    for (final entry in spacingMigrations.entries) {
      content = content.replaceAll(entry.key, entry.value);
    }

    // Aplicar migraciones de colores
    for (final entry in colorMigrations.entries) {
      content = content.replaceAll(entry.key, entry.value);
    }

    // Aplicar migraciones de tipografía
    for (final entry in fontSizeMigrations.entries) {
      content = content.replaceAll(entry.key, entry.value);
    }

    return content;
  }

  /// Analiza un archivo y reporta qué valores hardcodeados encontró
  static Future<MigrationReport> analyzeFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found: $filePath');
    }

    final content = await file.readAsString();
    final report = MigrationReport(filePath);

    // Buscar valores hardcodeados de espaciado
    final spacingPatterns = [
      RegExp(r'EdgeInsets\.all\((\d+\.?\d*)\)'),
      RegExp(r'EdgeInsetsDirectional\.fromSTEB\('),
      RegExp(r'SizedBox\((width|height): (\d+\.?\d*)\)'),
      RegExp(r'BorderRadius\.circular\((\d+\.?\d*)\)'),
    ];

    for (final pattern in spacingPatterns) {
      final matches = pattern.allMatches(content);
      report.spacingIssues.addAll(matches.map((m) => m.group(0)!));
    }

    // Buscar colores hardcodeados
    final colorPattern = RegExp(r'Color\(0x[A-Fa-f0-9]{8}\)');
    final colorMatches = colorPattern.allMatches(content);
    report.colorIssues.addAll(colorMatches.map((m) => m.group(0)!));

    // Buscar font sizes hardcodeados
    final fontSizePattern = RegExp(r'fontSize: (\d+\.?\d*)');
    final fontSizeMatches = fontSizePattern.allMatches(content);
    report.typographyIssues.addAll(fontSizeMatches.map((m) => m.group(0)!));

    // Verificar si ya tiene el import del design system
    report.hasDesignSystemImport = content.contains('design_system/index.dart');

    return report;
  }

  /// Migra múltiples archivos en un directorio
  static Future<List<MigrationResult>> migrateDirectory(String dirPath, {bool dryRun = false}) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      throw Exception('Directory not found: $dirPath');
    }

    final results = <MigrationResult>[];
    final dartFiles = await dir
        .list(recursive: true)
        .where((entity) => entity is File && entity.path.endsWith('.dart'))
        .cast<File>()
        .toList();

    for (final file in dartFiles) {
      try {
        final report = await analyzeFile(file.path);
        if (report.hasIssues) {
          final migratedContent = await migrateFile(file.path);
          
          if (!dryRun) {
            await file.writeAsString(migratedContent);
          }
          
          results.add(MigrationResult(
            filePath: file.path,
            success: true,
            report: report,
            migratedContent: dryRun ? migratedContent : null,
          ));
        }
      } catch (e) {
        results.add(MigrationResult(
          filePath: file.path,
          success: false,
          error: e.toString(),
        ));
      }
    }

    return results;
  }
}

class MigrationReport {
  final String filePath;
  final List<String> spacingIssues = [];
  final List<String> colorIssues = [];
  final List<String> typographyIssues = [];
  bool hasDesignSystemImport = false;

  MigrationReport(this.filePath);

  bool get hasIssues => spacingIssues.isNotEmpty || colorIssues.isNotEmpty || typographyIssues.isNotEmpty;

  int get totalIssues => spacingIssues.length + colorIssues.length + typographyIssues.length;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Migration Report for: $filePath');
    buffer.writeln('Has Design System Import: $hasDesignSystemImport');
    buffer.writeln('Total Issues: $totalIssues');
    
    if (spacingIssues.isNotEmpty) {
      buffer.writeln('\nSpacing Issues (${spacingIssues.length}):');
      for (final issue in spacingIssues.toSet()) {
        buffer.writeln('  - $issue');
      }
    }
    
    if (colorIssues.isNotEmpty) {
      buffer.writeln('\nColor Issues (${colorIssues.length}):');
      for (final issue in colorIssues.toSet()) {
        buffer.writeln('  - $issue');
      }
    }
    
    if (typographyIssues.isNotEmpty) {
      buffer.writeln('\nTypography Issues (${typographyIssues.length}):');
      for (final issue in typographyIssues.toSet()) {
        buffer.writeln('  - $issue');
      }
    }
    
    return buffer.toString();
  }
}

class MigrationResult {
  final String filePath;
  final bool success;
  final String? error;
  final MigrationReport? report;
  final String? migratedContent;

  MigrationResult({
    required this.filePath,
    required this.success,
    this.error,
    this.report,
    this.migratedContent,
  });

  @override
  String toString() {
    if (success) {
      return 'SUCCESS: $filePath (${report?.totalIssues ?? 0} issues fixed)';
    } else {
      return 'ERROR: $filePath - $error';
    }
  }
}

// Ejemplo de uso:
// void main() async {
//   // Analizar un archivo
//   final report = await MigrationHelper.analyzeFile('lib/bukeer/componentes/web_nav/web_nav_widget.dart');
//   print(report);
//   
//   // Migrar un archivo
//   final migratedContent = await MigrationHelper.migrateFile('lib/bukeer/componentes/web_nav/web_nav_widget.dart');
//   
//   // Migrar un directorio completo (dry run)
//   final results = await MigrationHelper.migrateDirectory('lib/bukeer/componentes', dryRun: true);
//   for (final result in results) {
//     print(result);
//   }
// }