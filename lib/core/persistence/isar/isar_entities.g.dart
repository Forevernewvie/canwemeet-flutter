// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_entities.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppMetaEntityCollection on Isar {
  IsarCollection<AppMetaEntity> get appMetaEntitys => this.collection();
}

const AppMetaEntitySchema = CollectionSchema(
  name: r'AppMetaEntity',
  id: 4798171179488078482,
  properties: {
    r'installDateIso': PropertySchema(
      id: 0,
      name: r'installDateIso',
      type: IsarType.string,
    ),
    r'migratedAtEpochMs': PropertySchema(
      id: 1,
      name: r'migratedAtEpochMs',
      type: IsarType.long,
    ),
    r'migrationVersion': PropertySchema(
      id: 2,
      name: r'migrationVersion',
      type: IsarType.long,
    ),
    r'onboardingCompleted': PropertySchema(
      id: 3,
      name: r'onboardingCompleted',
      type: IsarType.bool,
    ),
  },

  estimateSize: _appMetaEntityEstimateSize,
  serialize: _appMetaEntitySerialize,
  deserialize: _appMetaEntityDeserialize,
  deserializeProp: _appMetaEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _appMetaEntityGetId,
  getLinks: _appMetaEntityGetLinks,
  attach: _appMetaEntityAttach,
  version: '3.3.0',
);

int _appMetaEntityEstimateSize(
  AppMetaEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.installDateIso.length * 3;
  return bytesCount;
}

void _appMetaEntitySerialize(
  AppMetaEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.installDateIso);
  writer.writeLong(offsets[1], object.migratedAtEpochMs);
  writer.writeLong(offsets[2], object.migrationVersion);
  writer.writeBool(offsets[3], object.onboardingCompleted);
}

AppMetaEntity _appMetaEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppMetaEntity();
  object.id = id;
  object.installDateIso = reader.readString(offsets[0]);
  object.migratedAtEpochMs = reader.readLongOrNull(offsets[1]);
  object.migrationVersion = reader.readLong(offsets[2]);
  object.onboardingCompleted = reader.readBool(offsets[3]);
  return object;
}

P _appMetaEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appMetaEntityGetId(AppMetaEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appMetaEntityGetLinks(AppMetaEntity object) {
  return [];
}

void _appMetaEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  AppMetaEntity object,
) {
  object.id = id;
}

extension AppMetaEntityQueryWhereSort
    on QueryBuilder<AppMetaEntity, AppMetaEntity, QWhere> {
  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppMetaEntityQueryWhere
    on QueryBuilder<AppMetaEntity, AppMetaEntity, QWhereClause> {
  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AppMetaEntityQueryFilter
    on QueryBuilder<AppMetaEntity, AppMetaEntity, QFilterCondition> {
  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  installDateIsoEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'installDateIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  installDateIsoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'installDateIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  installDateIsoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'installDateIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  installDateIsoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'installDateIso',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  installDateIsoStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'installDateIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  installDateIsoEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'installDateIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  installDateIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'installDateIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  installDateIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'installDateIso',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  installDateIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'installDateIso', value: ''),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  installDateIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'installDateIso', value: ''),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  migratedAtEpochMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'migratedAtEpochMs'),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  migratedAtEpochMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'migratedAtEpochMs'),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  migratedAtEpochMsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'migratedAtEpochMs', value: value),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  migratedAtEpochMsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'migratedAtEpochMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  migratedAtEpochMsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'migratedAtEpochMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  migratedAtEpochMsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'migratedAtEpochMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  migrationVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'migrationVersion', value: value),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  migrationVersionGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'migrationVersion',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  migrationVersionLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'migrationVersion',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  migrationVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'migrationVersion',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterFilterCondition>
  onboardingCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'onboardingCompleted', value: value),
      );
    });
  }
}

extension AppMetaEntityQueryObject
    on QueryBuilder<AppMetaEntity, AppMetaEntity, QFilterCondition> {}

extension AppMetaEntityQueryLinks
    on QueryBuilder<AppMetaEntity, AppMetaEntity, QFilterCondition> {}

