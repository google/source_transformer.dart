import 'package:source_span/source_span.dart';
import 'package:source_transformer/src/dart/directives.dart';
import 'package:test/test.dart';

void main() {
  test('should remove directives', () async {
    final file = new SourceFile(r'''
      import 'package:foo/foo.dart';
      import 'package:bar/bar.dart';
      import 'package:baz/baz.dart';
    ''');
    final result = await const RemoveDirectives(const [
      'package:bar/bar.dart',
    ]).transform(file);
    expect(
      result.getText(0),
      equalsIgnoringWhitespace(r'''
        import 'package:foo/foo.dart';
        import 'package:baz/baz.dart';
      '''),
    );
  });
}
