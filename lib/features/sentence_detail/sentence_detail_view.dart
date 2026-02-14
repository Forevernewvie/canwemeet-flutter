import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SentenceDetailView extends StatelessWidget {
  const SentenceDetailView({required this.sentenceId, super.key});

  final String sentenceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('문장 상세')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sentence ID: $sentenceId',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () {
                // TODO: Hook TTS.
              },
              child: const Text('발음 듣기 (TTS)'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => context.push('/ai'),
              child: const Text('AI 대화 (Premium)'),
            ),
          ],
        ),
      ),
    );
  }
}
