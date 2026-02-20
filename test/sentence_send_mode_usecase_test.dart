import 'package:flutter_test/flutter_test.dart';

import 'package:ourmatchwell_flutter/domain/usecases/sentence_send_mode_usecase.dart';

void main() {
  const useCase = SentenceSendModeUseCase();

  test('natural variant keeps normalized original text', () {
    final output = useCase.textFor(
      '  Do you want to grab dinner?   ',
      SentenceToneVariant.natural,
    );

    expect(output, 'Do you want to grab dinner?');
  });

  test('softer variant rewrites phrase and adds polite ending', () {
    final output = useCase.textFor(
      'Do you want to grab dinner?',
      SentenceToneVariant.softer,
    );

    expect(output, 'Would you like to grab dinner please?');
  });

  test('more direct variant removes polite marker', () {
    final output = useCase.textFor(
      'Would you like to grab dinner please?',
      SentenceToneVariant.direct,
    );

    expect(output, 'Do you want to grab dinner?');
  });

  test('variant generation is deterministic for the same input', () {
    const source = 'Can you call me!';

    final first = useCase.textFor(source, SentenceToneVariant.softer);
    final second = useCase.textFor(source, SentenceToneVariant.softer);

    expect(first, second);
    expect(first, 'Could you call me, please.');
  });
}
