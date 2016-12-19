// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/analyzer.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

/// A patch that may be applied on existing source file.
///
/// Existing text between [offset] and [length] should be replaced with [text].
abstract class Patch implements Comparable<Patch> {
  const Patch._();

  /// Returns a simple patch that replaces existing text.
  @literal
  const factory Patch(
    int offset,
    int length,
    String text,
  ) = _StringPatch;

  /// Returns a patch that makes no modifications to a file.
  @literal
  const factory Patch.identity() = _IdentityPatch;

  /// Returns a patch that removes the AST [oldAst].
  @literal
  const factory Patch.removeAst(AstNode oldAst) = _RemoveAstPatch;

  /// Returns a patch that replaces the AST [oldAst] with [newAst].
  @literal
  const factory Patch.replaceAst(
    AstNode oldAst,
    AstNode newAst,
  ) = _ReplaceAstPatch;

  @override
  bool operator ==(Object o) {
    if (o is Patch) {
      return offset == o.offset && length == o.length && text == o.text;
    }
    return false;
  }

  @override
  int get hashCode => hash3(offset, length, text);

  @override
  int compareTo(Patch patch) => offset.compareTo(patch.offset);

  /// Where in the source file the patch should be applied.
  int get offset;

  /// Starting at [offset], how many character should be removed.
  int get length;

  /// After removing [length] characters at [offset], replace with this value.
  String get text;

  @override
  String toString() => '$Patch {$offset->${offset + length}: $text}';
}

class _IdentityPatch extends Patch {
  const _IdentityPatch() : super._();

  @override
  final int offset = 0;

  @override
  final int length = 0;

  @override
  final String text = '';
}

class _RemoveAstPatch extends Patch {
  final AstNode _oldNode;

  const _RemoveAstPatch(this._oldNode) : super._();

  @override
  int get offset => _oldNode.offset;

  @override
  int get length => _oldNode.length;

  @override
  final String text = '';
}

class _ReplaceAstPatch extends Patch {
  final AstNode _oldNode;
  final AstNode _newNode;

  const _ReplaceAstPatch(this._oldNode, this._newNode) : super._();

  @override
  int get offset => _oldNode.offset;

  @override
  int get length => _oldNode.length;

  @override
  String get text => _newNode.toSource();
}

class _StringPatch extends Patch {
  const _StringPatch(this.offset, this.length, this.text) : super._();

  @override
  final int offset;

  @override
  final int length;

  @override
  final String text;
}
