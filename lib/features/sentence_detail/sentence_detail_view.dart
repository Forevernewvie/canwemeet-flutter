import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/theme.dart';
import '../../core/content/content_providers.dart';
import '../../core/constants/feature_texts.dart';
import '../../core/persistence/preferences_store.dart';
import '../../domain/usecases/sentence_send_mode_usecase.dart';
import '../../ui_components/app_surfaces.dart';

/// Shows sentence details with practical send-mode actions.
class SentenceDetailView extends ConsumerStatefulWidget {
  const SentenceDetailView({required this.sentenceId, super.key});

  final String sentenceId;

  @override
  ConsumerState<SentenceDetailView> createState() => _SentenceDetailViewState();
}

class _SentenceDetailViewState extends ConsumerState<SentenceDetailView> {
  SentenceToneVariant _selectedTone = SentenceToneVariant.natural;

  @override
  /// Builds sentence details, tone variants, and send actions.
  Widget build(BuildContext context) {
    final sentenceAsync = ref.watch(sentenceByIdProvider(widget.sentenceId));
    final prefs = ref.watch(preferencesStoreProvider);
    final sendMode = ref.watch(sentenceSendModeUseCaseProvider);

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
          final sendText = sendMode.textFor(sentence.english, _selectedTone);

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
              Text(
                FeatureTexts.sendModeSectionTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: SentenceToneVariant.values
                    .map((variant) {
                      return ChoiceChip(
                        selected: _selectedTone == variant,
                        label: Text(variant.label),
                        onSelected: (_) {
                          setState(() => _selectedTone = variant);
                        },
                      );
                    })
                    .toList(growable: false),
              ),
              const SizedBox(height: 10),
              AppCard(
                title: FeatureTexts.sendModePreviewTitle,
                subtitle: sendText,
                badges: [_selectedTone.label],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _copyText(context, sendText),
                      icon: const Icon(Icons.copy_rounded),
                      label: const Text(FeatureTexts.sendModeCopyButton),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _shareText(context, sendText),
                      icon: const Icon(Icons.share_rounded),
                      label: const Text(FeatureTexts.sendModeShareButton),
                    ),
                  ),
                ],
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

  /// Copies transformed text to clipboard and displays completion feedback.
  Future<void> _copyText(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(FeatureTexts.sendModeCopiedSnackbar)),
    );
  }

  /// Opens system share sheet with transformed text content.
  Future<void> _shareText(BuildContext context, String text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  }
}
