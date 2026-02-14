import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' as legacy;
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main().',
  );
});

final preferencesStoreProvider =
    legacy.ChangeNotifierProvider<PreferencesStore>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return PreferencesStore(prefs);
    });

class PreferencesStore extends ChangeNotifier {
  PreferencesStore(this._prefs) {
    _onboardingCompleted = _prefs.getBool(_kOnboardingCompleted) ?? false;
    _installDateIso = _prefs.getString(_kInstallDateIso);
    _installDateIso ??= DateTime.now().toIso8601String();
    _prefs.setString(_kInstallDateIso, _installDateIso!);
  }

  static const _kOnboardingCompleted = 'onboarding_completed';
  static const _kInstallDateIso = 'install_date_iso';

  final SharedPreferences _prefs;

  bool _onboardingCompleted = false;
  String? _installDateIso;

  bool get onboardingCompleted => _onboardingCompleted;

  DateTime get installDate {
    final raw = _installDateIso;
    if (raw == null) return DateTime.now();
    return DateTime.tryParse(raw) ?? DateTime.now();
  }

  void completeOnboarding() {
    if (_onboardingCompleted) return;
    _onboardingCompleted = true;
    _prefs.setBool(_kOnboardingCompleted, true);
    notifyListeners();
  }
}

extension PreferencesStoreDayIndex on PreferencesStore {
  int dayIndexFor(DateTime date) {
    final startInstall = DateTime(
      installDate.year,
      installDate.month,
      installDate.day,
    );
    final startDate = DateTime(date.year, date.month, date.day);
    return startDate.difference(startInstall).inDays;
  }
}
