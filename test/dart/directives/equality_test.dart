import 'package:analyzer/analyzer.dart';
import 'package:source_transformer/src/dart/directives.dart';
import 'package:test/test.dart';

void main() {
  const equality = const DirectiveEquality();
  List<Directive> imports;
  List<Directive> exports;

  setUpAll(() {
    imports = parseDirectives(r'''
      import 'package:foo/foo.dart';            // 0
      import 'package:foo/foo.dart';            // 1
      import 'package:bar/bar.dart';            // 2
      import 'package:bar/bar.dart' as bar;     // 3
      import 'package:bar/bar.dart' as bar;     // 4
      import 'package:bar/bar.dart' as bar2;    // 5
      import 'package:baz/baz.dart';            // 6
      import 'package:baz/baz.dart' show baz;   // 7
      import 'package:baz/baz.dart' show baz;   // 8
      import 'package:baz/baz.dart' hide baz;   // 9
      import 'package:baz/baz.dart' hide baz;   // 10
    ''').directives.where((d) => d is ImportDirective).toList();

    exports = parseDirectives(r'''
      export 'package:foo/foo.dart';            // 0
      export 'package:foo/foo.dart';            // 1
      export 'package:bar/bar.dart';            // 2
      export 'package:baz/baz.dart';            // 3
      export 'package:baz/baz.dart' show baz;   // 4
      export 'package:baz/baz.dart' show baz;   // 5
      export 'package:baz/baz.dart' hide baz;   // 6
      export 'package:baz/baz.dart' hide baz;   // 7
    ''').directives.where((d) => d is ExportDirective).toList();
  });

  // Currently only supports URI comparisons, so test cases limited.

  group('$ImportDirective', () {
    test('should be equivalent to another import directive', () {
      expect(equality.equals(imports[0], imports[1]), isTrue);
    });

    test('should not be equuivalent with a different URI', () {
      expect(equality.equals(imports[0], imports[2]), isFalse);
    });
  });

  group('$ExportDirective', () {
    test('should be equivalent to another import directive', () {
      expect(equality.equals(exports[0], exports[1]), isTrue);
    });

    test('should not be equuivalent with a different URI', () {
      expect(equality.equals(exports[2], exports[3]), isFalse);
    });
  });
}