extension AppMetaEntityQuerySortBy
    on QueryBuilder<AppMetaEntity, AppMetaEntity, QSortBy> {
  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  sortByInstallDateIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installDateIso', Sort.asc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  sortByInstallDateIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installDateIso', Sort.desc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  sortByMigratedAtEpochMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'migratedAtEpochMs', Sort.asc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  sortByMigratedAtEpochMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'migratedAtEpochMs', Sort.desc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  sortByMigrationVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'migrationVersion', Sort.asc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  sortByMigrationVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'migrationVersion', Sort.desc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  sortByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.asc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  sortByOnboardingCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.desc);
    });
  }
}

extension AppMetaEntityQuerySortThenBy
    on QueryBuilder<AppMetaEntity, AppMetaEntity, QSortThenBy> {
  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  thenByInstallDateIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installDateIso', Sort.asc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  thenByInstallDateIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installDateIso', Sort.desc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  thenByMigratedAtEpochMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'migratedAtEpochMs', Sort.asc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  thenByMigratedAtEpochMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'migratedAtEpochMs', Sort.desc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  thenByMigrationVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'migrationVersion', Sort.asc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  thenByMigrationVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'migrationVersion', Sort.desc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  thenByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.asc);
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QAfterSortBy>
  thenByOnboardingCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.desc);
    });
  }
}

extension AppMetaEntityQueryWhereDistinct
    on QueryBuilder<AppMetaEntity, AppMetaEntity, QDistinct> {
  QueryBuilder<AppMetaEntity, AppMetaEntity, QDistinct>
  distinctByInstallDateIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'installDateIso',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QDistinct>
  distinctByMigratedAtEpochMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'migratedAtEpochMs');
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QDistinct>
  distinctByMigrationVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'migrationVersion');
    });
  }

  QueryBuilder<AppMetaEntity, AppMetaEntity, QDistinct>
  distinctByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onboardingCompleted');
    });
  }
}

extension AppMetaEntityQueryProperty
    on QueryBuilder<AppMetaEntity, AppMetaEntity, QQueryProperty> {
  QueryBuilder<AppMetaEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppMetaEntity, String, QQueryOperations>
  installDateIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'installDateIso');
    });
  }

  QueryBuilder<AppMetaEntity, int?, QQueryOperations>
  migratedAtEpochMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'migratedAtEpochMs');
    });
  }

  QueryBuilder<AppMetaEntity, int, QQueryOperations>
  migrationVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'migrationVersion');
    });
  }

  QueryBuilder<AppMetaEntity, bool, QQueryOperations>
  onboardingCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onboardingCompleted');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFavoriteEntityCollection on Isar {
  IsarCollection<FavoriteEntity> get favoriteEntitys => this.collection();
}

const FavoriteEntitySchema = CollectionSchema(
  name: r'FavoriteEntity',
  id: -2424802716597037588,
  properties: {
    r'createdAtEpochMs': PropertySchema(
      id: 0,
      name: r'createdAtEpochMs',
      type: IsarType.long,
    ),
    r'sentenceId': PropertySchema(
      id: 1,
      name: r'sentenceId',
      type: IsarType.string,
    ),
  },

  estimateSize: _favoriteEntityEstimateSize,
  serialize: _favoriteEntitySerialize,
  deserialize: _favoriteEntityDeserialize,
  deserializeProp: _favoriteEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'sentenceId': IndexSchema(
      id: -8491109664858005669,
      name: r'sentenceId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'sentenceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _favoriteEntityGetId,
  getLinks: _favoriteEntityGetLinks,
  attach: _favoriteEntityAttach,
  version: '3.3.0',
);

int _favoriteEntityEstimateSize(
  FavoriteEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.sentenceId.length * 3;
  return bytesCount;
}

void _favoriteEntitySerialize(
  FavoriteEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.createdAtEpochMs);
  writer.writeString(offsets[1], object.sentenceId);
}

FavoriteEntity _favoriteEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FavoriteEntity();
  object.createdAtEpochMs = reader.readLong(offsets[0]);
  object.id = id;
  object.sentenceId = reader.readString(offsets[1]);
  return object;
}

