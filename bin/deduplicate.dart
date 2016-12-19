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
