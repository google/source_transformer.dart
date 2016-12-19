// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:source_span/source_span.dart';
import 'package:source_transformer/source_transformer.dart';

/// Convenience function to run a [transformer] on the provided file [paths].
///
/// See `bin/deduplicate.dart` for an example.
Future runTransformer(
  Transformer transformer,
  Iterable<String> paths,
) {
  return Future.wait(paths.map((path) async {
    final input = new File(path);
    final sourceText = input.readAsStringSync();
    final oldFile = new SourceFile(sourceText, url: path);
    final newFile = await transformer.transform(oldFile);
    input.writeAsStringSync(newFile.getText(0));
  }));
}
