// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DialogueNodesTable extends DialogueNodes
    with TableInfo<$DialogueNodesTable, DialogueNodeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DialogueNodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _speakerPortugueseMeta =
      const VerificationMeta('speakerPortuguese');
  @override
  late final GeneratedColumn<String> speakerPortuguese =
      GeneratedColumn<String>('speaker_portuguese', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _speakerRussianMeta =
      const VerificationMeta('speakerRussian');
  @override
  late final GeneratedColumn<String> speakerRussian = GeneratedColumn<String>(
      'speaker_russian', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _linePortugueseMeta =
      const VerificationMeta('linePortuguese');
  @override
  late final GeneratedColumn<String> linePortuguese = GeneratedColumn<String>(
      'line_portuguese', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lineRussianMeta =
      const VerificationMeta('lineRussian');
  @override
  late final GeneratedColumn<String> lineRussian = GeneratedColumn<String>(
      'line_russian', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _audioPathMeta =
      const VerificationMeta('audioPath');
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
      'audio_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scenarioIdMeta =
      const VerificationMeta('scenarioId');
  @override
  late final GeneratedColumn<String> scenarioId = GeneratedColumn<String>(
      'scenario_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scenarioTitleMeta =
      const VerificationMeta('scenarioTitle');
  @override
  late final GeneratedColumn<String> scenarioTitle = GeneratedColumn<String>(
      'scenario_title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scenarioCategoryMeta =
      const VerificationMeta('scenarioCategory');
  @override
  late final GeneratedColumn<String> scenarioCategory = GeneratedColumn<String>(
      'scenario_category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dialectMeta =
      const VerificationMeta('dialect');
  @override
  late final GeneratedColumn<String> dialect = GeneratedColumn<String>(
      'dialect', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('all'));
  static const VerificationMeta _optionsJsonMeta =
      const VerificationMeta('optionsJson');
  @override
  late final GeneratedColumn<String> optionsJson = GeneratedColumn<String>(
      'options_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        speakerPortuguese,
        speakerRussian,
        linePortuguese,
        lineRussian,
        audioPath,
        scenarioId,
        scenarioTitle,
        scenarioCategory,
        dialect,
        optionsJson,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dialogue_nodes';
  @override
  VerificationContext validateIntegrity(Insertable<DialogueNodeRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('speaker_portuguese')) {
      context.handle(
          _speakerPortugueseMeta,
          speakerPortuguese.isAcceptableOrUnknown(
              data['speaker_portuguese']!, _speakerPortugueseMeta));
    } else if (isInserting) {
      context.missing(_speakerPortugueseMeta);
    }
    if (data.containsKey('speaker_russian')) {
      context.handle(
          _speakerRussianMeta,
          speakerRussian.isAcceptableOrUnknown(
              data['speaker_russian']!, _speakerRussianMeta));
    } else if (isInserting) {
      context.missing(_speakerRussianMeta);
    }
    if (data.containsKey('line_portuguese')) {
      context.handle(
          _linePortugueseMeta,
          linePortuguese.isAcceptableOrUnknown(
              data['line_portuguese']!, _linePortugueseMeta));
    } else if (isInserting) {
      context.missing(_linePortugueseMeta);
    }
    if (data.containsKey('line_russian')) {
      context.handle(
          _lineRussianMeta,
          lineRussian.isAcceptableOrUnknown(
              data['line_russian']!, _lineRussianMeta));
    } else if (isInserting) {
      context.missing(_lineRussianMeta);
    }
    if (data.containsKey('audio_path')) {
      context.handle(_audioPathMeta,
          audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta));
    }
    if (data.containsKey('scenario_id')) {
      context.handle(
          _scenarioIdMeta,
          scenarioId.isAcceptableOrUnknown(
              data['scenario_id']!, _scenarioIdMeta));
    } else if (isInserting) {
      context.missing(_scenarioIdMeta);
    }
    if (data.containsKey('scenario_title')) {
      context.handle(
          _scenarioTitleMeta,
          scenarioTitle.isAcceptableOrUnknown(
              data['scenario_title']!, _scenarioTitleMeta));
    } else if (isInserting) {
      context.missing(_scenarioTitleMeta);
    }
    if (data.containsKey('scenario_category')) {
      context.handle(
          _scenarioCategoryMeta,
          scenarioCategory.isAcceptableOrUnknown(
              data['scenario_category']!, _scenarioCategoryMeta));
    } else if (isInserting) {
      context.missing(_scenarioCategoryMeta);
    }
    if (data.containsKey('dialect')) {
      context.handle(_dialectMeta,
          dialect.isAcceptableOrUnknown(data['dialect']!, _dialectMeta));
    }
    if (data.containsKey('options_json')) {
      context.handle(
          _optionsJsonMeta,
          optionsJson.isAcceptableOrUnknown(
              data['options_json']!, _optionsJsonMeta));
    } else if (isInserting) {
      context.missing(_optionsJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DialogueNodeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DialogueNodeRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      speakerPortuguese: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}speaker_portuguese'])!,
      speakerRussian: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}speaker_russian'])!,
      linePortuguese: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}line_portuguese'])!,
      lineRussian: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}line_russian'])!,
      audioPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_path']),
      scenarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scenario_id'])!,
      scenarioTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scenario_title'])!,
      scenarioCategory: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}scenario_category'])!,
      dialect: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dialect'])!,
      optionsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}options_json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DialogueNodesTable createAlias(String alias) {
    return $DialogueNodesTable(attachedDatabase, alias);
  }
}

class DialogueNodeRow extends DataClass implements Insertable<DialogueNodeRow> {
  final String id;
  final String speakerPortuguese;
  final String speakerRussian;
  final String linePortuguese;
  final String lineRussian;
  final String? audioPath;
  final String scenarioId;
  final String scenarioTitle;
  final String scenarioCategory;
  final String dialect;
  final String optionsJson;
  final DateTime updatedAt;
  const DialogueNodeRow(
      {required this.id,
      required this.speakerPortuguese,
      required this.speakerRussian,
      required this.linePortuguese,
      required this.lineRussian,
      this.audioPath,
      required this.scenarioId,
      required this.scenarioTitle,
      required this.scenarioCategory,
      required this.dialect,
      required this.optionsJson,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['speaker_portuguese'] = Variable<String>(speakerPortuguese);
    map['speaker_russian'] = Variable<String>(speakerRussian);
    map['line_portuguese'] = Variable<String>(linePortuguese);
    map['line_russian'] = Variable<String>(lineRussian);
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    map['scenario_id'] = Variable<String>(scenarioId);
    map['scenario_title'] = Variable<String>(scenarioTitle);
    map['scenario_category'] = Variable<String>(scenarioCategory);
    map['dialect'] = Variable<String>(dialect);
    map['options_json'] = Variable<String>(optionsJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DialogueNodesCompanion toCompanion(bool nullToAbsent) {
    return DialogueNodesCompanion(
      id: Value(id),
      speakerPortuguese: Value(speakerPortuguese),
      speakerRussian: Value(speakerRussian),
      linePortuguese: Value(linePortuguese),
      lineRussian: Value(lineRussian),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      scenarioId: Value(scenarioId),
      scenarioTitle: Value(scenarioTitle),
      scenarioCategory: Value(scenarioCategory),
      dialect: Value(dialect),
      optionsJson: Value(optionsJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory DialogueNodeRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DialogueNodeRow(
      id: serializer.fromJson<String>(json['id']),
      speakerPortuguese: serializer.fromJson<String>(json['speakerPortuguese']),
      speakerRussian: serializer.fromJson<String>(json['speakerRussian']),
      linePortuguese: serializer.fromJson<String>(json['linePortuguese']),
      lineRussian: serializer.fromJson<String>(json['lineRussian']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      scenarioId: serializer.fromJson<String>(json['scenarioId']),
      scenarioTitle: serializer.fromJson<String>(json['scenarioTitle']),
      scenarioCategory: serializer.fromJson<String>(json['scenarioCategory']),
      dialect: serializer.fromJson<String>(json['dialect']),
      optionsJson: serializer.fromJson<String>(json['optionsJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'speakerPortuguese': serializer.toJson<String>(speakerPortuguese),
      'speakerRussian': serializer.toJson<String>(speakerRussian),
      'linePortuguese': serializer.toJson<String>(linePortuguese),
      'lineRussian': serializer.toJson<String>(lineRussian),
      'audioPath': serializer.toJson<String?>(audioPath),
      'scenarioId': serializer.toJson<String>(scenarioId),
      'scenarioTitle': serializer.toJson<String>(scenarioTitle),
      'scenarioCategory': serializer.toJson<String>(scenarioCategory),
      'dialect': serializer.toJson<String>(dialect),
      'optionsJson': serializer.toJson<String>(optionsJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DialogueNodeRow copyWith(
          {String? id,
          String? speakerPortuguese,
          String? speakerRussian,
          String? linePortuguese,
          String? lineRussian,
          Value<String?> audioPath = const Value.absent(),
          String? scenarioId,
          String? scenarioTitle,
          String? scenarioCategory,
          String? dialect,
          String? optionsJson,
          DateTime? updatedAt}) =>
      DialogueNodeRow(
        id: id ?? this.id,
        speakerPortuguese: speakerPortuguese ?? this.speakerPortuguese,
        speakerRussian: speakerRussian ?? this.speakerRussian,
        linePortuguese: linePortuguese ?? this.linePortuguese,
        lineRussian: lineRussian ?? this.lineRussian,
        audioPath: audioPath.present ? audioPath.value : this.audioPath,
        scenarioId: scenarioId ?? this.scenarioId,
        scenarioTitle: scenarioTitle ?? this.scenarioTitle,
        scenarioCategory: scenarioCategory ?? this.scenarioCategory,
        dialect: dialect ?? this.dialect,
        optionsJson: optionsJson ?? this.optionsJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DialogueNodeRow copyWithCompanion(DialogueNodesCompanion data) {
    return DialogueNodeRow(
      id: data.id.present ? data.id.value : this.id,
      speakerPortuguese: data.speakerPortuguese.present
          ? data.speakerPortuguese.value
          : this.speakerPortuguese,
      speakerRussian: data.speakerRussian.present
          ? data.speakerRussian.value
          : this.speakerRussian,
      linePortuguese: data.linePortuguese.present
          ? data.linePortuguese.value
          : this.linePortuguese,
      lineRussian:
          data.lineRussian.present ? data.lineRussian.value : this.lineRussian,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      scenarioId:
          data.scenarioId.present ? data.scenarioId.value : this.scenarioId,
      scenarioTitle: data.scenarioTitle.present
          ? data.scenarioTitle.value
          : this.scenarioTitle,
      scenarioCategory: data.scenarioCategory.present
          ? data.scenarioCategory.value
          : this.scenarioCategory,
      dialect: data.dialect.present ? data.dialect.value : this.dialect,
      optionsJson:
          data.optionsJson.present ? data.optionsJson.value : this.optionsJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DialogueNodeRow(')
          ..write('id: $id, ')
          ..write('speakerPortuguese: $speakerPortuguese, ')
          ..write('speakerRussian: $speakerRussian, ')
          ..write('linePortuguese: $linePortuguese, ')
          ..write('lineRussian: $lineRussian, ')
          ..write('audioPath: $audioPath, ')
          ..write('scenarioId: $scenarioId, ')
          ..write('scenarioTitle: $scenarioTitle, ')
          ..write('scenarioCategory: $scenarioCategory, ')
          ..write('dialect: $dialect, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      speakerPortuguese,
      speakerRussian,
      linePortuguese,
      lineRussian,
      audioPath,
      scenarioId,
      scenarioTitle,
      scenarioCategory,
      dialect,
      optionsJson,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DialogueNodeRow &&
          other.id == this.id &&
          other.speakerPortuguese == this.speakerPortuguese &&
          other.speakerRussian == this.speakerRussian &&
          other.linePortuguese == this.linePortuguese &&
          other.lineRussian == this.lineRussian &&
          other.audioPath == this.audioPath &&
          other.scenarioId == this.scenarioId &&
          other.scenarioTitle == this.scenarioTitle &&
          other.scenarioCategory == this.scenarioCategory &&
          other.dialect == this.dialect &&
          other.optionsJson == this.optionsJson &&
          other.updatedAt == this.updatedAt);
}

class DialogueNodesCompanion extends UpdateCompanion<DialogueNodeRow> {
  final Value<String> id;
  final Value<String> speakerPortuguese;
  final Value<String> speakerRussian;
  final Value<String> linePortuguese;
  final Value<String> lineRussian;
  final Value<String?> audioPath;
  final Value<String> scenarioId;
  final Value<String> scenarioTitle;
  final Value<String> scenarioCategory;
  final Value<String> dialect;
  final Value<String> optionsJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DialogueNodesCompanion({
    this.id = const Value.absent(),
    this.speakerPortuguese = const Value.absent(),
    this.speakerRussian = const Value.absent(),
    this.linePortuguese = const Value.absent(),
    this.lineRussian = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.scenarioId = const Value.absent(),
    this.scenarioTitle = const Value.absent(),
    this.scenarioCategory = const Value.absent(),
    this.dialect = const Value.absent(),
    this.optionsJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DialogueNodesCompanion.insert({
    required String id,
    required String speakerPortuguese,
    required String speakerRussian,
    required String linePortuguese,
    required String lineRussian,
    this.audioPath = const Value.absent(),
    required String scenarioId,
    required String scenarioTitle,
    required String scenarioCategory,
    this.dialect = const Value.absent(),
    required String optionsJson,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        speakerPortuguese = Value(speakerPortuguese),
        speakerRussian = Value(speakerRussian),
        linePortuguese = Value(linePortuguese),
        lineRussian = Value(lineRussian),
        scenarioId = Value(scenarioId),
        scenarioTitle = Value(scenarioTitle),
        scenarioCategory = Value(scenarioCategory),
        optionsJson = Value(optionsJson),
        updatedAt = Value(updatedAt);
  static Insertable<DialogueNodeRow> custom({
    Expression<String>? id,
    Expression<String>? speakerPortuguese,
    Expression<String>? speakerRussian,
    Expression<String>? linePortuguese,
    Expression<String>? lineRussian,
    Expression<String>? audioPath,
    Expression<String>? scenarioId,
    Expression<String>? scenarioTitle,
    Expression<String>? scenarioCategory,
    Expression<String>? dialect,
    Expression<String>? optionsJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (speakerPortuguese != null) 'speaker_portuguese': speakerPortuguese,
      if (speakerRussian != null) 'speaker_russian': speakerRussian,
      if (linePortuguese != null) 'line_portuguese': linePortuguese,
      if (lineRussian != null) 'line_russian': lineRussian,
      if (audioPath != null) 'audio_path': audioPath,
      if (scenarioId != null) 'scenario_id': scenarioId,
      if (scenarioTitle != null) 'scenario_title': scenarioTitle,
      if (scenarioCategory != null) 'scenario_category': scenarioCategory,
      if (dialect != null) 'dialect': dialect,
      if (optionsJson != null) 'options_json': optionsJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DialogueNodesCompanion copyWith(
      {Value<String>? id,
      Value<String>? speakerPortuguese,
      Value<String>? speakerRussian,
      Value<String>? linePortuguese,
      Value<String>? lineRussian,
      Value<String?>? audioPath,
      Value<String>? scenarioId,
      Value<String>? scenarioTitle,
      Value<String>? scenarioCategory,
      Value<String>? dialect,
      Value<String>? optionsJson,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DialogueNodesCompanion(
      id: id ?? this.id,
      speakerPortuguese: speakerPortuguese ?? this.speakerPortuguese,
      speakerRussian: speakerRussian ?? this.speakerRussian,
      linePortuguese: linePortuguese ?? this.linePortuguese,
      lineRussian: lineRussian ?? this.lineRussian,
      audioPath: audioPath ?? this.audioPath,
      scenarioId: scenarioId ?? this.scenarioId,
      scenarioTitle: scenarioTitle ?? this.scenarioTitle,
      scenarioCategory: scenarioCategory ?? this.scenarioCategory,
      dialect: dialect ?? this.dialect,
      optionsJson: optionsJson ?? this.optionsJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (speakerPortuguese.present) {
      map['speaker_portuguese'] = Variable<String>(speakerPortuguese.value);
    }
    if (speakerRussian.present) {
      map['speaker_russian'] = Variable<String>(speakerRussian.value);
    }
    if (linePortuguese.present) {
      map['line_portuguese'] = Variable<String>(linePortuguese.value);
    }
    if (lineRussian.present) {
      map['line_russian'] = Variable<String>(lineRussian.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (scenarioId.present) {
      map['scenario_id'] = Variable<String>(scenarioId.value);
    }
    if (scenarioTitle.present) {
      map['scenario_title'] = Variable<String>(scenarioTitle.value);
    }
    if (scenarioCategory.present) {
      map['scenario_category'] = Variable<String>(scenarioCategory.value);
    }
    if (dialect.present) {
      map['dialect'] = Variable<String>(dialect.value);
    }
    if (optionsJson.present) {
      map['options_json'] = Variable<String>(optionsJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DialogueNodesCompanion(')
          ..write('id: $id, ')
          ..write('speakerPortuguese: $speakerPortuguese, ')
          ..write('speakerRussian: $speakerRussian, ')
          ..write('linePortuguese: $linePortuguese, ')
          ..write('lineRussian: $lineRussian, ')
          ..write('audioPath: $audioPath, ')
          ..write('scenarioId: $scenarioId, ')
          ..write('scenarioTitle: $scenarioTitle, ')
          ..write('scenarioCategory: $scenarioCategory, ')
          ..write('dialect: $dialect, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DialogueHistoryEntriesTable extends DialogueHistoryEntries
    with TableInfo<$DialogueHistoryEntriesTable, DialogueHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DialogueHistoryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
      'node_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _selectedOptionIdMeta =
      const VerificationMeta('selectedOptionId');
  @override
  late final GeneratedColumn<String> selectedOptionId = GeneratedColumn<String>(
      'selected_option_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _answeredAtMeta =
      const VerificationMeta('answeredAt');
  @override
  late final GeneratedColumn<DateTime> answeredAt = GeneratedColumn<DateTime>(
      'answered_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, nodeId, selectedOptionId, answeredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dialogue_history_entries';
  @override
  VerificationContext validateIntegrity(Insertable<DialogueHistoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(_nodeIdMeta,
          nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta));
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('selected_option_id')) {
      context.handle(
          _selectedOptionIdMeta,
          selectedOptionId.isAcceptableOrUnknown(
              data['selected_option_id']!, _selectedOptionIdMeta));
    } else if (isInserting) {
      context.missing(_selectedOptionIdMeta);
    }
    if (data.containsKey('answered_at')) {
      context.handle(
          _answeredAtMeta,
          answeredAt.isAcceptableOrUnknown(
              data['answered_at']!, _answeredAtMeta));
    } else if (isInserting) {
      context.missing(_answeredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DialogueHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DialogueHistoryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nodeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}node_id'])!,
      selectedOptionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}selected_option_id'])!,
      answeredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}answered_at'])!,
    );
  }

  @override
  $DialogueHistoryEntriesTable createAlias(String alias) {
    return $DialogueHistoryEntriesTable(attachedDatabase, alias);
  }
}

class DialogueHistoryRow extends DataClass
    implements Insertable<DialogueHistoryRow> {
  final int id;
  final String nodeId;
  final String selectedOptionId;
  final DateTime answeredAt;
  const DialogueHistoryRow(
      {required this.id,
      required this.nodeId,
      required this.selectedOptionId,
      required this.answeredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['node_id'] = Variable<String>(nodeId);
    map['selected_option_id'] = Variable<String>(selectedOptionId);
    map['answered_at'] = Variable<DateTime>(answeredAt);
    return map;
  }

  DialogueHistoryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DialogueHistoryEntriesCompanion(
      id: Value(id),
      nodeId: Value(nodeId),
      selectedOptionId: Value(selectedOptionId),
      answeredAt: Value(answeredAt),
    );
  }

  factory DialogueHistoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DialogueHistoryRow(
      id: serializer.fromJson<int>(json['id']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      selectedOptionId: serializer.fromJson<String>(json['selectedOptionId']),
      answeredAt: serializer.fromJson<DateTime>(json['answeredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nodeId': serializer.toJson<String>(nodeId),
      'selectedOptionId': serializer.toJson<String>(selectedOptionId),
      'answeredAt': serializer.toJson<DateTime>(answeredAt),
    };
  }

  DialogueHistoryRow copyWith(
          {int? id,
          String? nodeId,
          String? selectedOptionId,
          DateTime? answeredAt}) =>
      DialogueHistoryRow(
        id: id ?? this.id,
        nodeId: nodeId ?? this.nodeId,
        selectedOptionId: selectedOptionId ?? this.selectedOptionId,
        answeredAt: answeredAt ?? this.answeredAt,
      );
  DialogueHistoryRow copyWithCompanion(DialogueHistoryEntriesCompanion data) {
    return DialogueHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      selectedOptionId: data.selectedOptionId.present
          ? data.selectedOptionId.value
          : this.selectedOptionId,
      answeredAt:
          data.answeredAt.present ? data.answeredAt.value : this.answeredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DialogueHistoryRow(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('selectedOptionId: $selectedOptionId, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nodeId, selectedOptionId, answeredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DialogueHistoryRow &&
          other.id == this.id &&
          other.nodeId == this.nodeId &&
          other.selectedOptionId == this.selectedOptionId &&
          other.answeredAt == this.answeredAt);
}

class DialogueHistoryEntriesCompanion
    extends UpdateCompanion<DialogueHistoryRow> {
  final Value<int> id;
  final Value<String> nodeId;
  final Value<String> selectedOptionId;
  final Value<DateTime> answeredAt;
  const DialogueHistoryEntriesCompanion({
    this.id = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.selectedOptionId = const Value.absent(),
    this.answeredAt = const Value.absent(),
  });
  DialogueHistoryEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String nodeId,
    required String selectedOptionId,
    required DateTime answeredAt,
  })  : nodeId = Value(nodeId),
        selectedOptionId = Value(selectedOptionId),
        answeredAt = Value(answeredAt);
  static Insertable<DialogueHistoryRow> custom({
    Expression<int>? id,
    Expression<String>? nodeId,
    Expression<String>? selectedOptionId,
    Expression<DateTime>? answeredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nodeId != null) 'node_id': nodeId,
      if (selectedOptionId != null) 'selected_option_id': selectedOptionId,
      if (answeredAt != null) 'answered_at': answeredAt,
    });
  }

  DialogueHistoryEntriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? nodeId,
      Value<String>? selectedOptionId,
      Value<DateTime>? answeredAt}) {
    return DialogueHistoryEntriesCompanion(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (selectedOptionId.present) {
      map['selected_option_id'] = Variable<String>(selectedOptionId.value);
    }
    if (answeredAt.present) {
      map['answered_at'] = Variable<DateTime>(answeredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DialogueHistoryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('selectedOptionId: $selectedOptionId, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }
}

class $SrsCardsTable extends SrsCards
    with TableInfo<$SrsCardsTable, SrsCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrsCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _portugueseMeta =
      const VerificationMeta('portuguese');
  @override
  late final GeneratedColumn<String> portuguese = GeneratedColumn<String>(
      'portuguese', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _russianTranslationMeta =
      const VerificationMeta('russianTranslation');
  @override
  late final GeneratedColumn<String> russianTranslation =
      GeneratedColumn<String>('russian_translation', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _partOfSpeechMeta =
      const VerificationMeta('partOfSpeech');
  @override
  late final GeneratedColumn<String> partOfSpeech = GeneratedColumn<String>(
      'part_of_speech', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('phrase'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('general'));
  static const VerificationMeta _dialectMeta =
      const VerificationMeta('dialect');
  @override
  late final GeneratedColumn<String> dialect = GeneratedColumn<String>(
      'dialect', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('all'));
  static const VerificationMeta _examplePortugueseMeta =
      const VerificationMeta('examplePortuguese');
  @override
  late final GeneratedColumn<String> examplePortuguese =
      GeneratedColumn<String>('example_portuguese', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exampleRussianMeta =
      const VerificationMeta('exampleRussian');
  @override
  late final GeneratedColumn<String> exampleRussian = GeneratedColumn<String>(
      'example_russian', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _audioUrlMeta =
      const VerificationMeta('audioUrl');
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
      'audio_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fsrsStateMeta =
      const VerificationMeta('fsrsState');
  @override
  late final GeneratedColumn<String> fsrsState = GeneratedColumn<String>(
      'fsrs_state', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('newCard'));
  static const VerificationMeta _stabilityMeta =
      const VerificationMeta('stability');
  @override
  late final GeneratedColumn<double> stability = GeneratedColumn<double>(
      'stability', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
      'lapses', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
      'due_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastReviewedAtMeta =
      const VerificationMeta('lastReviewedAt');
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>('last_reviewed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        portuguese,
        russianTranslation,
        partOfSpeech,
        category,
        dialect,
        examplePortuguese,
        exampleRussian,
        audioUrl,
        notes,
        fsrsState,
        stability,
        difficulty,
        reps,
        lapses,
        dueAt,
        lastReviewedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srs_cards';
  @override
  VerificationContext validateIntegrity(Insertable<SrsCardRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('portuguese')) {
      context.handle(
          _portugueseMeta,
          portuguese.isAcceptableOrUnknown(
              data['portuguese']!, _portugueseMeta));
    } else if (isInserting) {
      context.missing(_portugueseMeta);
    }
    if (data.containsKey('russian_translation')) {
      context.handle(
          _russianTranslationMeta,
          russianTranslation.isAcceptableOrUnknown(
              data['russian_translation']!, _russianTranslationMeta));
    } else if (isInserting) {
      context.missing(_russianTranslationMeta);
    }
    if (data.containsKey('part_of_speech')) {
      context.handle(
          _partOfSpeechMeta,
          partOfSpeech.isAcceptableOrUnknown(
              data['part_of_speech']!, _partOfSpeechMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('dialect')) {
      context.handle(_dialectMeta,
          dialect.isAcceptableOrUnknown(data['dialect']!, _dialectMeta));
    }
    if (data.containsKey('example_portuguese')) {
      context.handle(
          _examplePortugueseMeta,
          examplePortuguese.isAcceptableOrUnknown(
              data['example_portuguese']!, _examplePortugueseMeta));
    }
    if (data.containsKey('example_russian')) {
      context.handle(
          _exampleRussianMeta,
          exampleRussian.isAcceptableOrUnknown(
              data['example_russian']!, _exampleRussianMeta));
    }
    if (data.containsKey('audio_url')) {
      context.handle(_audioUrlMeta,
          audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('fsrs_state')) {
      context.handle(_fsrsStateMeta,
          fsrsState.isAcceptableOrUnknown(data['fsrs_state']!, _fsrsStateMeta));
    }
    if (data.containsKey('stability')) {
      context.handle(_stabilityMeta,
          stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta));
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    }
    if (data.containsKey('lapses')) {
      context.handle(_lapsesMeta,
          lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta));
    }
    if (data.containsKey('due_at')) {
      context.handle(
          _dueAtMeta, dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta));
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
          _lastReviewedAtMeta,
          lastReviewedAt.isAcceptableOrUnknown(
              data['last_reviewed_at']!, _lastReviewedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SrsCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrsCardRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      portuguese: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}portuguese'])!,
      russianTranslation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}russian_translation'])!,
      partOfSpeech: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}part_of_speech'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      dialect: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dialect'])!,
      examplePortuguese: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}example_portuguese']),
      exampleRussian: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_russian']),
      audioUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_url']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      fsrsState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fsrs_state'])!,
      stability: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stability'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}difficulty'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      lapses: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lapses'])!,
      dueAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_at'])!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_reviewed_at']),
    );
  }

  @override
  $SrsCardsTable createAlias(String alias) {
    return $SrsCardsTable(attachedDatabase, alias);
  }
}

class SrsCardRow extends DataClass implements Insertable<SrsCardRow> {
  final String id;
  final String portuguese;
  final String russianTranslation;
  final String partOfSpeech;
  final String category;
  final String dialect;
  final String? examplePortuguese;
  final String? exampleRussian;
  final String? audioUrl;
  final String? notes;
  final String fsrsState;
  final double stability;
  final double difficulty;
  final int reps;
  final int lapses;
  final DateTime dueAt;
  final DateTime? lastReviewedAt;
  const SrsCardRow(
      {required this.id,
      required this.portuguese,
      required this.russianTranslation,
      required this.partOfSpeech,
      required this.category,
      required this.dialect,
      this.examplePortuguese,
      this.exampleRussian,
      this.audioUrl,
      this.notes,
      required this.fsrsState,
      required this.stability,
      required this.difficulty,
      required this.reps,
      required this.lapses,
      required this.dueAt,
      this.lastReviewedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['portuguese'] = Variable<String>(portuguese);
    map['russian_translation'] = Variable<String>(russianTranslation);
    map['part_of_speech'] = Variable<String>(partOfSpeech);
    map['category'] = Variable<String>(category);
    map['dialect'] = Variable<String>(dialect);
    if (!nullToAbsent || examplePortuguese != null) {
      map['example_portuguese'] = Variable<String>(examplePortuguese);
    }
    if (!nullToAbsent || exampleRussian != null) {
      map['example_russian'] = Variable<String>(exampleRussian);
    }
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['fsrs_state'] = Variable<String>(fsrsState);
    map['stability'] = Variable<double>(stability);
    map['difficulty'] = Variable<double>(difficulty);
    map['reps'] = Variable<int>(reps);
    map['lapses'] = Variable<int>(lapses);
    map['due_at'] = Variable<DateTime>(dueAt);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    return map;
  }

  SrsCardsCompanion toCompanion(bool nullToAbsent) {
    return SrsCardsCompanion(
      id: Value(id),
      portuguese: Value(portuguese),
      russianTranslation: Value(russianTranslation),
      partOfSpeech: Value(partOfSpeech),
      category: Value(category),
      dialect: Value(dialect),
      examplePortuguese: examplePortuguese == null && nullToAbsent
          ? const Value.absent()
          : Value(examplePortuguese),
      exampleRussian: exampleRussian == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleRussian),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      fsrsState: Value(fsrsState),
      stability: Value(stability),
      difficulty: Value(difficulty),
      reps: Value(reps),
      lapses: Value(lapses),
      dueAt: Value(dueAt),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
    );
  }

  factory SrsCardRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrsCardRow(
      id: serializer.fromJson<String>(json['id']),
      portuguese: serializer.fromJson<String>(json['portuguese']),
      russianTranslation:
          serializer.fromJson<String>(json['russianTranslation']),
      partOfSpeech: serializer.fromJson<String>(json['partOfSpeech']),
      category: serializer.fromJson<String>(json['category']),
      dialect: serializer.fromJson<String>(json['dialect']),
      examplePortuguese:
          serializer.fromJson<String?>(json['examplePortuguese']),
      exampleRussian: serializer.fromJson<String?>(json['exampleRussian']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      notes: serializer.fromJson<String?>(json['notes']),
      fsrsState: serializer.fromJson<String>(json['fsrsState']),
      stability: serializer.fromJson<double>(json['stability']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      reps: serializer.fromJson<int>(json['reps']),
      lapses: serializer.fromJson<int>(json['lapses']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'portuguese': serializer.toJson<String>(portuguese),
      'russianTranslation': serializer.toJson<String>(russianTranslation),
      'partOfSpeech': serializer.toJson<String>(partOfSpeech),
      'category': serializer.toJson<String>(category),
      'dialect': serializer.toJson<String>(dialect),
      'examplePortuguese': serializer.toJson<String?>(examplePortuguese),
      'exampleRussian': serializer.toJson<String?>(exampleRussian),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'notes': serializer.toJson<String?>(notes),
      'fsrsState': serializer.toJson<String>(fsrsState),
      'stability': serializer.toJson<double>(stability),
      'difficulty': serializer.toJson<double>(difficulty),
      'reps': serializer.toJson<int>(reps),
      'lapses': serializer.toJson<int>(lapses),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
    };
  }

  SrsCardRow copyWith(
          {String? id,
          String? portuguese,
          String? russianTranslation,
          String? partOfSpeech,
          String? category,
          String? dialect,
          Value<String?> examplePortuguese = const Value.absent(),
          Value<String?> exampleRussian = const Value.absent(),
          Value<String?> audioUrl = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? fsrsState,
          double? stability,
          double? difficulty,
          int? reps,
          int? lapses,
          DateTime? dueAt,
          Value<DateTime?> lastReviewedAt = const Value.absent()}) =>
      SrsCardRow(
        id: id ?? this.id,
        portuguese: portuguese ?? this.portuguese,
        russianTranslation: russianTranslation ?? this.russianTranslation,
        partOfSpeech: partOfSpeech ?? this.partOfSpeech,
        category: category ?? this.category,
        dialect: dialect ?? this.dialect,
        examplePortuguese: examplePortuguese.present
            ? examplePortuguese.value
            : this.examplePortuguese,
        exampleRussian:
            exampleRussian.present ? exampleRussian.value : this.exampleRussian,
        audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
        notes: notes.present ? notes.value : this.notes,
        fsrsState: fsrsState ?? this.fsrsState,
        stability: stability ?? this.stability,
        difficulty: difficulty ?? this.difficulty,
        reps: reps ?? this.reps,
        lapses: lapses ?? this.lapses,
        dueAt: dueAt ?? this.dueAt,
        lastReviewedAt:
            lastReviewedAt.present ? lastReviewedAt.value : this.lastReviewedAt,
      );
  SrsCardRow copyWithCompanion(SrsCardsCompanion data) {
    return SrsCardRow(
      id: data.id.present ? data.id.value : this.id,
      portuguese:
          data.portuguese.present ? data.portuguese.value : this.portuguese,
      russianTranslation: data.russianTranslation.present
          ? data.russianTranslation.value
          : this.russianTranslation,
      partOfSpeech: data.partOfSpeech.present
          ? data.partOfSpeech.value
          : this.partOfSpeech,
      category: data.category.present ? data.category.value : this.category,
      dialect: data.dialect.present ? data.dialect.value : this.dialect,
      examplePortuguese: data.examplePortuguese.present
          ? data.examplePortuguese.value
          : this.examplePortuguese,
      exampleRussian: data.exampleRussian.present
          ? data.exampleRussian.value
          : this.exampleRussian,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      notes: data.notes.present ? data.notes.value : this.notes,
      fsrsState: data.fsrsState.present ? data.fsrsState.value : this.fsrsState,
      stability: data.stability.present ? data.stability.value : this.stability,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      reps: data.reps.present ? data.reps.value : this.reps,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrsCardRow(')
          ..write('id: $id, ')
          ..write('portuguese: $portuguese, ')
          ..write('russianTranslation: $russianTranslation, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('category: $category, ')
          ..write('dialect: $dialect, ')
          ..write('examplePortuguese: $examplePortuguese, ')
          ..write('exampleRussian: $exampleRussian, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('notes: $notes, ')
          ..write('fsrsState: $fsrsState, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('dueAt: $dueAt, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      portuguese,
      russianTranslation,
      partOfSpeech,
      category,
      dialect,
      examplePortuguese,
      exampleRussian,
      audioUrl,
      notes,
      fsrsState,
      stability,
      difficulty,
      reps,
      lapses,
      dueAt,
      lastReviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrsCardRow &&
          other.id == this.id &&
          other.portuguese == this.portuguese &&
          other.russianTranslation == this.russianTranslation &&
          other.partOfSpeech == this.partOfSpeech &&
          other.category == this.category &&
          other.dialect == this.dialect &&
          other.examplePortuguese == this.examplePortuguese &&
          other.exampleRussian == this.exampleRussian &&
          other.audioUrl == this.audioUrl &&
          other.notes == this.notes &&
          other.fsrsState == this.fsrsState &&
          other.stability == this.stability &&
          other.difficulty == this.difficulty &&
          other.reps == this.reps &&
          other.lapses == this.lapses &&
          other.dueAt == this.dueAt &&
          other.lastReviewedAt == this.lastReviewedAt);
}

class SrsCardsCompanion extends UpdateCompanion<SrsCardRow> {
  final Value<String> id;
  final Value<String> portuguese;
  final Value<String> russianTranslation;
  final Value<String> partOfSpeech;
  final Value<String> category;
  final Value<String> dialect;
  final Value<String?> examplePortuguese;
  final Value<String?> exampleRussian;
  final Value<String?> audioUrl;
  final Value<String?> notes;
  final Value<String> fsrsState;
  final Value<double> stability;
  final Value<double> difficulty;
  final Value<int> reps;
  final Value<int> lapses;
  final Value<DateTime> dueAt;
  final Value<DateTime?> lastReviewedAt;
  final Value<int> rowid;
  const SrsCardsCompanion({
    this.id = const Value.absent(),
    this.portuguese = const Value.absent(),
    this.russianTranslation = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.category = const Value.absent(),
    this.dialect = const Value.absent(),
    this.examplePortuguese = const Value.absent(),
    this.exampleRussian = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.fsrsState = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrsCardsCompanion.insert({
    required String id,
    required String portuguese,
    required String russianTranslation,
    this.partOfSpeech = const Value.absent(),
    this.category = const Value.absent(),
    this.dialect = const Value.absent(),
    this.examplePortuguese = const Value.absent(),
    this.exampleRussian = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.fsrsState = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    required DateTime dueAt,
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        portuguese = Value(portuguese),
        russianTranslation = Value(russianTranslation),
        dueAt = Value(dueAt);
  static Insertable<SrsCardRow> custom({
    Expression<String>? id,
    Expression<String>? portuguese,
    Expression<String>? russianTranslation,
    Expression<String>? partOfSpeech,
    Expression<String>? category,
    Expression<String>? dialect,
    Expression<String>? examplePortuguese,
    Expression<String>? exampleRussian,
    Expression<String>? audioUrl,
    Expression<String>? notes,
    Expression<String>? fsrsState,
    Expression<double>? stability,
    Expression<double>? difficulty,
    Expression<int>? reps,
    Expression<int>? lapses,
    Expression<DateTime>? dueAt,
    Expression<DateTime>? lastReviewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (portuguese != null) 'portuguese': portuguese,
      if (russianTranslation != null) 'russian_translation': russianTranslation,
      if (partOfSpeech != null) 'part_of_speech': partOfSpeech,
      if (category != null) 'category': category,
      if (dialect != null) 'dialect': dialect,
      if (examplePortuguese != null) 'example_portuguese': examplePortuguese,
      if (exampleRussian != null) 'example_russian': exampleRussian,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (notes != null) 'notes': notes,
      if (fsrsState != null) 'fsrs_state': fsrsState,
      if (stability != null) 'stability': stability,
      if (difficulty != null) 'difficulty': difficulty,
      if (reps != null) 'reps': reps,
      if (lapses != null) 'lapses': lapses,
      if (dueAt != null) 'due_at': dueAt,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrsCardsCompanion copyWith(
      {Value<String>? id,
      Value<String>? portuguese,
      Value<String>? russianTranslation,
      Value<String>? partOfSpeech,
      Value<String>? category,
      Value<String>? dialect,
      Value<String?>? examplePortuguese,
      Value<String?>? exampleRussian,
      Value<String?>? audioUrl,
      Value<String?>? notes,
      Value<String>? fsrsState,
      Value<double>? stability,
      Value<double>? difficulty,
      Value<int>? reps,
      Value<int>? lapses,
      Value<DateTime>? dueAt,
      Value<DateTime?>? lastReviewedAt,
      Value<int>? rowid}) {
    return SrsCardsCompanion(
      id: id ?? this.id,
      portuguese: portuguese ?? this.portuguese,
      russianTranslation: russianTranslation ?? this.russianTranslation,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      category: category ?? this.category,
      dialect: dialect ?? this.dialect,
      examplePortuguese: examplePortuguese ?? this.examplePortuguese,
      exampleRussian: exampleRussian ?? this.exampleRussian,
      audioUrl: audioUrl ?? this.audioUrl,
      notes: notes ?? this.notes,
      fsrsState: fsrsState ?? this.fsrsState,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      dueAt: dueAt ?? this.dueAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (portuguese.present) {
      map['portuguese'] = Variable<String>(portuguese.value);
    }
    if (russianTranslation.present) {
      map['russian_translation'] = Variable<String>(russianTranslation.value);
    }
    if (partOfSpeech.present) {
      map['part_of_speech'] = Variable<String>(partOfSpeech.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (dialect.present) {
      map['dialect'] = Variable<String>(dialect.value);
    }
    if (examplePortuguese.present) {
      map['example_portuguese'] = Variable<String>(examplePortuguese.value);
    }
    if (exampleRussian.present) {
      map['example_russian'] = Variable<String>(exampleRussian.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (fsrsState.present) {
      map['fsrs_state'] = Variable<String>(fsrsState.value);
    }
    if (stability.present) {
      map['stability'] = Variable<double>(stability.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrsCardsCompanion(')
          ..write('id: $id, ')
          ..write('portuguese: $portuguese, ')
          ..write('russianTranslation: $russianTranslation, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('category: $category, ')
          ..write('dialect: $dialect, ')
          ..write('examplePortuguese: $examplePortuguese, ')
          ..write('exampleRussian: $exampleRussian, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('notes: $notes, ')
          ..write('fsrsState: $fsrsState, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('dueAt: $dueAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrsReviewLogsTable extends SrsReviewLogs
    with TableInfo<$SrsReviewLogsTable, SrsReviewLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrsReviewLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
      'card_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
      'rating', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _stabilityBeforeMeta =
      const VerificationMeta('stabilityBefore');
  @override
  late final GeneratedColumn<double> stabilityBefore = GeneratedColumn<double>(
      'stability_before', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _stabilityAfterMeta =
      const VerificationMeta('stabilityAfter');
  @override
  late final GeneratedColumn<double> stabilityAfter = GeneratedColumn<double>(
      'stability_after', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _difficultyAfterMeta =
      const VerificationMeta('difficultyAfter');
  @override
  late final GeneratedColumn<double> difficultyAfter = GeneratedColumn<double>(
      'difficulty_after', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _scheduledDaysMeta =
      const VerificationMeta('scheduledDays');
  @override
  late final GeneratedColumn<int> scheduledDays = GeneratedColumn<int>(
      'scheduled_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _wasTypedCheckMeta =
      const VerificationMeta('wasTypedCheck');
  @override
  late final GeneratedColumn<bool> wasTypedCheck = GeneratedColumn<bool>(
      'was_typed_check', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("was_typed_check" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _wasTypedExactMeta =
      const VerificationMeta('wasTypedExact');
  @override
  late final GeneratedColumn<bool> wasTypedExact = GeneratedColumn<bool>(
      'was_typed_exact', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("was_typed_exact" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _reviewedAtMeta =
      const VerificationMeta('reviewedAt');
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
      'reviewed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cardId,
        rating,
        stabilityBefore,
        stabilityAfter,
        difficultyAfter,
        scheduledDays,
        wasTypedCheck,
        wasTypedExact,
        reviewedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srs_review_logs';
  @override
  VerificationContext validateIntegrity(Insertable<SrsReviewLogRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('stability_before')) {
      context.handle(
          _stabilityBeforeMeta,
          stabilityBefore.isAcceptableOrUnknown(
              data['stability_before']!, _stabilityBeforeMeta));
    } else if (isInserting) {
      context.missing(_stabilityBeforeMeta);
    }
    if (data.containsKey('stability_after')) {
      context.handle(
          _stabilityAfterMeta,
          stabilityAfter.isAcceptableOrUnknown(
              data['stability_after']!, _stabilityAfterMeta));
    } else if (isInserting) {
      context.missing(_stabilityAfterMeta);
    }
    if (data.containsKey('difficulty_after')) {
      context.handle(
          _difficultyAfterMeta,
          difficultyAfter.isAcceptableOrUnknown(
              data['difficulty_after']!, _difficultyAfterMeta));
    } else if (isInserting) {
      context.missing(_difficultyAfterMeta);
    }
    if (data.containsKey('scheduled_days')) {
      context.handle(
          _scheduledDaysMeta,
          scheduledDays.isAcceptableOrUnknown(
              data['scheduled_days']!, _scheduledDaysMeta));
    } else if (isInserting) {
      context.missing(_scheduledDaysMeta);
    }
    if (data.containsKey('was_typed_check')) {
      context.handle(
          _wasTypedCheckMeta,
          wasTypedCheck.isAcceptableOrUnknown(
              data['was_typed_check']!, _wasTypedCheckMeta));
    }
    if (data.containsKey('was_typed_exact')) {
      context.handle(
          _wasTypedExactMeta,
          wasTypedExact.isAcceptableOrUnknown(
              data['was_typed_exact']!, _wasTypedExactMeta));
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
          _reviewedAtMeta,
          reviewedAt.isAcceptableOrUnknown(
              data['reviewed_at']!, _reviewedAtMeta));
    } else if (isInserting) {
      context.missing(_reviewedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SrsReviewLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrsReviewLogRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_id'])!,
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rating'])!,
      stabilityBefore: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}stability_before'])!,
      stabilityAfter: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}stability_after'])!,
      difficultyAfter: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}difficulty_after'])!,
      scheduledDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scheduled_days'])!,
      wasTypedCheck: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}was_typed_check'])!,
      wasTypedExact: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}was_typed_exact'])!,
      reviewedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reviewed_at'])!,
    );
  }

  @override
  $SrsReviewLogsTable createAlias(String alias) {
    return $SrsReviewLogsTable(attachedDatabase, alias);
  }
}

class SrsReviewLogRow extends DataClass implements Insertable<SrsReviewLogRow> {
  final int id;
  final String cardId;
  final int rating;
  final double stabilityBefore;
  final double stabilityAfter;
  final double difficultyAfter;
  final int scheduledDays;
  final bool wasTypedCheck;
  final bool wasTypedExact;
  final DateTime reviewedAt;
  const SrsReviewLogRow(
      {required this.id,
      required this.cardId,
      required this.rating,
      required this.stabilityBefore,
      required this.stabilityAfter,
      required this.difficultyAfter,
      required this.scheduledDays,
      required this.wasTypedCheck,
      required this.wasTypedExact,
      required this.reviewedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<String>(cardId);
    map['rating'] = Variable<int>(rating);
    map['stability_before'] = Variable<double>(stabilityBefore);
    map['stability_after'] = Variable<double>(stabilityAfter);
    map['difficulty_after'] = Variable<double>(difficultyAfter);
    map['scheduled_days'] = Variable<int>(scheduledDays);
    map['was_typed_check'] = Variable<bool>(wasTypedCheck);
    map['was_typed_exact'] = Variable<bool>(wasTypedExact);
    map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    return map;
  }

  SrsReviewLogsCompanion toCompanion(bool nullToAbsent) {
    return SrsReviewLogsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      rating: Value(rating),
      stabilityBefore: Value(stabilityBefore),
      stabilityAfter: Value(stabilityAfter),
      difficultyAfter: Value(difficultyAfter),
      scheduledDays: Value(scheduledDays),
      wasTypedCheck: Value(wasTypedCheck),
      wasTypedExact: Value(wasTypedExact),
      reviewedAt: Value(reviewedAt),
    );
  }

  factory SrsReviewLogRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrsReviewLogRow(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      rating: serializer.fromJson<int>(json['rating']),
      stabilityBefore: serializer.fromJson<double>(json['stabilityBefore']),
      stabilityAfter: serializer.fromJson<double>(json['stabilityAfter']),
      difficultyAfter: serializer.fromJson<double>(json['difficultyAfter']),
      scheduledDays: serializer.fromJson<int>(json['scheduledDays']),
      wasTypedCheck: serializer.fromJson<bool>(json['wasTypedCheck']),
      wasTypedExact: serializer.fromJson<bool>(json['wasTypedExact']),
      reviewedAt: serializer.fromJson<DateTime>(json['reviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<String>(cardId),
      'rating': serializer.toJson<int>(rating),
      'stabilityBefore': serializer.toJson<double>(stabilityBefore),
      'stabilityAfter': serializer.toJson<double>(stabilityAfter),
      'difficultyAfter': serializer.toJson<double>(difficultyAfter),
      'scheduledDays': serializer.toJson<int>(scheduledDays),
      'wasTypedCheck': serializer.toJson<bool>(wasTypedCheck),
      'wasTypedExact': serializer.toJson<bool>(wasTypedExact),
      'reviewedAt': serializer.toJson<DateTime>(reviewedAt),
    };
  }

  SrsReviewLogRow copyWith(
          {int? id,
          String? cardId,
          int? rating,
          double? stabilityBefore,
          double? stabilityAfter,
          double? difficultyAfter,
          int? scheduledDays,
          bool? wasTypedCheck,
          bool? wasTypedExact,
          DateTime? reviewedAt}) =>
      SrsReviewLogRow(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        rating: rating ?? this.rating,
        stabilityBefore: stabilityBefore ?? this.stabilityBefore,
        stabilityAfter: stabilityAfter ?? this.stabilityAfter,
        difficultyAfter: difficultyAfter ?? this.difficultyAfter,
        scheduledDays: scheduledDays ?? this.scheduledDays,
        wasTypedCheck: wasTypedCheck ?? this.wasTypedCheck,
        wasTypedExact: wasTypedExact ?? this.wasTypedExact,
        reviewedAt: reviewedAt ?? this.reviewedAt,
      );
  SrsReviewLogRow copyWithCompanion(SrsReviewLogsCompanion data) {
    return SrsReviewLogRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      rating: data.rating.present ? data.rating.value : this.rating,
      stabilityBefore: data.stabilityBefore.present
          ? data.stabilityBefore.value
          : this.stabilityBefore,
      stabilityAfter: data.stabilityAfter.present
          ? data.stabilityAfter.value
          : this.stabilityAfter,
      difficultyAfter: data.difficultyAfter.present
          ? data.difficultyAfter.value
          : this.difficultyAfter,
      scheduledDays: data.scheduledDays.present
          ? data.scheduledDays.value
          : this.scheduledDays,
      wasTypedCheck: data.wasTypedCheck.present
          ? data.wasTypedCheck.value
          : this.wasTypedCheck,
      wasTypedExact: data.wasTypedExact.present
          ? data.wasTypedExact.value
          : this.wasTypedExact,
      reviewedAt:
          data.reviewedAt.present ? data.reviewedAt.value : this.reviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrsReviewLogRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('rating: $rating, ')
          ..write('stabilityBefore: $stabilityBefore, ')
          ..write('stabilityAfter: $stabilityAfter, ')
          ..write('difficultyAfter: $difficultyAfter, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('wasTypedCheck: $wasTypedCheck, ')
          ..write('wasTypedExact: $wasTypedExact, ')
          ..write('reviewedAt: $reviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      cardId,
      rating,
      stabilityBefore,
      stabilityAfter,
      difficultyAfter,
      scheduledDays,
      wasTypedCheck,
      wasTypedExact,
      reviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrsReviewLogRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.rating == this.rating &&
          other.stabilityBefore == this.stabilityBefore &&
          other.stabilityAfter == this.stabilityAfter &&
          other.difficultyAfter == this.difficultyAfter &&
          other.scheduledDays == this.scheduledDays &&
          other.wasTypedCheck == this.wasTypedCheck &&
          other.wasTypedExact == this.wasTypedExact &&
          other.reviewedAt == this.reviewedAt);
}

class SrsReviewLogsCompanion extends UpdateCompanion<SrsReviewLogRow> {
  final Value<int> id;
  final Value<String> cardId;
  final Value<int> rating;
  final Value<double> stabilityBefore;
  final Value<double> stabilityAfter;
  final Value<double> difficultyAfter;
  final Value<int> scheduledDays;
  final Value<bool> wasTypedCheck;
  final Value<bool> wasTypedExact;
  final Value<DateTime> reviewedAt;
  const SrsReviewLogsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.rating = const Value.absent(),
    this.stabilityBefore = const Value.absent(),
    this.stabilityAfter = const Value.absent(),
    this.difficultyAfter = const Value.absent(),
    this.scheduledDays = const Value.absent(),
    this.wasTypedCheck = const Value.absent(),
    this.wasTypedExact = const Value.absent(),
    this.reviewedAt = const Value.absent(),
  });
  SrsReviewLogsCompanion.insert({
    this.id = const Value.absent(),
    required String cardId,
    required int rating,
    required double stabilityBefore,
    required double stabilityAfter,
    required double difficultyAfter,
    required int scheduledDays,
    this.wasTypedCheck = const Value.absent(),
    this.wasTypedExact = const Value.absent(),
    required DateTime reviewedAt,
  })  : cardId = Value(cardId),
        rating = Value(rating),
        stabilityBefore = Value(stabilityBefore),
        stabilityAfter = Value(stabilityAfter),
        difficultyAfter = Value(difficultyAfter),
        scheduledDays = Value(scheduledDays),
        reviewedAt = Value(reviewedAt);
  static Insertable<SrsReviewLogRow> custom({
    Expression<int>? id,
    Expression<String>? cardId,
    Expression<int>? rating,
    Expression<double>? stabilityBefore,
    Expression<double>? stabilityAfter,
    Expression<double>? difficultyAfter,
    Expression<int>? scheduledDays,
    Expression<bool>? wasTypedCheck,
    Expression<bool>? wasTypedExact,
    Expression<DateTime>? reviewedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (rating != null) 'rating': rating,
      if (stabilityBefore != null) 'stability_before': stabilityBefore,
      if (stabilityAfter != null) 'stability_after': stabilityAfter,
      if (difficultyAfter != null) 'difficulty_after': difficultyAfter,
      if (scheduledDays != null) 'scheduled_days': scheduledDays,
      if (wasTypedCheck != null) 'was_typed_check': wasTypedCheck,
      if (wasTypedExact != null) 'was_typed_exact': wasTypedExact,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
    });
  }

  SrsReviewLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? cardId,
      Value<int>? rating,
      Value<double>? stabilityBefore,
      Value<double>? stabilityAfter,
      Value<double>? difficultyAfter,
      Value<int>? scheduledDays,
      Value<bool>? wasTypedCheck,
      Value<bool>? wasTypedExact,
      Value<DateTime>? reviewedAt}) {
    return SrsReviewLogsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      rating: rating ?? this.rating,
      stabilityBefore: stabilityBefore ?? this.stabilityBefore,
      stabilityAfter: stabilityAfter ?? this.stabilityAfter,
      difficultyAfter: difficultyAfter ?? this.difficultyAfter,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      wasTypedCheck: wasTypedCheck ?? this.wasTypedCheck,
      wasTypedExact: wasTypedExact ?? this.wasTypedExact,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (stabilityBefore.present) {
      map['stability_before'] = Variable<double>(stabilityBefore.value);
    }
    if (stabilityAfter.present) {
      map['stability_after'] = Variable<double>(stabilityAfter.value);
    }
    if (difficultyAfter.present) {
      map['difficulty_after'] = Variable<double>(difficultyAfter.value);
    }
    if (scheduledDays.present) {
      map['scheduled_days'] = Variable<int>(scheduledDays.value);
    }
    if (wasTypedCheck.present) {
      map['was_typed_check'] = Variable<bool>(wasTypedCheck.value);
    }
    if (wasTypedExact.present) {
      map['was_typed_exact'] = Variable<bool>(wasTypedExact.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrsReviewLogsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('rating: $rating, ')
          ..write('stabilityBefore: $stabilityBefore, ')
          ..write('stabilityAfter: $stabilityAfter, ')
          ..write('difficultyAfter: $difficultyAfter, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('wasTypedCheck: $wasTypedCheck, ')
          ..write('wasTypedExact: $wasTypedExact, ')
          ..write('reviewedAt: $reviewedAt')
          ..write(')'))
        .toString();
  }
}

class $GrammarVerbsTable extends GrammarVerbs
    with TableInfo<$GrammarVerbsTable, GrammarVerbRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarVerbsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _infinitiveMeta =
      const VerificationMeta('infinitive');
  @override
  late final GeneratedColumn<String> infinitive = GeneratedColumn<String>(
      'infinitive', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _regularityMeta =
      const VerificationMeta('regularity');
  @override
  late final GeneratedColumn<String> regularity = GeneratedColumn<String>(
      'regularity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _conjugationGroupMeta =
      const VerificationMeta('conjugationGroup');
  @override
  late final GeneratedColumn<String> conjugationGroup = GeneratedColumn<String>(
      'conjugation_group', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _russianMeaningMeta =
      const VerificationMeta('russianMeaning');
  @override
  late final GeneratedColumn<String> russianMeaning = GeneratedColumn<String>(
      'russian_meaning', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _grammarNotesRuMeta =
      const VerificationMeta('grammarNotesRu');
  @override
  late final GeneratedColumn<String> grammarNotesRu = GeneratedColumn<String>(
      'grammar_notes_ru', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _differenceNoteMeta =
      const VerificationMeta('differenceNote');
  @override
  late final GeneratedColumn<String> differenceNote = GeneratedColumn<String>(
      'difference_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conjugationsJsonMeta =
      const VerificationMeta('conjugationsJson');
  @override
  late final GeneratedColumn<String> conjugationsJson = GeneratedColumn<String>(
      'conjugations_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        infinitive,
        regularity,
        conjugationGroup,
        russianMeaning,
        grammarNotesRu,
        differenceNote,
        conjugationsJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_verbs';
  @override
  VerificationContext validateIntegrity(Insertable<GrammarVerbRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('infinitive')) {
      context.handle(
          _infinitiveMeta,
          infinitive.isAcceptableOrUnknown(
              data['infinitive']!, _infinitiveMeta));
    } else if (isInserting) {
      context.missing(_infinitiveMeta);
    }
    if (data.containsKey('regularity')) {
      context.handle(
          _regularityMeta,
          regularity.isAcceptableOrUnknown(
              data['regularity']!, _regularityMeta));
    } else if (isInserting) {
      context.missing(_regularityMeta);
    }
    if (data.containsKey('conjugation_group')) {
      context.handle(
          _conjugationGroupMeta,
          conjugationGroup.isAcceptableOrUnknown(
              data['conjugation_group']!, _conjugationGroupMeta));
    } else if (isInserting) {
      context.missing(_conjugationGroupMeta);
    }
    if (data.containsKey('russian_meaning')) {
      context.handle(
          _russianMeaningMeta,
          russianMeaning.isAcceptableOrUnknown(
              data['russian_meaning']!, _russianMeaningMeta));
    } else if (isInserting) {
      context.missing(_russianMeaningMeta);
    }
    if (data.containsKey('grammar_notes_ru')) {
      context.handle(
          _grammarNotesRuMeta,
          grammarNotesRu.isAcceptableOrUnknown(
              data['grammar_notes_ru']!, _grammarNotesRuMeta));
    } else if (isInserting) {
      context.missing(_grammarNotesRuMeta);
    }
    if (data.containsKey('difference_note')) {
      context.handle(
          _differenceNoteMeta,
          differenceNote.isAcceptableOrUnknown(
              data['difference_note']!, _differenceNoteMeta));
    }
    if (data.containsKey('conjugations_json')) {
      context.handle(
          _conjugationsJsonMeta,
          conjugationsJson.isAcceptableOrUnknown(
              data['conjugations_json']!, _conjugationsJsonMeta));
    } else if (isInserting) {
      context.missing(_conjugationsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarVerbRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarVerbRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      infinitive: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}infinitive'])!,
      regularity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}regularity'])!,
      conjugationGroup: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conjugation_group'])!,
      russianMeaning: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}russian_meaning'])!,
      grammarNotesRu: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}grammar_notes_ru'])!,
      differenceNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difference_note']),
      conjugationsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conjugations_json'])!,
    );
  }

  @override
  $GrammarVerbsTable createAlias(String alias) {
    return $GrammarVerbsTable(attachedDatabase, alias);
  }
}

class GrammarVerbRow extends DataClass implements Insertable<GrammarVerbRow> {
  final String id;
  final String infinitive;
  final String regularity;
  final String conjugationGroup;
  final String russianMeaning;
  final String grammarNotesRu;
  final String? differenceNote;
  final String conjugationsJson;
  const GrammarVerbRow(
      {required this.id,
      required this.infinitive,
      required this.regularity,
      required this.conjugationGroup,
      required this.russianMeaning,
      required this.grammarNotesRu,
      this.differenceNote,
      required this.conjugationsJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['infinitive'] = Variable<String>(infinitive);
    map['regularity'] = Variable<String>(regularity);
    map['conjugation_group'] = Variable<String>(conjugationGroup);
    map['russian_meaning'] = Variable<String>(russianMeaning);
    map['grammar_notes_ru'] = Variable<String>(grammarNotesRu);
    if (!nullToAbsent || differenceNote != null) {
      map['difference_note'] = Variable<String>(differenceNote);
    }
    map['conjugations_json'] = Variable<String>(conjugationsJson);
    return map;
  }

  GrammarVerbsCompanion toCompanion(bool nullToAbsent) {
    return GrammarVerbsCompanion(
      id: Value(id),
      infinitive: Value(infinitive),
      regularity: Value(regularity),
      conjugationGroup: Value(conjugationGroup),
      russianMeaning: Value(russianMeaning),
      grammarNotesRu: Value(grammarNotesRu),
      differenceNote: differenceNote == null && nullToAbsent
          ? const Value.absent()
          : Value(differenceNote),
      conjugationsJson: Value(conjugationsJson),
    );
  }

  factory GrammarVerbRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarVerbRow(
      id: serializer.fromJson<String>(json['id']),
      infinitive: serializer.fromJson<String>(json['infinitive']),
      regularity: serializer.fromJson<String>(json['regularity']),
      conjugationGroup: serializer.fromJson<String>(json['conjugationGroup']),
      russianMeaning: serializer.fromJson<String>(json['russianMeaning']),
      grammarNotesRu: serializer.fromJson<String>(json['grammarNotesRu']),
      differenceNote: serializer.fromJson<String?>(json['differenceNote']),
      conjugationsJson: serializer.fromJson<String>(json['conjugationsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'infinitive': serializer.toJson<String>(infinitive),
      'regularity': serializer.toJson<String>(regularity),
      'conjugationGroup': serializer.toJson<String>(conjugationGroup),
      'russianMeaning': serializer.toJson<String>(russianMeaning),
      'grammarNotesRu': serializer.toJson<String>(grammarNotesRu),
      'differenceNote': serializer.toJson<String?>(differenceNote),
      'conjugationsJson': serializer.toJson<String>(conjugationsJson),
    };
  }

  GrammarVerbRow copyWith(
          {String? id,
          String? infinitive,
          String? regularity,
          String? conjugationGroup,
          String? russianMeaning,
          String? grammarNotesRu,
          Value<String?> differenceNote = const Value.absent(),
          String? conjugationsJson}) =>
      GrammarVerbRow(
        id: id ?? this.id,
        infinitive: infinitive ?? this.infinitive,
        regularity: regularity ?? this.regularity,
        conjugationGroup: conjugationGroup ?? this.conjugationGroup,
        russianMeaning: russianMeaning ?? this.russianMeaning,
        grammarNotesRu: grammarNotesRu ?? this.grammarNotesRu,
        differenceNote:
            differenceNote.present ? differenceNote.value : this.differenceNote,
        conjugationsJson: conjugationsJson ?? this.conjugationsJson,
      );
  GrammarVerbRow copyWithCompanion(GrammarVerbsCompanion data) {
    return GrammarVerbRow(
      id: data.id.present ? data.id.value : this.id,
      infinitive:
          data.infinitive.present ? data.infinitive.value : this.infinitive,
      regularity:
          data.regularity.present ? data.regularity.value : this.regularity,
      conjugationGroup: data.conjugationGroup.present
          ? data.conjugationGroup.value
          : this.conjugationGroup,
      russianMeaning: data.russianMeaning.present
          ? data.russianMeaning.value
          : this.russianMeaning,
      grammarNotesRu: data.grammarNotesRu.present
          ? data.grammarNotesRu.value
          : this.grammarNotesRu,
      differenceNote: data.differenceNote.present
          ? data.differenceNote.value
          : this.differenceNote,
      conjugationsJson: data.conjugationsJson.present
          ? data.conjugationsJson.value
          : this.conjugationsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarVerbRow(')
          ..write('id: $id, ')
          ..write('infinitive: $infinitive, ')
          ..write('regularity: $regularity, ')
          ..write('conjugationGroup: $conjugationGroup, ')
          ..write('russianMeaning: $russianMeaning, ')
          ..write('grammarNotesRu: $grammarNotesRu, ')
          ..write('differenceNote: $differenceNote, ')
          ..write('conjugationsJson: $conjugationsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, infinitive, regularity, conjugationGroup,
      russianMeaning, grammarNotesRu, differenceNote, conjugationsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarVerbRow &&
          other.id == this.id &&
          other.infinitive == this.infinitive &&
          other.regularity == this.regularity &&
          other.conjugationGroup == this.conjugationGroup &&
          other.russianMeaning == this.russianMeaning &&
          other.grammarNotesRu == this.grammarNotesRu &&
          other.differenceNote == this.differenceNote &&
          other.conjugationsJson == this.conjugationsJson);
}

class GrammarVerbsCompanion extends UpdateCompanion<GrammarVerbRow> {
  final Value<String> id;
  final Value<String> infinitive;
  final Value<String> regularity;
  final Value<String> conjugationGroup;
  final Value<String> russianMeaning;
  final Value<String> grammarNotesRu;
  final Value<String?> differenceNote;
  final Value<String> conjugationsJson;
  final Value<int> rowid;
  const GrammarVerbsCompanion({
    this.id = const Value.absent(),
    this.infinitive = const Value.absent(),
    this.regularity = const Value.absent(),
    this.conjugationGroup = const Value.absent(),
    this.russianMeaning = const Value.absent(),
    this.grammarNotesRu = const Value.absent(),
    this.differenceNote = const Value.absent(),
    this.conjugationsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GrammarVerbsCompanion.insert({
    required String id,
    required String infinitive,
    required String regularity,
    required String conjugationGroup,
    required String russianMeaning,
    required String grammarNotesRu,
    this.differenceNote = const Value.absent(),
    required String conjugationsJson,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        infinitive = Value(infinitive),
        regularity = Value(regularity),
        conjugationGroup = Value(conjugationGroup),
        russianMeaning = Value(russianMeaning),
        grammarNotesRu = Value(grammarNotesRu),
        conjugationsJson = Value(conjugationsJson);
  static Insertable<GrammarVerbRow> custom({
    Expression<String>? id,
    Expression<String>? infinitive,
    Expression<String>? regularity,
    Expression<String>? conjugationGroup,
    Expression<String>? russianMeaning,
    Expression<String>? grammarNotesRu,
    Expression<String>? differenceNote,
    Expression<String>? conjugationsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (infinitive != null) 'infinitive': infinitive,
      if (regularity != null) 'regularity': regularity,
      if (conjugationGroup != null) 'conjugation_group': conjugationGroup,
      if (russianMeaning != null) 'russian_meaning': russianMeaning,
      if (grammarNotesRu != null) 'grammar_notes_ru': grammarNotesRu,
      if (differenceNote != null) 'difference_note': differenceNote,
      if (conjugationsJson != null) 'conjugations_json': conjugationsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GrammarVerbsCompanion copyWith(
      {Value<String>? id,
      Value<String>? infinitive,
      Value<String>? regularity,
      Value<String>? conjugationGroup,
      Value<String>? russianMeaning,
      Value<String>? grammarNotesRu,
      Value<String?>? differenceNote,
      Value<String>? conjugationsJson,
      Value<int>? rowid}) {
    return GrammarVerbsCompanion(
      id: id ?? this.id,
      infinitive: infinitive ?? this.infinitive,
      regularity: regularity ?? this.regularity,
      conjugationGroup: conjugationGroup ?? this.conjugationGroup,
      russianMeaning: russianMeaning ?? this.russianMeaning,
      grammarNotesRu: grammarNotesRu ?? this.grammarNotesRu,
      differenceNote: differenceNote ?? this.differenceNote,
      conjugationsJson: conjugationsJson ?? this.conjugationsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (infinitive.present) {
      map['infinitive'] = Variable<String>(infinitive.value);
    }
    if (regularity.present) {
      map['regularity'] = Variable<String>(regularity.value);
    }
    if (conjugationGroup.present) {
      map['conjugation_group'] = Variable<String>(conjugationGroup.value);
    }
    if (russianMeaning.present) {
      map['russian_meaning'] = Variable<String>(russianMeaning.value);
    }
    if (grammarNotesRu.present) {
      map['grammar_notes_ru'] = Variable<String>(grammarNotesRu.value);
    }
    if (differenceNote.present) {
      map['difference_note'] = Variable<String>(differenceNote.value);
    }
    if (conjugationsJson.present) {
      map['conjugations_json'] = Variable<String>(conjugationsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarVerbsCompanion(')
          ..write('id: $id, ')
          ..write('infinitive: $infinitive, ')
          ..write('regularity: $regularity, ')
          ..write('conjugationGroup: $conjugationGroup, ')
          ..write('russianMeaning: $russianMeaning, ')
          ..write('grammarNotesRu: $grammarNotesRu, ')
          ..write('differenceNote: $differenceNote, ')
          ..write('conjugationsJson: $conjugationsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GrammarPracticeLogsTable extends GrammarPracticeLogs
    with TableInfo<$GrammarPracticeLogsTable, GrammarPracticeLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarPracticeLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _verbIdMeta = const VerificationMeta('verbId');
  @override
  late final GeneratedColumn<String> verbId = GeneratedColumn<String>(
      'verb_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenseMeta = const VerificationMeta('tense');
  @override
  late final GeneratedColumn<String> tense = GeneratedColumn<String>(
      'tense', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personMeta = const VerificationMeta('person');
  @override
  late final GeneratedColumn<String> person = GeneratedColumn<String>(
      'person', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCorrectMeta =
      const VerificationMeta('isCorrect');
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
      'is_correct', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_correct" IN (0, 1))'));
  static const VerificationMeta _practicedAtMeta =
      const VerificationMeta('practicedAt');
  @override
  late final GeneratedColumn<DateTime> practicedAt = GeneratedColumn<DateTime>(
      'practiced_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, verbId, tense, person, isCorrect, practicedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_practice_logs';
  @override
  VerificationContext validateIntegrity(
      Insertable<GrammarPracticeLogRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('verb_id')) {
      context.handle(_verbIdMeta,
          verbId.isAcceptableOrUnknown(data['verb_id']!, _verbIdMeta));
    } else if (isInserting) {
      context.missing(_verbIdMeta);
    }
    if (data.containsKey('tense')) {
      context.handle(
          _tenseMeta, tense.isAcceptableOrUnknown(data['tense']!, _tenseMeta));
    } else if (isInserting) {
      context.missing(_tenseMeta);
    }
    if (data.containsKey('person')) {
      context.handle(_personMeta,
          person.isAcceptableOrUnknown(data['person']!, _personMeta));
    } else if (isInserting) {
      context.missing(_personMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(_isCorrectMeta,
          isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta));
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('practiced_at')) {
      context.handle(
          _practicedAtMeta,
          practicedAt.isAcceptableOrUnknown(
              data['practiced_at']!, _practicedAtMeta));
    } else if (isInserting) {
      context.missing(_practicedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarPracticeLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarPracticeLogRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      verbId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verb_id'])!,
      tense: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tense'])!,
      person: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person'])!,
      isCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_correct'])!,
      practicedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}practiced_at'])!,
    );
  }

  @override
  $GrammarPracticeLogsTable createAlias(String alias) {
    return $GrammarPracticeLogsTable(attachedDatabase, alias);
  }
}

class GrammarPracticeLogRow extends DataClass
    implements Insertable<GrammarPracticeLogRow> {
  final int id;
  final String verbId;
  final String tense;
  final String person;
  final bool isCorrect;
  final DateTime practicedAt;
  const GrammarPracticeLogRow(
      {required this.id,
      required this.verbId,
      required this.tense,
      required this.person,
      required this.isCorrect,
      required this.practicedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['verb_id'] = Variable<String>(verbId);
    map['tense'] = Variable<String>(tense);
    map['person'] = Variable<String>(person);
    map['is_correct'] = Variable<bool>(isCorrect);
    map['practiced_at'] = Variable<DateTime>(practicedAt);
    return map;
  }

  GrammarPracticeLogsCompanion toCompanion(bool nullToAbsent) {
    return GrammarPracticeLogsCompanion(
      id: Value(id),
      verbId: Value(verbId),
      tense: Value(tense),
      person: Value(person),
      isCorrect: Value(isCorrect),
      practicedAt: Value(practicedAt),
    );
  }

  factory GrammarPracticeLogRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarPracticeLogRow(
      id: serializer.fromJson<int>(json['id']),
      verbId: serializer.fromJson<String>(json['verbId']),
      tense: serializer.fromJson<String>(json['tense']),
      person: serializer.fromJson<String>(json['person']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      practicedAt: serializer.fromJson<DateTime>(json['practicedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'verbId': serializer.toJson<String>(verbId),
      'tense': serializer.toJson<String>(tense),
      'person': serializer.toJson<String>(person),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'practicedAt': serializer.toJson<DateTime>(practicedAt),
    };
  }

  GrammarPracticeLogRow copyWith(
          {int? id,
          String? verbId,
          String? tense,
          String? person,
          bool? isCorrect,
          DateTime? practicedAt}) =>
      GrammarPracticeLogRow(
        id: id ?? this.id,
        verbId: verbId ?? this.verbId,
        tense: tense ?? this.tense,
        person: person ?? this.person,
        isCorrect: isCorrect ?? this.isCorrect,
        practicedAt: practicedAt ?? this.practicedAt,
      );
  GrammarPracticeLogRow copyWithCompanion(GrammarPracticeLogsCompanion data) {
    return GrammarPracticeLogRow(
      id: data.id.present ? data.id.value : this.id,
      verbId: data.verbId.present ? data.verbId.value : this.verbId,
      tense: data.tense.present ? data.tense.value : this.tense,
      person: data.person.present ? data.person.value : this.person,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      practicedAt:
          data.practicedAt.present ? data.practicedAt.value : this.practicedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarPracticeLogRow(')
          ..write('id: $id, ')
          ..write('verbId: $verbId, ')
          ..write('tense: $tense, ')
          ..write('person: $person, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('practicedAt: $practicedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, verbId, tense, person, isCorrect, practicedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarPracticeLogRow &&
          other.id == this.id &&
          other.verbId == this.verbId &&
          other.tense == this.tense &&
          other.person == this.person &&
          other.isCorrect == this.isCorrect &&
          other.practicedAt == this.practicedAt);
}

class GrammarPracticeLogsCompanion
    extends UpdateCompanion<GrammarPracticeLogRow> {
  final Value<int> id;
  final Value<String> verbId;
  final Value<String> tense;
  final Value<String> person;
  final Value<bool> isCorrect;
  final Value<DateTime> practicedAt;
  const GrammarPracticeLogsCompanion({
    this.id = const Value.absent(),
    this.verbId = const Value.absent(),
    this.tense = const Value.absent(),
    this.person = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.practicedAt = const Value.absent(),
  });
  GrammarPracticeLogsCompanion.insert({
    this.id = const Value.absent(),
    required String verbId,
    required String tense,
    required String person,
    required bool isCorrect,
    required DateTime practicedAt,
  })  : verbId = Value(verbId),
        tense = Value(tense),
        person = Value(person),
        isCorrect = Value(isCorrect),
        practicedAt = Value(practicedAt);
  static Insertable<GrammarPracticeLogRow> custom({
    Expression<int>? id,
    Expression<String>? verbId,
    Expression<String>? tense,
    Expression<String>? person,
    Expression<bool>? isCorrect,
    Expression<DateTime>? practicedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (verbId != null) 'verb_id': verbId,
      if (tense != null) 'tense': tense,
      if (person != null) 'person': person,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (practicedAt != null) 'practiced_at': practicedAt,
    });
  }

  GrammarPracticeLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? verbId,
      Value<String>? tense,
      Value<String>? person,
      Value<bool>? isCorrect,
      Value<DateTime>? practicedAt}) {
    return GrammarPracticeLogsCompanion(
      id: id ?? this.id,
      verbId: verbId ?? this.verbId,
      tense: tense ?? this.tense,
      person: person ?? this.person,
      isCorrect: isCorrect ?? this.isCorrect,
      practicedAt: practicedAt ?? this.practicedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (verbId.present) {
      map['verb_id'] = Variable<String>(verbId.value);
    }
    if (tense.present) {
      map['tense'] = Variable<String>(tense.value);
    }
    if (person.present) {
      map['person'] = Variable<String>(person.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (practicedAt.present) {
      map['practiced_at'] = Variable<DateTime>(practicedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarPracticeLogsCompanion(')
          ..write('id: $id, ')
          ..write('verbId: $verbId, ')
          ..write('tense: $tense, ')
          ..write('person: $person, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('practicedAt: $practicedAt')
          ..write(')'))
        .toString();
  }
}

class $ListeningExercisesTable extends ListeningExercises
    with TableInfo<$ListeningExercisesTable, ListeningExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListeningExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transcriptMeta =
      const VerificationMeta('transcript');
  @override
  late final GeneratedColumn<String> transcript = GeneratedColumn<String>(
      'transcript', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _russianTranslationMeta =
      const VerificationMeta('russianTranslation');
  @override
  late final GeneratedColumn<String> russianTranslation =
      GeneratedColumn<String>('russian_translation', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _audioUrlMeta =
      const VerificationMeta('audioUrl');
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
      'audio_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('beginner'));
  static const VerificationMeta _focusWordsJsonMeta =
      const VerificationMeta('focusWordsJson');
  @override
  late final GeneratedColumn<String> focusWordsJson = GeneratedColumn<String>(
      'focus_words_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dialectMeta =
      const VerificationMeta('dialect');
  @override
  late final GeneratedColumn<String> dialect = GeneratedColumn<String>(
      'dialect', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('all'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        transcript,
        russianTranslation,
        audioUrl,
        difficulty,
        focusWordsJson,
        dialect
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'listening_exercises';
  @override
  VerificationContext validateIntegrity(
      Insertable<ListeningExerciseRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transcript')) {
      context.handle(
          _transcriptMeta,
          transcript.isAcceptableOrUnknown(
              data['transcript']!, _transcriptMeta));
    } else if (isInserting) {
      context.missing(_transcriptMeta);
    }
    if (data.containsKey('russian_translation')) {
      context.handle(
          _russianTranslationMeta,
          russianTranslation.isAcceptableOrUnknown(
              data['russian_translation']!, _russianTranslationMeta));
    } else if (isInserting) {
      context.missing(_russianTranslationMeta);
    }
    if (data.containsKey('audio_url')) {
      context.handle(_audioUrlMeta,
          audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta));
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    if (data.containsKey('focus_words_json')) {
      context.handle(
          _focusWordsJsonMeta,
          focusWordsJson.isAcceptableOrUnknown(
              data['focus_words_json']!, _focusWordsJsonMeta));
    } else if (isInserting) {
      context.missing(_focusWordsJsonMeta);
    }
    if (data.containsKey('dialect')) {
      context.handle(_dialectMeta,
          dialect.isAcceptableOrUnknown(data['dialect']!, _dialectMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListeningExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListeningExerciseRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      transcript: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transcript'])!,
      russianTranslation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}russian_translation'])!,
      audioUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_url']),
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty'])!,
      focusWordsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}focus_words_json'])!,
      dialect: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dialect'])!,
    );
  }

  @override
  $ListeningExercisesTable createAlias(String alias) {
    return $ListeningExercisesTable(attachedDatabase, alias);
  }
}

class ListeningExerciseRow extends DataClass
    implements Insertable<ListeningExerciseRow> {
  final String id;
  final String transcript;
  final String russianTranslation;
  final String? audioUrl;
  final String difficulty;
  final String focusWordsJson;
  final String dialect;
  const ListeningExerciseRow(
      {required this.id,
      required this.transcript,
      required this.russianTranslation,
      this.audioUrl,
      required this.difficulty,
      required this.focusWordsJson,
      required this.dialect});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transcript'] = Variable<String>(transcript);
    map['russian_translation'] = Variable<String>(russianTranslation);
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    map['difficulty'] = Variable<String>(difficulty);
    map['focus_words_json'] = Variable<String>(focusWordsJson);
    map['dialect'] = Variable<String>(dialect);
    return map;
  }

  ListeningExercisesCompanion toCompanion(bool nullToAbsent) {
    return ListeningExercisesCompanion(
      id: Value(id),
      transcript: Value(transcript),
      russianTranslation: Value(russianTranslation),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      difficulty: Value(difficulty),
      focusWordsJson: Value(focusWordsJson),
      dialect: Value(dialect),
    );
  }

  factory ListeningExerciseRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListeningExerciseRow(
      id: serializer.fromJson<String>(json['id']),
      transcript: serializer.fromJson<String>(json['transcript']),
      russianTranslation:
          serializer.fromJson<String>(json['russianTranslation']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      focusWordsJson: serializer.fromJson<String>(json['focusWordsJson']),
      dialect: serializer.fromJson<String>(json['dialect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transcript': serializer.toJson<String>(transcript),
      'russianTranslation': serializer.toJson<String>(russianTranslation),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'difficulty': serializer.toJson<String>(difficulty),
      'focusWordsJson': serializer.toJson<String>(focusWordsJson),
      'dialect': serializer.toJson<String>(dialect),
    };
  }

  ListeningExerciseRow copyWith(
          {String? id,
          String? transcript,
          String? russianTranslation,
          Value<String?> audioUrl = const Value.absent(),
          String? difficulty,
          String? focusWordsJson,
          String? dialect}) =>
      ListeningExerciseRow(
        id: id ?? this.id,
        transcript: transcript ?? this.transcript,
        russianTranslation: russianTranslation ?? this.russianTranslation,
        audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
        difficulty: difficulty ?? this.difficulty,
        focusWordsJson: focusWordsJson ?? this.focusWordsJson,
        dialect: dialect ?? this.dialect,
      );
  ListeningExerciseRow copyWithCompanion(ListeningExercisesCompanion data) {
    return ListeningExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      transcript:
          data.transcript.present ? data.transcript.value : this.transcript,
      russianTranslation: data.russianTranslation.present
          ? data.russianTranslation.value
          : this.russianTranslation,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      focusWordsJson: data.focusWordsJson.present
          ? data.focusWordsJson.value
          : this.focusWordsJson,
      dialect: data.dialect.present ? data.dialect.value : this.dialect,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListeningExerciseRow(')
          ..write('id: $id, ')
          ..write('transcript: $transcript, ')
          ..write('russianTranslation: $russianTranslation, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('difficulty: $difficulty, ')
          ..write('focusWordsJson: $focusWordsJson, ')
          ..write('dialect: $dialect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, transcript, russianTranslation, audioUrl,
      difficulty, focusWordsJson, dialect);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListeningExerciseRow &&
          other.id == this.id &&
          other.transcript == this.transcript &&
          other.russianTranslation == this.russianTranslation &&
          other.audioUrl == this.audioUrl &&
          other.difficulty == this.difficulty &&
          other.focusWordsJson == this.focusWordsJson &&
          other.dialect == this.dialect);
}

class ListeningExercisesCompanion
    extends UpdateCompanion<ListeningExerciseRow> {
  final Value<String> id;
  final Value<String> transcript;
  final Value<String> russianTranslation;
  final Value<String?> audioUrl;
  final Value<String> difficulty;
  final Value<String> focusWordsJson;
  final Value<String> dialect;
  final Value<int> rowid;
  const ListeningExercisesCompanion({
    this.id = const Value.absent(),
    this.transcript = const Value.absent(),
    this.russianTranslation = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.focusWordsJson = const Value.absent(),
    this.dialect = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ListeningExercisesCompanion.insert({
    required String id,
    required String transcript,
    required String russianTranslation,
    this.audioUrl = const Value.absent(),
    this.difficulty = const Value.absent(),
    required String focusWordsJson,
    this.dialect = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        transcript = Value(transcript),
        russianTranslation = Value(russianTranslation),
        focusWordsJson = Value(focusWordsJson);
  static Insertable<ListeningExerciseRow> custom({
    Expression<String>? id,
    Expression<String>? transcript,
    Expression<String>? russianTranslation,
    Expression<String>? audioUrl,
    Expression<String>? difficulty,
    Expression<String>? focusWordsJson,
    Expression<String>? dialect,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transcript != null) 'transcript': transcript,
      if (russianTranslation != null) 'russian_translation': russianTranslation,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (difficulty != null) 'difficulty': difficulty,
      if (focusWordsJson != null) 'focus_words_json': focusWordsJson,
      if (dialect != null) 'dialect': dialect,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ListeningExercisesCompanion copyWith(
      {Value<String>? id,
      Value<String>? transcript,
      Value<String>? russianTranslation,
      Value<String?>? audioUrl,
      Value<String>? difficulty,
      Value<String>? focusWordsJson,
      Value<String>? dialect,
      Value<int>? rowid}) {
    return ListeningExercisesCompanion(
      id: id ?? this.id,
      transcript: transcript ?? this.transcript,
      russianTranslation: russianTranslation ?? this.russianTranslation,
      audioUrl: audioUrl ?? this.audioUrl,
      difficulty: difficulty ?? this.difficulty,
      focusWordsJson: focusWordsJson ?? this.focusWordsJson,
      dialect: dialect ?? this.dialect,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transcript.present) {
      map['transcript'] = Variable<String>(transcript.value);
    }
    if (russianTranslation.present) {
      map['russian_translation'] = Variable<String>(russianTranslation.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (focusWordsJson.present) {
      map['focus_words_json'] = Variable<String>(focusWordsJson.value);
    }
    if (dialect.present) {
      map['dialect'] = Variable<String>(dialect.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListeningExercisesCompanion(')
          ..write('id: $id, ')
          ..write('transcript: $transcript, ')
          ..write('russianTranslation: $russianTranslation, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('difficulty: $difficulty, ')
          ..write('focusWordsJson: $focusWordsJson, ')
          ..write('dialect: $dialect, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ListeningAttemptLogsTable extends ListeningAttemptLogs
    with TableInfo<$ListeningAttemptLogsTable, ListeningAttemptLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListeningAttemptLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _wordAccuracyMeta =
      const VerificationMeta('wordAccuracy');
  @override
  late final GeneratedColumn<double> wordAccuracy = GeneratedColumn<double>(
      'word_accuracy', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isExactMatchMeta =
      const VerificationMeta('isExactMatch');
  @override
  late final GeneratedColumn<bool> isExactMatch = GeneratedColumn<bool>(
      'is_exact_match', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_exact_match" IN (0, 1))'));
  static const VerificationMeta _attemptedAtMeta =
      const VerificationMeta('attemptedAt');
  @override
  late final GeneratedColumn<DateTime> attemptedAt = GeneratedColumn<DateTime>(
      'attempted_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, exerciseId, wordAccuracy, isExactMatch, attemptedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'listening_attempt_logs';
  @override
  VerificationContext validateIntegrity(
      Insertable<ListeningAttemptLogRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('word_accuracy')) {
      context.handle(
          _wordAccuracyMeta,
          wordAccuracy.isAcceptableOrUnknown(
              data['word_accuracy']!, _wordAccuracyMeta));
    } else if (isInserting) {
      context.missing(_wordAccuracyMeta);
    }
    if (data.containsKey('is_exact_match')) {
      context.handle(
          _isExactMatchMeta,
          isExactMatch.isAcceptableOrUnknown(
              data['is_exact_match']!, _isExactMatchMeta));
    } else if (isInserting) {
      context.missing(_isExactMatchMeta);
    }
    if (data.containsKey('attempted_at')) {
      context.handle(
          _attemptedAtMeta,
          attemptedAt.isAcceptableOrUnknown(
              data['attempted_at']!, _attemptedAtMeta));
    } else if (isInserting) {
      context.missing(_attemptedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListeningAttemptLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListeningAttemptLogRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id'])!,
      wordAccuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}word_accuracy'])!,
      isExactMatch: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_exact_match'])!,
      attemptedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}attempted_at'])!,
    );
  }

  @override
  $ListeningAttemptLogsTable createAlias(String alias) {
    return $ListeningAttemptLogsTable(attachedDatabase, alias);
  }
}

class ListeningAttemptLogRow extends DataClass
    implements Insertable<ListeningAttemptLogRow> {
  final int id;
  final String exerciseId;
  final double wordAccuracy;
  final bool isExactMatch;
  final DateTime attemptedAt;
  const ListeningAttemptLogRow(
      {required this.id,
      required this.exerciseId,
      required this.wordAccuracy,
      required this.isExactMatch,
      required this.attemptedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['word_accuracy'] = Variable<double>(wordAccuracy);
    map['is_exact_match'] = Variable<bool>(isExactMatch);
    map['attempted_at'] = Variable<DateTime>(attemptedAt);
    return map;
  }

  ListeningAttemptLogsCompanion toCompanion(bool nullToAbsent) {
    return ListeningAttemptLogsCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      wordAccuracy: Value(wordAccuracy),
      isExactMatch: Value(isExactMatch),
      attemptedAt: Value(attemptedAt),
    );
  }

  factory ListeningAttemptLogRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListeningAttemptLogRow(
      id: serializer.fromJson<int>(json['id']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      wordAccuracy: serializer.fromJson<double>(json['wordAccuracy']),
      isExactMatch: serializer.fromJson<bool>(json['isExactMatch']),
      attemptedAt: serializer.fromJson<DateTime>(json['attemptedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'wordAccuracy': serializer.toJson<double>(wordAccuracy),
      'isExactMatch': serializer.toJson<bool>(isExactMatch),
      'attemptedAt': serializer.toJson<DateTime>(attemptedAt),
    };
  }

  ListeningAttemptLogRow copyWith(
          {int? id,
          String? exerciseId,
          double? wordAccuracy,
          bool? isExactMatch,
          DateTime? attemptedAt}) =>
      ListeningAttemptLogRow(
        id: id ?? this.id,
        exerciseId: exerciseId ?? this.exerciseId,
        wordAccuracy: wordAccuracy ?? this.wordAccuracy,
        isExactMatch: isExactMatch ?? this.isExactMatch,
        attemptedAt: attemptedAt ?? this.attemptedAt,
      );
  ListeningAttemptLogRow copyWithCompanion(ListeningAttemptLogsCompanion data) {
    return ListeningAttemptLogRow(
      id: data.id.present ? data.id.value : this.id,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      wordAccuracy: data.wordAccuracy.present
          ? data.wordAccuracy.value
          : this.wordAccuracy,
      isExactMatch: data.isExactMatch.present
          ? data.isExactMatch.value
          : this.isExactMatch,
      attemptedAt:
          data.attemptedAt.present ? data.attemptedAt.value : this.attemptedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListeningAttemptLogRow(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('wordAccuracy: $wordAccuracy, ')
          ..write('isExactMatch: $isExactMatch, ')
          ..write('attemptedAt: $attemptedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, exerciseId, wordAccuracy, isExactMatch, attemptedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListeningAttemptLogRow &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.wordAccuracy == this.wordAccuracy &&
          other.isExactMatch == this.isExactMatch &&
          other.attemptedAt == this.attemptedAt);
}

class ListeningAttemptLogsCompanion
    extends UpdateCompanion<ListeningAttemptLogRow> {
  final Value<int> id;
  final Value<String> exerciseId;
  final Value<double> wordAccuracy;
  final Value<bool> isExactMatch;
  final Value<DateTime> attemptedAt;
  const ListeningAttemptLogsCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.wordAccuracy = const Value.absent(),
    this.isExactMatch = const Value.absent(),
    this.attemptedAt = const Value.absent(),
  });
  ListeningAttemptLogsCompanion.insert({
    this.id = const Value.absent(),
    required String exerciseId,
    required double wordAccuracy,
    required bool isExactMatch,
    required DateTime attemptedAt,
  })  : exerciseId = Value(exerciseId),
        wordAccuracy = Value(wordAccuracy),
        isExactMatch = Value(isExactMatch),
        attemptedAt = Value(attemptedAt);
  static Insertable<ListeningAttemptLogRow> custom({
    Expression<int>? id,
    Expression<String>? exerciseId,
    Expression<double>? wordAccuracy,
    Expression<bool>? isExactMatch,
    Expression<DateTime>? attemptedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (wordAccuracy != null) 'word_accuracy': wordAccuracy,
      if (isExactMatch != null) 'is_exact_match': isExactMatch,
      if (attemptedAt != null) 'attempted_at': attemptedAt,
    });
  }

  ListeningAttemptLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? exerciseId,
      Value<double>? wordAccuracy,
      Value<bool>? isExactMatch,
      Value<DateTime>? attemptedAt}) {
    return ListeningAttemptLogsCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      wordAccuracy: wordAccuracy ?? this.wordAccuracy,
      isExactMatch: isExactMatch ?? this.isExactMatch,
      attemptedAt: attemptedAt ?? this.attemptedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (wordAccuracy.present) {
      map['word_accuracy'] = Variable<double>(wordAccuracy.value);
    }
    if (isExactMatch.present) {
      map['is_exact_match'] = Variable<bool>(isExactMatch.value);
    }
    if (attemptedAt.present) {
      map['attempted_at'] = Variable<DateTime>(attemptedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListeningAttemptLogsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('wordAccuracy: $wordAccuracy, ')
          ..write('isExactMatch: $isExactMatch, ')
          ..write('attemptedAt: $attemptedAt')
          ..write(')'))
        .toString();
  }
}

class $DictionaryEntriesTable extends DictionaryEntries
    with TableInfo<$DictionaryEntriesTable, DictionaryEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DictionaryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
      'word', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _partOfSpeechMeta =
      const VerificationMeta('partOfSpeech');
  @override
  late final GeneratedColumn<String> partOfSpeech = GeneratedColumn<String>(
      'part_of_speech', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _translationRuMeta =
      const VerificationMeta('translationRu');
  @override
  late final GeneratedColumn<String> translationRu = GeneratedColumn<String>(
      'translation_ru', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _frequencyRankMeta =
      const VerificationMeta('frequencyRank');
  @override
  late final GeneratedColumn<int> frequencyRank = GeneratedColumn<int>(
      'frequency_rank', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9999));
  static const VerificationMeta _dialectMeta =
      const VerificationMeta('dialect');
  @override
  late final GeneratedColumn<String> dialect = GeneratedColumn<String>(
      'dialect', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('all'));
  static const VerificationMeta _examplePtMeta =
      const VerificationMeta('examplePt');
  @override
  late final GeneratedColumn<String> examplePt = GeneratedColumn<String>(
      'example_pt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exampleRuMeta =
      const VerificationMeta('exampleRu');
  @override
  late final GeneratedColumn<String> exampleRu = GeneratedColumn<String>(
      'example_ru', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        word,
        partOfSpeech,
        translationRu,
        frequencyRank,
        dialect,
        examplePt,
        exampleRu,
        notes,
        isCustom
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dictionary_entries';
  @override
  VerificationContext validateIntegrity(Insertable<DictionaryEntryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
          _wordMeta, word.isAcceptableOrUnknown(data['word']!, _wordMeta));
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('part_of_speech')) {
      context.handle(
          _partOfSpeechMeta,
          partOfSpeech.isAcceptableOrUnknown(
              data['part_of_speech']!, _partOfSpeechMeta));
    } else if (isInserting) {
      context.missing(_partOfSpeechMeta);
    }
    if (data.containsKey('translation_ru')) {
      context.handle(
          _translationRuMeta,
          translationRu.isAcceptableOrUnknown(
              data['translation_ru']!, _translationRuMeta));
    } else if (isInserting) {
      context.missing(_translationRuMeta);
    }
    if (data.containsKey('frequency_rank')) {
      context.handle(
          _frequencyRankMeta,
          frequencyRank.isAcceptableOrUnknown(
              data['frequency_rank']!, _frequencyRankMeta));
    }
    if (data.containsKey('dialect')) {
      context.handle(_dialectMeta,
          dialect.isAcceptableOrUnknown(data['dialect']!, _dialectMeta));
    }
    if (data.containsKey('example_pt')) {
      context.handle(_examplePtMeta,
          examplePt.isAcceptableOrUnknown(data['example_pt']!, _examplePtMeta));
    }
    if (data.containsKey('example_ru')) {
      context.handle(_exampleRuMeta,
          exampleRu.isAcceptableOrUnknown(data['example_ru']!, _exampleRuMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DictionaryEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DictionaryEntryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      word: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word'])!,
      partOfSpeech: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}part_of_speech'])!,
      translationRu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}translation_ru'])!,
      frequencyRank: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}frequency_rank'])!,
      dialect: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dialect'])!,
      examplePt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_pt']),
      exampleRu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_ru']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
    );
  }

  @override
  $DictionaryEntriesTable createAlias(String alias) {
    return $DictionaryEntriesTable(attachedDatabase, alias);
  }
}

class DictionaryEntryRow extends DataClass
    implements Insertable<DictionaryEntryRow> {
  final String id;
  final String word;
  final String partOfSpeech;
  final String translationRu;
  final int frequencyRank;
  final String dialect;
  final String? examplePt;
  final String? exampleRu;
  final String? notes;
  final bool isCustom;
  const DictionaryEntryRow(
      {required this.id,
      required this.word,
      required this.partOfSpeech,
      required this.translationRu,
      required this.frequencyRank,
      required this.dialect,
      this.examplePt,
      this.exampleRu,
      this.notes,
      required this.isCustom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['word'] = Variable<String>(word);
    map['part_of_speech'] = Variable<String>(partOfSpeech);
    map['translation_ru'] = Variable<String>(translationRu);
    map['frequency_rank'] = Variable<int>(frequencyRank);
    map['dialect'] = Variable<String>(dialect);
    if (!nullToAbsent || examplePt != null) {
      map['example_pt'] = Variable<String>(examplePt);
    }
    if (!nullToAbsent || exampleRu != null) {
      map['example_ru'] = Variable<String>(exampleRu);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  DictionaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DictionaryEntriesCompanion(
      id: Value(id),
      word: Value(word),
      partOfSpeech: Value(partOfSpeech),
      translationRu: Value(translationRu),
      frequencyRank: Value(frequencyRank),
      dialect: Value(dialect),
      examplePt: examplePt == null && nullToAbsent
          ? const Value.absent()
          : Value(examplePt),
      exampleRu: exampleRu == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleRu),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isCustom: Value(isCustom),
    );
  }

  factory DictionaryEntryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DictionaryEntryRow(
      id: serializer.fromJson<String>(json['id']),
      word: serializer.fromJson<String>(json['word']),
      partOfSpeech: serializer.fromJson<String>(json['partOfSpeech']),
      translationRu: serializer.fromJson<String>(json['translationRu']),
      frequencyRank: serializer.fromJson<int>(json['frequencyRank']),
      dialect: serializer.fromJson<String>(json['dialect']),
      examplePt: serializer.fromJson<String?>(json['examplePt']),
      exampleRu: serializer.fromJson<String?>(json['exampleRu']),
      notes: serializer.fromJson<String?>(json['notes']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'word': serializer.toJson<String>(word),
      'partOfSpeech': serializer.toJson<String>(partOfSpeech),
      'translationRu': serializer.toJson<String>(translationRu),
      'frequencyRank': serializer.toJson<int>(frequencyRank),
      'dialect': serializer.toJson<String>(dialect),
      'examplePt': serializer.toJson<String?>(examplePt),
      'exampleRu': serializer.toJson<String?>(exampleRu),
      'notes': serializer.toJson<String?>(notes),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  DictionaryEntryRow copyWith(
          {String? id,
          String? word,
          String? partOfSpeech,
          String? translationRu,
          int? frequencyRank,
          String? dialect,
          Value<String?> examplePt = const Value.absent(),
          Value<String?> exampleRu = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isCustom}) =>
      DictionaryEntryRow(
        id: id ?? this.id,
        word: word ?? this.word,
        partOfSpeech: partOfSpeech ?? this.partOfSpeech,
        translationRu: translationRu ?? this.translationRu,
        frequencyRank: frequencyRank ?? this.frequencyRank,
        dialect: dialect ?? this.dialect,
        examplePt: examplePt.present ? examplePt.value : this.examplePt,
        exampleRu: exampleRu.present ? exampleRu.value : this.exampleRu,
        notes: notes.present ? notes.value : this.notes,
        isCustom: isCustom ?? this.isCustom,
      );
  DictionaryEntryRow copyWithCompanion(DictionaryEntriesCompanion data) {
    return DictionaryEntryRow(
      id: data.id.present ? data.id.value : this.id,
      word: data.word.present ? data.word.value : this.word,
      partOfSpeech: data.partOfSpeech.present
          ? data.partOfSpeech.value
          : this.partOfSpeech,
      translationRu: data.translationRu.present
          ? data.translationRu.value
          : this.translationRu,
      frequencyRank: data.frequencyRank.present
          ? data.frequencyRank.value
          : this.frequencyRank,
      dialect: data.dialect.present ? data.dialect.value : this.dialect,
      examplePt: data.examplePt.present ? data.examplePt.value : this.examplePt,
      exampleRu: data.exampleRu.present ? data.exampleRu.value : this.exampleRu,
      notes: data.notes.present ? data.notes.value : this.notes,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DictionaryEntryRow(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('translationRu: $translationRu, ')
          ..write('frequencyRank: $frequencyRank, ')
          ..write('dialect: $dialect, ')
          ..write('examplePt: $examplePt, ')
          ..write('exampleRu: $exampleRu, ')
          ..write('notes: $notes, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, word, partOfSpeech, translationRu,
      frequencyRank, dialect, examplePt, exampleRu, notes, isCustom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DictionaryEntryRow &&
          other.id == this.id &&
          other.word == this.word &&
          other.partOfSpeech == this.partOfSpeech &&
          other.translationRu == this.translationRu &&
          other.frequencyRank == this.frequencyRank &&
          other.dialect == this.dialect &&
          other.examplePt == this.examplePt &&
          other.exampleRu == this.exampleRu &&
          other.notes == this.notes &&
          other.isCustom == this.isCustom);
}

class DictionaryEntriesCompanion extends UpdateCompanion<DictionaryEntryRow> {
  final Value<String> id;
  final Value<String> word;
  final Value<String> partOfSpeech;
  final Value<String> translationRu;
  final Value<int> frequencyRank;
  final Value<String> dialect;
  final Value<String?> examplePt;
  final Value<String?> exampleRu;
  final Value<String?> notes;
  final Value<bool> isCustom;
  final Value<int> rowid;
  const DictionaryEntriesCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.translationRu = const Value.absent(),
    this.frequencyRank = const Value.absent(),
    this.dialect = const Value.absent(),
    this.examplePt = const Value.absent(),
    this.exampleRu = const Value.absent(),
    this.notes = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DictionaryEntriesCompanion.insert({
    required String id,
    required String word,
    required String partOfSpeech,
    required String translationRu,
    this.frequencyRank = const Value.absent(),
    this.dialect = const Value.absent(),
    this.examplePt = const Value.absent(),
    this.exampleRu = const Value.absent(),
    this.notes = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        word = Value(word),
        partOfSpeech = Value(partOfSpeech),
        translationRu = Value(translationRu);
  static Insertable<DictionaryEntryRow> custom({
    Expression<String>? id,
    Expression<String>? word,
    Expression<String>? partOfSpeech,
    Expression<String>? translationRu,
    Expression<int>? frequencyRank,
    Expression<String>? dialect,
    Expression<String>? examplePt,
    Expression<String>? exampleRu,
    Expression<String>? notes,
    Expression<bool>? isCustom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (partOfSpeech != null) 'part_of_speech': partOfSpeech,
      if (translationRu != null) 'translation_ru': translationRu,
      if (frequencyRank != null) 'frequency_rank': frequencyRank,
      if (dialect != null) 'dialect': dialect,
      if (examplePt != null) 'example_pt': examplePt,
      if (exampleRu != null) 'example_ru': exampleRu,
      if (notes != null) 'notes': notes,
      if (isCustom != null) 'is_custom': isCustom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DictionaryEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? word,
      Value<String>? partOfSpeech,
      Value<String>? translationRu,
      Value<int>? frequencyRank,
      Value<String>? dialect,
      Value<String?>? examplePt,
      Value<String?>? exampleRu,
      Value<String?>? notes,
      Value<bool>? isCustom,
      Value<int>? rowid}) {
    return DictionaryEntriesCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      translationRu: translationRu ?? this.translationRu,
      frequencyRank: frequencyRank ?? this.frequencyRank,
      dialect: dialect ?? this.dialect,
      examplePt: examplePt ?? this.examplePt,
      exampleRu: exampleRu ?? this.exampleRu,
      notes: notes ?? this.notes,
      isCustom: isCustom ?? this.isCustom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (partOfSpeech.present) {
      map['part_of_speech'] = Variable<String>(partOfSpeech.value);
    }
    if (translationRu.present) {
      map['translation_ru'] = Variable<String>(translationRu.value);
    }
    if (frequencyRank.present) {
      map['frequency_rank'] = Variable<int>(frequencyRank.value);
    }
    if (dialect.present) {
      map['dialect'] = Variable<String>(dialect.value);
    }
    if (examplePt.present) {
      map['example_pt'] = Variable<String>(examplePt.value);
    }
    if (exampleRu.present) {
      map['example_ru'] = Variable<String>(exampleRu.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DictionaryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('translationRu: $translationRu, ')
          ..write('frequencyRank: $frequencyRank, ')
          ..write('dialect: $dialect, ')
          ..write('examplePt: $examplePt, ')
          ..write('exampleRu: $exampleRu, ')
          ..write('notes: $notes, ')
          ..write('isCustom: $isCustom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoriesTable extends Stories with TableInfo<$StoriesTable, StoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titlePortugueseMeta =
      const VerificationMeta('titlePortuguese');
  @override
  late final GeneratedColumn<String> titlePortuguese = GeneratedColumn<String>(
      'title_portuguese', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleRussianMeta =
      const VerificationMeta('titleRussian');
  @override
  late final GeneratedColumn<String> titleRussian = GeneratedColumn<String>(
      'title_russian', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dialectMeta =
      const VerificationMeta('dialect');
  @override
  late final GeneratedColumn<String> dialect = GeneratedColumn<String>(
      'dialect', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _coverIconMeta =
      const VerificationMeta('coverIcon');
  @override
  late final GeneratedColumn<String> coverIcon = GeneratedColumn<String>(
      'cover_icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentJsonMeta =
      const VerificationMeta('contentJson');
  @override
  late final GeneratedColumn<String> contentJson = GeneratedColumn<String>(
      'content_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        titlePortuguese,
        titleRussian,
        dialect,
        level,
        coverIcon,
        description,
        contentJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stories';
  @override
  VerificationContext validateIntegrity(Insertable<StoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title_portuguese')) {
      context.handle(
          _titlePortugueseMeta,
          titlePortuguese.isAcceptableOrUnknown(
              data['title_portuguese']!, _titlePortugueseMeta));
    } else if (isInserting) {
      context.missing(_titlePortugueseMeta);
    }
    if (data.containsKey('title_russian')) {
      context.handle(
          _titleRussianMeta,
          titleRussian.isAcceptableOrUnknown(
              data['title_russian']!, _titleRussianMeta));
    } else if (isInserting) {
      context.missing(_titleRussianMeta);
    }
    if (data.containsKey('dialect')) {
      context.handle(_dialectMeta,
          dialect.isAcceptableOrUnknown(data['dialect']!, _dialectMeta));
    } else if (isInserting) {
      context.missing(_dialectMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('cover_icon')) {
      context.handle(_coverIconMeta,
          coverIcon.isAcceptableOrUnknown(data['cover_icon']!, _coverIconMeta));
    } else if (isInserting) {
      context.missing(_coverIconMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('content_json')) {
      context.handle(
          _contentJsonMeta,
          contentJson.isAcceptableOrUnknown(
              data['content_json']!, _contentJsonMeta));
    } else if (isInserting) {
      context.missing(_contentJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      titlePortuguese: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}title_portuguese'])!,
      titleRussian: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_russian'])!,
      dialect: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dialect'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      coverIcon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_icon'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      contentJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_json'])!,
    );
  }

  @override
  $StoriesTable createAlias(String alias) {
    return $StoriesTable(attachedDatabase, alias);
  }
}

class StoryRow extends DataClass implements Insertable<StoryRow> {
  final String id;
  final String titlePortuguese;
  final String titleRussian;
  final String dialect;
  final String level;
  final String coverIcon;
  final String description;
  final String contentJson;
  const StoryRow(
      {required this.id,
      required this.titlePortuguese,
      required this.titleRussian,
      required this.dialect,
      required this.level,
      required this.coverIcon,
      required this.description,
      required this.contentJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title_portuguese'] = Variable<String>(titlePortuguese);
    map['title_russian'] = Variable<String>(titleRussian);
    map['dialect'] = Variable<String>(dialect);
    map['level'] = Variable<String>(level);
    map['cover_icon'] = Variable<String>(coverIcon);
    map['description'] = Variable<String>(description);
    map['content_json'] = Variable<String>(contentJson);
    return map;
  }

  StoriesCompanion toCompanion(bool nullToAbsent) {
    return StoriesCompanion(
      id: Value(id),
      titlePortuguese: Value(titlePortuguese),
      titleRussian: Value(titleRussian),
      dialect: Value(dialect),
      level: Value(level),
      coverIcon: Value(coverIcon),
      description: Value(description),
      contentJson: Value(contentJson),
    );
  }

  factory StoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoryRow(
      id: serializer.fromJson<String>(json['id']),
      titlePortuguese: serializer.fromJson<String>(json['titlePortuguese']),
      titleRussian: serializer.fromJson<String>(json['titleRussian']),
      dialect: serializer.fromJson<String>(json['dialect']),
      level: serializer.fromJson<String>(json['level']),
      coverIcon: serializer.fromJson<String>(json['coverIcon']),
      description: serializer.fromJson<String>(json['description']),
      contentJson: serializer.fromJson<String>(json['contentJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'titlePortuguese': serializer.toJson<String>(titlePortuguese),
      'titleRussian': serializer.toJson<String>(titleRussian),
      'dialect': serializer.toJson<String>(dialect),
      'level': serializer.toJson<String>(level),
      'coverIcon': serializer.toJson<String>(coverIcon),
      'description': serializer.toJson<String>(description),
      'contentJson': serializer.toJson<String>(contentJson),
    };
  }

  StoryRow copyWith(
          {String? id,
          String? titlePortuguese,
          String? titleRussian,
          String? dialect,
          String? level,
          String? coverIcon,
          String? description,
          String? contentJson}) =>
      StoryRow(
        id: id ?? this.id,
        titlePortuguese: titlePortuguese ?? this.titlePortuguese,
        titleRussian: titleRussian ?? this.titleRussian,
        dialect: dialect ?? this.dialect,
        level: level ?? this.level,
        coverIcon: coverIcon ?? this.coverIcon,
        description: description ?? this.description,
        contentJson: contentJson ?? this.contentJson,
      );
  StoryRow copyWithCompanion(StoriesCompanion data) {
    return StoryRow(
      id: data.id.present ? data.id.value : this.id,
      titlePortuguese: data.titlePortuguese.present
          ? data.titlePortuguese.value
          : this.titlePortuguese,
      titleRussian: data.titleRussian.present
          ? data.titleRussian.value
          : this.titleRussian,
      dialect: data.dialect.present ? data.dialect.value : this.dialect,
      level: data.level.present ? data.level.value : this.level,
      coverIcon: data.coverIcon.present ? data.coverIcon.value : this.coverIcon,
      description:
          data.description.present ? data.description.value : this.description,
      contentJson:
          data.contentJson.present ? data.contentJson.value : this.contentJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoryRow(')
          ..write('id: $id, ')
          ..write('titlePortuguese: $titlePortuguese, ')
          ..write('titleRussian: $titleRussian, ')
          ..write('dialect: $dialect, ')
          ..write('level: $level, ')
          ..write('coverIcon: $coverIcon, ')
          ..write('description: $description, ')
          ..write('contentJson: $contentJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, titlePortuguese, titleRussian, dialect,
      level, coverIcon, description, contentJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoryRow &&
          other.id == this.id &&
          other.titlePortuguese == this.titlePortuguese &&
          other.titleRussian == this.titleRussian &&
          other.dialect == this.dialect &&
          other.level == this.level &&
          other.coverIcon == this.coverIcon &&
          other.description == this.description &&
          other.contentJson == this.contentJson);
}

class StoriesCompanion extends UpdateCompanion<StoryRow> {
  final Value<String> id;
  final Value<String> titlePortuguese;
  final Value<String> titleRussian;
  final Value<String> dialect;
  final Value<String> level;
  final Value<String> coverIcon;
  final Value<String> description;
  final Value<String> contentJson;
  final Value<int> rowid;
  const StoriesCompanion({
    this.id = const Value.absent(),
    this.titlePortuguese = const Value.absent(),
    this.titleRussian = const Value.absent(),
    this.dialect = const Value.absent(),
    this.level = const Value.absent(),
    this.coverIcon = const Value.absent(),
    this.description = const Value.absent(),
    this.contentJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoriesCompanion.insert({
    required String id,
    required String titlePortuguese,
    required String titleRussian,
    required String dialect,
    required String level,
    required String coverIcon,
    required String description,
    required String contentJson,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        titlePortuguese = Value(titlePortuguese),
        titleRussian = Value(titleRussian),
        dialect = Value(dialect),
        level = Value(level),
        coverIcon = Value(coverIcon),
        description = Value(description),
        contentJson = Value(contentJson);
  static Insertable<StoryRow> custom({
    Expression<String>? id,
    Expression<String>? titlePortuguese,
    Expression<String>? titleRussian,
    Expression<String>? dialect,
    Expression<String>? level,
    Expression<String>? coverIcon,
    Expression<String>? description,
    Expression<String>? contentJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titlePortuguese != null) 'title_portuguese': titlePortuguese,
      if (titleRussian != null) 'title_russian': titleRussian,
      if (dialect != null) 'dialect': dialect,
      if (level != null) 'level': level,
      if (coverIcon != null) 'cover_icon': coverIcon,
      if (description != null) 'description': description,
      if (contentJson != null) 'content_json': contentJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? titlePortuguese,
      Value<String>? titleRussian,
      Value<String>? dialect,
      Value<String>? level,
      Value<String>? coverIcon,
      Value<String>? description,
      Value<String>? contentJson,
      Value<int>? rowid}) {
    return StoriesCompanion(
      id: id ?? this.id,
      titlePortuguese: titlePortuguese ?? this.titlePortuguese,
      titleRussian: titleRussian ?? this.titleRussian,
      dialect: dialect ?? this.dialect,
      level: level ?? this.level,
      coverIcon: coverIcon ?? this.coverIcon,
      description: description ?? this.description,
      contentJson: contentJson ?? this.contentJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (titlePortuguese.present) {
      map['title_portuguese'] = Variable<String>(titlePortuguese.value);
    }
    if (titleRussian.present) {
      map['title_russian'] = Variable<String>(titleRussian.value);
    }
    if (dialect.present) {
      map['dialect'] = Variable<String>(dialect.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (coverIcon.present) {
      map['cover_icon'] = Variable<String>(coverIcon.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (contentJson.present) {
      map['content_json'] = Variable<String>(contentJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoriesCompanion(')
          ..write('id: $id, ')
          ..write('titlePortuguese: $titlePortuguese, ')
          ..write('titleRussian: $titleRussian, ')
          ..write('dialect: $dialect, ')
          ..write('level: $level, ')
          ..write('coverIcon: $coverIcon, ')
          ..write('description: $description, ')
          ..write('contentJson: $contentJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SlangEntriesTable extends SlangEntries
    with TableInfo<$SlangEntriesTable, SlangRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SlangEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expressionMeta =
      const VerificationMeta('expression');
  @override
  late final GeneratedColumn<String> expression = GeneratedColumn<String>(
      'expression', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _literalTranslationMeta =
      const VerificationMeta('literalTranslation');
  @override
  late final GeneratedColumn<String> literalTranslation =
      GeneratedColumn<String>('literal_translation', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actualMeaningMeta =
      const VerificationMeta('actualMeaning');
  @override
  late final GeneratedColumn<String> actualMeaning = GeneratedColumn<String>(
      'actual_meaning', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dialectMeta =
      const VerificationMeta('dialect');
  @override
  late final GeneratedColumn<String> dialect = GeneratedColumn<String>(
      'dialect', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originNotesMeta =
      const VerificationMeta('originNotes');
  @override
  late final GeneratedColumn<String> originNotes = GeneratedColumn<String>(
      'origin_notes', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exampleSentenceMeta =
      const VerificationMeta('exampleSentence');
  @override
  late final GeneratedColumn<String> exampleSentence = GeneratedColumn<String>(
      'example_sentence', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exampleTranslationMeta =
      const VerificationMeta('exampleTranslation');
  @override
  late final GeneratedColumn<String> exampleTranslation =
      GeneratedColumn<String>('example_translation', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        expression,
        literalTranslation,
        actualMeaning,
        dialect,
        originNotes,
        exampleSentence,
        exampleTranslation
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'slang_entries';
  @override
  VerificationContext validateIntegrity(Insertable<SlangRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('expression')) {
      context.handle(
          _expressionMeta,
          expression.isAcceptableOrUnknown(
              data['expression']!, _expressionMeta));
    } else if (isInserting) {
      context.missing(_expressionMeta);
    }
    if (data.containsKey('literal_translation')) {
      context.handle(
          _literalTranslationMeta,
          literalTranslation.isAcceptableOrUnknown(
              data['literal_translation']!, _literalTranslationMeta));
    } else if (isInserting) {
      context.missing(_literalTranslationMeta);
    }
    if (data.containsKey('actual_meaning')) {
      context.handle(
          _actualMeaningMeta,
          actualMeaning.isAcceptableOrUnknown(
              data['actual_meaning']!, _actualMeaningMeta));
    } else if (isInserting) {
      context.missing(_actualMeaningMeta);
    }
    if (data.containsKey('dialect')) {
      context.handle(_dialectMeta,
          dialect.isAcceptableOrUnknown(data['dialect']!, _dialectMeta));
    } else if (isInserting) {
      context.missing(_dialectMeta);
    }
    if (data.containsKey('origin_notes')) {
      context.handle(
          _originNotesMeta,
          originNotes.isAcceptableOrUnknown(
              data['origin_notes']!, _originNotesMeta));
    } else if (isInserting) {
      context.missing(_originNotesMeta);
    }
    if (data.containsKey('example_sentence')) {
      context.handle(
          _exampleSentenceMeta,
          exampleSentence.isAcceptableOrUnknown(
              data['example_sentence']!, _exampleSentenceMeta));
    } else if (isInserting) {
      context.missing(_exampleSentenceMeta);
    }
    if (data.containsKey('example_translation')) {
      context.handle(
          _exampleTranslationMeta,
          exampleTranslation.isAcceptableOrUnknown(
              data['example_translation']!, _exampleTranslationMeta));
    } else if (isInserting) {
      context.missing(_exampleTranslationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SlangRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SlangRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      expression: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}expression'])!,
      literalTranslation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}literal_translation'])!,
      actualMeaning: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actual_meaning'])!,
      dialect: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dialect'])!,
      originNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}origin_notes'])!,
      exampleSentence: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}example_sentence'])!,
      exampleTranslation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}example_translation'])!,
    );
  }

  @override
  $SlangEntriesTable createAlias(String alias) {
    return $SlangEntriesTable(attachedDatabase, alias);
  }
}

class SlangRow extends DataClass implements Insertable<SlangRow> {
  final String id;
  final String expression;
  final String literalTranslation;
  final String actualMeaning;
  final String dialect;
  final String originNotes;
  final String exampleSentence;
  final String exampleTranslation;
  const SlangRow(
      {required this.id,
      required this.expression,
      required this.literalTranslation,
      required this.actualMeaning,
      required this.dialect,
      required this.originNotes,
      required this.exampleSentence,
      required this.exampleTranslation});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['expression'] = Variable<String>(expression);
    map['literal_translation'] = Variable<String>(literalTranslation);
    map['actual_meaning'] = Variable<String>(actualMeaning);
    map['dialect'] = Variable<String>(dialect);
    map['origin_notes'] = Variable<String>(originNotes);
    map['example_sentence'] = Variable<String>(exampleSentence);
    map['example_translation'] = Variable<String>(exampleTranslation);
    return map;
  }

  SlangEntriesCompanion toCompanion(bool nullToAbsent) {
    return SlangEntriesCompanion(
      id: Value(id),
      expression: Value(expression),
      literalTranslation: Value(literalTranslation),
      actualMeaning: Value(actualMeaning),
      dialect: Value(dialect),
      originNotes: Value(originNotes),
      exampleSentence: Value(exampleSentence),
      exampleTranslation: Value(exampleTranslation),
    );
  }

  factory SlangRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SlangRow(
      id: serializer.fromJson<String>(json['id']),
      expression: serializer.fromJson<String>(json['expression']),
      literalTranslation:
          serializer.fromJson<String>(json['literalTranslation']),
      actualMeaning: serializer.fromJson<String>(json['actualMeaning']),
      dialect: serializer.fromJson<String>(json['dialect']),
      originNotes: serializer.fromJson<String>(json['originNotes']),
      exampleSentence: serializer.fromJson<String>(json['exampleSentence']),
      exampleTranslation:
          serializer.fromJson<String>(json['exampleTranslation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'expression': serializer.toJson<String>(expression),
      'literalTranslation': serializer.toJson<String>(literalTranslation),
      'actualMeaning': serializer.toJson<String>(actualMeaning),
      'dialect': serializer.toJson<String>(dialect),
      'originNotes': serializer.toJson<String>(originNotes),
      'exampleSentence': serializer.toJson<String>(exampleSentence),
      'exampleTranslation': serializer.toJson<String>(exampleTranslation),
    };
  }

  SlangRow copyWith(
          {String? id,
          String? expression,
          String? literalTranslation,
          String? actualMeaning,
          String? dialect,
          String? originNotes,
          String? exampleSentence,
          String? exampleTranslation}) =>
      SlangRow(
        id: id ?? this.id,
        expression: expression ?? this.expression,
        literalTranslation: literalTranslation ?? this.literalTranslation,
        actualMeaning: actualMeaning ?? this.actualMeaning,
        dialect: dialect ?? this.dialect,
        originNotes: originNotes ?? this.originNotes,
        exampleSentence: exampleSentence ?? this.exampleSentence,
        exampleTranslation: exampleTranslation ?? this.exampleTranslation,
      );
  SlangRow copyWithCompanion(SlangEntriesCompanion data) {
    return SlangRow(
      id: data.id.present ? data.id.value : this.id,
      expression:
          data.expression.present ? data.expression.value : this.expression,
      literalTranslation: data.literalTranslation.present
          ? data.literalTranslation.value
          : this.literalTranslation,
      actualMeaning: data.actualMeaning.present
          ? data.actualMeaning.value
          : this.actualMeaning,
      dialect: data.dialect.present ? data.dialect.value : this.dialect,
      originNotes:
          data.originNotes.present ? data.originNotes.value : this.originNotes,
      exampleSentence: data.exampleSentence.present
          ? data.exampleSentence.value
          : this.exampleSentence,
      exampleTranslation: data.exampleTranslation.present
          ? data.exampleTranslation.value
          : this.exampleTranslation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SlangRow(')
          ..write('id: $id, ')
          ..write('expression: $expression, ')
          ..write('literalTranslation: $literalTranslation, ')
          ..write('actualMeaning: $actualMeaning, ')
          ..write('dialect: $dialect, ')
          ..write('originNotes: $originNotes, ')
          ..write('exampleSentence: $exampleSentence, ')
          ..write('exampleTranslation: $exampleTranslation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, expression, literalTranslation,
      actualMeaning, dialect, originNotes, exampleSentence, exampleTranslation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SlangRow &&
          other.id == this.id &&
          other.expression == this.expression &&
          other.literalTranslation == this.literalTranslation &&
          other.actualMeaning == this.actualMeaning &&
          other.dialect == this.dialect &&
          other.originNotes == this.originNotes &&
          other.exampleSentence == this.exampleSentence &&
          other.exampleTranslation == this.exampleTranslation);
}

class SlangEntriesCompanion extends UpdateCompanion<SlangRow> {
  final Value<String> id;
  final Value<String> expression;
  final Value<String> literalTranslation;
  final Value<String> actualMeaning;
  final Value<String> dialect;
  final Value<String> originNotes;
  final Value<String> exampleSentence;
  final Value<String> exampleTranslation;
  final Value<int> rowid;
  const SlangEntriesCompanion({
    this.id = const Value.absent(),
    this.expression = const Value.absent(),
    this.literalTranslation = const Value.absent(),
    this.actualMeaning = const Value.absent(),
    this.dialect = const Value.absent(),
    this.originNotes = const Value.absent(),
    this.exampleSentence = const Value.absent(),
    this.exampleTranslation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SlangEntriesCompanion.insert({
    required String id,
    required String expression,
    required String literalTranslation,
    required String actualMeaning,
    required String dialect,
    required String originNotes,
    required String exampleSentence,
    required String exampleTranslation,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        expression = Value(expression),
        literalTranslation = Value(literalTranslation),
        actualMeaning = Value(actualMeaning),
        dialect = Value(dialect),
        originNotes = Value(originNotes),
        exampleSentence = Value(exampleSentence),
        exampleTranslation = Value(exampleTranslation);
  static Insertable<SlangRow> custom({
    Expression<String>? id,
    Expression<String>? expression,
    Expression<String>? literalTranslation,
    Expression<String>? actualMeaning,
    Expression<String>? dialect,
    Expression<String>? originNotes,
    Expression<String>? exampleSentence,
    Expression<String>? exampleTranslation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (expression != null) 'expression': expression,
      if (literalTranslation != null) 'literal_translation': literalTranslation,
      if (actualMeaning != null) 'actual_meaning': actualMeaning,
      if (dialect != null) 'dialect': dialect,
      if (originNotes != null) 'origin_notes': originNotes,
      if (exampleSentence != null) 'example_sentence': exampleSentence,
      if (exampleTranslation != null) 'example_translation': exampleTranslation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SlangEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? expression,
      Value<String>? literalTranslation,
      Value<String>? actualMeaning,
      Value<String>? dialect,
      Value<String>? originNotes,
      Value<String>? exampleSentence,
      Value<String>? exampleTranslation,
      Value<int>? rowid}) {
    return SlangEntriesCompanion(
      id: id ?? this.id,
      expression: expression ?? this.expression,
      literalTranslation: literalTranslation ?? this.literalTranslation,
      actualMeaning: actualMeaning ?? this.actualMeaning,
      dialect: dialect ?? this.dialect,
      originNotes: originNotes ?? this.originNotes,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      exampleTranslation: exampleTranslation ?? this.exampleTranslation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (expression.present) {
      map['expression'] = Variable<String>(expression.value);
    }
    if (literalTranslation.present) {
      map['literal_translation'] = Variable<String>(literalTranslation.value);
    }
    if (actualMeaning.present) {
      map['actual_meaning'] = Variable<String>(actualMeaning.value);
    }
    if (dialect.present) {
      map['dialect'] = Variable<String>(dialect.value);
    }
    if (originNotes.present) {
      map['origin_notes'] = Variable<String>(originNotes.value);
    }
    if (exampleSentence.present) {
      map['example_sentence'] = Variable<String>(exampleSentence.value);
    }
    if (exampleTranslation.present) {
      map['example_translation'] = Variable<String>(exampleTranslation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SlangEntriesCompanion(')
          ..write('id: $id, ')
          ..write('expression: $expression, ')
          ..write('literalTranslation: $literalTranslation, ')
          ..write('actualMeaning: $actualMeaning, ')
          ..write('dialect: $dialect, ')
          ..write('originNotes: $originNotes, ')
          ..write('exampleSentence: $exampleSentence, ')
          ..write('exampleTranslation: $exampleTranslation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DialogueNodesTable dialogueNodes = $DialogueNodesTable(this);
  late final $DialogueHistoryEntriesTable dialogueHistoryEntries =
      $DialogueHistoryEntriesTable(this);
  late final $SrsCardsTable srsCards = $SrsCardsTable(this);
  late final $SrsReviewLogsTable srsReviewLogs = $SrsReviewLogsTable(this);
  late final $GrammarVerbsTable grammarVerbs = $GrammarVerbsTable(this);
  late final $GrammarPracticeLogsTable grammarPracticeLogs =
      $GrammarPracticeLogsTable(this);
  late final $ListeningExercisesTable listeningExercises =
      $ListeningExercisesTable(this);
  late final $ListeningAttemptLogsTable listeningAttemptLogs =
      $ListeningAttemptLogsTable(this);
  late final $DictionaryEntriesTable dictionaryEntries =
      $DictionaryEntriesTable(this);
  late final $StoriesTable stories = $StoriesTable(this);
  late final $SlangEntriesTable slangEntries = $SlangEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        dialogueNodes,
        dialogueHistoryEntries,
        srsCards,
        srsReviewLogs,
        grammarVerbs,
        grammarPracticeLogs,
        listeningExercises,
        listeningAttemptLogs,
        dictionaryEntries,
        stories,
        slangEntries
      ];
}

typedef $$DialogueNodesTableCreateCompanionBuilder = DialogueNodesCompanion
    Function({
  required String id,
  required String speakerPortuguese,
  required String speakerRussian,
  required String linePortuguese,
  required String lineRussian,
  Value<String?> audioPath,
  required String scenarioId,
  required String scenarioTitle,
  required String scenarioCategory,
  Value<String> dialect,
  required String optionsJson,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DialogueNodesTableUpdateCompanionBuilder = DialogueNodesCompanion
    Function({
  Value<String> id,
  Value<String> speakerPortuguese,
  Value<String> speakerRussian,
  Value<String> linePortuguese,
  Value<String> lineRussian,
  Value<String?> audioPath,
  Value<String> scenarioId,
  Value<String> scenarioTitle,
  Value<String> scenarioCategory,
  Value<String> dialect,
  Value<String> optionsJson,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DialogueNodesTableFilterComposer
    extends Composer<_$AppDatabase, $DialogueNodesTable> {
  $$DialogueNodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get speakerPortuguese => $composableBuilder(
      column: $table.speakerPortuguese,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get speakerRussian => $composableBuilder(
      column: $table.speakerRussian,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linePortuguese => $composableBuilder(
      column: $table.linePortuguese,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lineRussian => $composableBuilder(
      column: $table.lineRussian, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioPath => $composableBuilder(
      column: $table.audioPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scenarioId => $composableBuilder(
      column: $table.scenarioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scenarioTitle => $composableBuilder(
      column: $table.scenarioTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scenarioCategory => $composableBuilder(
      column: $table.scenarioCategory,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dialect => $composableBuilder(
      column: $table.dialect, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DialogueNodesTableOrderingComposer
    extends Composer<_$AppDatabase, $DialogueNodesTable> {
  $$DialogueNodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get speakerPortuguese => $composableBuilder(
      column: $table.speakerPortuguese,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get speakerRussian => $composableBuilder(
      column: $table.speakerRussian,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linePortuguese => $composableBuilder(
      column: $table.linePortuguese,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lineRussian => $composableBuilder(
      column: $table.lineRussian, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioPath => $composableBuilder(
      column: $table.audioPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scenarioId => $composableBuilder(
      column: $table.scenarioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scenarioTitle => $composableBuilder(
      column: $table.scenarioTitle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scenarioCategory => $composableBuilder(
      column: $table.scenarioCategory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dialect => $composableBuilder(
      column: $table.dialect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DialogueNodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DialogueNodesTable> {
  $$DialogueNodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get speakerPortuguese => $composableBuilder(
      column: $table.speakerPortuguese, builder: (column) => column);

  GeneratedColumn<String> get speakerRussian => $composableBuilder(
      column: $table.speakerRussian, builder: (column) => column);

  GeneratedColumn<String> get linePortuguese => $composableBuilder(
      column: $table.linePortuguese, builder: (column) => column);

  GeneratedColumn<String> get lineRussian => $composableBuilder(
      column: $table.lineRussian, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<String> get scenarioId => $composableBuilder(
      column: $table.scenarioId, builder: (column) => column);

  GeneratedColumn<String> get scenarioTitle => $composableBuilder(
      column: $table.scenarioTitle, builder: (column) => column);

  GeneratedColumn<String> get scenarioCategory => $composableBuilder(
      column: $table.scenarioCategory, builder: (column) => column);

  GeneratedColumn<String> get dialect =>
      $composableBuilder(column: $table.dialect, builder: (column) => column);

  GeneratedColumn<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DialogueNodesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DialogueNodesTable,
    DialogueNodeRow,
    $$DialogueNodesTableFilterComposer,
    $$DialogueNodesTableOrderingComposer,
    $$DialogueNodesTableAnnotationComposer,
    $$DialogueNodesTableCreateCompanionBuilder,
    $$DialogueNodesTableUpdateCompanionBuilder,
    (
      DialogueNodeRow,
      BaseReferences<_$AppDatabase, $DialogueNodesTable, DialogueNodeRow>
    ),
    DialogueNodeRow,
    PrefetchHooks Function()> {
  $$DialogueNodesTableTableManager(_$AppDatabase db, $DialogueNodesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DialogueNodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DialogueNodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DialogueNodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> speakerPortuguese = const Value.absent(),
            Value<String> speakerRussian = const Value.absent(),
            Value<String> linePortuguese = const Value.absent(),
            Value<String> lineRussian = const Value.absent(),
            Value<String?> audioPath = const Value.absent(),
            Value<String> scenarioId = const Value.absent(),
            Value<String> scenarioTitle = const Value.absent(),
            Value<String> scenarioCategory = const Value.absent(),
            Value<String> dialect = const Value.absent(),
            Value<String> optionsJson = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DialogueNodesCompanion(
            id: id,
            speakerPortuguese: speakerPortuguese,
            speakerRussian: speakerRussian,
            linePortuguese: linePortuguese,
            lineRussian: lineRussian,
            audioPath: audioPath,
            scenarioId: scenarioId,
            scenarioTitle: scenarioTitle,
            scenarioCategory: scenarioCategory,
            dialect: dialect,
            optionsJson: optionsJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String speakerPortuguese,
            required String speakerRussian,
            required String linePortuguese,
            required String lineRussian,
            Value<String?> audioPath = const Value.absent(),
            required String scenarioId,
            required String scenarioTitle,
            required String scenarioCategory,
            Value<String> dialect = const Value.absent(),
            required String optionsJson,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DialogueNodesCompanion.insert(
            id: id,
            speakerPortuguese: speakerPortuguese,
            speakerRussian: speakerRussian,
            linePortuguese: linePortuguese,
            lineRussian: lineRussian,
            audioPath: audioPath,
            scenarioId: scenarioId,
            scenarioTitle: scenarioTitle,
            scenarioCategory: scenarioCategory,
            dialect: dialect,
            optionsJson: optionsJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DialogueNodesTable, DialogueNodeRow>(table),
                    BaseReferences<_$AppDatabase, $DialogueNodesTable,
                        DialogueNodeRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DialogueNodesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DialogueNodesTable,
    DialogueNodeRow,
    $$DialogueNodesTableFilterComposer,
    $$DialogueNodesTableOrderingComposer,
    $$DialogueNodesTableAnnotationComposer,
    $$DialogueNodesTableCreateCompanionBuilder,
    $$DialogueNodesTableUpdateCompanionBuilder,
    (
      DialogueNodeRow,
      BaseReferences<_$AppDatabase, $DialogueNodesTable, DialogueNodeRow>
    ),
    DialogueNodeRow,
    PrefetchHooks Function()>;
typedef $$DialogueHistoryEntriesTableCreateCompanionBuilder
    = DialogueHistoryEntriesCompanion Function({
  Value<int> id,
  required String nodeId,
  required String selectedOptionId,
  required DateTime answeredAt,
});
typedef $$DialogueHistoryEntriesTableUpdateCompanionBuilder
    = DialogueHistoryEntriesCompanion Function({
  Value<int> id,
  Value<String> nodeId,
  Value<String> selectedOptionId,
  Value<DateTime> answeredAt,
});

class $$DialogueHistoryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DialogueHistoryEntriesTable> {
  $$DialogueHistoryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nodeId => $composableBuilder(
      column: $table.nodeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selectedOptionId => $composableBuilder(
      column: $table.selectedOptionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => ColumnFilters(column));
}

class $$DialogueHistoryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DialogueHistoryEntriesTable> {
  $$DialogueHistoryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nodeId => $composableBuilder(
      column: $table.nodeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selectedOptionId => $composableBuilder(
      column: $table.selectedOptionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => ColumnOrderings(column));
}

class $$DialogueHistoryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DialogueHistoryEntriesTable> {
  $$DialogueHistoryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get selectedOptionId => $composableBuilder(
      column: $table.selectedOptionId, builder: (column) => column);

  GeneratedColumn<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => column);
}

class $$DialogueHistoryEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DialogueHistoryEntriesTable,
    DialogueHistoryRow,
    $$DialogueHistoryEntriesTableFilterComposer,
    $$DialogueHistoryEntriesTableOrderingComposer,
    $$DialogueHistoryEntriesTableAnnotationComposer,
    $$DialogueHistoryEntriesTableCreateCompanionBuilder,
    $$DialogueHistoryEntriesTableUpdateCompanionBuilder,
    (
      DialogueHistoryRow,
      BaseReferences<_$AppDatabase, $DialogueHistoryEntriesTable,
          DialogueHistoryRow>
    ),
    DialogueHistoryRow,
    PrefetchHooks Function()> {
  $$DialogueHistoryEntriesTableTableManager(
      _$AppDatabase db, $DialogueHistoryEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DialogueHistoryEntriesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$DialogueHistoryEntriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DialogueHistoryEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nodeId = const Value.absent(),
            Value<String> selectedOptionId = const Value.absent(),
            Value<DateTime> answeredAt = const Value.absent(),
          }) =>
              DialogueHistoryEntriesCompanion(
            id: id,
            nodeId: nodeId,
            selectedOptionId: selectedOptionId,
            answeredAt: answeredAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nodeId,
            required String selectedOptionId,
            required DateTime answeredAt,
          }) =>
              DialogueHistoryEntriesCompanion.insert(
            id: id,
            nodeId: nodeId,
            selectedOptionId: selectedOptionId,
            answeredAt: answeredAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DialogueHistoryEntriesTable,
                        DialogueHistoryRow>(table),
                    BaseReferences<_$AppDatabase, $DialogueHistoryEntriesTable,
                        DialogueHistoryRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DialogueHistoryEntriesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $DialogueHistoryEntriesTable,
        DialogueHistoryRow,
        $$DialogueHistoryEntriesTableFilterComposer,
        $$DialogueHistoryEntriesTableOrderingComposer,
        $$DialogueHistoryEntriesTableAnnotationComposer,
        $$DialogueHistoryEntriesTableCreateCompanionBuilder,
        $$DialogueHistoryEntriesTableUpdateCompanionBuilder,
        (
          DialogueHistoryRow,
          BaseReferences<_$AppDatabase, $DialogueHistoryEntriesTable,
              DialogueHistoryRow>
        ),
        DialogueHistoryRow,
        PrefetchHooks Function()>;
typedef $$SrsCardsTableCreateCompanionBuilder = SrsCardsCompanion Function({
  required String id,
  required String portuguese,
  required String russianTranslation,
  Value<String> partOfSpeech,
  Value<String> category,
  Value<String> dialect,
  Value<String?> examplePortuguese,
  Value<String?> exampleRussian,
  Value<String?> audioUrl,
  Value<String?> notes,
  Value<String> fsrsState,
  Value<double> stability,
  Value<double> difficulty,
  Value<int> reps,
  Value<int> lapses,
  required DateTime dueAt,
  Value<DateTime?> lastReviewedAt,
  Value<int> rowid,
});
typedef $$SrsCardsTableUpdateCompanionBuilder = SrsCardsCompanion Function({
  Value<String> id,
  Value<String> portuguese,
  Value<String> russianTranslation,
  Value<String> partOfSpeech,
  Value<String> category,
  Value<String> dialect,
  Value<String?> examplePortuguese,
  Value<String?> exampleRussian,
  Value<String?> audioUrl,
  Value<String?> notes,
  Value<String> fsrsState,
  Value<double> stability,
  Value<double> difficulty,
  Value<int> reps,
  Value<int> lapses,
  Value<DateTime> dueAt,
  Value<DateTime?> lastReviewedAt,
  Value<int> rowid,
});

class $$SrsCardsTableFilterComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get portuguese => $composableBuilder(
      column: $table.portuguese, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get russianTranslation => $composableBuilder(
      column: $table.russianTranslation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dialect => $composableBuilder(
      column: $table.dialect, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get examplePortuguese => $composableBuilder(
      column: $table.examplePortuguese,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleRussian => $composableBuilder(
      column: $table.exampleRussian,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fsrsState => $composableBuilder(
      column: $table.fsrsState, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stability => $composableBuilder(
      column: $table.stability, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lapses => $composableBuilder(
      column: $table.lapses, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnFilters(column));
}

class $$SrsCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get portuguese => $composableBuilder(
      column: $table.portuguese, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get russianTranslation => $composableBuilder(
      column: $table.russianTranslation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dialect => $composableBuilder(
      column: $table.dialect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get examplePortuguese => $composableBuilder(
      column: $table.examplePortuguese,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleRussian => $composableBuilder(
      column: $table.exampleRussian,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fsrsState => $composableBuilder(
      column: $table.fsrsState, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stability => $composableBuilder(
      column: $table.stability, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lapses => $composableBuilder(
      column: $table.lapses, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$SrsCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get portuguese => $composableBuilder(
      column: $table.portuguese, builder: (column) => column);

  GeneratedColumn<String> get russianTranslation => $composableBuilder(
      column: $table.russianTranslation, builder: (column) => column);

  GeneratedColumn<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get dialect =>
      $composableBuilder(column: $table.dialect, builder: (column) => column);

  GeneratedColumn<String> get examplePortuguese => $composableBuilder(
      column: $table.examplePortuguese, builder: (column) => column);

  GeneratedColumn<String> get exampleRussian => $composableBuilder(
      column: $table.exampleRussian, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get fsrsState =>
      $composableBuilder(column: $table.fsrsState, builder: (column) => column);

  GeneratedColumn<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt, builder: (column) => column);
}

class $$SrsCardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SrsCardsTable,
    SrsCardRow,
    $$SrsCardsTableFilterComposer,
    $$SrsCardsTableOrderingComposer,
    $$SrsCardsTableAnnotationComposer,
    $$SrsCardsTableCreateCompanionBuilder,
    $$SrsCardsTableUpdateCompanionBuilder,
    (SrsCardRow, BaseReferences<_$AppDatabase, $SrsCardsTable, SrsCardRow>),
    SrsCardRow,
    PrefetchHooks Function()> {
  $$SrsCardsTableTableManager(_$AppDatabase db, $SrsCardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrsCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrsCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrsCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> portuguese = const Value.absent(),
            Value<String> russianTranslation = const Value.absent(),
            Value<String> partOfSpeech = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> dialect = const Value.absent(),
            Value<String?> examplePortuguese = const Value.absent(),
            Value<String?> exampleRussian = const Value.absent(),
            Value<String?> audioUrl = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> fsrsState = const Value.absent(),
            Value<double> stability = const Value.absent(),
            Value<double> difficulty = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<int> lapses = const Value.absent(),
            Value<DateTime> dueAt = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SrsCardsCompanion(
            id: id,
            portuguese: portuguese,
            russianTranslation: russianTranslation,
            partOfSpeech: partOfSpeech,
            category: category,
            dialect: dialect,
            examplePortuguese: examplePortuguese,
            exampleRussian: exampleRussian,
            audioUrl: audioUrl,
            notes: notes,
            fsrsState: fsrsState,
            stability: stability,
            difficulty: difficulty,
            reps: reps,
            lapses: lapses,
            dueAt: dueAt,
            lastReviewedAt: lastReviewedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String portuguese,
            required String russianTranslation,
            Value<String> partOfSpeech = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> dialect = const Value.absent(),
            Value<String?> examplePortuguese = const Value.absent(),
            Value<String?> exampleRussian = const Value.absent(),
            Value<String?> audioUrl = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> fsrsState = const Value.absent(),
            Value<double> stability = const Value.absent(),
            Value<double> difficulty = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<int> lapses = const Value.absent(),
            required DateTime dueAt,
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SrsCardsCompanion.insert(
            id: id,
            portuguese: portuguese,
            russianTranslation: russianTranslation,
            partOfSpeech: partOfSpeech,
            category: category,
            dialect: dialect,
            examplePortuguese: examplePortuguese,
            exampleRussian: exampleRussian,
            audioUrl: audioUrl,
            notes: notes,
            fsrsState: fsrsState,
            stability: stability,
            difficulty: difficulty,
            reps: reps,
            lapses: lapses,
            dueAt: dueAt,
            lastReviewedAt: lastReviewedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SrsCardsTable, SrsCardRow>(table),
                    BaseReferences<_$AppDatabase, $SrsCardsTable, SrsCardRow>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SrsCardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SrsCardsTable,
    SrsCardRow,
    $$SrsCardsTableFilterComposer,
    $$SrsCardsTableOrderingComposer,
    $$SrsCardsTableAnnotationComposer,
    $$SrsCardsTableCreateCompanionBuilder,
    $$SrsCardsTableUpdateCompanionBuilder,
    (SrsCardRow, BaseReferences<_$AppDatabase, $SrsCardsTable, SrsCardRow>),
    SrsCardRow,
    PrefetchHooks Function()>;
typedef $$SrsReviewLogsTableCreateCompanionBuilder = SrsReviewLogsCompanion
    Function({
  Value<int> id,
  required String cardId,
  required int rating,
  required double stabilityBefore,
  required double stabilityAfter,
  required double difficultyAfter,
  required int scheduledDays,
  Value<bool> wasTypedCheck,
  Value<bool> wasTypedExact,
  required DateTime reviewedAt,
});
typedef $$SrsReviewLogsTableUpdateCompanionBuilder = SrsReviewLogsCompanion
    Function({
  Value<int> id,
  Value<String> cardId,
  Value<int> rating,
  Value<double> stabilityBefore,
  Value<double> stabilityAfter,
  Value<double> difficultyAfter,
  Value<int> scheduledDays,
  Value<bool> wasTypedCheck,
  Value<bool> wasTypedExact,
  Value<DateTime> reviewedAt,
});

class $$SrsReviewLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SrsReviewLogsTable> {
  $$SrsReviewLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stabilityBefore => $composableBuilder(
      column: $table.stabilityBefore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stabilityAfter => $composableBuilder(
      column: $table.stabilityAfter,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get difficultyAfter => $composableBuilder(
      column: $table.difficultyAfter,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scheduledDays => $composableBuilder(
      column: $table.scheduledDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get wasTypedCheck => $composableBuilder(
      column: $table.wasTypedCheck, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get wasTypedExact => $composableBuilder(
      column: $table.wasTypedExact, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => ColumnFilters(column));
}

class $$SrsReviewLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SrsReviewLogsTable> {
  $$SrsReviewLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stabilityBefore => $composableBuilder(
      column: $table.stabilityBefore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stabilityAfter => $composableBuilder(
      column: $table.stabilityAfter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get difficultyAfter => $composableBuilder(
      column: $table.difficultyAfter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scheduledDays => $composableBuilder(
      column: $table.scheduledDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get wasTypedCheck => $composableBuilder(
      column: $table.wasTypedCheck,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get wasTypedExact => $composableBuilder(
      column: $table.wasTypedExact,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => ColumnOrderings(column));
}

class $$SrsReviewLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrsReviewLogsTable> {
  $$SrsReviewLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<double> get stabilityBefore => $composableBuilder(
      column: $table.stabilityBefore, builder: (column) => column);

  GeneratedColumn<double> get stabilityAfter => $composableBuilder(
      column: $table.stabilityAfter, builder: (column) => column);

  GeneratedColumn<double> get difficultyAfter => $composableBuilder(
      column: $table.difficultyAfter, builder: (column) => column);

  GeneratedColumn<int> get scheduledDays => $composableBuilder(
      column: $table.scheduledDays, builder: (column) => column);

  GeneratedColumn<bool> get wasTypedCheck => $composableBuilder(
      column: $table.wasTypedCheck, builder: (column) => column);

  GeneratedColumn<bool> get wasTypedExact => $composableBuilder(
      column: $table.wasTypedExact, builder: (column) => column);

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => column);
}

class $$SrsReviewLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SrsReviewLogsTable,
    SrsReviewLogRow,
    $$SrsReviewLogsTableFilterComposer,
    $$SrsReviewLogsTableOrderingComposer,
    $$SrsReviewLogsTableAnnotationComposer,
    $$SrsReviewLogsTableCreateCompanionBuilder,
    $$SrsReviewLogsTableUpdateCompanionBuilder,
    (
      SrsReviewLogRow,
      BaseReferences<_$AppDatabase, $SrsReviewLogsTable, SrsReviewLogRow>
    ),
    SrsReviewLogRow,
    PrefetchHooks Function()> {
  $$SrsReviewLogsTableTableManager(_$AppDatabase db, $SrsReviewLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrsReviewLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrsReviewLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrsReviewLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> cardId = const Value.absent(),
            Value<int> rating = const Value.absent(),
            Value<double> stabilityBefore = const Value.absent(),
            Value<double> stabilityAfter = const Value.absent(),
            Value<double> difficultyAfter = const Value.absent(),
            Value<int> scheduledDays = const Value.absent(),
            Value<bool> wasTypedCheck = const Value.absent(),
            Value<bool> wasTypedExact = const Value.absent(),
            Value<DateTime> reviewedAt = const Value.absent(),
          }) =>
              SrsReviewLogsCompanion(
            id: id,
            cardId: cardId,
            rating: rating,
            stabilityBefore: stabilityBefore,
            stabilityAfter: stabilityAfter,
            difficultyAfter: difficultyAfter,
            scheduledDays: scheduledDays,
            wasTypedCheck: wasTypedCheck,
            wasTypedExact: wasTypedExact,
            reviewedAt: reviewedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String cardId,
            required int rating,
            required double stabilityBefore,
            required double stabilityAfter,
            required double difficultyAfter,
            required int scheduledDays,
            Value<bool> wasTypedCheck = const Value.absent(),
            Value<bool> wasTypedExact = const Value.absent(),
            required DateTime reviewedAt,
          }) =>
              SrsReviewLogsCompanion.insert(
            id: id,
            cardId: cardId,
            rating: rating,
            stabilityBefore: stabilityBefore,
            stabilityAfter: stabilityAfter,
            difficultyAfter: difficultyAfter,
            scheduledDays: scheduledDays,
            wasTypedCheck: wasTypedCheck,
            wasTypedExact: wasTypedExact,
            reviewedAt: reviewedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SrsReviewLogsTable, SrsReviewLogRow>(table),
                    BaseReferences<_$AppDatabase, $SrsReviewLogsTable,
                        SrsReviewLogRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SrsReviewLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SrsReviewLogsTable,
    SrsReviewLogRow,
    $$SrsReviewLogsTableFilterComposer,
    $$SrsReviewLogsTableOrderingComposer,
    $$SrsReviewLogsTableAnnotationComposer,
    $$SrsReviewLogsTableCreateCompanionBuilder,
    $$SrsReviewLogsTableUpdateCompanionBuilder,
    (
      SrsReviewLogRow,
      BaseReferences<_$AppDatabase, $SrsReviewLogsTable, SrsReviewLogRow>
    ),
    SrsReviewLogRow,
    PrefetchHooks Function()>;
typedef $$GrammarVerbsTableCreateCompanionBuilder = GrammarVerbsCompanion
    Function({
  required String id,
  required String infinitive,
  required String regularity,
  required String conjugationGroup,
  required String russianMeaning,
  required String grammarNotesRu,
  Value<String?> differenceNote,
  required String conjugationsJson,
  Value<int> rowid,
});
typedef $$GrammarVerbsTableUpdateCompanionBuilder = GrammarVerbsCompanion
    Function({
  Value<String> id,
  Value<String> infinitive,
  Value<String> regularity,
  Value<String> conjugationGroup,
  Value<String> russianMeaning,
  Value<String> grammarNotesRu,
  Value<String?> differenceNote,
  Value<String> conjugationsJson,
  Value<int> rowid,
});

class $$GrammarVerbsTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarVerbsTable> {
  $$GrammarVerbsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get infinitive => $composableBuilder(
      column: $table.infinitive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get regularity => $composableBuilder(
      column: $table.regularity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conjugationGroup => $composableBuilder(
      column: $table.conjugationGroup,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get russianMeaning => $composableBuilder(
      column: $table.russianMeaning,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get grammarNotesRu => $composableBuilder(
      column: $table.grammarNotesRu,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get differenceNote => $composableBuilder(
      column: $table.differenceNote,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conjugationsJson => $composableBuilder(
      column: $table.conjugationsJson,
      builder: (column) => ColumnFilters(column));
}

class $$GrammarVerbsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarVerbsTable> {
  $$GrammarVerbsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get infinitive => $composableBuilder(
      column: $table.infinitive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get regularity => $composableBuilder(
      column: $table.regularity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conjugationGroup => $composableBuilder(
      column: $table.conjugationGroup,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get russianMeaning => $composableBuilder(
      column: $table.russianMeaning,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get grammarNotesRu => $composableBuilder(
      column: $table.grammarNotesRu,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get differenceNote => $composableBuilder(
      column: $table.differenceNote,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conjugationsJson => $composableBuilder(
      column: $table.conjugationsJson,
      builder: (column) => ColumnOrderings(column));
}

class $$GrammarVerbsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarVerbsTable> {
  $$GrammarVerbsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get infinitive => $composableBuilder(
      column: $table.infinitive, builder: (column) => column);

  GeneratedColumn<String> get regularity => $composableBuilder(
      column: $table.regularity, builder: (column) => column);

  GeneratedColumn<String> get conjugationGroup => $composableBuilder(
      column: $table.conjugationGroup, builder: (column) => column);

  GeneratedColumn<String> get russianMeaning => $composableBuilder(
      column: $table.russianMeaning, builder: (column) => column);

  GeneratedColumn<String> get grammarNotesRu => $composableBuilder(
      column: $table.grammarNotesRu, builder: (column) => column);

  GeneratedColumn<String> get differenceNote => $composableBuilder(
      column: $table.differenceNote, builder: (column) => column);

  GeneratedColumn<String> get conjugationsJson => $composableBuilder(
      column: $table.conjugationsJson, builder: (column) => column);
}

class $$GrammarVerbsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GrammarVerbsTable,
    GrammarVerbRow,
    $$GrammarVerbsTableFilterComposer,
    $$GrammarVerbsTableOrderingComposer,
    $$GrammarVerbsTableAnnotationComposer,
    $$GrammarVerbsTableCreateCompanionBuilder,
    $$GrammarVerbsTableUpdateCompanionBuilder,
    (
      GrammarVerbRow,
      BaseReferences<_$AppDatabase, $GrammarVerbsTable, GrammarVerbRow>
    ),
    GrammarVerbRow,
    PrefetchHooks Function()> {
  $$GrammarVerbsTableTableManager(_$AppDatabase db, $GrammarVerbsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarVerbsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarVerbsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarVerbsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> infinitive = const Value.absent(),
            Value<String> regularity = const Value.absent(),
            Value<String> conjugationGroup = const Value.absent(),
            Value<String> russianMeaning = const Value.absent(),
            Value<String> grammarNotesRu = const Value.absent(),
            Value<String?> differenceNote = const Value.absent(),
            Value<String> conjugationsJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GrammarVerbsCompanion(
            id: id,
            infinitive: infinitive,
            regularity: regularity,
            conjugationGroup: conjugationGroup,
            russianMeaning: russianMeaning,
            grammarNotesRu: grammarNotesRu,
            differenceNote: differenceNote,
            conjugationsJson: conjugationsJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String infinitive,
            required String regularity,
            required String conjugationGroup,
            required String russianMeaning,
            required String grammarNotesRu,
            Value<String?> differenceNote = const Value.absent(),
            required String conjugationsJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              GrammarVerbsCompanion.insert(
            id: id,
            infinitive: infinitive,
            regularity: regularity,
            conjugationGroup: conjugationGroup,
            russianMeaning: russianMeaning,
            grammarNotesRu: grammarNotesRu,
            differenceNote: differenceNote,
            conjugationsJson: conjugationsJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$GrammarVerbsTable, GrammarVerbRow>(table),
                    BaseReferences<_$AppDatabase, $GrammarVerbsTable,
                        GrammarVerbRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GrammarVerbsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GrammarVerbsTable,
    GrammarVerbRow,
    $$GrammarVerbsTableFilterComposer,
    $$GrammarVerbsTableOrderingComposer,
    $$GrammarVerbsTableAnnotationComposer,
    $$GrammarVerbsTableCreateCompanionBuilder,
    $$GrammarVerbsTableUpdateCompanionBuilder,
    (
      GrammarVerbRow,
      BaseReferences<_$AppDatabase, $GrammarVerbsTable, GrammarVerbRow>
    ),
    GrammarVerbRow,
    PrefetchHooks Function()>;
typedef $$GrammarPracticeLogsTableCreateCompanionBuilder
    = GrammarPracticeLogsCompanion Function({
  Value<int> id,
  required String verbId,
  required String tense,
  required String person,
  required bool isCorrect,
  required DateTime practicedAt,
});
typedef $$GrammarPracticeLogsTableUpdateCompanionBuilder
    = GrammarPracticeLogsCompanion Function({
  Value<int> id,
  Value<String> verbId,
  Value<String> tense,
  Value<String> person,
  Value<bool> isCorrect,
  Value<DateTime> practicedAt,
});

class $$GrammarPracticeLogsTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarPracticeLogsTable> {
  $$GrammarPracticeLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verbId => $composableBuilder(
      column: $table.verbId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tense => $composableBuilder(
      column: $table.tense, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get person => $composableBuilder(
      column: $table.person, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get practicedAt => $composableBuilder(
      column: $table.practicedAt, builder: (column) => ColumnFilters(column));
}

class $$GrammarPracticeLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarPracticeLogsTable> {
  $$GrammarPracticeLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verbId => $composableBuilder(
      column: $table.verbId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tense => $composableBuilder(
      column: $table.tense, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get person => $composableBuilder(
      column: $table.person, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get practicedAt => $composableBuilder(
      column: $table.practicedAt, builder: (column) => ColumnOrderings(column));
}

class $$GrammarPracticeLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarPracticeLogsTable> {
  $$GrammarPracticeLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get verbId =>
      $composableBuilder(column: $table.verbId, builder: (column) => column);

  GeneratedColumn<String> get tense =>
      $composableBuilder(column: $table.tense, builder: (column) => column);

  GeneratedColumn<String> get person =>
      $composableBuilder(column: $table.person, builder: (column) => column);

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<DateTime> get practicedAt => $composableBuilder(
      column: $table.practicedAt, builder: (column) => column);
}

class $$GrammarPracticeLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GrammarPracticeLogsTable,
    GrammarPracticeLogRow,
    $$GrammarPracticeLogsTableFilterComposer,
    $$GrammarPracticeLogsTableOrderingComposer,
    $$GrammarPracticeLogsTableAnnotationComposer,
    $$GrammarPracticeLogsTableCreateCompanionBuilder,
    $$GrammarPracticeLogsTableUpdateCompanionBuilder,
    (
      GrammarPracticeLogRow,
      BaseReferences<_$AppDatabase, $GrammarPracticeLogsTable,
          GrammarPracticeLogRow>
    ),
    GrammarPracticeLogRow,
    PrefetchHooks Function()> {
  $$GrammarPracticeLogsTableTableManager(
      _$AppDatabase db, $GrammarPracticeLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarPracticeLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarPracticeLogsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarPracticeLogsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> verbId = const Value.absent(),
            Value<String> tense = const Value.absent(),
            Value<String> person = const Value.absent(),
            Value<bool> isCorrect = const Value.absent(),
            Value<DateTime> practicedAt = const Value.absent(),
          }) =>
              GrammarPracticeLogsCompanion(
            id: id,
            verbId: verbId,
            tense: tense,
            person: person,
            isCorrect: isCorrect,
            practicedAt: practicedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String verbId,
            required String tense,
            required String person,
            required bool isCorrect,
            required DateTime practicedAt,
          }) =>
              GrammarPracticeLogsCompanion.insert(
            id: id,
            verbId: verbId,
            tense: tense,
            person: person,
            isCorrect: isCorrect,
            practicedAt: practicedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$GrammarPracticeLogsTable,
                        GrammarPracticeLogRow>(table),
                    BaseReferences<_$AppDatabase, $GrammarPracticeLogsTable,
                        GrammarPracticeLogRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GrammarPracticeLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GrammarPracticeLogsTable,
    GrammarPracticeLogRow,
    $$GrammarPracticeLogsTableFilterComposer,
    $$GrammarPracticeLogsTableOrderingComposer,
    $$GrammarPracticeLogsTableAnnotationComposer,
    $$GrammarPracticeLogsTableCreateCompanionBuilder,
    $$GrammarPracticeLogsTableUpdateCompanionBuilder,
    (
      GrammarPracticeLogRow,
      BaseReferences<_$AppDatabase, $GrammarPracticeLogsTable,
          GrammarPracticeLogRow>
    ),
    GrammarPracticeLogRow,
    PrefetchHooks Function()>;
typedef $$ListeningExercisesTableCreateCompanionBuilder
    = ListeningExercisesCompanion Function({
  required String id,
  required String transcript,
  required String russianTranslation,
  Value<String?> audioUrl,
  Value<String> difficulty,
  required String focusWordsJson,
  Value<String> dialect,
  Value<int> rowid,
});
typedef $$ListeningExercisesTableUpdateCompanionBuilder
    = ListeningExercisesCompanion Function({
  Value<String> id,
  Value<String> transcript,
  Value<String> russianTranslation,
  Value<String?> audioUrl,
  Value<String> difficulty,
  Value<String> focusWordsJson,
  Value<String> dialect,
  Value<int> rowid,
});

class $$ListeningExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ListeningExercisesTable> {
  $$ListeningExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transcript => $composableBuilder(
      column: $table.transcript, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get russianTranslation => $composableBuilder(
      column: $table.russianTranslation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get focusWordsJson => $composableBuilder(
      column: $table.focusWordsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dialect => $composableBuilder(
      column: $table.dialect, builder: (column) => ColumnFilters(column));
}

class $$ListeningExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ListeningExercisesTable> {
  $$ListeningExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transcript => $composableBuilder(
      column: $table.transcript, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get russianTranslation => $composableBuilder(
      column: $table.russianTranslation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get focusWordsJson => $composableBuilder(
      column: $table.focusWordsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dialect => $composableBuilder(
      column: $table.dialect, builder: (column) => ColumnOrderings(column));
}

class $$ListeningExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListeningExercisesTable> {
  $$ListeningExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transcript => $composableBuilder(
      column: $table.transcript, builder: (column) => column);

  GeneratedColumn<String> get russianTranslation => $composableBuilder(
      column: $table.russianTranslation, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<String> get focusWordsJson => $composableBuilder(
      column: $table.focusWordsJson, builder: (column) => column);

  GeneratedColumn<String> get dialect =>
      $composableBuilder(column: $table.dialect, builder: (column) => column);
}

class $$ListeningExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ListeningExercisesTable,
    ListeningExerciseRow,
    $$ListeningExercisesTableFilterComposer,
    $$ListeningExercisesTableOrderingComposer,
    $$ListeningExercisesTableAnnotationComposer,
    $$ListeningExercisesTableCreateCompanionBuilder,
    $$ListeningExercisesTableUpdateCompanionBuilder,
    (
      ListeningExerciseRow,
      BaseReferences<_$AppDatabase, $ListeningExercisesTable,
          ListeningExerciseRow>
    ),
    ListeningExerciseRow,
    PrefetchHooks Function()> {
  $$ListeningExercisesTableTableManager(
      _$AppDatabase db, $ListeningExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListeningExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListeningExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListeningExercisesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> transcript = const Value.absent(),
            Value<String> russianTranslation = const Value.absent(),
            Value<String?> audioUrl = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
            Value<String> focusWordsJson = const Value.absent(),
            Value<String> dialect = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ListeningExercisesCompanion(
            id: id,
            transcript: transcript,
            russianTranslation: russianTranslation,
            audioUrl: audioUrl,
            difficulty: difficulty,
            focusWordsJson: focusWordsJson,
            dialect: dialect,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String transcript,
            required String russianTranslation,
            Value<String?> audioUrl = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
            required String focusWordsJson,
            Value<String> dialect = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ListeningExercisesCompanion.insert(
            id: id,
            transcript: transcript,
            russianTranslation: russianTranslation,
            audioUrl: audioUrl,
            difficulty: difficulty,
            focusWordsJson: focusWordsJson,
            dialect: dialect,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ListeningExercisesTable, ListeningExerciseRow>(
                        table),
                    BaseReferences<_$AppDatabase, $ListeningExercisesTable,
                        ListeningExerciseRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ListeningExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ListeningExercisesTable,
    ListeningExerciseRow,
    $$ListeningExercisesTableFilterComposer,
    $$ListeningExercisesTableOrderingComposer,
    $$ListeningExercisesTableAnnotationComposer,
    $$ListeningExercisesTableCreateCompanionBuilder,
    $$ListeningExercisesTableUpdateCompanionBuilder,
    (
      ListeningExerciseRow,
      BaseReferences<_$AppDatabase, $ListeningExercisesTable,
          ListeningExerciseRow>
    ),
    ListeningExerciseRow,
    PrefetchHooks Function()>;
typedef $$ListeningAttemptLogsTableCreateCompanionBuilder
    = ListeningAttemptLogsCompanion Function({
  Value<int> id,
  required String exerciseId,
  required double wordAccuracy,
  required bool isExactMatch,
  required DateTime attemptedAt,
});
typedef $$ListeningAttemptLogsTableUpdateCompanionBuilder
    = ListeningAttemptLogsCompanion Function({
  Value<int> id,
  Value<String> exerciseId,
  Value<double> wordAccuracy,
  Value<bool> isExactMatch,
  Value<DateTime> attemptedAt,
});

class $$ListeningAttemptLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ListeningAttemptLogsTable> {
  $$ListeningAttemptLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get wordAccuracy => $composableBuilder(
      column: $table.wordAccuracy, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isExactMatch => $composableBuilder(
      column: $table.isExactMatch, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get attemptedAt => $composableBuilder(
      column: $table.attemptedAt, builder: (column) => ColumnFilters(column));
}

class $$ListeningAttemptLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ListeningAttemptLogsTable> {
  $$ListeningAttemptLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get wordAccuracy => $composableBuilder(
      column: $table.wordAccuracy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isExactMatch => $composableBuilder(
      column: $table.isExactMatch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get attemptedAt => $composableBuilder(
      column: $table.attemptedAt, builder: (column) => ColumnOrderings(column));
}

class $$ListeningAttemptLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListeningAttemptLogsTable> {
  $$ListeningAttemptLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => column);

  GeneratedColumn<double> get wordAccuracy => $composableBuilder(
      column: $table.wordAccuracy, builder: (column) => column);

  GeneratedColumn<bool> get isExactMatch => $composableBuilder(
      column: $table.isExactMatch, builder: (column) => column);

  GeneratedColumn<DateTime> get attemptedAt => $composableBuilder(
      column: $table.attemptedAt, builder: (column) => column);
}

class $$ListeningAttemptLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ListeningAttemptLogsTable,
    ListeningAttemptLogRow,
    $$ListeningAttemptLogsTableFilterComposer,
    $$ListeningAttemptLogsTableOrderingComposer,
    $$ListeningAttemptLogsTableAnnotationComposer,
    $$ListeningAttemptLogsTableCreateCompanionBuilder,
    $$ListeningAttemptLogsTableUpdateCompanionBuilder,
    (
      ListeningAttemptLogRow,
      BaseReferences<_$AppDatabase, $ListeningAttemptLogsTable,
          ListeningAttemptLogRow>
    ),
    ListeningAttemptLogRow,
    PrefetchHooks Function()> {
  $$ListeningAttemptLogsTableTableManager(
      _$AppDatabase db, $ListeningAttemptLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListeningAttemptLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListeningAttemptLogsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListeningAttemptLogsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> exerciseId = const Value.absent(),
            Value<double> wordAccuracy = const Value.absent(),
            Value<bool> isExactMatch = const Value.absent(),
            Value<DateTime> attemptedAt = const Value.absent(),
          }) =>
              ListeningAttemptLogsCompanion(
            id: id,
            exerciseId: exerciseId,
            wordAccuracy: wordAccuracy,
            isExactMatch: isExactMatch,
            attemptedAt: attemptedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String exerciseId,
            required double wordAccuracy,
            required bool isExactMatch,
            required DateTime attemptedAt,
          }) =>
              ListeningAttemptLogsCompanion.insert(
            id: id,
            exerciseId: exerciseId,
            wordAccuracy: wordAccuracy,
            isExactMatch: isExactMatch,
            attemptedAt: attemptedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ListeningAttemptLogsTable,
                        ListeningAttemptLogRow>(table),
                    BaseReferences<_$AppDatabase, $ListeningAttemptLogsTable,
                        ListeningAttemptLogRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ListeningAttemptLogsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ListeningAttemptLogsTable,
        ListeningAttemptLogRow,
        $$ListeningAttemptLogsTableFilterComposer,
        $$ListeningAttemptLogsTableOrderingComposer,
        $$ListeningAttemptLogsTableAnnotationComposer,
        $$ListeningAttemptLogsTableCreateCompanionBuilder,
        $$ListeningAttemptLogsTableUpdateCompanionBuilder,
        (
          ListeningAttemptLogRow,
          BaseReferences<_$AppDatabase, $ListeningAttemptLogsTable,
              ListeningAttemptLogRow>
        ),
        ListeningAttemptLogRow,
        PrefetchHooks Function()>;
typedef $$DictionaryEntriesTableCreateCompanionBuilder
    = DictionaryEntriesCompanion Function({
  required String id,
  required String word,
  required String partOfSpeech,
  required String translationRu,
  Value<int> frequencyRank,
  Value<String> dialect,
  Value<String?> examplePt,
  Value<String?> exampleRu,
  Value<String?> notes,
  Value<bool> isCustom,
  Value<int> rowid,
});
typedef $$DictionaryEntriesTableUpdateCompanionBuilder
    = DictionaryEntriesCompanion Function({
  Value<String> id,
  Value<String> word,
  Value<String> partOfSpeech,
  Value<String> translationRu,
  Value<int> frequencyRank,
  Value<String> dialect,
  Value<String?> examplePt,
  Value<String?> exampleRu,
  Value<String?> notes,
  Value<bool> isCustom,
  Value<int> rowid,
});

class $$DictionaryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DictionaryEntriesTable> {
  $$DictionaryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get translationRu => $composableBuilder(
      column: $table.translationRu, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get frequencyRank => $composableBuilder(
      column: $table.frequencyRank, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dialect => $composableBuilder(
      column: $table.dialect, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get examplePt => $composableBuilder(
      column: $table.examplePt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleRu => $composableBuilder(
      column: $table.exampleRu, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnFilters(column));
}

class $$DictionaryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DictionaryEntriesTable> {
  $$DictionaryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get translationRu => $composableBuilder(
      column: $table.translationRu,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get frequencyRank => $composableBuilder(
      column: $table.frequencyRank,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dialect => $composableBuilder(
      column: $table.dialect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get examplePt => $composableBuilder(
      column: $table.examplePt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleRu => $composableBuilder(
      column: $table.exampleRu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnOrderings(column));
}

class $$DictionaryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DictionaryEntriesTable> {
  $$DictionaryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech, builder: (column) => column);

  GeneratedColumn<String> get translationRu => $composableBuilder(
      column: $table.translationRu, builder: (column) => column);

  GeneratedColumn<int> get frequencyRank => $composableBuilder(
      column: $table.frequencyRank, builder: (column) => column);

  GeneratedColumn<String> get dialect =>
      $composableBuilder(column: $table.dialect, builder: (column) => column);

  GeneratedColumn<String> get examplePt =>
      $composableBuilder(column: $table.examplePt, builder: (column) => column);

  GeneratedColumn<String> get exampleRu =>
      $composableBuilder(column: $table.exampleRu, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);
}

class $$DictionaryEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DictionaryEntriesTable,
    DictionaryEntryRow,
    $$DictionaryEntriesTableFilterComposer,
    $$DictionaryEntriesTableOrderingComposer,
    $$DictionaryEntriesTableAnnotationComposer,
    $$DictionaryEntriesTableCreateCompanionBuilder,
    $$DictionaryEntriesTableUpdateCompanionBuilder,
    (
      DictionaryEntryRow,
      BaseReferences<_$AppDatabase, $DictionaryEntriesTable, DictionaryEntryRow>
    ),
    DictionaryEntryRow,
    PrefetchHooks Function()> {
  $$DictionaryEntriesTableTableManager(
      _$AppDatabase db, $DictionaryEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DictionaryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DictionaryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DictionaryEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> word = const Value.absent(),
            Value<String> partOfSpeech = const Value.absent(),
            Value<String> translationRu = const Value.absent(),
            Value<int> frequencyRank = const Value.absent(),
            Value<String> dialect = const Value.absent(),
            Value<String?> examplePt = const Value.absent(),
            Value<String?> exampleRu = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DictionaryEntriesCompanion(
            id: id,
            word: word,
            partOfSpeech: partOfSpeech,
            translationRu: translationRu,
            frequencyRank: frequencyRank,
            dialect: dialect,
            examplePt: examplePt,
            exampleRu: exampleRu,
            notes: notes,
            isCustom: isCustom,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String word,
            required String partOfSpeech,
            required String translationRu,
            Value<int> frequencyRank = const Value.absent(),
            Value<String> dialect = const Value.absent(),
            Value<String?> examplePt = const Value.absent(),
            Value<String?> exampleRu = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DictionaryEntriesCompanion.insert(
            id: id,
            word: word,
            partOfSpeech: partOfSpeech,
            translationRu: translationRu,
            frequencyRank: frequencyRank,
            dialect: dialect,
            examplePt: examplePt,
            exampleRu: exampleRu,
            notes: notes,
            isCustom: isCustom,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DictionaryEntriesTable, DictionaryEntryRow>(
                        table),
                    BaseReferences<_$AppDatabase, $DictionaryEntriesTable,
                        DictionaryEntryRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DictionaryEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DictionaryEntriesTable,
    DictionaryEntryRow,
    $$DictionaryEntriesTableFilterComposer,
    $$DictionaryEntriesTableOrderingComposer,
    $$DictionaryEntriesTableAnnotationComposer,
    $$DictionaryEntriesTableCreateCompanionBuilder,
    $$DictionaryEntriesTableUpdateCompanionBuilder,
    (
      DictionaryEntryRow,
      BaseReferences<_$AppDatabase, $DictionaryEntriesTable, DictionaryEntryRow>
    ),
    DictionaryEntryRow,
    PrefetchHooks Function()>;
typedef $$StoriesTableCreateCompanionBuilder = StoriesCompanion Function({
  required String id,
  required String titlePortuguese,
  required String titleRussian,
  required String dialect,
  required String level,
  required String coverIcon,
  required String description,
  required String contentJson,
  Value<int> rowid,
});
typedef $$StoriesTableUpdateCompanionBuilder = StoriesCompanion Function({
  Value<String> id,
  Value<String> titlePortuguese,
  Value<String> titleRussian,
  Value<String> dialect,
  Value<String> level,
  Value<String> coverIcon,
  Value<String> description,
  Value<String> contentJson,
  Value<int> rowid,
});

class $$StoriesTableFilterComposer
    extends Composer<_$AppDatabase, $StoriesTable> {
  $$StoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titlePortuguese => $composableBuilder(
      column: $table.titlePortuguese,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleRussian => $composableBuilder(
      column: $table.titleRussian, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dialect => $composableBuilder(
      column: $table.dialect, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverIcon => $composableBuilder(
      column: $table.coverIcon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => ColumnFilters(column));
}

class $$StoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StoriesTable> {
  $$StoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titlePortuguese => $composableBuilder(
      column: $table.titlePortuguese,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleRussian => $composableBuilder(
      column: $table.titleRussian,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dialect => $composableBuilder(
      column: $table.dialect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverIcon => $composableBuilder(
      column: $table.coverIcon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => ColumnOrderings(column));
}

class $$StoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoriesTable> {
  $$StoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titlePortuguese => $composableBuilder(
      column: $table.titlePortuguese, builder: (column) => column);

  GeneratedColumn<String> get titleRussian => $composableBuilder(
      column: $table.titleRussian, builder: (column) => column);

  GeneratedColumn<String> get dialect =>
      $composableBuilder(column: $table.dialect, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get coverIcon =>
      $composableBuilder(column: $table.coverIcon, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => column);
}

class $$StoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StoriesTable,
    StoryRow,
    $$StoriesTableFilterComposer,
    $$StoriesTableOrderingComposer,
    $$StoriesTableAnnotationComposer,
    $$StoriesTableCreateCompanionBuilder,
    $$StoriesTableUpdateCompanionBuilder,
    (StoryRow, BaseReferences<_$AppDatabase, $StoriesTable, StoryRow>),
    StoryRow,
    PrefetchHooks Function()> {
  $$StoriesTableTableManager(_$AppDatabase db, $StoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> titlePortuguese = const Value.absent(),
            Value<String> titleRussian = const Value.absent(),
            Value<String> dialect = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> coverIcon = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> contentJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StoriesCompanion(
            id: id,
            titlePortuguese: titlePortuguese,
            titleRussian: titleRussian,
            dialect: dialect,
            level: level,
            coverIcon: coverIcon,
            description: description,
            contentJson: contentJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String titlePortuguese,
            required String titleRussian,
            required String dialect,
            required String level,
            required String coverIcon,
            required String description,
            required String contentJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              StoriesCompanion.insert(
            id: id,
            titlePortuguese: titlePortuguese,
            titleRussian: titleRussian,
            dialect: dialect,
            level: level,
            coverIcon: coverIcon,
            description: description,
            contentJson: contentJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$StoriesTable, StoryRow>(table),
                    BaseReferences<_$AppDatabase, $StoriesTable, StoryRow>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StoriesTable,
    StoryRow,
    $$StoriesTableFilterComposer,
    $$StoriesTableOrderingComposer,
    $$StoriesTableAnnotationComposer,
    $$StoriesTableCreateCompanionBuilder,
    $$StoriesTableUpdateCompanionBuilder,
    (StoryRow, BaseReferences<_$AppDatabase, $StoriesTable, StoryRow>),
    StoryRow,
    PrefetchHooks Function()>;
typedef $$SlangEntriesTableCreateCompanionBuilder = SlangEntriesCompanion
    Function({
  required String id,
  required String expression,
  required String literalTranslation,
  required String actualMeaning,
  required String dialect,
  required String originNotes,
  required String exampleSentence,
  required String exampleTranslation,
  Value<int> rowid,
});
typedef $$SlangEntriesTableUpdateCompanionBuilder = SlangEntriesCompanion
    Function({
  Value<String> id,
  Value<String> expression,
  Value<String> literalTranslation,
  Value<String> actualMeaning,
  Value<String> dialect,
  Value<String> originNotes,
  Value<String> exampleSentence,
  Value<String> exampleTranslation,
  Value<int> rowid,
});

class $$SlangEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SlangEntriesTable> {
  $$SlangEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get expression => $composableBuilder(
      column: $table.expression, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get literalTranslation => $composableBuilder(
      column: $table.literalTranslation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actualMeaning => $composableBuilder(
      column: $table.actualMeaning, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dialect => $composableBuilder(
      column: $table.dialect, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originNotes => $composableBuilder(
      column: $table.originNotes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleSentence => $composableBuilder(
      column: $table.exampleSentence,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleTranslation => $composableBuilder(
      column: $table.exampleTranslation,
      builder: (column) => ColumnFilters(column));
}

class $$SlangEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SlangEntriesTable> {
  $$SlangEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get expression => $composableBuilder(
      column: $table.expression, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get literalTranslation => $composableBuilder(
      column: $table.literalTranslation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actualMeaning => $composableBuilder(
      column: $table.actualMeaning,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dialect => $composableBuilder(
      column: $table.dialect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originNotes => $composableBuilder(
      column: $table.originNotes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleSentence => $composableBuilder(
      column: $table.exampleSentence,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleTranslation => $composableBuilder(
      column: $table.exampleTranslation,
      builder: (column) => ColumnOrderings(column));
}

class $$SlangEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SlangEntriesTable> {
  $$SlangEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get expression => $composableBuilder(
      column: $table.expression, builder: (column) => column);

  GeneratedColumn<String> get literalTranslation => $composableBuilder(
      column: $table.literalTranslation, builder: (column) => column);

  GeneratedColumn<String> get actualMeaning => $composableBuilder(
      column: $table.actualMeaning, builder: (column) => column);

  GeneratedColumn<String> get dialect =>
      $composableBuilder(column: $table.dialect, builder: (column) => column);

  GeneratedColumn<String> get originNotes => $composableBuilder(
      column: $table.originNotes, builder: (column) => column);

  GeneratedColumn<String> get exampleSentence => $composableBuilder(
      column: $table.exampleSentence, builder: (column) => column);

  GeneratedColumn<String> get exampleTranslation => $composableBuilder(
      column: $table.exampleTranslation, builder: (column) => column);
}

class $$SlangEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SlangEntriesTable,
    SlangRow,
    $$SlangEntriesTableFilterComposer,
    $$SlangEntriesTableOrderingComposer,
    $$SlangEntriesTableAnnotationComposer,
    $$SlangEntriesTableCreateCompanionBuilder,
    $$SlangEntriesTableUpdateCompanionBuilder,
    (SlangRow, BaseReferences<_$AppDatabase, $SlangEntriesTable, SlangRow>),
    SlangRow,
    PrefetchHooks Function()> {
  $$SlangEntriesTableTableManager(_$AppDatabase db, $SlangEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SlangEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SlangEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SlangEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> expression = const Value.absent(),
            Value<String> literalTranslation = const Value.absent(),
            Value<String> actualMeaning = const Value.absent(),
            Value<String> dialect = const Value.absent(),
            Value<String> originNotes = const Value.absent(),
            Value<String> exampleSentence = const Value.absent(),
            Value<String> exampleTranslation = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SlangEntriesCompanion(
            id: id,
            expression: expression,
            literalTranslation: literalTranslation,
            actualMeaning: actualMeaning,
            dialect: dialect,
            originNotes: originNotes,
            exampleSentence: exampleSentence,
            exampleTranslation: exampleTranslation,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String expression,
            required String literalTranslation,
            required String actualMeaning,
            required String dialect,
            required String originNotes,
            required String exampleSentence,
            required String exampleTranslation,
            Value<int> rowid = const Value.absent(),
          }) =>
              SlangEntriesCompanion.insert(
            id: id,
            expression: expression,
            literalTranslation: literalTranslation,
            actualMeaning: actualMeaning,
            dialect: dialect,
            originNotes: originNotes,
            exampleSentence: exampleSentence,
            exampleTranslation: exampleTranslation,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SlangEntriesTable, SlangRow>(table),
                    BaseReferences<_$AppDatabase, $SlangEntriesTable, SlangRow>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SlangEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SlangEntriesTable,
    SlangRow,
    $$SlangEntriesTableFilterComposer,
    $$SlangEntriesTableOrderingComposer,
    $$SlangEntriesTableAnnotationComposer,
    $$SlangEntriesTableCreateCompanionBuilder,
    $$SlangEntriesTableUpdateCompanionBuilder,
    (SlangRow, BaseReferences<_$AppDatabase, $SlangEntriesTable, SlangRow>),
    SlangRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DialogueNodesTableTableManager get dialogueNodes =>
      $$DialogueNodesTableTableManager(_db, _db.dialogueNodes);
  $$DialogueHistoryEntriesTableTableManager get dialogueHistoryEntries =>
      $$DialogueHistoryEntriesTableTableManager(
          _db, _db.dialogueHistoryEntries);
  $$SrsCardsTableTableManager get srsCards =>
      $$SrsCardsTableTableManager(_db, _db.srsCards);
  $$SrsReviewLogsTableTableManager get srsReviewLogs =>
      $$SrsReviewLogsTableTableManager(_db, _db.srsReviewLogs);
  $$GrammarVerbsTableTableManager get grammarVerbs =>
      $$GrammarVerbsTableTableManager(_db, _db.grammarVerbs);
  $$GrammarPracticeLogsTableTableManager get grammarPracticeLogs =>
      $$GrammarPracticeLogsTableTableManager(_db, _db.grammarPracticeLogs);
  $$ListeningExercisesTableTableManager get listeningExercises =>
      $$ListeningExercisesTableTableManager(_db, _db.listeningExercises);
  $$ListeningAttemptLogsTableTableManager get listeningAttemptLogs =>
      $$ListeningAttemptLogsTableTableManager(_db, _db.listeningAttemptLogs);
  $$DictionaryEntriesTableTableManager get dictionaryEntries =>
      $$DictionaryEntriesTableTableManager(_db, _db.dictionaryEntries);
  $$StoriesTableTableManager get stories =>
      $$StoriesTableTableManager(_db, _db.stories);
  $$SlangEntriesTableTableManager get slangEntries =>
      $$SlangEntriesTableTableManager(_db, _db.slangEntries);
}