P _favoriteEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _favoriteEntityGetId(FavoriteEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _favoriteEntityGetLinks(FavoriteEntity object) {
  return [];
}

void _favoriteEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  FavoriteEntity object,
) {
  object.id = id;
}

extension FavoriteEntityByIndex on IsarCollection<FavoriteEntity> {
  Future<FavoriteEntity?> getBySentenceId(String sentenceId) {
    return getByIndex(r'sentenceId', [sentenceId]);
  }

  FavoriteEntity? getBySentenceIdSync(String sentenceId) {
    return getByIndexSync(r'sentenceId', [sentenceId]);
  }

  Future<bool> deleteBySentenceId(String sentenceId) {
    return deleteByIndex(r'sentenceId', [sentenceId]);
  }

  bool deleteBySentenceIdSync(String sentenceId) {
    return deleteByIndexSync(r'sentenceId', [sentenceId]);
  }

  Future<List<FavoriteEntity?>> getAllBySentenceId(
    List<String> sentenceIdValues,
  ) {
    final values = sentenceIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'sentenceId', values);
  }

  List<FavoriteEntity?> getAllBySentenceIdSync(List<String> sentenceIdValues) {
    final values = sentenceIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'sentenceId', values);
  }

  Future<int> deleteAllBySentenceId(List<String> sentenceIdValues) {
    final values = sentenceIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'sentenceId', values);
  }

  int deleteAllBySentenceIdSync(List<String> sentenceIdValues) {
    final values = sentenceIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'sentenceId', values);
  }

  Future<Id> putBySentenceId(FavoriteEntity object) {
    return putByIndex(r'sentenceId', object);
  }

  Id putBySentenceIdSync(FavoriteEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'sentenceId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySentenceId(List<FavoriteEntity> objects) {
    return putAllByIndex(r'sentenceId', objects);
  }

  List<Id> putAllBySentenceIdSync(
    List<FavoriteEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'sentenceId', objects, saveLinks: saveLinks);
  }
}

extension FavoriteEntityQueryWhereSort
    on QueryBuilder<FavoriteEntity, FavoriteEntity, QWhere> {
  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FavoriteEntityQueryWhere
    on QueryBuilder<FavoriteEntity, FavoriteEntity, QWhereClause> {
  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterWhereClause>
  sentenceIdEqualTo(String sentenceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'sentenceId', value: [sentenceId]),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterWhereClause>
  sentenceIdNotEqualTo(String sentenceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sentenceId',
                lower: [],
                upper: [sentenceId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sentenceId',
                lower: [sentenceId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sentenceId',
                lower: [sentenceId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sentenceId',
                lower: [],
                upper: [sentenceId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension FavoriteEntityQueryFilter
    on QueryBuilder<FavoriteEntity, FavoriteEntity, QFilterCondition> {
  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  createdAtEpochMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAtEpochMs', value: value),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  createdAtEpochMsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAtEpochMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  createdAtEpochMsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAtEpochMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  createdAtEpochMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAtEpochMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  sentenceIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sentenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  sentenceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sentenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  sentenceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sentenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  sentenceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sentenceId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  sentenceIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sentenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  sentenceIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sentenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  sentenceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sentenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  sentenceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sentenceId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  sentenceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sentenceId', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterFilterCondition>
  sentenceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sentenceId', value: ''),
      );
    });
  }
}

extension FavoriteEntityQueryObject
    on QueryBuilder<FavoriteEntity, FavoriteEntity, QFilterCondition> {}

extension FavoriteEntityQueryLinks
    on QueryBuilder<FavoriteEntity, FavoriteEntity, QFilterCondition> {}

extension FavoriteEntityQuerySortBy
    on QueryBuilder<FavoriteEntity, FavoriteEntity, QSortBy> {
  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterSortBy>
  sortByCreatedAtEpochMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtEpochMs', Sort.asc);
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterSortBy>
  sortByCreatedAtEpochMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtEpochMs', Sort.desc);
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterSortBy>
  sortBySentenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentenceId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterSortBy>
  sortBySentenceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentenceId', Sort.desc);
    });
  }
}

