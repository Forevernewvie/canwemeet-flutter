import 'package:flutter_riverpod/flutter_riverpod.dart';

final iapServiceProvider = Provider<IapService>((ref) {
  // TODO: Wire StoreKit/Google Play via in_app_purchase.
  return const IapService();
});

class IapService {
  const IapService();

  Future<bool> purchasePremium() async {
    // Stub: always succeeds in debug flows.
    return true;
  }

  Future<bool> restore() async {
    // Stub: no-op.
    return false;
  }
}
