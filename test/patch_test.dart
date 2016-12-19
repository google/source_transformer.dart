// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/analyzer.dart';
import 'package:source_transformer/src/patch.dart';
import 'package:test/test.dart';

void main() {
  test('should create a simple text patch', () {
    final patch = new Patch(10, 5, 'Test');
    expect(patch.offset, 10);
    expect(patch.length, 5);
    expect(patch.text, 'Test');
  });

  test('should create a simple AST removal patch', () {
    final patch = new Patch.removeAst(parseCompilationUnit('class A {}'));
    expect(patch.offset, 0);
    expect(patch.length, 10);
    expect(patch.text, isEmpty);
  });

  test('should create a simple AST replacement patch', () {
    final astA = parseCompilationUnit('class A {}');
    final astB = parseCompilationUnit('class B {}');
    final patch = new Patch.replaceAst(astA, astB);
    expect(patch.offset, 0);
    expect(patch.length, 10);
    expect(patch.text, astB.toSource());
  });
}
