// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/standard_ast_factory.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/src/dart/ast/token.dart';
import 'package:source_transformer/src/patch.dart';
import 'package:source_transformer/src/phase.dart';
import 'package:source_transformer/src/utils.dart';
import 'package:test/test.dart';

void main() {
  test('should apply a simple string replacement', () {
    final string = 'Hello "Joe"!';
    expect(
      new Phase([
        new Patch(string.indexOf('"') + 1, 'Joe'.length, 'Jill'),
      ]).apply(string),
      'Hello "Jill"!',
    );
  });

  test('should apply a simple AST removal', () {
    const file = '''
      import 'package:old/old.dart';

      void main() {
        doThing();
      }
    ''';

    final oldDirective = parseCompilationUnit(file).directives.first;

    expect(
      new Phase([
        new Patch.removeAst(oldDirective),
      ]).apply(file),
      equalsIgnoringWhitespace(r'''
        void main() {
          doThing();
        }
      '''),
    );
  });

  test('should apply a simple AST replacement', () {
    const file = '''
      import 'package:old/old.dart';

      void main() {
        doThing();
      }
    ''';

    final oldDirective = parseCompilationUnit(file).directives.first;
    final newDirective = cloneNode/*<ImportDirective>*/(oldDirective);
    newDirective.uri = astFactory.simpleStringLiteral(
      new StringToken(TokenType.STRING, "'package:new/new.dart'", 0),
      "'package:new/new.dart'",
    );

    expect(
      new Phase([
        new Patch.replaceAst(oldDirective, newDirective),
      ]).apply(file),
      equalsIgnoringWhitespace(r'''
        import 'package:new/new.dart';

        void main() {
          doThing();
        }
      '''),
    );
  });
}
