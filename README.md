# source_transformer

_NOTE: This project is **not** an official Google or dart-lang project_

**This package is currently in development**

Not to be confused with `code_transformers` or `source_gen`,
`source_transformer` is a library for building and applying
modifications to existing files, primarily `.dart` source files, and to
commit the results of those changes.

Example uses:

* Writing tools to automatically upgrade deprecated APIs
* Writing tools to perform mass refactorings
* Writing tools to perform macros as part of writing new code

An example of creating a binary that removes duplicate imports/exports:

```dart
import 'package:source_transformer/source_transformer.dart';

main(List<String> paths) async {
  await runTransformer(const DeduplicateDirectives(), paths);
}
```
