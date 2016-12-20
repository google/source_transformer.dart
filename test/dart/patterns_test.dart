// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:source_span/source_span.dart';
import 'package:source_transformer/source_transformer.dart';
import 'package:test/test.dart';

main() {
  final aDartFile = new SourceFile(r'''
void main() {
  statement1;
  statement2();
  state.ment3;

  state..ment(4);

  statement + 5;

  statement = 6;
}''');

  test('$RemoveDirectives should remove patterns', () async {
    final transformer = new RemovePatterns([
      // These examples include detailed whitespace captures before and after
      // the statements, so that the trailing newline is also removed, which
      // dartfmt will respect.
      new RegExp(r'[ \t]*statement2\(\);[ \t]*\n?'),
      new RegExp(r'[ \t]*statement \+ 5;[ \t]*\n?'),
    ]);

    // Note the strict whitespace equality requirements: this example verifies
    // that whitespace is as it should be to support statement removals:
    //
    // * There is no blank line between statements 1 and 3, which would be
    //   preserved by dartfmt; this way, statements are not replaced by blank
    //   lines.
    // * There are two blank lines between statements 4 and 6, which will be
    //   squeezed into just one blank line. This allows dartfmt to respect the
    //   whitespace in the original text.
    expect(
      (await transformer.transform(aDartFile)).getText(0),
      equals(
        r'''
void main() {
  statement1;
  state.ment3;

  state..ment(4);


  statement = 6;
}''',
      ),
    );
  });
}