extension FavoriteEntityQuerySortThenBy
    on QueryBuilder<FavoriteEntity, FavoriteEntity, QSortThenBy> {
  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterSortBy>
  thenByCreatedAtEpochMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtEpochMs', Sort.asc);
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterSortBy>
  thenByCreatedAtEpochMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtEpochMs', Sort.desc);
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterSortBy>
  thenBySentenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentenceId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QAfterSortBy>
  thenBySentenceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentenceId', Sort.desc);
    });
  }
}

extension FavoriteEntityQueryWhereDistinct
    on QueryBuilder<FavoriteEntity, FavoriteEntity, QDistinct> {
  QueryBuilder<FavoriteEntity, FavoriteEntity, QDistinct>
  distinctByCreatedAtEpochMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAtEpochMs');
    });
  }

  QueryBuilder<FavoriteEntity, FavoriteEntity, QDistinct> distinctBySentenceId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sentenceId', caseSensitive: caseSensitive);
    });
  }
}

extension FavoriteEntityQueryProperty
    on QueryBuilder<FavoriteEntity, FavoriteEntity, QQueryProperty> {
  QueryBuilder<FavoriteEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FavoriteEntity, int, QQueryOperations>
  createdAtEpochMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAtEpochMs');
    });
  }

  QueryBuilder<FavoriteEntity, String, QQueryOperations> sentenceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sentenceId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStudyDayEntityCollection on Isar {
  IsarCollection<StudyDayEntity> get studyDayEntitys => this.collection();
}

const StudyDayEntitySchema = CollectionSchema(
  name: r'StudyDayEntity',
  id: -3587771322401842250,
  properties: {
    r'dayKey': PropertySchema(id: 0, name: r'dayKey', type: IsarType.string),
  },

  estimateSize: _studyDayEntityEstimateSize,
  serialize: _studyDayEntitySerialize,
  deserialize: _studyDayEntityDeserialize,
  deserializeProp: _studyDayEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'dayKey': IndexSchema(
      id: -3264092797330672150,
      name: r'dayKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'dayKey',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _studyDayEntityGetId,
  getLinks: _studyDayEntityGetLinks,
  attach: _studyDayEntityAttach,
  version: '3.3.0',
);

int _studyDayEntityEstimateSize(
  StudyDayEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dayKey.length * 3;
  return bytesCount;
}

void _studyDayEntitySerialize(
  StudyDayEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.dayKey);
}

StudyDayEntity _studyDayEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StudyDayEntity();
  object.dayKey = reader.readString(offsets[0]);
  object.id = id;
  return object;
}

P _studyDayEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _studyDayEntityGetId(StudyDayEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _studyDayEntityGetLinks(StudyDayEntity object) {
  return [];
}

void _studyDayEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  StudyDayEntity object,
) {
  object.id = id;
}

extension StudyDayEntityByIndex on IsarCollection<StudyDayEntity> {
  Future<StudyDayEntity?> getByDayKey(String dayKey) {
    return getByIndex(r'dayKey', [dayKey]);
  }

  StudyDayEntity? getByDayKeySync(String dayKey) {
    return getByIndexSync(r'dayKey', [dayKey]);
  }

  Future<bool> deleteByDayKey(String dayKey) {
    return deleteByIndex(r'dayKey', [dayKey]);
  }

  bool deleteByDayKeySync(String dayKey) {
    return deleteByIndexSync(r'dayKey', [dayKey]);
  }

  Future<List<StudyDayEntity?>> getAllByDayKey(List<String> dayKeyValues) {
    final values = dayKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'dayKey', values);
  }

  List<StudyDayEntity?> getAllByDayKeySync(List<String> dayKeyValues) {
    final values = dayKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'dayKey', values);
  }

  Future<int> deleteAllByDayKey(List<String> dayKeyValues) {
    final values = dayKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'dayKey', values);
  }

  int deleteAllByDayKeySync(List<String> dayKeyValues) {
    final values = dayKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'dayKey', values);
  }

  Future<Id> putByDayKey(StudyDayEntity object) {
    return putByIndex(r'dayKey', object);
  }

  Id putByDayKeySync(StudyDayEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'dayKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDayKey(List<StudyDayEntity> objects) {
    return putAllByIndex(r'dayKey', objects);
  }

  List<Id> putAllByDayKeySync(
    List<StudyDayEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'dayKey', objects, saveLinks: saveLinks);
  }
}

