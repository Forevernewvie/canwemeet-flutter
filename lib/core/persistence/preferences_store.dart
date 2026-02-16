import 'dart:collection';
import 'dart:convert';

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

    _favoriteIds = (_prefs.getStringList(_kFavoriteIds) ?? const <String>[])
        .toSet();
    _studiedDayKeys =
        (_prefs.getStringList(_kStudiedDayKeys) ?? const <String>[]).toSet();
    _reviewMap = _decodeReviewMap(_prefs.getString(_kReviewStateJson));
  }

  static const _kOnboardingCompleted = 'onboarding_completed';
  static const _kInstallDateIso = 'install_date_iso';
  static const _kFavoriteIds = 'favorite_ids';
  static const _kStudiedDayKeys = 'studied_day_keys';
  static const _kReviewStateJson = 'review_state_json';

  final SharedPreferences _prefs;

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
    notifyListeners();
  }

  void recordStudyEvent({DateTime? now}) {
    _recordStudiedDay(now ?? DateTime.now());
    _persistStudiedDays();
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
    notifyListeners();
  }

  void refreshReviewNow(String sentenceId, {DateTime? now}) {
    final current = now ?? DateTime.now();
    _reviewMap[sentenceId] = ReviewState(
      dueAtEpochMs: current.millisecondsSinceEpoch,
      intervalDays: 0,
    );
    _persistReviewState();
    notifyListeners();
  }

  void _recordStudiedDay(DateTime date) {
    _studiedDayKeys.add(_dayKey(date));
  }

  void _persistFavorites() {
    _prefs.setStringList(_kFavoriteIds, _favoriteIds.toList(growable: false));
  }

  void _persistStudiedDays() {
    _prefs.setStringList(
      _kStudiedDayKeys,
      _studiedDayKeys.toList(growable: false),
    );
  }

  void _persistReviewState() {
    final json = jsonEncode(
      _reviewMap.map((key, value) => MapEntry(key, value.toJson())),
    );
    _prefs.setString(_kReviewStateJson, json);
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
