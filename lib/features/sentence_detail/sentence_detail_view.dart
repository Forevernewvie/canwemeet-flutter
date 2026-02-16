import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/content/content_providers.dart';
import '../../core/persistence/preferences_store.dart';
import '../../ui_components/app_surfaces.dart';

class SentenceDetailView extends ConsumerWidget {
  const SentenceDetailView({required this.sentenceId, super.key});

  final String sentenceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sentenceAsync = ref.watch(sentenceByIdProvider(sentenceId));
    final prefs = ref.watch(preferencesStoreProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('문장')),
      body: sentenceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('문장을 불러오지 못했어요: $error')),
        data: (sentence) {
          if (sentence == null) {
            return const Center(child: Text('문장을 찾지 못했어요.'));
          }

          final isFavorite = prefs.isFavorite(sentence.id);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard(
                title: sentence.english,
                subtitle: sentence.korean,
                badges: [sentence.usageLabel, '톤: ${sentence.tone}'],
                trailing: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        ref.read(preferencesStoreProvider).recordStudyEvent();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('발음 재생 기능은 준비 중입니다.')),
                        );
                      },
                      icon: const Icon(Icons.volume_up_outlined),
                    ),
                    IconButton(
                      onPressed: () => ref
                          .read(preferencesStoreProvider)
                          .toggleFavorite(sentence.id),
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'AI 대화 기능은 서버 연동 후 제공될 예정입니다.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.text),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
