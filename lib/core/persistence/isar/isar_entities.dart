import 'package:isar_community/isar.dart';

part 'isar_entities.g.dart';

@collection
class AppMetaEntity {
  Id id = 0;

  bool onboardingCompleted = false;
  String installDateIso = '';
  int migrationVersion = 0;
  int? migratedAtEpochMs;
}

@collection
class FavoriteEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String sentenceId;

  int createdAtEpochMs = 0;
}

@collection
class StudyDayEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String dayKey;
}

@collection
class ReviewStateEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String sentenceId;

  int dueAtEpochMs = 0;
  int intervalDays = 0;
}

@collection
class CacheBlobEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  late String value;
  int updatedAtEpochMs = 0;
}
