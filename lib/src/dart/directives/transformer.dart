// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of source_transformer.src.dart.directives;

/// A high-level transformer for manipulating `import` and `export` directives.
abstract class DirectiveTransformer<S> extends DartSourceTransformer {
  const DirectiveTransformer();

  /// Should return `true` if the directive should be altered.
  @protected
  bool canTransform(Directive directive);

  /// Return a new default state object; optional.
  @protected
  S defaultState() => null;

  @override
  Iterable<Patch> computePatches(CompilationUnit parsedSource) {
    final initialState = defaultState();
    return parsedSource.directives.where(canTransform).map((oldDirective) {
      final newDirective = transformDirective(oldDirective, initialState);
      if (newDirective == null) {
        return new Patch.removeAst(oldDirective);
      }
      return new Patch.replaceAst(oldDirective, newDirective);
    });
  }

  /// Returns a new directive to replace [directive] with.
  ///
  /// May return back the _same_ directive to avoid doing anything, but if
  /// possible it is preferred to make this type of check in [canTransform].
  ///
  /// If `null` is returned, indicates that directive should be removed.
  @protected
  Directive transformDirective(Directive directive, [S state]);
}
