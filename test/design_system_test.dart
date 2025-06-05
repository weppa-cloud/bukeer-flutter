import 'package:flutter_test/flutter_test.dart';
import '../lib/design_system/index.dart';

void main() {
  group('Design System Tests', () {
    test('BukeerSpacing constants are correct', () {
      expect(BukeerSpacing.xs, 4.0);
      expect(BukeerSpacing.s, 8.0);
      expect(BukeerSpacing.m, 16.0);
      expect(BukeerSpacing.l, 24.0);
      expect(BukeerSpacing.xl, 32.0);
    });

    test('BukeerColors constants are defined', () {
      expect(BukeerColors.primary, isNotNull);
      expect(BukeerColors.secondary, isNotNull);
      expect(BukeerColors.backgroundPrimary, isNotNull);
      expect(BukeerColors.textPrimary, isNotNull);
    });

    test('BukeerTypography styles are defined', () {
      expect(BukeerTypography.displayLarge, isNotNull);
      expect(BukeerTypography.headlineLarge, isNotNull);
      expect(BukeerTypography.titleLarge, isNotNull);
      expect(BukeerTypography.bodyLarge, isNotNull);
    });

    test('BukeerElevation shadows are defined', () {
      expect(BukeerElevation.shadow1, isNotNull);
      expect(BukeerElevation.shadow2, isNotNull);
      expect(BukeerElevation.shadow3, isNotNull);
      expect(BukeerElevation.shadow4, isNotNull);
    });
  });
}