// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:source_transformer/src/patch.dart';

/// A synchronous phase of multiple, ordered patches to a source file.
abstract class Phase implements Iterable<Patch> {
  /// Create a new phase from an existing set of [patches].
  ///
  /// Patches are ordered to apply in decreasing order of offsets.
  factory Phase(Iterable<Patch> patches) {
    return new _ListPhase((patches.toList()..sort()).reversed.toList());
  }

  /// Returns a new source text by patching [text].
  String apply(String text) {
    return fold(text, (text, p) {
      return text.replaceRange(p.offset, p.offset + p.length, p.text);
    });
  }
}

class _ListPhase extends DelegatingList<Patch> with Phase {
  _ListPhase(List<Patch> patches) : super(patches);

  @override
  String toString() => '$Phase {$this}';
}
