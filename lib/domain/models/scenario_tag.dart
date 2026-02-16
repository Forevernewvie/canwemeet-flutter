enum ScenarioTag {
  date('date', '데이트', '💛'),
  conflict('conflict', '갈등', '🧩'),
  compliment('compliment', '칭찬', '✨'),
  sorry('sorry', '미안', '🙏'),
  daily('daily', '일상', '☀️'),
  clarify('clarify', '확인질문', '❓');

  const ScenarioTag(this.key, this.titleKr, this.emoji);

  final String key;
  final String titleKr;
  final String emoji;

  static ScenarioTag fromKey(String raw) {
    for (final tag in ScenarioTag.values) {
      if (tag.key == raw) return tag;
    }
    return ScenarioTag.date;
  }
}
