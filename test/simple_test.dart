import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Simple arithmetic test', () {
    expect(2 + 2, equals(4));
    expect(3 * 3, equals(9));
    expect(10 / 2, equals(5));
  });

  test('String operations test', () {
    expect('hello'.toUpperCase(), equals('HELLO'));
    expect('world'.length, equals(5));
    expect('flutter'.contains('utter'), isTrue);
  });

  group('List operations', () {
    test('List manipulation', () {
      final list = [1, 2, 3];
      list.add(4);
      expect(list.length, equals(4));
      expect(list.last, equals(4));
    });
  });
}