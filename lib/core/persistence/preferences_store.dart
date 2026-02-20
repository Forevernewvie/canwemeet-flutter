import 'dart:collection';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' as legacy;
import 'package:shared_preferences/shared_preferences.dart';

import 'isar/isar_persistence_engine.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main().',
  );
});

final preferencesStoreProvider =
    legacy.ChangeNotifierProvider<PreferencesStore>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      final isarEngine = ref.watch(isarPersistenceEngineProvider);
      return PreferencesStore(prefs, isarEngine: isarEngine);
    });

class PreferencesStore extends ChangeNotifier {
  PreferencesStore(this._prefs, {IsarPersistenceEngine? isarEngine})
    : _isarEngine = isarEngine ?? defaultIsarPersistenceEngine {
    _onboardingCompleted = _prefs.getBool(_kOnboardingCompleted) ?? false;
    _installDateIso = _prefs.getString(_kInstallDateIso);
    _installDateIso ??= DateTime.now().toIso8601String();
    _prefs.setString(_kInstallDateIso, _installDateIso!);

    _favoriteIds = (_prefs.getStringList(_kFavoriteIds) ?? const <String>[])
        .toSet();
    _studiedDayKeys =
        (_prefs.getStringList(_kStudiedDayKeys) ?? const <String>[]).toSet();
    _reviewMap = _decodeReviewMap(_prefs.getString(_kReviewStateJson));

    unawaited(_hydrateFromIsar());
    _persistMeta();
  }

  static const _kOnboardingCompleted = 'onboarding_completed';
  static const _kInstallDateIso = 'install_date_iso';
  static const _kFavoriteIds = 'favorite_ids';
  static const _kStudiedDayKeys = 'studied_day_keys';
  static const _kReviewStateJson = 'review_state_json';

  final SharedPreferences _prefs;
  final IsarPersistenceEngine _isarEngine;

  bool _onboardingCompleted = false;
  String? _installDateIso;
  Set<String> _favoriteIds = <String>{};
  Set<String> _studiedDayKeys = <String>{};
  Map<String, ReviewState> _reviewMap = <String, ReviewState>{};

  bool get onboardingCompleted => _onboardingCompleted;

  UnmodifiableSetView<String> get favoriteIds =>
      UnmodifiableSetView(_favoriteIds);

  DateTime get installDate {
    final raw = _installDateIso;
    if (raw == null) return DateTime.now();
    return DateTime.tryParse(raw) ?? DateTime.now();
  }

  void completeOnboarding() {
    if (_onboardingCompleted) return;
    _onboardingCompleted = true;
    _prefs.setBool(_kOnboardingCompleted, true);
    _persistMeta();
    notifyListeners();
  }

  bool isFavorite(String sentenceId) => _favoriteIds.contains(sentenceId);

  void toggleFavorite(String sentenceId, {DateTime? now}) {
    final timestamp = now ?? DateTime.now();
    if (_favoriteIds.contains(sentenceId)) {
      _favoriteIds.remove(sentenceId);
      _reviewMap.remove(sentenceId);
    } else {
      _favoriteIds.add(sentenceId);
      _reviewMap[sentenceId] = ReviewState(
        dueAtEpochMs: timestamp.millisecondsSinceEpoch,
        intervalDays: 0,
      );
      _recordStudiedDay(timestamp);
    }

    _persistFavorites();
    _persistReviewState();
    _persistStudiedDays();
    _persistMeta();
    notifyListeners();
  }

  void recordStudyEvent({DateTime? now}) {
    _recordStudiedDay(now ?? DateTime.now());
    _persistStudiedDays();
    _persistMeta();
    notifyListeners();
  }

  bool hasStudiedToday({DateTime? today}) {
    final current = today ?? DateTime.now();
    return _studiedDayKeys.contains(_dayKey(current));
  }

  int studiedDayCountInMonth({DateTime? date}) {
    final current = date ?? DateTime.now();
    final monthPrefix =
        '${current.year.toString().padLeft(4, '0')}-${current.month.toString().padLeft(2, '0')}-';
    return _studiedDayKeys
        .where((dayKey) => dayKey.startsWith(monthPrefix))
        .length;
  }

