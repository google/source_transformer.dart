// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

export 'package:source_transformer/src/cli.dart' show runTransformer;
export 'package:source_transformer/src/dart/directives.dart'
    show
        DeduplicateDirectives,
        DirectiveTransformer,
        RemoveDirectives,
        ReplaceDirectives;
export 'package:source_transformer/src/patch.dart' show Patch;
export 'package:source_transformer/src/patterns.dart'
    show RemovePatterns, ReplacePatterns;
export 'package:source_transformer/src/phase.dart' show Phase;
export 'package:source_transformer/src/transformer.dart'
    show DartSourceTransformer, Transformer;
