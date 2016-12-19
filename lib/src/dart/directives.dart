// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
library source_transformer.src.dart.directives;

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/standard_ast_factory.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/src/dart/ast/token.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:source_transformer/source_transformer.dart';
import 'package:source_transformer/src/utils.dart';

part 'directives/equality.dart';
part 'directives/transformer.dart';

/// A transformer that removes duplicate import and export directives.
///
/// The default implementation of `Equality<Directive>` only attempts to remove
/// directives without deferred loading, an `as` statement, or the `show` and
/// `hide` combinators.
///
/// An ideal transformer to run after refactoring directives.
class DeduplicateDirectives extends DirectiveTransformer<Set<Directive>> {
  final Equality<Directive> _equality;

  @literal
  const DeduplicateDirectives({
    Equality<Directive> equality: const DirectiveEquality(),
  })
      : _equality = equality;

  @override
  bool canTransform(Directive directive) {
    if (directive is ImportDirective) {
      return directive.asKeyword == null &&
              directive.deferredKeyword == null &&
              directive.combinators == null ||
          directive.combinators.isEmpty;
    }
    if (directive is ExportDirective) {
      return directive.combinators == null || directive.combinators.isEmpty;
    }
    return false;
  }

  @override
  Set<Directive> defaultState() => new EqualitySet<Directive>(_equality);

  @override
  Directive transformDirective(Directive directive, [Set<Directive> state]) {
    return state.add(directive) ? directive : null;
  }
}

/// A source transformer that removes directives that reference certain URIs.
///
/// If a URI is not found, it is skipped.
///
/// ## Example use
/// ```
/// const RemoveDirectives([
///   'package:a/a.dart',
///   'package:b/b.dart',
/// ])
/// ```
class RemoveDirectives extends DirectiveTransformer<Null> {
  final Iterable<String> _uris;

  @literal
  const RemoveDirectives(this._uris);

  @mustCallSuper
  @override
  bool canTransform(Directive directive) {
    if (directive is UriBasedDirective) {
      return _uris.contains(directive.uri.stringValue);
    }
    return false;
  }

  @override
  Directive transformDirective(@checked UriBasedDirective directive, [_]) {
    return null;
  }
}

/// A source transformer that replaces directives with other URIs.
///
/// ## Example use
/// ```
/// const ReplaceDirectives({
///   'package:a/a.dart': 'package:b/b.dart',
/// })
/// ```
class ReplaceDirectives extends DirectiveTransformer<Null> {
  final Map<String, String> _uris;

  const ReplaceDirectives(this._uris);

  @mustCallSuper
  @override
  bool canTransform(Directive directive) {
    if (directive is UriBasedDirective) {
      return _uris.containsKey(directive.uri.stringValue);
    }
    return false;
  }

  @override
  Directive transformDirective(@checked UriBasedDirective directive, [_]) {
    final newUri = _uris[directive.uri.stringValue];
    if (newUri != null) {
      return cloneNode(directive)
        ..uri = astFactory.simpleStringLiteral(
          new StringToken(TokenType.STRING, "'$newUri'", 0),
          "'$newUri'",
        );
    }
    return directive;
  }
}
