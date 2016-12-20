// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:source_span/source_span.dart';
import 'package:source_transformer/source_transformer.dart';

/// Invokes `String.replaceAll` to remove all pattern matches.
class RemovePatterns implements Transformer {
  final Iterable<Pattern> _removals;

  const RemovePatterns(this._removals);

  @override
  Future<SourceFile> transform(SourceFile source) async {
    String text = source.getText(0);
    text = _removals.fold(text, (text, pattern) {
      return text.replaceAll(pattern, '');
    });
    return new SourceFile(text, url: source.url);
  }
}

/// Invokes 'String.replaceAll' to replace all pattern matches.
class ReplacePatterns implements Transformer {
  final Map<Pattern, String> _replacements;

  const ReplacePatterns(this._replacements);

  @override
  Future<SourceFile> transform(SourceFile source) async {
    String text = source.getText(0);
    text = _replacements.keys.fold(text, (text, pattern) {
      return text.replaceAll(pattern, _replacements[pattern]);
    });
    return new SourceFile(text, url: source.url);
  }
}

