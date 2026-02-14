import 'package:flutter_riverpod/flutter_riverpod.dart';

final manifestClientProvider = Provider<ManifestClient>((ref) {
  // TODO: Wire a real endpoint. Keeping stubbed avoids misleading UX until we ship an API.
  return const ManifestClient();
});

class ManifestClient {
  const ManifestClient();

  Future<RemoteManifest?> fetch() async {
    return null;
  }
}

class RemoteManifest {
  const RemoteManifest({required this.version});

  final int version;
}
