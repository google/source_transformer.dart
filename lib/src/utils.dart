// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/analyzer.dart';

/// Returns a deep-copy of [astNode].
/*=T*/ cloneNode/*<T extends AstNode>*/(AstNode/*=T*/ astNode) {
  return new AstCloner().cloneNode/*<T>*/(astNode);
}
