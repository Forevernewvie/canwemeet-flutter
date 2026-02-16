import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/content/content_providers.dart';
import '../../domain/models/pattern.dart';
import '../../ui_components/app_surfaces.dart';

class PatternPracticeView extends ConsumerStatefulWidget {
  const PatternPracticeView({super.key});

  @override
  ConsumerState<PatternPracticeView> createState() =>
      _PatternPracticeViewState();
}

class _PatternPracticeViewState extends ConsumerState<PatternPracticeView> {
  Pattern? _selectedPattern;
  final Map<String, TextEditingController> _slotControllers =
      <String, TextEditingController>{};
  String? _result;

  @override
  void dispose() {
    for (final controller in _slotControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentAsync = ref.watch(contentSnapshotProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('패턴 연습')),
      body: contentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('로딩 실패: $error')),
        data: (snapshot) {
          final patterns = snapshot.patterns;
          _selectedPattern ??= patterns.isEmpty ? null : patterns.first;

          final pattern = _selectedPattern;
          if (pattern == null) {
            return const Center(child: Text('패턴 데이터가 없습니다.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DropdownButtonFormField<String>(
                initialValue: pattern.id,
                decoration: const InputDecoration(labelText: '패턴 선택'),
                items: [
                  for (final item in patterns)
                    DropdownMenuItem<String>(
                      value: item.id,
                      child: Text(item.title),
                    ),
                ],
                onChanged: (id) {
                  final next = patterns.where((p) => p.id == id).firstOrNull;
                  if (next == null) return;
                  setState(() {
                    _selectedPattern = next;
                    _result = null;
                    for (final controller in _slotControllers.values) {
                      controller.dispose();
                    }
                    _slotControllers.clear();
                  });
                },
              ),
              const SizedBox(height: 12),
              AppCard(
                title: pattern.title,
                subtitle:
                    '${pattern.exampleEnglish}\n${pattern.exampleKorean}\n\n팁: ${pattern.tip}',
                badges: pattern.tags
                    .map((tag) => '#$tag')
                    .toList(growable: false),
              ),
              const SizedBox(height: 12),
              for (final slot in pattern.slots) ...[
                TextField(
                  controller: _slotControllers.putIfAbsent(
                    slot.key,
                    () => TextEditingController(),
                  ),
                  decoration: InputDecoration(
                    hintText: '${slot.key} (예: ${slot.hint})',
                  ),
                ),
                const SizedBox(height: 10),
              ],
              FilledButton(
                onPressed: () {
                  setState(() {
                    _result = _buildSentence(pattern);
                  });
                },
                child: const Text('문장 만들기'),
              ),
              if (_result != null) ...[
                const SizedBox(height: 12),
                AppCard(
                  title: '내가 만든 문장',
                  subtitle: _result,
                  badges: const ['연습'],
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  String _buildSentence(Pattern pattern) {
    var output = pattern.slotTemplate;
    for (final slot in pattern.slots) {
      final input = _slotControllers[slot.key]?.text.trim();
      final replacement = (input == null || input.isEmpty) ? slot.hint : input;
      output = output.replaceAll('{${slot.key}}', replacement);
    }
    return output;
  }
}

extension _IterableFirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