extension StudyDayEntityQueryWhereSort
    on QueryBuilder<StudyDayEntity, StudyDayEntity, QWhere> {
  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StudyDayEntityQueryWhere
    on QueryBuilder<StudyDayEntity, StudyDayEntity, QWhereClause> {
  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterWhereClause> dayKeyEqualTo(
    String dayKey,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dayKey', value: [dayKey]),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterWhereClause>
  dayKeyNotEqualTo(String dayKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dayKey',
                lower: [],
                upper: [dayKey],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dayKey',
                lower: [dayKey],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dayKey',
                lower: [dayKey],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dayKey',
                lower: [],
                upper: [dayKey],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension StudyDayEntityQueryFilter
    on QueryBuilder<StudyDayEntity, StudyDayEntity, QFilterCondition> {
  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterFilterCondition>
  dayKeyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterFilterCondition>
  dayKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterFilterCondition>
  dayKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterFilterCondition>
  dayKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dayKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterFilterCondition>
  dayKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterFilterCondition>
  dayKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterFilterCondition>
  dayKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterFilterCondition>
  dayKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dayKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterFilterCondition>
  dayKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dayKey', value: ''),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterFilterCondition>
  dayKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dayKey', value: ''),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension StudyDayEntityQueryObject
    on QueryBuilder<StudyDayEntity, StudyDayEntity, QFilterCondition> {}

extension StudyDayEntityQueryLinks
    on QueryBuilder<StudyDayEntity, StudyDayEntity, QFilterCondition> {}

extension StudyDayEntityQuerySortBy
    on QueryBuilder<StudyDayEntity, StudyDayEntity, QSortBy> {
  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterSortBy> sortByDayKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayKey', Sort.asc);
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterSortBy>
  sortByDayKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayKey', Sort.desc);
    });
  }
}

extension StudyDayEntityQuerySortThenBy
    on QueryBuilder<StudyDayEntity, StudyDayEntity, QSortThenBy> {
  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterSortBy> thenByDayKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayKey', Sort.asc);
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterSortBy>
  thenByDayKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayKey', Sort.desc);
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StudyDayEntity, StudyDayEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension StudyDayEntityQueryWhereDistinct
    on QueryBuilder<StudyDayEntity, StudyDayEntity, QDistinct> {
  QueryBuilder<StudyDayEntity, StudyDayEntity, QDistinct> distinctByDayKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayKey', caseSensitive: caseSensitive);
    });
  }
}

extension StudyDayEntityQueryProperty
    on QueryBuilder<StudyDayEntity, StudyDayEntity, QQueryProperty> {
  QueryBuilder<StudyDayEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StudyDayEntity, String, QQueryOperations> dayKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayKey');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReviewStateEntityCollection on Isar {
  IsarCollection<ReviewStateEntity> get reviewStateEntitys => this.collection();
}

const ReviewStateEntitySchema = CollectionSchema(
  name: r'ReviewStateEntity',
  id: 3436682584031612012,
  properties: {
    r'dueAtEpochMs': PropertySchema(
      id: 0,
      name: r'dueAtEpochMs',
      type: IsarType.long,
    ),
    r'intervalDays': PropertySchema(
      id: 1,
      name: r'intervalDays',
      type: IsarType.long,
    ),
    r'sentenceId': PropertySchema(
      id: 2,
      name: r'sentenceId',
      type: IsarType.string,
    ),
  },

  estimateSize: _reviewStateEntityEstimateSize,
  serialize: _reviewStateEntitySerialize,
  deserialize: _reviewStateEntityDeserialize,
  deserializeProp: _reviewStateEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'sentenceId': IndexSchema(
      id: -8491109664858005669,
      name: r'sentenceId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'sentenceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _reviewStateEntityGetId,
  getLinks: _reviewStateEntityGetLinks,
  attach: _reviewStateEntityAttach,
  version: '3.3.0',
);

int _reviewStateEntityEstimateSize(
  ReviewStateEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.sentenceId.length * 3;
  return bytesCount;
}

void _reviewStateEntitySerialize(
  ReviewStateEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dueAtEpochMs);
  writer.writeLong(offsets[1], object.intervalDays);
  writer.writeString(offsets[2], object.sentenceId);
}

