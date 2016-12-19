// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
part of source_transformer.src.dart.directives;

class DirectiveEquality implements Equality<Directive> {
  const DirectiveEquality();

  @override
  bool equals(Directive e1, Directive e2) {
    if (e1 is ImportDirective && e2 is ImportDirective) {
      if (e1.asKeyword != null ||
          e1.deferredKeyword != null ||
          e1.combinators?.isNotEmpty == true ||
          e2.asKeyword != null ||
          e2.deferredKeyword != null ||
          e2.combinators?.isNotEmpty == true) {
        // For now don't try to compare import directive properties.
        return false;
      }
      return e1.uri.stringValue == e2.uri.stringValue;
    }
    if (e1 is ExportDirective && e2 is ExportDirective) {
      if (e1.combinators?.isNotEmpty == true ||
          e2.combinators?.isNotEmpty == true) {
        // For now don't try to compare import directive properties.
        return false;
      }
      return e1.uri.stringValue == e2.uri.stringValue;
    }
    return false;
  }

  @override
  int hash(Directive e) => e.toSource().hashCode;

  @override
  bool isValidKey(Object o) => o is Directive;
}