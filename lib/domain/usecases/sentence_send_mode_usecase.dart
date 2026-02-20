import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/feature_texts.dart';

/// Provides send-mode text transformation logic as a dependency.
final sentenceSendModeUseCaseProvider = Provider<SentenceSendModeUseCase>((
  ref,
) {
  return const SentenceSendModeUseCase();
});

/// Supported tone variants for practical message sending.
enum SentenceToneVariant {
  natural,
  softer,
  direct;

  /// Returns the localized display label for each tone variant.
  String get label {
    return switch (this) {
      SentenceToneVariant.natural => FeatureTexts.toneNatural,
      SentenceToneVariant.softer => FeatureTexts.toneSofter,
      SentenceToneVariant.direct => FeatureTexts.toneDirect,
    };
  }
}

/// Builds deterministic sentence variants for copy/share workflows.
class SentenceSendModeUseCase {
  const SentenceSendModeUseCase();

  /// Returns a transformed sentence for the selected tone.
  String textFor(String source, SentenceToneVariant variant) {
    final normalized = _normalize(source);
    if (normalized.isEmpty) return normalized;

    return switch (variant) {
      SentenceToneVariant.natural => normalized,
      SentenceToneVariant.softer => _softer(normalized),
      SentenceToneVariant.direct => _moreDirect(normalized),
    };
  }

  /// Makes the sentence more polite while preserving the original intent.
  String _softer(String source) {
    var out = source;
    out = _applyRules(out, _softenRules);

    if (out.endsWith('!')) {
      out = out.replaceFirst(RegExp(r'!$'), '.');
    }

    if (_containsPlease(out)) return _normalize(out);

    if (out.endsWith('?')) {
      out = out.replaceFirst(RegExp(r'\?$'), ' please?');
    } else if (out.endsWith('.')) {
      out = out.replaceFirst(RegExp(r'\.$'), ', please.');
    } else {
      out = '$out, please';
    }

    return _normalize(out);
  }

  /// Makes the sentence more direct by removing polite hedging.
  String _moreDirect(String source) {
    var out = source;
    out = _applyRules(out, _directRules);
    out = out
        .replaceAll(RegExp(r',\s*please\.', caseSensitive: false), '.')
        .replaceAll(RegExp(r'\s+please\?', caseSensitive: false), '?')
        .replaceAll(RegExp(r',\s*please$', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+please$', caseSensitive: false), '');

    if (out.endsWith('!')) {
      out = out.replaceFirst(RegExp(r'!$'), '.');
    }

    return _normalize(out);
  }

  /// Checks whether the sentence already contains a polite marker.
  bool _containsPlease(String text) {
    return RegExp(r'\bplease\b', caseSensitive: false).hasMatch(text);
  }

  /// Applies rewrite rules in sequence to produce deterministic output.
  String _applyRules(String input, List<_RewriteRule> rules) {
    var out = input;
    for (final rule in rules) {
      out = out.replaceAll(rule.pattern, rule.replacement);
    }
    return out;
  }

  /// Trims and collapses whitespace to normalize sentence formatting.
  String _normalize(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    return trimmed.replaceAll(RegExp(r'\s+'), ' ');
  }
}

/// Simple text rewrite rule used by tone transformation.
class _RewriteRule {
  const _RewriteRule(this.pattern, this.replacement);

  final RegExp pattern;
  final String replacement;
}

final List<_RewriteRule> _softenRules = <_RewriteRule>[
  _RewriteRule(
    RegExp(r'\bDo you want to\b', caseSensitive: false),
    'Would you like to',
  ),
  _RewriteRule(RegExp(r'\bCan you\b', caseSensitive: false), 'Could you'),
  _RewriteRule(RegExp(r'\bCan we\b', caseSensitive: false), 'Could we'),
  _RewriteRule(RegExp(r'\bI want\b', caseSensitive: false), "I'd like"),
  _RewriteRule(
    RegExp(r'\bI need\b', caseSensitive: false),
    'I would appreciate',
  ),
];

final List<_RewriteRule> _directRules = <_RewriteRule>[
  _RewriteRule(
    RegExp(r'\bWould you like to\b', caseSensitive: false),
    'Do you want to',
  ),
  _RewriteRule(RegExp(r'\bCould you\b', caseSensitive: false), 'Can you'),
  _RewriteRule(RegExp(r'\bCould we\b', caseSensitive: false), 'Can we'),
  _RewriteRule(RegExp(r"\bI'd like\b", caseSensitive: false), 'I want'),
  _RewriteRule(
    RegExp(r'\bI would appreciate\b', caseSensitive: false),
    'I need',
  ),
];
