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
    final palette = context.appPalette;
    final sentenceAsync = ref.watch(sentenceByIdProvider(widget.sentenceId));
    final prefs = ref.watch(preferencesStoreProvider);
    final sendMode = ref.watch(sentenceSendModeUseCaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('문장')),
      body: sentenceAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: AppLoadingStateCard(message: '문장을 불러오고 있어요...'),
        ),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(16),
          child: AppErrorStateCard(
            title: '오류가 발생했어요',
            body: '문장을 불러오지 못했어요: $error',
            onRetry: null,
          ),
        ),
        data: (sentence) {
          if (sentence == null) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: AppEmptyStateCard(
                title: '문장을 찾지 못했어요.',
                body: '문장 목록으로 돌아가 다시 선택해 주세요.',
              ),
            );
          }

          final isFavorite = prefs.isFavorite(sentence.id);
          final sendText = sendMode.textFor(sentence.english, _selectedTone);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '문장 상세 · 실전 전송 모드',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              AppCard(
                title: sentence.english,
                subtitle: sentence.korean,
                badges: [sentence.usageLabel],
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
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: SentenceToneVariant.values
                    .map(
                      (variant) => ChoiceChip(
                        selected: _selectedTone == variant,
                        label: Text(variant.label),
                        onSelected: (_) =>
                            setState(() => _selectedTone = variant),
                        showCheckmark: false,
                        labelStyle: TextStyle(
                          color: _selectedTone == variant
                              ? palette.onAccent
                              : palette.chipText,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        backgroundColor: palette.chip,
                        selectedColor: palette.accent,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    )
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
                    child: OutlinedButton(
                      onPressed: () => _copyText(context, sendText),
                      child: const Text(FeatureTexts.sendModeCopyButton),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _shareText(context, sendText),
                      child: const Text(FeatureTexts.sendModeShareButton),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              AppStatusBanner(
                title: '오늘 추천 저장 ${isFavorite ? 1 : 0}개',
                body: '좋았던 문장을 저장하면 복습 큐가 자동 생성돼요.',
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () {
                  ref
                      .read(preferencesStoreProvider)
                      .toggleFavorite(sentence.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isFavorite ? '저장에서 제거했어요.' : '학습에 추가했어요.'),
                    ),
                  );
                },
                child: const Text('학습에 추가하기'),
              ),
              const SizedBox(height: 10),
              Text(
                '기본 학습/저장은 무료로 유지됩니다.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: palette.subText),
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
