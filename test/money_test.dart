import 'package:flutter_test/flutter_test.dart';

void main() {
  /// ----------------------------------------------------------
  /// Constructors & Basic Getters
  /// ----------------------------------------------------------
  group('Money - Constructors & Getters', () {
    test('Money(int) should store poisha correctly', () {
      final money = Money(150);
      expect(money.inPoisha, equals(150));
    });

    test('Money.zero() should create zero money', () {
      final money = Money.zero();
      expect(money.inPoisha, equals(0));
    });

    test('formatted should convert poisha to taka correctly', () {
      final money = Money(123456);
      expect(money.formatted, equals('1,234.56'));
    });

    test('formattedWithSymbol should prepend currency symbol', () {
      final money = Money(5000);
      expect(money.formattedWithSymbol, equals('৳ 50.00'));
    });

    test('toString should return formattedWithSymbol', () {
      final money = Money(100);
      expect(money.toString(), equals('৳ 1.00'));
    });
  });

  /// ----------------------------------------------------------
  /// parseCurrency (Static Helper)
  /// ----------------------------------------------------------
  group('Money.parseCurrency', () {
    test('Should parse valid decimal currency', () {
      final value = Money.parseCurrency('1,234.56');
      expect(value, equals(1234.56));
    });

    test('Should ignore currency symbols', () {
      final value = Money.parseCurrency('৳ 1,234.56');
      expect(value, equals(1234.56));
    });

    test('Should ignore invalid characters', () {
      final value = Money.parseCurrency('abc123.45xyz');
      expect(value, equals(123.45));
    });

    test('Should return 0.0 for invalid input', () {
      final value = Money.parseCurrency('abc');
      expect(value, equals(0.0));
    });

    test('Should strip decimals when allowDecimal=false', () {
      final value =
      Money.parseCurrency('1234.56', allowDecimal: false);
      expect(value, equals(1234));
    });
  });

  /// ----------------------------------------------------------
  /// Arithmetic Methods
  /// ----------------------------------------------------------
  group('Money - Arithmetic methods', () {
    test('add should sum poisha correctly', () {
      final a = Money(100);
      final b = Money(200);
      expect(a.add(b).inPoisha, equals(300));
    });

    test('subtract should subtract poisha correctly', () {
      final a = Money(500);
      final b = Money(200);
      expect(a.subtract(b).inPoisha, equals(300));
    });

    test('multiply should multiply correctly', () {
      final money = Money(100);
      expect(money.multiply(2).inPoisha, equals(200));
    });

    test('multiply should round result', () {
      final money = Money(100);
      expect(money.multiply(1.5).inPoisha, equals(150));
    });

    test('divide should divide correctly', () {
      final money = Money(300);
      expect(money.divide(3).inPoisha, equals(100));
    });

    test('divide should round result', () {
      final money = Money(100);
      expect(money.divide(3).inPoisha, equals(33));
    });
  });

  /// ----------------------------------------------------------
  /// Operator Overloads
  /// ----------------------------------------------------------
  group('Money - Operator overloads', () {
    test('+ operator', () {
      final a = Money(100);
      final b = Money(50);
      expect((a + b).inPoisha, equals(150));
    });

    test('- operator', () {
      final a = Money(100);
      final b = Money(30);
      expect((a - b).inPoisha, equals(70));
    });

    test('* operator', () {
      final money = Money(200);
      expect((money * 2).inPoisha, equals(400));
    });

    test('/ operator', () {
      final money = Money(200);
      expect((money / 4).inPoisha, equals(50));
    });
  });

  /// ----------------------------------------------------------
  /// Comparison Operators
  /// ----------------------------------------------------------
  group('Money - Comparison operators', () {
    final a = Money(100);
    final b = Money(200);

    test('>', () {
      expect(b > a, isTrue);
    });

    test('<', () {
      expect(a < b, isTrue);
    });

    test('>=', () {
      expect(a >= Money(100), isTrue);
    });

    test('<=', () {
      expect(a <= b, isTrue);
    });
  });

  /// ----------------------------------------------------------
  /// Equality & HashCode
  /// ----------------------------------------------------------
  group('Money - Equality & hashCode', () {
    test('== should be true for same poisha', () {
      final a = Money(100);
      final b = Money(100);
      expect(a == b, isTrue);
    });

    test('== should be false for different poisha', () {
      final a = Money(100);
      final b = Money(200);
      expect(a == b, isFalse);
    });

    test('hashCode should match for equal objects', () {
      final a = Money(500);
      final b = Money(500);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Should not equal non-Money object', () {
      final money = Money(100);
      expect(money == 100, isFalse);
    });
  });

  /// ----------------------------------------------------------
  /// Factory Constructors - fromPoisha
  /// ----------------------------------------------------------
  group('Money.fromPoisha - Corner cases', () {
    test('Should handle null input', () {
      final money = Money.fromPoisha(null);
      expect(money.inPoisha, equals(0));
    });

    test('Should handle empty string', () {
      final money = Money.fromPoisha('');
      expect(money.inPoisha, equals(0));
    });

    test('Should handle "null" string', () {
      final money = Money.fromPoisha('null');
      expect(money.inPoisha, equals(0));
    });

    test('Should handle valid poisha string', () {
      final money = Money.fromPoisha('12345');
      expect(money.inPoisha, equals(12345));
    });

    test('Should strip non-numeric characters', () {
      final money = Money.fromPoisha('৳12,345');
      expect(money.inPoisha, equals(12345));
    });

    test('Should ignore decimal places in poisha', () {
      final money = Money.fromPoisha('123.45');
      expect(money.inPoisha, equals(123));
    });

    test('Should handle zero', () {
      final money = Money.fromPoisha('0');
      expect(money.inPoisha, equals(0));
    });

    test('Should handle negative-looking strings', () {
      final money = Money.fromPoisha('-500');
      expect(money.inPoisha, equals(500));
    });

    test('Should handle only non-numeric characters', () {
      final money = Money.fromPoisha('abc');
      expect(money.inPoisha, equals(0));
    });
  });

  /// ----------------------------------------------------------
  /// Factory Constructors - fromTaka
  /// ----------------------------------------------------------
  group('Money.fromTaka - Corner cases', () {
    test('Should handle null input', () {
      final money = Money.fromTaka(null);
      expect(money.inPoisha, equals(0));
    });

    test('Should handle empty string', () {
      final money = Money.fromTaka('');
      expect(money.inPoisha, equals(0));
    });

    test('Should handle "null" string', () {
      final money = Money.fromTaka('null');
      expect(money.inPoisha, equals(0));
    });

    test('Should convert taka to poisha correctly', () {
      final money = Money.fromTaka('123.45');
      expect(money.inPoisha, equals(12345));
    });

    test('Should handle integer taka', () {
      final money = Money.fromTaka('100');
      expect(money.inPoisha, equals(10000));
    });

    test('Should handle zero taka', () {
      final money = Money.fromTaka('0');
      expect(money.inPoisha, equals(0));
    });

    test('Should strip currency symbols', () {
      final money = Money.fromTaka('৳ 50.25');
      expect(money.inPoisha, equals(5025));
    });

    test('Should handle comma separators', () {
      final money = Money.fromTaka('1,234.56');
      expect(money.inPoisha, equals(123456));
    });

    test('Should round properly on conversion', () {
      final money = Money.fromTaka('1.235');
      expect(money.inPoisha, equals(124)); // Rounds to 123.5 poisha
    });

    test('Should handle very small amounts', () {
      final money = Money.fromTaka('0.01');
      expect(money.inPoisha, equals(1));
    });

    test('Should handle only non-numeric characters', () {
      final money = Money.fromTaka('xyz');
      expect(money.inPoisha, equals(0));
    });

    test('Should handle multiple decimal points', () {
      final money = Money.fromTaka('12.34.56');
      expect(money.inPoisha, equals(1235)); // 12.3456 * 100 = 1234.56 rounded to 1235
    });
  });

  /// ----------------------------------------------------------
  /// parseCurrency - Additional Edge Cases
  /// ----------------------------------------------------------
  group('Money.parseCurrency - Additional edge cases', () {
    test('Should handle empty string', () {
      final value = Money.parseCurrency('');
      expect(value, equals(0.0));
    });

    test('Should handle whitespace', () {
      final value = Money.parseCurrency('  123.45  ');
      expect(value, equals(123.45));
    });

    test('Should handle multiple decimal points', () {
      final value = Money.parseCurrency('12.34.56');
      expect(value, equals(12.3456)); // First decimal kept, rest joined
    });

    test('Should handle leading zeros', () {
      final value = Money.parseCurrency('00123.45');
      expect(value, equals(123.45));
    });

    test('Should handle trailing decimal', () {
      final value = Money.parseCurrency('123.');
      expect(value, equals(123.0));
    });

    test('Should handle leading decimal', () {
      final value = Money.parseCurrency('.45');
      expect(value, equals(0.45));
    });

    test('Should handle mixed symbols and numbers', () {
      final value = Money.parseCurrency('৳1,2@3#4.5%6');
      expect(value, equals(1234.56)); // Only digits and decimals extracted
    });

    test('Should handle zero with decimals', () {
      final value = Money.parseCurrency('0.00');
      expect(value, equals(0.0));
    });
  });

  /// ----------------------------------------------------------
  /// Negative Values & Edge Cases
  /// ----------------------------------------------------------
  group('Money - Negative values', () {
    test('Should handle negative poisha', () {
      final money = Money(-100);
      expect(money.inPoisha, equals(-100));
    });

    test('Should subtract to negative', () {
      final a = Money(50);
      final b = Money(100);
      final result = a.subtract(b);
      expect(result.inPoisha, equals(-50));
    });

    test('Should add negative result back to zero', () {
      final a = Money(-100);
      final b = Money(100);
      final result = a.add(b);
      expect(result.inPoisha, equals(0));
    });

    test('Should multiply negative correctly', () {
      final money = Money(-100);
      final result = money.multiply(2);
      expect(result.inPoisha, equals(-200));
    });

    test('Should divide negative correctly', () {
      final money = Money(-100);
      final result = money.divide(2);
      expect(result.inPoisha, equals(-50));
    });

    test('Should compare negative values correctly', () {
      final a = Money(-100);
      final b = Money(-50);
      expect(a < b, isTrue);
      expect(b > a, isTrue);
    });
  });

  /// ----------------------------------------------------------
  /// Large Numbers & Boundary Cases
  /// ----------------------------------------------------------
  group('Money - Large numbers & boundaries', () {
    test('Should handle very large amounts', () {
      final money = Money(999999999);
      expect(money.inPoisha, equals(999999999));
    });

    test('Should handle maximum int values', () {
      final money = Money(9223372036854775807); // Max int64
      expect(money.inPoisha, equals(9223372036854775807));
    });

    test('Should multiply large numbers', () {
      final money = Money(1000000);
      final result = money.multiply(1000);
      expect(result.inPoisha, equals(1000000000));
    });

    test('Should handle zero multiplication', () {
      final money = Money(12345);
      final result = money.multiply(0);
      expect(result.inPoisha, equals(0));
    });

    test('Should handle fractional multiplication', () {
      final money = Money(100);
      final result = money.multiply(0.5);
      expect(result.inPoisha, equals(50));
    });

    test('Should handle fractional division', () {
      final money = Money(100);
      final result = money.divide(0.5);
      expect(result.inPoisha, equals(200));
    });
  });

  /// ----------------------------------------------------------
  /// Rounding & Precision
  /// ----------------------------------------------------------
  group('Money - Rounding & precision', () {
    test('Should round up on multiply (0.5 or greater)', () {
      final money = Money(100);
      final result = money.multiply(1.555);
      expect(result.inPoisha, equals(156)); // 155.5 rounds to 156
    });

    test('Should round down on multiply (less than 0.5)', () {
      final money = Money(100);
      final result = money.multiply(1.444);
      expect(result.inPoisha, equals(144)); // 144.4 rounds to 144
    });

    test('Should round up on divide (0.5 or greater)', () {
      final money = Money(100);
      final result = money.divide(3);
      expect(result.inPoisha, equals(33)); // 33.33... rounds to 33
    });

    test('Should round correctly for edge case', () {
      final money = Money(1);
      final result = money.divide(2);
      expect(result.inPoisha, equals(1)); // 0.5 rounds to 1
    });

    test('Should handle very precise multiplier', () {
      final money = Money(100);
      final result = money.multiply(1.23456789);
      expect(result.inPoisha, equals(123)); // 123.456789 rounds to 123
    });
  });

  /// ----------------------------------------------------------
  /// Chaining Operations
  /// ----------------------------------------------------------
  group('Money - Chaining operations', () {
    test('Should chain multiple additions', () {
      final result = Money(100)
          .add(Money(50))
          .add(Money(25));
      expect(result.inPoisha, equals(175));
    });

    test('Should chain mixed operations', () {
      final result = Money(1000)
          .multiply(2)
          .subtract(Money(500))
          .divide(3);
      expect(result.inPoisha, equals(500));
    });

    test('Should chain with operators', () {
      final result = ((Money(100) + Money(50)) * 2) / 3;
      expect(result.inPoisha, equals(100));
    });
  });

  /// ----------------------------------------------------------
  /// Identical Objects
  /// ----------------------------------------------------------
  group('Money - Identical objects', () {
    test('Should return true for identical objects', () {
      final money = Money(100);
      expect(money == money, isTrue);
    });

    test('Should work with const constructor', () {
      const a = Money(100);
      const b = Money(100);
      expect(identical(a, b), isTrue);
    });

    test('Should work with Money.zero', () {
      const a = Money.zero();
      const b = Money.zero();
      expect(identical(a, b), isTrue);
      expect(a == b, isTrue);
    });
  });
}
