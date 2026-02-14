class Sentence {
  const Sentence({
    required this.id,
    required this.english,
    required this.korean,
    required this.tags,
    required this.tone,
    required this.usageLabel,
    required this.patternHint,
  });

  final String id;
  final String english;
  final String korean;
  final List<String> tags;
  final String tone;
  final String usageLabel;
  final String? patternHint;

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      id: json['id'] as String,
      english: json['english'] as String,
      korean: json['korean'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      tone: json['tone'] as String,
      usageLabel: json['usageLabel'] as String,
      patternHint: json['patternHint'] as String?,
    );
  }
}
