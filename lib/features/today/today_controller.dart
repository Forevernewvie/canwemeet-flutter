import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' as legacy;

import '../../domain/usecases/today_pack_usecase.dart';

final todayFocusProvider = legacy.StateProvider<String>((ref) => 'date');

final todayPackProvider = FutureProvider<TodayPack>((ref) async {
  final focus = ref.watch(todayFocusProvider);
  final usecase = ref.watch(todayPackUseCaseProvider);
  return usecase.getTodayPack(date: DateTime.now(), scenarioTag: focus);
});
