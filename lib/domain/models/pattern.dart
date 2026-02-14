class Pattern {
  const Pattern({
    required this.id,
    required this.title,
    required this.exampleEnglish,
    required this.exampleKorean,
    required this.tip,
    required this.tags,
    required this.slotTemplate,
    required this.slots,
  });

  final String id;
  final String title;
  final String exampleEnglish;
  final String exampleKorean;
  final String tip;
  final List<String> tags;
  final String slotTemplate;
  final List<PatternSlot> slots;

  factory Pattern.fromJson(Map<String, dynamic> json) {
    return Pattern(
      id: json['id'] as String,
      title: json['title'] as String,
      exampleEnglish: json['exampleEnglish'] as String,
      exampleKorean: json['exampleKorean'] as String,
      tip: json['tip'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      slotTemplate: json['slotTemplate'] as String,
      slots: (json['slots'] as List<dynamic>)
          .map((e) => PatternSlot.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

class PatternSlot {
  const PatternSlot({required this.key, required this.hint});

  final String key;
  final String hint;

  factory PatternSlot.fromJson(Map<String, dynamic> json) {
    return PatternSlot(
      key: json['key'] as String,
      hint: json['hint'] as String,
    );
  }
}
