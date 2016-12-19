// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:source_transformer/source_transformer.dart';

/// Remove all duplicate imports and exports in a set of files.
///
/// Simple but useful example of consuming a source transformer.
///
/// ## Example use
/// ```
/// $ dart bin/deduplicate.dart /some/path.dart /some/other/path.dart ...
/// ```
main(List<String> paths) async {
  await runTransformer(const DeduplicateDirectives(), paths);
}
