// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:source_span/source_span.dart';
import 'package:source_transformer/src/dart/directives.dart';
import 'package:test/test.dart';

void main() {
  test('should replace directives', () async {
    final file = new SourceFile(r'''
      import 'package:foo/foo.dart';
      import 'package:bar/bar.dart';
      import 'package:baz/baz.dart';
    ''');
    final result = await const ReplaceDirectives(const {
      'package:bar/bar.dart': 'package:bar/deprecated.dart',
    }).transform(file);
    expect(
      result.getText(0),
      equalsIgnoringWhitespace(r'''
        import 'package:foo/foo.dart';
        import 'package:bar/deprecated.dart';
        import 'package:baz/baz.dart';
      '''),
    );
  });
}