ReviewStateEntity _reviewStateEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReviewStateEntity();
  object.dueAtEpochMs = reader.readLong(offsets[0]);
  object.id = id;
  object.intervalDays = reader.readLong(offsets[1]);
  object.sentenceId = reader.readString(offsets[2]);
  return object;
}

P _reviewStateEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _reviewStateEntityGetId(ReviewStateEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reviewStateEntityGetLinks(
  ReviewStateEntity object,
) {
  return [];
}

void _reviewStateEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  ReviewStateEntity object,
) {
  object.id = id;
}

extension ReviewStateEntityByIndex on IsarCollection<ReviewStateEntity> {
  Future<ReviewStateEntity?> getBySentenceId(String sentenceId) {
    return getByIndex(r'sentenceId', [sentenceId]);
  }

  ReviewStateEntity? getBySentenceIdSync(String sentenceId) {
    return getByIndexSync(r'sentenceId', [sentenceId]);
  }

  Future<bool> deleteBySentenceId(String sentenceId) {
    return deleteByIndex(r'sentenceId', [sentenceId]);
  }

  bool deleteBySentenceIdSync(String sentenceId) {
    return deleteByIndexSync(r'sentenceId', [sentenceId]);
  }

  Future<List<ReviewStateEntity?>> getAllBySentenceId(
    List<String> sentenceIdValues,
  ) {
    final values = sentenceIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'sentenceId', values);
  }

  List<ReviewStateEntity?> getAllBySentenceIdSync(
    List<String> sentenceIdValues,
  ) {
    final values = sentenceIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'sentenceId', values);
  }

  Future<int> deleteAllBySentenceId(List<String> sentenceIdValues) {
    final values = sentenceIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'sentenceId', values);
  }

  int deleteAllBySentenceIdSync(List<String> sentenceIdValues) {
    final values = sentenceIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'sentenceId', values);
  }

  Future<Id> putBySentenceId(ReviewStateEntity object) {
    return putByIndex(r'sentenceId', object);
  }

  Id putBySentenceIdSync(ReviewStateEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'sentenceId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySentenceId(List<ReviewStateEntity> objects) {
    return putAllByIndex(r'sentenceId', objects);
  }

  List<Id> putAllBySentenceIdSync(
    List<ReviewStateEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'sentenceId', objects, saveLinks: saveLinks);
  }
}

extension ReviewStateEntityQueryWhereSort
    on QueryBuilder<ReviewStateEntity, ReviewStateEntity, QWhere> {
  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReviewStateEntityQueryWhere
    on QueryBuilder<ReviewStateEntity, ReviewStateEntity, QWhereClause> {
  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterWhereClause>
  sentenceIdEqualTo(String sentenceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'sentenceId', value: [sentenceId]),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterWhereClause>
  sentenceIdNotEqualTo(String sentenceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sentenceId',
                lower: [],
                upper: [sentenceId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sentenceId',
                lower: [sentenceId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sentenceId',
                lower: [sentenceId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sentenceId',
                lower: [],
                upper: [sentenceId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension ReviewStateEntityQueryFilter
    on QueryBuilder<ReviewStateEntity, ReviewStateEntity, QFilterCondition> {
  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  dueAtEpochMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dueAtEpochMs', value: value),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  dueAtEpochMsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dueAtEpochMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  dueAtEpochMsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dueAtEpochMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  dueAtEpochMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dueAtEpochMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  intervalDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'intervalDays', value: value),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  intervalDaysGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'intervalDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  intervalDaysLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'intervalDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  intervalDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'intervalDays',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  sentenceIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sentenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  sentenceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sentenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  sentenceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sentenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  sentenceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sentenceId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  sentenceIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sentenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  sentenceIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sentenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  sentenceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sentenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  sentenceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sentenceId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  sentenceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sentenceId', value: ''),
      );
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterFilterCondition>
  sentenceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sentenceId', value: ''),
      );
    });
  }
}

extension ReviewStateEntityQueryObject
    on QueryBuilder<ReviewStateEntity, ReviewStateEntity, QFilterCondition> {}

extension ReviewStateEntityQueryLinks
    on QueryBuilder<ReviewStateEntity, ReviewStateEntity, QFilterCondition> {}

extension ReviewStateEntityQuerySortBy
    on QueryBuilder<ReviewStateEntity, ReviewStateEntity, QSortBy> {
  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterSortBy>
  sortByDueAtEpochMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueAtEpochMs', Sort.asc);
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterSortBy>
  sortByDueAtEpochMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueAtEpochMs', Sort.desc);
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterSortBy>
  sortByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.asc);
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterSortBy>
  sortByIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.desc);
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterSortBy>
  sortBySentenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentenceId', Sort.asc);
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterSortBy>
  sortBySentenceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentenceId', Sort.desc);
    });
  }
}