  int currentStreak({DateTime? asOf}) {
    final today = asOf ?? DateTime.now();
    var cursor = DateTime(today.year, today.month, today.day);
    var streak = 0;
    while (_studiedDayKeys.contains(_dayKey(cursor))) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  List<String> dueReviewSentenceIds({DateTime? now}) {
    final timestamp = (now ?? DateTime.now()).millisecondsSinceEpoch;
    return _reviewMap.entries
        .where((entry) => entry.value.dueAtEpochMs <= timestamp)
        .map((entry) => entry.key)
        .toList(growable: false);
  }

  int reviewQueueCount({DateTime? now}) =>
      dueReviewSentenceIds(now: now).length;

  void submitReviewResult(
    String sentenceId,
    ReviewResult result, {
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final previous =
        _reviewMap[sentenceId] ??
        ReviewState(
          dueAtEpochMs: current.millisecondsSinceEpoch,
          intervalDays: 0,
        );

    final nextInterval = switch (result) {
      ReviewResult.again => 0,
      ReviewResult.hard => 1,
      ReviewResult.easy =>
        previous.intervalDays <= 0
            ? 2
            : (previous.intervalDays * 2).clamp(2, 30),
    };

    final nextDue = switch (result) {
      ReviewResult.again => current.add(const Duration(minutes: 10)),
      ReviewResult.hard => current.add(const Duration(hours: 18)),
      ReviewResult.easy => current.add(Duration(days: nextInterval)),
    };

    _reviewMap[sentenceId] = ReviewState(
      dueAtEpochMs: nextDue.millisecondsSinceEpoch,
      intervalDays: nextInterval,
    );

    _recordStudiedDay(current);
    _persistReviewState();
    _persistStudiedDays();
    _persistMeta();
    notifyListeners();
  }

  void refreshReviewNow(String sentenceId, {DateTime? now}) {
    final current = now ?? DateTime.now();
    _reviewMap[sentenceId] = ReviewState(
      dueAtEpochMs: current.millisecondsSinceEpoch,
      intervalDays: 0,
    );
    _persistReviewState();
    _persistMeta();
    notifyListeners();
  }

  void _recordStudiedDay(DateTime date) {
    _studiedDayKeys.add(_dayKey(date));
  }

  void _persistFavorites() {
    _prefs.setStringList(_kFavoriteIds, _favoriteIds.toList(growable: false));
    if (_isarEngine.isEnabled) {
      unawaited(_isarEngine.replaceFavorites(_favoriteIds));
    }
  }

  void _persistStudiedDays() {
    _prefs.setStringList(
      _kStudiedDayKeys,
      _studiedDayKeys.toList(growable: false),
    );
    if (_isarEngine.isEnabled) {
      unawaited(_isarEngine.replaceStudiedDays(_studiedDayKeys));
    }
  }

  void _persistReviewState() {
    final json = jsonEncode(
      _reviewMap.map((key, value) => MapEntry(key, value.toJson())),
    );
    _prefs.setString(_kReviewStateJson, json);
    if (_isarEngine.isEnabled) {
      unawaited(
        _isarEngine.replaceReviewMap(_toPersistedReviewMap(_reviewMap)),
      );
    }
  }

  void _persistMeta() {
    if (!_isarEngine.isEnabled) return;
    final installDateIso = _installDateIso ?? DateTime.now().toIso8601String();
    unawaited(
      _isarEngine.persistMeta(
        onboardingCompleted: _onboardingCompleted,
        installDateIso: installDateIso,
      ),
    );
  }

  Future<void> _hydrateFromIsar() async {
    if (!_isarEngine.isEnabled) return;
    final snapshot = await _isarEngine.loadStateSnapshot();
    if (snapshot == null) {
      // Isar missing/empty: keep legacy values and let startup migration handle
      // initial copy. Writes continue to dual targets for rollback safety.
      return;
    }

    final isarInstallDateIso = snapshot.meta.installDateIso.isEmpty
        ? (_installDateIso ?? DateTime.now().toIso8601String())
        : snapshot.meta.installDateIso;

    final shouldNotify =
        _onboardingCompleted != snapshot.meta.onboardingCompleted ||
        _installDateIso != isarInstallDateIso ||
        !_setEquals(_favoriteIds, snapshot.favoriteIds) ||
        !_setEquals(_studiedDayKeys, snapshot.studiedDayKeys) ||
        !_reviewMapEquals(_reviewMap, snapshot.reviewMap);

    _onboardingCompleted = snapshot.meta.onboardingCompleted;
    _installDateIso = isarInstallDateIso;
    _favoriteIds = snapshot.favoriteIds;
    _studiedDayKeys = snapshot.studiedDayKeys;
    _reviewMap = _fromPersistedReviewMap(snapshot.reviewMap);

    if (shouldNotify) {
      notifyListeners();
    }
  }

  Map<String, PersistedReviewState> _toPersistedReviewMap(
    Map<String, ReviewState> source,
  ) {
    return <String, PersistedReviewState>{
      for (final entry in source.entries)
        entry.key: PersistedReviewState(
          dueAtEpochMs: entry.value.dueAtEpochMs,
          intervalDays: entry.value.intervalDays,
        ),
    };
  }

  Map<String, ReviewState> _fromPersistedReviewMap(
    Map<String, PersistedReviewState> source,
  ) {
    return <String, ReviewState>{
      for (final entry in source.entries)
        entry.key: ReviewState(
          dueAtEpochMs: entry.value.dueAtEpochMs,
          intervalDays: entry.value.intervalDays,
        ),
    };
  }

  Map<String, ReviewState> _decodeReviewMap(String? raw) {
    if (raw == null || raw.isEmpty) return <String, ReviewState>{};

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return <String, ReviewState>{};
      final out = <String, ReviewState>{};
      for (final entry in decoded.entries) {
        final value = entry.value;
        if (value is! Map<String, dynamic>) continue;
        out[entry.key] = ReviewState.fromJson(value);
      }
      return out;
    } catch (_) {
      return <String, ReviewState>{};
    }
  }

  bool _setEquals(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }

  bool _reviewMapEquals(
    Map<String, ReviewState> legacy,
    Map<String, PersistedReviewState> persisted,
  ) {
    if (legacy.length != persisted.length) return false;
    for (final entry in legacy.entries) {
      final other = persisted[entry.key];
      if (other == null) return false;
      if (other.dueAtEpochMs != entry.value.dueAtEpochMs) return false;
      if (other.intervalDays != entry.value.intervalDays) return false;
    }
    return true;
  }

  String _dayKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
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

enum ReviewResult { again, hard, easy }

@immutable
class ReviewState {
  const ReviewState({required this.dueAtEpochMs, required this.intervalDays});

  final int dueAtEpochMs;
  final int intervalDays;

  factory ReviewState.fromJson(Map<String, dynamic> json) {
    return ReviewState(
      dueAtEpochMs: json['dueAtEpochMs'] is int
          ? json['dueAtEpochMs'] as int
          : 0,
      intervalDays: json['intervalDays'] is int
          ? json['intervalDays'] as int
          : 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'dueAtEpochMs': dueAtEpochMs,
    'intervalDays': intervalDays,
  };
}
