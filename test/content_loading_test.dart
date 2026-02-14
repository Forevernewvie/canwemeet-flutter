import 'package:flutter_test/flutter_test.dart';

import 'package:ourmatchwell_flutter/core/content/content_store.dart';
import 'package:ourmatchwell_flutter/core/content/manifest_client.dart';
import 'package:ourmatchwell_flutter/core/persistence/file_cache.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('ContentStore loads bundled datasets', () async {
    final store = ContentStore(
      fileCache: MemoryCache(),
      manifestClient: const ManifestClient(),
    );

    final sentences = await store.getSentences();
    final curated = await store.getCuratedSentences();
    final patterns = await store.getPatterns();

    expect(sentences.length, 1000);
    expect(curated.length, 200);
    expect(patterns.length, 24);
  });
}