extension ReviewStateEntityQuerySortThenBy
    on QueryBuilder<ReviewStateEntity, ReviewStateEntity, QSortThenBy> {
  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterSortBy>
  thenByDueAtEpochMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueAtEpochMs', Sort.asc);
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterSortBy>
  thenByDueAtEpochMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueAtEpochMs', Sort.desc);
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterSortBy>
  thenByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.asc);
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterSortBy>
  thenByIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.desc);
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterSortBy>
  thenBySentenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentenceId', Sort.asc);
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QAfterSortBy>
  thenBySentenceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentenceId', Sort.desc);
    });
  }
}

extension ReviewStateEntityQueryWhereDistinct
    on QueryBuilder<ReviewStateEntity, ReviewStateEntity, QDistinct> {
  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QDistinct>
  distinctByDueAtEpochMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dueAtEpochMs');
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QDistinct>
  distinctByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalDays');
    });
  }

  QueryBuilder<ReviewStateEntity, ReviewStateEntity, QDistinct>
  distinctBySentenceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sentenceId', caseSensitive: caseSensitive);
    });
  }
}

extension ReviewStateEntityQueryProperty
    on QueryBuilder<ReviewStateEntity, ReviewStateEntity, QQueryProperty> {
  QueryBuilder<ReviewStateEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReviewStateEntity, int, QQueryOperations>
  dueAtEpochMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dueAtEpochMs');
    });
  }

  QueryBuilder<ReviewStateEntity, int, QQueryOperations>
  intervalDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalDays');
    });
  }

  QueryBuilder<ReviewStateEntity, String, QQueryOperations>
  sentenceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sentenceId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCacheBlobEntityCollection on Isar {
  IsarCollection<CacheBlobEntity> get cacheBlobEntitys => this.collection();
}

const CacheBlobEntitySchema = CollectionSchema(
  name: r'CacheBlobEntity',
  id: 8106746025749865640,
  properties: {
    r'key': PropertySchema(id: 0, name: r'key', type: IsarType.string),
    r'updatedAtEpochMs': PropertySchema(
      id: 1,
      name: r'updatedAtEpochMs',
      type: IsarType.long,
    ),
    r'value': PropertySchema(id: 2, name: r'value', type: IsarType.string),
  },

  estimateSize: _cacheBlobEntityEstimateSize,
  serialize: _cacheBlobEntitySerialize,
  deserialize: _cacheBlobEntityDeserialize,
  deserializeProp: _cacheBlobEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'key': IndexSchema(
      id: -4906094122524121629,
      name: r'key',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'key',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _cacheBlobEntityGetId,
  getLinks: _cacheBlobEntityGetLinks,
  attach: _cacheBlobEntityAttach,
  version: '3.3.0',
);

int _cacheBlobEntityEstimateSize(
  CacheBlobEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  bytesCount += 3 + object.value.length * 3;
  return bytesCount;
}

void _cacheBlobEntitySerialize(
  CacheBlobEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.key);
  writer.writeLong(offsets[1], object.updatedAtEpochMs);
  writer.writeString(offsets[2], object.value);
}

