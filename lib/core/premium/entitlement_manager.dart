import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart' as legacy;

import 'iap_service.dart';

final entitlementManagerProvider =
    legacy.ChangeNotifierProvider<EntitlementManager>((ref) {
      final iap = ref.watch(iapServiceProvider);
      return EntitlementManager(iap);
    });

class EntitlementManager extends ChangeNotifier {
  EntitlementManager(this._iap);

  final IapService _iap;

  bool _isPremium = false;

  bool get isPremium => _isPremium;

  Future<void> purchasePremium() async {
    final ok = await _iap.purchasePremium();
    if (ok) {
      _isPremium = true;
      notifyListeners();
    }
  }

  Future<void> restore() async {
    final ok = await _iap.restore();
    if (ok) {
      _isPremium = true;
      notifyListeners();
    }
  }

  // Useful for unit tests.
  void setPremiumForDebug(bool value) {
    if (_isPremium == value) return;
    _isPremium = value;
    notifyListeners();
  }
}
