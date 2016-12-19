// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:analyzer/analyzer.dart';
import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';
import 'package:source_transformer/src/patch.dart';
import 'package:source_transformer/src/phase.dart';

/// A transforming API that applies a set of changes to an input file.
///
/// To apply multiple transformers, see [Transformer.multiple].
abstract class Transformer {
  /// Returns a source transformer that applies multiple [transformers].
  @literal
  const factory Transformer.multiple(
    Iterable<Transformer> transformers,
  ) = _MultiTransformer;

  /// Returns a source transformer that just returns the original file.
  @literal
  const factory Transformer.identity() = _IdentityTransformer;

  /// Returns a future that completes with a transformed [file].
  Future<SourceFile> transform(SourceFile file);
}

/// A base transformer that may be implemented to easily patch `.dart` files.
abstract class DartSourceTransformer implements Transformer {
  final bool _parseFunctionBodies;

  const DartSourceTransformer({bool parseFunctionBodies: false})
      : _parseFunctionBodies = parseFunctionBodies;

  /// Returns a collection of patches to apply on [parsedSource].
  @protected
  Iterable<Patch> computePatches(CompilationUnit parsedSource);

  @override
  Future<SourceFile> transform(SourceFile file) async {
    final parsedSource = parseCompilationUnit(
      file.getText(0),
      parseFunctionBodies: _parseFunctionBodies,
    );
    return new SourceFile(
      new Phase(computePatches(parsedSource)).apply(
        file.getText(0),
      ),
      url: file.url,
    );
  }
}

class _IdentityTransformer implements Transformer {
  const _IdentityTransformer();

  @override
  Future<SourceFile> transform(SourceFile file) async => file;
}

class _MultiTransformer implements Transformer {
  final Iterable<Transformer> _transformers;

  const _MultiTransformer(this._transformers);

  @override
  Future<SourceFile> transform(SourceFile file) {
    return new Stream.fromIterable(_transformers).fold/*<Future<SourceFile>>*/(
      new Future.value(file),
      (futureFile, transformer) async {
        return transformer.transform(await futureFile);
      },
    );
  }
}