CacheBlobEntity _cacheBlobEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CacheBlobEntity();
  object.id = id;
  object.key = reader.readString(offsets[0]);
  object.updatedAtEpochMs = reader.readLong(offsets[1]);
  object.value = reader.readString(offsets[2]);
  return object;
}

P _cacheBlobEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cacheBlobEntityGetId(CacheBlobEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cacheBlobEntityGetLinks(CacheBlobEntity object) {
  return [];
}

void _cacheBlobEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  CacheBlobEntity object,
) {
  object.id = id;
}

extension CacheBlobEntityByIndex on IsarCollection<CacheBlobEntity> {
  Future<CacheBlobEntity?> getByKey(String key) {
    return getByIndex(r'key', [key]);
  }

  CacheBlobEntity? getByKeySync(String key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<CacheBlobEntity?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<CacheBlobEntity?> getAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'key', values);
  }

  Future<int> deleteAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'key', values);
  }

  int deleteAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'key', values);
  }

  Future<Id> putByKey(CacheBlobEntity object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(CacheBlobEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<CacheBlobEntity> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(
    List<CacheBlobEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension CacheBlobEntityQueryWhereSort
    on QueryBuilder<CacheBlobEntity, CacheBlobEntity, QWhere> {
  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CacheBlobEntityQueryWhere
    on QueryBuilder<CacheBlobEntity, CacheBlobEntity, QWhereClause> {
  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterWhereClause> keyEqualTo(
    String key,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'key', value: [key]),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterWhereClause>
  keyNotEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [],
                upper: [key],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [key],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [key],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [],
                upper: [key],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension CacheBlobEntityQueryFilter
    on QueryBuilder<CacheBlobEntity, CacheBlobEntity, QFilterCondition> {
  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  keyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  keyLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'key',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  keyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  keyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'key',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  updatedAtEpochMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAtEpochMs', value: value),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  updatedAtEpochMsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAtEpochMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  updatedAtEpochMsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAtEpochMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  updatedAtEpochMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAtEpochMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  valueEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  valueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  valueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  valueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'value',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  valueStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  valueEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  valueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  valueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'value',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'value', value: ''),
      );
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterFilterCondition>
  valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'value', value: ''),
      );
    });
  }
}

extension CacheBlobEntityQueryObject
    on QueryBuilder<CacheBlobEntity, CacheBlobEntity, QFilterCondition> {}

extension CacheBlobEntityQueryLinks
    on QueryBuilder<CacheBlobEntity, CacheBlobEntity, QFilterCondition> {}

extension CacheBlobEntityQuerySortBy
    on QueryBuilder<CacheBlobEntity, CacheBlobEntity, QSortBy> {
  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterSortBy>
  sortByUpdatedAtEpochMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtEpochMs', Sort.asc);
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterSortBy>
  sortByUpdatedAtEpochMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtEpochMs', Sort.desc);
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterSortBy>
  sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension CacheBlobEntityQuerySortThenBy
    on QueryBuilder<CacheBlobEntity, CacheBlobEntity, QSortThenBy> {
  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterSortBy>
  thenByUpdatedAtEpochMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtEpochMs', Sort.asc);
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterSortBy>
  thenByUpdatedAtEpochMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtEpochMs', Sort.desc);
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QAfterSortBy>
  thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension CacheBlobEntityQueryWhereDistinct
    on QueryBuilder<CacheBlobEntity, CacheBlobEntity, QDistinct> {
  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QDistinct> distinctByKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QDistinct>
  distinctByUpdatedAtEpochMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAtEpochMs');
    });
  }

  QueryBuilder<CacheBlobEntity, CacheBlobEntity, QDistinct> distinctByValue({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value', caseSensitive: caseSensitive);
    });
  }
}

extension CacheBlobEntityQueryProperty
    on QueryBuilder<CacheBlobEntity, CacheBlobEntity, QQueryProperty> {
  QueryBuilder<CacheBlobEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CacheBlobEntity, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<CacheBlobEntity, int, QQueryOperations>
  updatedAtEpochMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAtEpochMs');
    });
  }

  QueryBuilder<CacheBlobEntity, String, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
