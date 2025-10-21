// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlayerProfilesTable extends PlayerProfiles
    with TableInfo<$PlayerProfilesTable, PlayerProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarUrlOrProviderMeta =
      const VerificationMeta('avatarUrlOrProvider');
  @override
  late final GeneratedColumn<String> avatarUrlOrProvider =
      GeneratedColumn<String>(
        'avatar_url_or_provider',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _gemsMeta = const VerificationMeta('gems');
  @override
  late final GeneratedColumn<int> gems = GeneratedColumn<int>(
    'gems',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hintsMeta = const VerificationMeta('hints');
  @override
  late final GeneratedColumn<int> hints = GeneratedColumn<int>(
    'hints',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nickname,
    avatarUrlOrProvider,
    gems,
    hints,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('avatar_url_or_provider')) {
      context.handle(
        _avatarUrlOrProviderMeta,
        avatarUrlOrProvider.isAcceptableOrUnknown(
          data['avatar_url_or_provider']!,
          _avatarUrlOrProviderMeta,
        ),
      );
    }
    if (data.containsKey('gems')) {
      context.handle(
        _gemsMeta,
        gems.isAcceptableOrUnknown(data['gems']!, _gemsMeta),
      );
    }
    if (data.containsKey('hints')) {
      context.handle(
        _hintsMeta,
        hints.isAcceptableOrUnknown(data['hints']!, _hintsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      avatarUrlOrProvider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url_or_provider'],
      ),
      gems: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gems'],
      )!,
      hints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hints'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlayerProfilesTable createAlias(String alias) {
    return $PlayerProfilesTable(attachedDatabase, alias);
  }
}

class PlayerProfile extends DataClass implements Insertable<PlayerProfile> {
  final int id;
  final String nickname;
  final String? avatarUrlOrProvider;
  final int gems;
  final int hints;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PlayerProfile({
    required this.id,
    required this.nickname,
    this.avatarUrlOrProvider,
    required this.gems,
    required this.hints,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nickname'] = Variable<String>(nickname);
    if (!nullToAbsent || avatarUrlOrProvider != null) {
      map['avatar_url_or_provider'] = Variable<String>(avatarUrlOrProvider);
    }
    map['gems'] = Variable<int>(gems);
    map['hints'] = Variable<int>(hints);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlayerProfilesCompanion toCompanion(bool nullToAbsent) {
    return PlayerProfilesCompanion(
      id: Value(id),
      nickname: Value(nickname),
      avatarUrlOrProvider: avatarUrlOrProvider == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrlOrProvider),
      gems: Value(gems),
      hints: Value(hints),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlayerProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerProfile(
      id: serializer.fromJson<int>(json['id']),
      nickname: serializer.fromJson<String>(json['nickname']),
      avatarUrlOrProvider: serializer.fromJson<String?>(
        json['avatarUrlOrProvider'],
      ),
      gems: serializer.fromJson<int>(json['gems']),
      hints: serializer.fromJson<int>(json['hints']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nickname': serializer.toJson<String>(nickname),
      'avatarUrlOrProvider': serializer.toJson<String?>(avatarUrlOrProvider),
      'gems': serializer.toJson<int>(gems),
      'hints': serializer.toJson<int>(hints),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlayerProfile copyWith({
    int? id,
    String? nickname,
    Value<String?> avatarUrlOrProvider = const Value.absent(),
    int? gems,
    int? hints,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PlayerProfile(
    id: id ?? this.id,
    nickname: nickname ?? this.nickname,
    avatarUrlOrProvider: avatarUrlOrProvider.present
        ? avatarUrlOrProvider.value
        : this.avatarUrlOrProvider,
    gems: gems ?? this.gems,
    hints: hints ?? this.hints,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlayerProfile copyWithCompanion(PlayerProfilesCompanion data) {
    return PlayerProfile(
      id: data.id.present ? data.id.value : this.id,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      avatarUrlOrProvider: data.avatarUrlOrProvider.present
          ? data.avatarUrlOrProvider.value
          : this.avatarUrlOrProvider,
      gems: data.gems.present ? data.gems.value : this.gems,
      hints: data.hints.present ? data.hints.value : this.hints,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerProfile(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('avatarUrlOrProvider: $avatarUrlOrProvider, ')
          ..write('gems: $gems, ')
          ..write('hints: $hints, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nickname,
    avatarUrlOrProvider,
    gems,
    hints,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerProfile &&
          other.id == this.id &&
          other.nickname == this.nickname &&
          other.avatarUrlOrProvider == this.avatarUrlOrProvider &&
          other.gems == this.gems &&
          other.hints == this.hints &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlayerProfilesCompanion extends UpdateCompanion<PlayerProfile> {
  final Value<int> id;
  final Value<String> nickname;
  final Value<String?> avatarUrlOrProvider;
  final Value<int> gems;
  final Value<int> hints;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PlayerProfilesCompanion({
    this.id = const Value.absent(),
    this.nickname = const Value.absent(),
    this.avatarUrlOrProvider = const Value.absent(),
    this.gems = const Value.absent(),
    this.hints = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PlayerProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String nickname,
    this.avatarUrlOrProvider = const Value.absent(),
    this.gems = const Value.absent(),
    this.hints = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : nickname = Value(nickname);
  static Insertable<PlayerProfile> custom({
    Expression<int>? id,
    Expression<String>? nickname,
    Expression<String>? avatarUrlOrProvider,
    Expression<int>? gems,
    Expression<int>? hints,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nickname != null) 'nickname': nickname,
      if (avatarUrlOrProvider != null)
        'avatar_url_or_provider': avatarUrlOrProvider,
      if (gems != null) 'gems': gems,
      if (hints != null) 'hints': hints,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PlayerProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? nickname,
    Value<String?>? avatarUrlOrProvider,
    Value<int>? gems,
    Value<int>? hints,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PlayerProfilesCompanion(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatarUrlOrProvider: avatarUrlOrProvider ?? this.avatarUrlOrProvider,
      gems: gems ?? this.gems,
      hints: hints ?? this.hints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (avatarUrlOrProvider.present) {
      map['avatar_url_or_provider'] = Variable<String>(
        avatarUrlOrProvider.value,
      );
    }
    if (gems.present) {
      map['gems'] = Variable<int>(gems.value);
    }
    if (hints.present) {
      map['hints'] = Variable<int>(hints.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerProfilesCompanion(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('avatarUrlOrProvider: $avatarUrlOrProvider, ')
          ..write('gems: $gems, ')
          ..write('hints: $hints, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PlayerStatsTable extends PlayerStats
    with TableInfo<$PlayerStatsTable, PlayerStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES player_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _winsMeta = const VerificationMeta('wins');
  @override
  late final GeneratedColumn<int> wins = GeneratedColumn<int>(
    'wins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lossesMeta = const VerificationMeta('losses');
  @override
  late final GeneratedColumn<int> losses = GeneratedColumn<int>(
    'losses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _drawsMeta = const VerificationMeta('draws');
  @override
  late final GeneratedColumn<int> draws = GeneratedColumn<int>(
    'draws',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
    'streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalGamesMeta = const VerificationMeta(
    'totalGames',
  );
  @override
  late final GeneratedColumn<int> totalGames = GeneratedColumn<int>(
    'total_games',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    wins,
    losses,
    draws,
    streak,
    totalGames,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('wins')) {
      context.handle(
        _winsMeta,
        wins.isAcceptableOrUnknown(data['wins']!, _winsMeta),
      );
    }
    if (data.containsKey('losses')) {
      context.handle(
        _lossesMeta,
        losses.isAcceptableOrUnknown(data['losses']!, _lossesMeta),
      );
    }
    if (data.containsKey('draws')) {
      context.handle(
        _drawsMeta,
        draws.isAcceptableOrUnknown(data['draws']!, _drawsMeta),
      );
    }
    if (data.containsKey('streak')) {
      context.handle(
        _streakMeta,
        streak.isAcceptableOrUnknown(data['streak']!, _streakMeta),
      );
    }
    if (data.containsKey('total_games')) {
      context.handle(
        _totalGamesMeta,
        totalGames.isAcceptableOrUnknown(data['total_games']!, _totalGamesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerStat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      wins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wins'],
      )!,
      losses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}losses'],
      )!,
      draws: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}draws'],
      )!,
      streak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak'],
      )!,
      totalGames: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_games'],
      )!,
    );
  }

  @override
  $PlayerStatsTable createAlias(String alias) {
    return $PlayerStatsTable(attachedDatabase, alias);
  }
}

class PlayerStat extends DataClass implements Insertable<PlayerStat> {
  final int id;
  final int profileId;
  final int wins;
  final int losses;
  final int draws;
  final int streak;
  final int totalGames;
  const PlayerStat({
    required this.id,
    required this.profileId,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.streak,
    required this.totalGames,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['wins'] = Variable<int>(wins);
    map['losses'] = Variable<int>(losses);
    map['draws'] = Variable<int>(draws);
    map['streak'] = Variable<int>(streak);
    map['total_games'] = Variable<int>(totalGames);
    return map;
  }

  PlayerStatsCompanion toCompanion(bool nullToAbsent) {
    return PlayerStatsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      wins: Value(wins),
      losses: Value(losses),
      draws: Value(draws),
      streak: Value(streak),
      totalGames: Value(totalGames),
    );
  }

  factory PlayerStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerStat(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      wins: serializer.fromJson<int>(json['wins']),
      losses: serializer.fromJson<int>(json['losses']),
      draws: serializer.fromJson<int>(json['draws']),
      streak: serializer.fromJson<int>(json['streak']),
      totalGames: serializer.fromJson<int>(json['totalGames']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'wins': serializer.toJson<int>(wins),
      'losses': serializer.toJson<int>(losses),
      'draws': serializer.toJson<int>(draws),
      'streak': serializer.toJson<int>(streak),
      'totalGames': serializer.toJson<int>(totalGames),
    };
  }

  PlayerStat copyWith({
    int? id,
    int? profileId,
    int? wins,
    int? losses,
    int? draws,
    int? streak,
    int? totalGames,
  }) => PlayerStat(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    wins: wins ?? this.wins,
    losses: losses ?? this.losses,
    draws: draws ?? this.draws,
    streak: streak ?? this.streak,
    totalGames: totalGames ?? this.totalGames,
  );
  PlayerStat copyWithCompanion(PlayerStatsCompanion data) {
    return PlayerStat(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      wins: data.wins.present ? data.wins.value : this.wins,
      losses: data.losses.present ? data.losses.value : this.losses,
      draws: data.draws.present ? data.draws.value : this.draws,
      streak: data.streak.present ? data.streak.value : this.streak,
      totalGames: data.totalGames.present
          ? data.totalGames.value
          : this.totalGames,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerStat(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('wins: $wins, ')
          ..write('losses: $losses, ')
          ..write('draws: $draws, ')
          ..write('streak: $streak, ')
          ..write('totalGames: $totalGames')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, wins, losses, draws, streak, totalGames);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerStat &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.wins == this.wins &&
          other.losses == this.losses &&
          other.draws == this.draws &&
          other.streak == this.streak &&
          other.totalGames == this.totalGames);
}

class PlayerStatsCompanion extends UpdateCompanion<PlayerStat> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<int> wins;
  final Value<int> losses;
  final Value<int> draws;
  final Value<int> streak;
  final Value<int> totalGames;
  const PlayerStatsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.wins = const Value.absent(),
    this.losses = const Value.absent(),
    this.draws = const Value.absent(),
    this.streak = const Value.absent(),
    this.totalGames = const Value.absent(),
  });
  PlayerStatsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    this.wins = const Value.absent(),
    this.losses = const Value.absent(),
    this.draws = const Value.absent(),
    this.streak = const Value.absent(),
    this.totalGames = const Value.absent(),
  }) : profileId = Value(profileId);
  static Insertable<PlayerStat> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<int>? wins,
    Expression<int>? losses,
    Expression<int>? draws,
    Expression<int>? streak,
    Expression<int>? totalGames,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (wins != null) 'wins': wins,
      if (losses != null) 'losses': losses,
      if (draws != null) 'draws': draws,
      if (streak != null) 'streak': streak,
      if (totalGames != null) 'total_games': totalGames,
    });
  }

  PlayerStatsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<int>? wins,
    Value<int>? losses,
    Value<int>? draws,
    Value<int>? streak,
    Value<int>? totalGames,
  }) {
    return PlayerStatsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
      streak: streak ?? this.streak,
      totalGames: totalGames ?? this.totalGames,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (wins.present) {
      map['wins'] = Variable<int>(wins.value);
    }
    if (losses.present) {
      map['losses'] = Variable<int>(losses.value);
    }
    if (draws.present) {
      map['draws'] = Variable<int>(draws.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (totalGames.present) {
      map['total_games'] = Variable<int>(totalGames.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerStatsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('wins: $wins, ')
          ..write('losses: $losses, ')
          ..write('draws: $draws, ')
          ..write('streak: $streak, ')
          ..write('totalGames: $totalGames')
          ..write(')'))
        .toString();
  }
}

class $GameHistoryTable extends GameHistory
    with TableInfo<$GameHistoryTable, GameHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES player_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _opponentMeta = const VerificationMeta(
    'opponent',
  );
  @override
  late final GeneratedColumn<String> opponent = GeneratedColumn<String>(
    'opponent',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<GameResult, int> result =
      GeneratedColumn<int>(
        'result',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<GameResult>($GameHistoryTable.$converterresult);
  static const VerificationMeta _boardSizeMeta = const VerificationMeta(
    'boardSize',
  );
  @override
  late final GeneratedColumn<String> boardSize = GeneratedColumn<String>(
    'board_size',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 5,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<String> score = GeneratedColumn<String>(
    'score',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playedAtMeta = const VerificationMeta(
    'playedAt',
  );
  @override
  late final GeneratedColumn<DateTime> playedAt = GeneratedColumn<DateTime>(
    'played_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    opponent,
    result,
    boardSize,
    durationSeconds,
    score,
    playedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('opponent')) {
      context.handle(
        _opponentMeta,
        opponent.isAcceptableOrUnknown(data['opponent']!, _opponentMeta),
      );
    } else if (isInserting) {
      context.missing(_opponentMeta);
    }
    if (data.containsKey('board_size')) {
      context.handle(
        _boardSizeMeta,
        boardSize.isAcceptableOrUnknown(data['board_size']!, _boardSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_boardSizeMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('played_at')) {
      context.handle(
        _playedAtMeta,
        playedAt.isAcceptableOrUnknown(data['played_at']!, _playedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      opponent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opponent'],
      )!,
      result: $GameHistoryTable.$converterresult.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}result'],
        )!,
      ),
      boardSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}board_size'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}score'],
      )!,
      playedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}played_at'],
      )!,
    );
  }

  @override
  $GameHistoryTable createAlias(String alias) {
    return $GameHistoryTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GameResult, int, int> $converterresult =
      const EnumIndexConverter<GameResult>(GameResult.values);
}

class GameHistoryData extends DataClass implements Insertable<GameHistoryData> {
  final int id;
  final int profileId;
  final String opponent;
  final GameResult result;
  final String boardSize;
  final int durationSeconds;
  final String score;
  final DateTime playedAt;
  const GameHistoryData({
    required this.id,
    required this.profileId,
    required this.opponent,
    required this.result,
    required this.boardSize,
    required this.durationSeconds,
    required this.score,
    required this.playedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['opponent'] = Variable<String>(opponent);
    {
      map['result'] = Variable<int>(
        $GameHistoryTable.$converterresult.toSql(result),
      );
    }
    map['board_size'] = Variable<String>(boardSize);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['score'] = Variable<String>(score);
    map['played_at'] = Variable<DateTime>(playedAt);
    return map;
  }

  GameHistoryCompanion toCompanion(bool nullToAbsent) {
    return GameHistoryCompanion(
      id: Value(id),
      profileId: Value(profileId),
      opponent: Value(opponent),
      result: Value(result),
      boardSize: Value(boardSize),
      durationSeconds: Value(durationSeconds),
      score: Value(score),
      playedAt: Value(playedAt),
    );
  }

  factory GameHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameHistoryData(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      opponent: serializer.fromJson<String>(json['opponent']),
      result: $GameHistoryTable.$converterresult.fromJson(
        serializer.fromJson<int>(json['result']),
      ),
      boardSize: serializer.fromJson<String>(json['boardSize']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      score: serializer.fromJson<String>(json['score']),
      playedAt: serializer.fromJson<DateTime>(json['playedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'opponent': serializer.toJson<String>(opponent),
      'result': serializer.toJson<int>(
        $GameHistoryTable.$converterresult.toJson(result),
      ),
      'boardSize': serializer.toJson<String>(boardSize),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'score': serializer.toJson<String>(score),
      'playedAt': serializer.toJson<DateTime>(playedAt),
    };
  }

  GameHistoryData copyWith({
    int? id,
    int? profileId,
    String? opponent,
    GameResult? result,
    String? boardSize,
    int? durationSeconds,
    String? score,
    DateTime? playedAt,
  }) => GameHistoryData(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    opponent: opponent ?? this.opponent,
    result: result ?? this.result,
    boardSize: boardSize ?? this.boardSize,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    score: score ?? this.score,
    playedAt: playedAt ?? this.playedAt,
  );
  GameHistoryData copyWithCompanion(GameHistoryCompanion data) {
    return GameHistoryData(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      opponent: data.opponent.present ? data.opponent.value : this.opponent,
      result: data.result.present ? data.result.value : this.result,
      boardSize: data.boardSize.present ? data.boardSize.value : this.boardSize,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      score: data.score.present ? data.score.value : this.score,
      playedAt: data.playedAt.present ? data.playedAt.value : this.playedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameHistoryData(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('opponent: $opponent, ')
          ..write('result: $result, ')
          ..write('boardSize: $boardSize, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('score: $score, ')
          ..write('playedAt: $playedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    opponent,
    result,
    boardSize,
    durationSeconds,
    score,
    playedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameHistoryData &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.opponent == this.opponent &&
          other.result == this.result &&
          other.boardSize == this.boardSize &&
          other.durationSeconds == this.durationSeconds &&
          other.score == this.score &&
          other.playedAt == this.playedAt);
}

class GameHistoryCompanion extends UpdateCompanion<GameHistoryData> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> opponent;
  final Value<GameResult> result;
  final Value<String> boardSize;
  final Value<int> durationSeconds;
  final Value<String> score;
  final Value<DateTime> playedAt;
  const GameHistoryCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.opponent = const Value.absent(),
    this.result = const Value.absent(),
    this.boardSize = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.score = const Value.absent(),
    this.playedAt = const Value.absent(),
  });
  GameHistoryCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String opponent,
    required GameResult result,
    required String boardSize,
    required int durationSeconds,
    required String score,
    this.playedAt = const Value.absent(),
  }) : profileId = Value(profileId),
       opponent = Value(opponent),
       result = Value(result),
       boardSize = Value(boardSize),
       durationSeconds = Value(durationSeconds),
       score = Value(score);
  static Insertable<GameHistoryData> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? opponent,
    Expression<int>? result,
    Expression<String>? boardSize,
    Expression<int>? durationSeconds,
    Expression<String>? score,
    Expression<DateTime>? playedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (opponent != null) 'opponent': opponent,
      if (result != null) 'result': result,
      if (boardSize != null) 'board_size': boardSize,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (score != null) 'score': score,
      if (playedAt != null) 'played_at': playedAt,
    });
  }

  GameHistoryCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? opponent,
    Value<GameResult>? result,
    Value<String>? boardSize,
    Value<int>? durationSeconds,
    Value<String>? score,
    Value<DateTime>? playedAt,
  }) {
    return GameHistoryCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      opponent: opponent ?? this.opponent,
      result: result ?? this.result,
      boardSize: boardSize ?? this.boardSize,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      score: score ?? this.score,
      playedAt: playedAt ?? this.playedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (opponent.present) {
      map['opponent'] = Variable<String>(opponent.value);
    }
    if (result.present) {
      map['result'] = Variable<int>(
        $GameHistoryTable.$converterresult.toSql(result.value),
      );
    }
    if (boardSize.present) {
      map['board_size'] = Variable<String>(boardSize.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (score.present) {
      map['score'] = Variable<String>(score.value);
    }
    if (playedAt.present) {
      map['played_at'] = Variable<DateTime>(playedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameHistoryCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('opponent: $opponent, ')
          ..write('result: $result, ')
          ..write('boardSize: $boardSize, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('score: $score, ')
          ..write('playedAt: $playedAt')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES player_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _achievementIdMeta = const VerificationMeta(
    'achievementId',
  );
  @override
  late final GeneratedColumn<String> achievementId = GeneratedColumn<String>(
    'achievement_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isUnlockedMeta = const VerificationMeta(
    'isUnlocked',
  );
  @override
  late final GeneratedColumn<bool> isUnlocked = GeneratedColumn<bool>(
    'is_unlocked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_unlocked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _unlockedDateMeta = const VerificationMeta(
    'unlockedDate',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedDate = GeneratedColumn<DateTime>(
    'unlocked_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    achievementId,
    isUnlocked,
    progress,
    unlockedDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Achievement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('achievement_id')) {
      context.handle(
        _achievementIdMeta,
        achievementId.isAcceptableOrUnknown(
          data['achievement_id']!,
          _achievementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_achievementIdMeta);
    }
    if (data.containsKey('is_unlocked')) {
      context.handle(
        _isUnlockedMeta,
        isUnlocked.isAcceptableOrUnknown(data['is_unlocked']!, _isUnlockedMeta),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('unlocked_date')) {
      context.handle(
        _unlockedDateMeta,
        unlockedDate.isAcceptableOrUnknown(
          data['unlocked_date']!,
          _unlockedDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      achievementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievement_id'],
      )!,
      isUnlocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_unlocked'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      unlockedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_date'],
      ),
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  final int id;
  final int profileId;
  final String achievementId;
  final bool isUnlocked;
  final int progress;
  final DateTime? unlockedDate;
  const Achievement({
    required this.id,
    required this.profileId,
    required this.achievementId,
    required this.isUnlocked,
    required this.progress,
    this.unlockedDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['achievement_id'] = Variable<String>(achievementId);
    map['is_unlocked'] = Variable<bool>(isUnlocked);
    map['progress'] = Variable<int>(progress);
    if (!nullToAbsent || unlockedDate != null) {
      map['unlocked_date'] = Variable<DateTime>(unlockedDate);
    }
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      achievementId: Value(achievementId),
      isUnlocked: Value(isUnlocked),
      progress: Value(progress),
      unlockedDate: unlockedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedDate),
    );
  }

  factory Achievement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      achievementId: serializer.fromJson<String>(json['achievementId']),
      isUnlocked: serializer.fromJson<bool>(json['isUnlocked']),
      progress: serializer.fromJson<int>(json['progress']),
      unlockedDate: serializer.fromJson<DateTime?>(json['unlockedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'achievementId': serializer.toJson<String>(achievementId),
      'isUnlocked': serializer.toJson<bool>(isUnlocked),
      'progress': serializer.toJson<int>(progress),
      'unlockedDate': serializer.toJson<DateTime?>(unlockedDate),
    };
  }

  Achievement copyWith({
    int? id,
    int? profileId,
    String? achievementId,
    bool? isUnlocked,
    int? progress,
    Value<DateTime?> unlockedDate = const Value.absent(),
  }) => Achievement(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    achievementId: achievementId ?? this.achievementId,
    isUnlocked: isUnlocked ?? this.isUnlocked,
    progress: progress ?? this.progress,
    unlockedDate: unlockedDate.present ? unlockedDate.value : this.unlockedDate,
  );
  Achievement copyWithCompanion(AchievementsCompanion data) {
    return Achievement(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      achievementId: data.achievementId.present
          ? data.achievementId.value
          : this.achievementId,
      isUnlocked: data.isUnlocked.present
          ? data.isUnlocked.value
          : this.isUnlocked,
      progress: data.progress.present ? data.progress.value : this.progress,
      unlockedDate: data.unlockedDate.present
          ? data.unlockedDate.value
          : this.unlockedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('achievementId: $achievementId, ')
          ..write('isUnlocked: $isUnlocked, ')
          ..write('progress: $progress, ')
          ..write('unlockedDate: $unlockedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    achievementId,
    isUnlocked,
    progress,
    unlockedDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.achievementId == this.achievementId &&
          other.isUnlocked == this.isUnlocked &&
          other.progress == this.progress &&
          other.unlockedDate == this.unlockedDate);
}

class AchievementsCompanion extends UpdateCompanion<Achievement> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> achievementId;
  final Value<bool> isUnlocked;
  final Value<int> progress;
  final Value<DateTime?> unlockedDate;
  const AchievementsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.achievementId = const Value.absent(),
    this.isUnlocked = const Value.absent(),
    this.progress = const Value.absent(),
    this.unlockedDate = const Value.absent(),
  });
  AchievementsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String achievementId,
    this.isUnlocked = const Value.absent(),
    this.progress = const Value.absent(),
    this.unlockedDate = const Value.absent(),
  }) : profileId = Value(profileId),
       achievementId = Value(achievementId);
  static Insertable<Achievement> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? achievementId,
    Expression<bool>? isUnlocked,
    Expression<int>? progress,
    Expression<DateTime>? unlockedDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (achievementId != null) 'achievement_id': achievementId,
      if (isUnlocked != null) 'is_unlocked': isUnlocked,
      if (progress != null) 'progress': progress,
      if (unlockedDate != null) 'unlocked_date': unlockedDate,
    });
  }

  AchievementsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? achievementId,
    Value<bool>? isUnlocked,
    Value<int>? progress,
    Value<DateTime?>? unlockedDate,
  }) {
    return AchievementsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      achievementId: achievementId ?? this.achievementId,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      progress: progress ?? this.progress,
      unlockedDate: unlockedDate ?? this.unlockedDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (achievementId.present) {
      map['achievement_id'] = Variable<String>(achievementId.value);
    }
    if (isUnlocked.present) {
      map['is_unlocked'] = Variable<bool>(isUnlocked.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (unlockedDate.present) {
      map['unlocked_date'] = Variable<DateTime>(unlockedDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('achievementId: $achievementId, ')
          ..write('isUnlocked: $isUnlocked, ')
          ..write('progress: $progress, ')
          ..write('unlockedDate: $unlockedDate')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _soundEnabledMeta = const VerificationMeta(
    'soundEnabled',
  );
  @override
  late final GeneratedColumn<bool> soundEnabled = GeneratedColumn<bool>(
    'sound_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _musicEnabledMeta = const VerificationMeta(
    'musicEnabled',
  );
  @override
  late final GeneratedColumn<bool> musicEnabled = GeneratedColumn<bool>(
    'music_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("music_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _vibrationEnabledMeta = const VerificationMeta(
    'vibrationEnabled',
  );
  @override
  late final GeneratedColumn<bool> vibrationEnabled = GeneratedColumn<bool>(
    'vibration_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vibration_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hapticFeedbackEnabledMeta =
      const VerificationMeta('hapticFeedbackEnabled');
  @override
  late final GeneratedColumn<bool> hapticFeedbackEnabled =
      GeneratedColumn<bool>(
        'haptic_feedback_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("haptic_feedback_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _autoSaveEnabledMeta = const VerificationMeta(
    'autoSaveEnabled',
  );
  @override
  late final GeneratedColumn<bool> autoSaveEnabled = GeneratedColumn<bool>(
    'auto_save_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_save_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    soundEnabled,
    musicEnabled,
    vibrationEnabled,
    hapticFeedbackEnabled,
    autoSaveEnabled,
    notificationsEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sound_enabled')) {
      context.handle(
        _soundEnabledMeta,
        soundEnabled.isAcceptableOrUnknown(
          data['sound_enabled']!,
          _soundEnabledMeta,
        ),
      );
    }
    if (data.containsKey('music_enabled')) {
      context.handle(
        _musicEnabledMeta,
        musicEnabled.isAcceptableOrUnknown(
          data['music_enabled']!,
          _musicEnabledMeta,
        ),
      );
    }
    if (data.containsKey('vibration_enabled')) {
      context.handle(
        _vibrationEnabledMeta,
        vibrationEnabled.isAcceptableOrUnknown(
          data['vibration_enabled']!,
          _vibrationEnabledMeta,
        ),
      );
    }
    if (data.containsKey('haptic_feedback_enabled')) {
      context.handle(
        _hapticFeedbackEnabledMeta,
        hapticFeedbackEnabled.isAcceptableOrUnknown(
          data['haptic_feedback_enabled']!,
          _hapticFeedbackEnabledMeta,
        ),
      );
    }
    if (data.containsKey('auto_save_enabled')) {
      context.handle(
        _autoSaveEnabledMeta,
        autoSaveEnabled.isAcceptableOrUnknown(
          data['auto_save_enabled']!,
          _autoSaveEnabledMeta,
        ),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      soundEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound_enabled'],
      )!,
      musicEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}music_enabled'],
      )!,
      vibrationEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vibration_enabled'],
      )!,
      hapticFeedbackEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}haptic_feedback_enabled'],
      )!,
      autoSaveEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_save_enabled'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final bool soundEnabled;
  final bool musicEnabled;
  final bool vibrationEnabled;
  final bool hapticFeedbackEnabled;
  final bool autoSaveEnabled;
  final bool notificationsEnabled;
  const AppSetting({
    required this.id,
    required this.soundEnabled,
    required this.musicEnabled,
    required this.vibrationEnabled,
    required this.hapticFeedbackEnabled,
    required this.autoSaveEnabled,
    required this.notificationsEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sound_enabled'] = Variable<bool>(soundEnabled);
    map['music_enabled'] = Variable<bool>(musicEnabled);
    map['vibration_enabled'] = Variable<bool>(vibrationEnabled);
    map['haptic_feedback_enabled'] = Variable<bool>(hapticFeedbackEnabled);
    map['auto_save_enabled'] = Variable<bool>(autoSaveEnabled);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      soundEnabled: Value(soundEnabled),
      musicEnabled: Value(musicEnabled),
      vibrationEnabled: Value(vibrationEnabled),
      hapticFeedbackEnabled: Value(hapticFeedbackEnabled),
      autoSaveEnabled: Value(autoSaveEnabled),
      notificationsEnabled: Value(notificationsEnabled),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      soundEnabled: serializer.fromJson<bool>(json['soundEnabled']),
      musicEnabled: serializer.fromJson<bool>(json['musicEnabled']),
      vibrationEnabled: serializer.fromJson<bool>(json['vibrationEnabled']),
      hapticFeedbackEnabled: serializer.fromJson<bool>(
        json['hapticFeedbackEnabled'],
      ),
      autoSaveEnabled: serializer.fromJson<bool>(json['autoSaveEnabled']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'soundEnabled': serializer.toJson<bool>(soundEnabled),
      'musicEnabled': serializer.toJson<bool>(musicEnabled),
      'vibrationEnabled': serializer.toJson<bool>(vibrationEnabled),
      'hapticFeedbackEnabled': serializer.toJson<bool>(hapticFeedbackEnabled),
      'autoSaveEnabled': serializer.toJson<bool>(autoSaveEnabled),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
    };
  }

  AppSetting copyWith({
    int? id,
    bool? soundEnabled,
    bool? musicEnabled,
    bool? vibrationEnabled,
    bool? hapticFeedbackEnabled,
    bool? autoSaveEnabled,
    bool? notificationsEnabled,
  }) => AppSetting(
    id: id ?? this.id,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    musicEnabled: musicEnabled ?? this.musicEnabled,
    vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
    autoSaveEnabled: autoSaveEnabled ?? this.autoSaveEnabled,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      soundEnabled: data.soundEnabled.present
          ? data.soundEnabled.value
          : this.soundEnabled,
      musicEnabled: data.musicEnabled.present
          ? data.musicEnabled.value
          : this.musicEnabled,
      vibrationEnabled: data.vibrationEnabled.present
          ? data.vibrationEnabled.value
          : this.vibrationEnabled,
      hapticFeedbackEnabled: data.hapticFeedbackEnabled.present
          ? data.hapticFeedbackEnabled.value
          : this.hapticFeedbackEnabled,
      autoSaveEnabled: data.autoSaveEnabled.present
          ? data.autoSaveEnabled.value
          : this.autoSaveEnabled,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('musicEnabled: $musicEnabled, ')
          ..write('vibrationEnabled: $vibrationEnabled, ')
          ..write('hapticFeedbackEnabled: $hapticFeedbackEnabled, ')
          ..write('autoSaveEnabled: $autoSaveEnabled, ')
          ..write('notificationsEnabled: $notificationsEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    soundEnabled,
    musicEnabled,
    vibrationEnabled,
    hapticFeedbackEnabled,
    autoSaveEnabled,
    notificationsEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.soundEnabled == this.soundEnabled &&
          other.musicEnabled == this.musicEnabled &&
          other.vibrationEnabled == this.vibrationEnabled &&
          other.hapticFeedbackEnabled == this.hapticFeedbackEnabled &&
          other.autoSaveEnabled == this.autoSaveEnabled &&
          other.notificationsEnabled == this.notificationsEnabled);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<bool> soundEnabled;
  final Value<bool> musicEnabled;
  final Value<bool> vibrationEnabled;
  final Value<bool> hapticFeedbackEnabled;
  final Value<bool> autoSaveEnabled;
  final Value<bool> notificationsEnabled;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.musicEnabled = const Value.absent(),
    this.vibrationEnabled = const Value.absent(),
    this.hapticFeedbackEnabled = const Value.absent(),
    this.autoSaveEnabled = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.musicEnabled = const Value.absent(),
    this.vibrationEnabled = const Value.absent(),
    this.hapticFeedbackEnabled = const Value.absent(),
    this.autoSaveEnabled = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<bool>? soundEnabled,
    Expression<bool>? musicEnabled,
    Expression<bool>? vibrationEnabled,
    Expression<bool>? hapticFeedbackEnabled,
    Expression<bool>? autoSaveEnabled,
    Expression<bool>? notificationsEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (musicEnabled != null) 'music_enabled': musicEnabled,
      if (vibrationEnabled != null) 'vibration_enabled': vibrationEnabled,
      if (hapticFeedbackEnabled != null)
        'haptic_feedback_enabled': hapticFeedbackEnabled,
      if (autoSaveEnabled != null) 'auto_save_enabled': autoSaveEnabled,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? soundEnabled,
    Value<bool>? musicEnabled,
    Value<bool>? vibrationEnabled,
    Value<bool>? hapticFeedbackEnabled,
    Value<bool>? autoSaveEnabled,
    Value<bool>? notificationsEnabled,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      autoSaveEnabled: autoSaveEnabled ?? this.autoSaveEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (soundEnabled.present) {
      map['sound_enabled'] = Variable<bool>(soundEnabled.value);
    }
    if (musicEnabled.present) {
      map['music_enabled'] = Variable<bool>(musicEnabled.value);
    }
    if (vibrationEnabled.present) {
      map['vibration_enabled'] = Variable<bool>(vibrationEnabled.value);
    }
    if (hapticFeedbackEnabled.present) {
      map['haptic_feedback_enabled'] = Variable<bool>(
        hapticFeedbackEnabled.value,
      );
    }
    if (autoSaveEnabled.present) {
      map['auto_save_enabled'] = Variable<bool>(autoSaveEnabled.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('musicEnabled: $musicEnabled, ')
          ..write('vibrationEnabled: $vibrationEnabled, ')
          ..write('hapticFeedbackEnabled: $hapticFeedbackEnabled, ')
          ..write('autoSaveEnabled: $autoSaveEnabled, ')
          ..write('notificationsEnabled: $notificationsEnabled')
          ..write(')'))
        .toString();
  }
}

class $ThemeSettingsTable extends ThemeSettings
    with TableInfo<$ThemeSettingsTable, ThemeSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThemeSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<int> themeMode = GeneratedColumn<int>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  @override
  List<GeneratedColumn> get $columns => [id, themeMode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'theme_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ThemeSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ThemeSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThemeSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}theme_mode'],
      )!,
    );
  }

  @override
  $ThemeSettingsTable createAlias(String alias) {
    return $ThemeSettingsTable(attachedDatabase, alias);
  }
}

class ThemeSetting extends DataClass implements Insertable<ThemeSetting> {
  final int id;
  final int themeMode;
  const ThemeSetting({required this.id, required this.themeMode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<int>(themeMode);
    return map;
  }

  ThemeSettingsCompanion toCompanion(bool nullToAbsent) {
    return ThemeSettingsCompanion(id: Value(id), themeMode: Value(themeMode));
  }

  factory ThemeSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThemeSetting(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<int>(json['themeMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<int>(themeMode),
    };
  }

  ThemeSetting copyWith({int? id, int? themeMode}) =>
      ThemeSetting(id: id ?? this.id, themeMode: themeMode ?? this.themeMode);
  ThemeSetting copyWithCompanion(ThemeSettingsCompanion data) {
    return ThemeSetting(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThemeSetting(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, themeMode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThemeSetting &&
          other.id == this.id &&
          other.themeMode == this.themeMode);
}

class ThemeSettingsCompanion extends UpdateCompanion<ThemeSetting> {
  final Value<int> id;
  final Value<int> themeMode;
  const ThemeSettingsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
  });
  ThemeSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
  });
  static Insertable<ThemeSetting> custom({
    Expression<int>? id,
    Expression<int>? themeMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
    });
  }

  ThemeSettingsCompanion copyWith({Value<int>? id, Value<int>? themeMode}) {
    return ThemeSettingsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<int>(themeMode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThemeSettingsCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode')
          ..write(')'))
        .toString();
  }
}

class $StoreItemsTable extends StoreItems
    with TableInfo<$StoreItemsTable, StoreItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoreItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES player_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _purchasedDateMeta = const VerificationMeta(
    'purchasedDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedDate =
      GeneratedColumn<DateTime>(
        'purchased_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    itemId,
    quantity,
    purchasedDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'store_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoreItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('purchased_date')) {
      context.handle(
        _purchasedDateMeta,
        purchasedDate.isAcceptableOrUnknown(
          data['purchased_date']!,
          _purchasedDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoreItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoreItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      purchasedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_date'],
      )!,
    );
  }

  @override
  $StoreItemsTable createAlias(String alias) {
    return $StoreItemsTable(attachedDatabase, alias);
  }
}

class StoreItem extends DataClass implements Insertable<StoreItem> {
  final int id;
  final int profileId;
  final String itemId;
  final int quantity;
  final DateTime purchasedDate;
  const StoreItem({
    required this.id,
    required this.profileId,
    required this.itemId,
    required this.quantity,
    required this.purchasedDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['item_id'] = Variable<String>(itemId);
    map['quantity'] = Variable<int>(quantity);
    map['purchased_date'] = Variable<DateTime>(purchasedDate);
    return map;
  }

  StoreItemsCompanion toCompanion(bool nullToAbsent) {
    return StoreItemsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      itemId: Value(itemId),
      quantity: Value(quantity),
      purchasedDate: Value(purchasedDate),
    );
  }

  factory StoreItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoreItem(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      purchasedDate: serializer.fromJson<DateTime>(json['purchasedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'itemId': serializer.toJson<String>(itemId),
      'quantity': serializer.toJson<int>(quantity),
      'purchasedDate': serializer.toJson<DateTime>(purchasedDate),
    };
  }

  StoreItem copyWith({
    int? id,
    int? profileId,
    String? itemId,
    int? quantity,
    DateTime? purchasedDate,
  }) => StoreItem(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    itemId: itemId ?? this.itemId,
    quantity: quantity ?? this.quantity,
    purchasedDate: purchasedDate ?? this.purchasedDate,
  );
  StoreItem copyWithCompanion(StoreItemsCompanion data) {
    return StoreItem(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      purchasedDate: data.purchasedDate.present
          ? data.purchasedDate.value
          : this.purchasedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoreItem(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('itemId: $itemId, ')
          ..write('quantity: $quantity, ')
          ..write('purchasedDate: $purchasedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, itemId, quantity, purchasedDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoreItem &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.itemId == this.itemId &&
          other.quantity == this.quantity &&
          other.purchasedDate == this.purchasedDate);
}

class StoreItemsCompanion extends UpdateCompanion<StoreItem> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> itemId;
  final Value<int> quantity;
  final Value<DateTime> purchasedDate;
  const StoreItemsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.purchasedDate = const Value.absent(),
  });
  StoreItemsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String itemId,
    this.quantity = const Value.absent(),
    this.purchasedDate = const Value.absent(),
  }) : profileId = Value(profileId),
       itemId = Value(itemId);
  static Insertable<StoreItem> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? itemId,
    Expression<int>? quantity,
    Expression<DateTime>? purchasedDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (itemId != null) 'item_id': itemId,
      if (quantity != null) 'quantity': quantity,
      if (purchasedDate != null) 'purchased_date': purchasedDate,
    });
  }

  StoreItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? itemId,
    Value<int>? quantity,
    Value<DateTime>? purchasedDate,
  }) {
    return StoreItemsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      itemId: itemId ?? this.itemId,
      quantity: quantity ?? this.quantity,
      purchasedDate: purchasedDate ?? this.purchasedDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (purchasedDate.present) {
      map['purchased_date'] = Variable<DateTime>(purchasedDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoreItemsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('itemId: $itemId, ')
          ..write('quantity: $quantity, ')
          ..write('purchasedDate: $purchasedDate')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlayerProfilesTable playerProfiles = $PlayerProfilesTable(this);
  late final $PlayerStatsTable playerStats = $PlayerStatsTable(this);
  late final $GameHistoryTable gameHistory = $GameHistoryTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $ThemeSettingsTable themeSettings = $ThemeSettingsTable(this);
  late final $StoreItemsTable storeItems = $StoreItemsTable(this);
  late final Index playerProfilesNicknameIdx = Index(
    'player_profiles_nickname_idx',
    'CREATE INDEX player_profiles_nickname_idx ON player_profiles (nickname)',
  );
  late final Index playerProfilesCreatedAtIdx = Index(
    'player_profiles_created_at_idx',
    'CREATE INDEX player_profiles_created_at_idx ON player_profiles (created_at)',
  );
  late final Index playerStatsProfileIdIdx = Index(
    'player_stats_profile_id_idx',
    'CREATE INDEX player_stats_profile_id_idx ON player_stats (profile_id)',
  );
  late final Index playerStatsTotalGamesIdx = Index(
    'player_stats_total_games_idx',
    'CREATE INDEX player_stats_total_games_idx ON player_stats (total_games)',
  );
  late final Index gameHistoryProfileIdIdx = Index(
    'game_history_profile_id_idx',
    'CREATE INDEX game_history_profile_id_idx ON game_history (profile_id)',
  );
  late final Index gameHistoryPlayedAtIdx = Index(
    'game_history_played_at_idx',
    'CREATE INDEX game_history_played_at_idx ON game_history (played_at)',
  );
  late final Index gameHistoryResultIdx = Index(
    'game_history_result_idx',
    'CREATE INDEX game_history_result_idx ON game_history (result)',
  );
  late final Index gameHistoryOpponentIdx = Index(
    'game_history_opponent_idx',
    'CREATE INDEX game_history_opponent_idx ON game_history (opponent)',
  );
  late final Index achievementsProfileIdIdx = Index(
    'achievements_profile_id_idx',
    'CREATE INDEX achievements_profile_id_idx ON achievements (profile_id)',
  );
  late final Index achievementsAchievementIdIdx = Index(
    'achievements_achievement_id_idx',
    'CREATE INDEX achievements_achievement_id_idx ON achievements (achievement_id)',
  );
  late final Index achievementsIsUnlockedIdx = Index(
    'achievements_is_unlocked_idx',
    'CREATE INDEX achievements_is_unlocked_idx ON achievements (is_unlocked)',
  );
  late final Index achievementsUnlockedDateIdx = Index(
    'achievements_unlocked_date_idx',
    'CREATE INDEX achievements_unlocked_date_idx ON achievements (unlocked_date)',
  );
  late final Index storeItemsProfileIdIdx = Index(
    'store_items_profile_id_idx',
    'CREATE INDEX store_items_profile_id_idx ON store_items (profile_id)',
  );
  late final Index storeItemsItemIdIdx = Index(
    'store_items_item_id_idx',
    'CREATE INDEX store_items_item_id_idx ON store_items (item_id)',
  );
  late final Index storeItemsPurchasedDateIdx = Index(
    'store_items_purchased_date_idx',
    'CREATE INDEX store_items_purchased_date_idx ON store_items (purchased_date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    playerProfiles,
    playerStats,
    gameHistory,
    achievements,
    appSettings,
    themeSettings,
    storeItems,
    playerProfilesNicknameIdx,
    playerProfilesCreatedAtIdx,
    playerStatsProfileIdIdx,
    playerStatsTotalGamesIdx,
    gameHistoryProfileIdIdx,
    gameHistoryPlayedAtIdx,
    gameHistoryResultIdx,
    gameHistoryOpponentIdx,
    achievementsProfileIdIdx,
    achievementsAchievementIdIdx,
    achievementsIsUnlockedIdx,
    achievementsUnlockedDateIdx,
    storeItemsProfileIdIdx,
    storeItemsItemIdIdx,
    storeItemsPurchasedDateIdx,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'player_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('player_stats', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'player_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('game_history', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'player_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('achievements', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'player_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('store_items', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$PlayerProfilesTableCreateCompanionBuilder =
    PlayerProfilesCompanion Function({
      Value<int> id,
      required String nickname,
      Value<String?> avatarUrlOrProvider,
      Value<int> gems,
      Value<int> hints,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PlayerProfilesTableUpdateCompanionBuilder =
    PlayerProfilesCompanion Function({
      Value<int> id,
      Value<String> nickname,
      Value<String?> avatarUrlOrProvider,
      Value<int> gems,
      Value<int> hints,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$PlayerProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $PlayerProfilesTable, PlayerProfile> {
  $$PlayerProfilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PlayerStatsTable, List<PlayerStat>>
  _playerStatsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playerStats,
    aliasName: $_aliasNameGenerator(
      db.playerProfiles.id,
      db.playerStats.profileId,
    ),
  );

  $$PlayerStatsTableProcessedTableManager get playerStatsRefs {
    final manager = $$PlayerStatsTableTableManager(
      $_db,
      $_db.playerStats,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playerStatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GameHistoryTable, List<GameHistoryData>>
  _gameHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gameHistory,
    aliasName: $_aliasNameGenerator(
      db.playerProfiles.id,
      db.gameHistory.profileId,
    ),
  );

  $$GameHistoryTableProcessedTableManager get gameHistoryRefs {
    final manager = $$GameHistoryTableTableManager(
      $_db,
      $_db.gameHistory,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gameHistoryRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AchievementsTable, List<Achievement>>
  _achievementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.achievements,
    aliasName: $_aliasNameGenerator(
      db.playerProfiles.id,
      db.achievements.profileId,
    ),
  );

  $$AchievementsTableProcessedTableManager get achievementsRefs {
    final manager = $$AchievementsTableTableManager(
      $_db,
      $_db.achievements,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_achievementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StoreItemsTable, List<StoreItem>>
  _storeItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storeItems,
    aliasName: $_aliasNameGenerator(
      db.playerProfiles.id,
      db.storeItems.profileId,
    ),
  );

  $$StoreItemsTableProcessedTableManager get storeItemsRefs {
    final manager = $$StoreItemsTableTableManager(
      $_db,
      $_db.storeItems,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_storeItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlayerProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerProfilesTable> {
  $$PlayerProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrlOrProvider => $composableBuilder(
    column: $table.avatarUrlOrProvider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gems => $composableBuilder(
    column: $table.gems,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hints => $composableBuilder(
    column: $table.hints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> playerStatsRefs(
    Expression<bool> Function($$PlayerStatsTableFilterComposer f) f,
  ) {
    final $$PlayerStatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playerStats,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerStatsTableFilterComposer(
            $db: $db,
            $table: $db.playerStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> gameHistoryRefs(
    Expression<bool> Function($$GameHistoryTableFilterComposer f) f,
  ) {
    final $$GameHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gameHistory,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameHistoryTableFilterComposer(
            $db: $db,
            $table: $db.gameHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> achievementsRefs(
    Expression<bool> Function($$AchievementsTableFilterComposer f) f,
  ) {
    final $$AchievementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.achievements,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AchievementsTableFilterComposer(
            $db: $db,
            $table: $db.achievements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> storeItemsRefs(
    Expression<bool> Function($$StoreItemsTableFilterComposer f) f,
  ) {
    final $$StoreItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storeItems,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoreItemsTableFilterComposer(
            $db: $db,
            $table: $db.storeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayerProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerProfilesTable> {
  $$PlayerProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrlOrProvider => $composableBuilder(
    column: $table.avatarUrlOrProvider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gems => $composableBuilder(
    column: $table.gems,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hints => $composableBuilder(
    column: $table.hints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayerProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerProfilesTable> {
  $$PlayerProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get avatarUrlOrProvider => $composableBuilder(
    column: $table.avatarUrlOrProvider,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gems =>
      $composableBuilder(column: $table.gems, builder: (column) => column);

  GeneratedColumn<int> get hints =>
      $composableBuilder(column: $table.hints, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> playerStatsRefs<T extends Object>(
    Expression<T> Function($$PlayerStatsTableAnnotationComposer a) f,
  ) {
    final $$PlayerStatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playerStats,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerStatsTableAnnotationComposer(
            $db: $db,
            $table: $db.playerStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> gameHistoryRefs<T extends Object>(
    Expression<T> Function($$GameHistoryTableAnnotationComposer a) f,
  ) {
    final $$GameHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gameHistory,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.gameHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> achievementsRefs<T extends Object>(
    Expression<T> Function($$AchievementsTableAnnotationComposer a) f,
  ) {
    final $$AchievementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.achievements,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AchievementsTableAnnotationComposer(
            $db: $db,
            $table: $db.achievements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> storeItemsRefs<T extends Object>(
    Expression<T> Function($$StoreItemsTableAnnotationComposer a) f,
  ) {
    final $$StoreItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storeItems,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoreItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.storeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayerProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayerProfilesTable,
          PlayerProfile,
          $$PlayerProfilesTableFilterComposer,
          $$PlayerProfilesTableOrderingComposer,
          $$PlayerProfilesTableAnnotationComposer,
          $$PlayerProfilesTableCreateCompanionBuilder,
          $$PlayerProfilesTableUpdateCompanionBuilder,
          (PlayerProfile, $$PlayerProfilesTableReferences),
          PlayerProfile,
          PrefetchHooks Function({
            bool playerStatsRefs,
            bool gameHistoryRefs,
            bool achievementsRefs,
            bool storeItemsRefs,
          })
        > {
  $$PlayerProfilesTableTableManager(
    _$AppDatabase db,
    $PlayerProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String?> avatarUrlOrProvider = const Value.absent(),
                Value<int> gems = const Value.absent(),
                Value<int> hints = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PlayerProfilesCompanion(
                id: id,
                nickname: nickname,
                avatarUrlOrProvider: avatarUrlOrProvider,
                gems: gems,
                hints: hints,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nickname,
                Value<String?> avatarUrlOrProvider = const Value.absent(),
                Value<int> gems = const Value.absent(),
                Value<int> hints = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PlayerProfilesCompanion.insert(
                id: id,
                nickname: nickname,
                avatarUrlOrProvider: avatarUrlOrProvider,
                gems: gems,
                hints: hints,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayerProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                playerStatsRefs = false,
                gameHistoryRefs = false,
                achievementsRefs = false,
                storeItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (playerStatsRefs) db.playerStats,
                    if (gameHistoryRefs) db.gameHistory,
                    if (achievementsRefs) db.achievements,
                    if (storeItemsRefs) db.storeItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (playerStatsRefs)
                        await $_getPrefetchedData<
                          PlayerProfile,
                          $PlayerProfilesTable,
                          PlayerStat
                        >(
                          currentTable: table,
                          referencedTable: $$PlayerProfilesTableReferences
                              ._playerStatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayerProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).playerStatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (gameHistoryRefs)
                        await $_getPrefetchedData<
                          PlayerProfile,
                          $PlayerProfilesTable,
                          GameHistoryData
                        >(
                          currentTable: table,
                          referencedTable: $$PlayerProfilesTableReferences
                              ._gameHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayerProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).gameHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (achievementsRefs)
                        await $_getPrefetchedData<
                          PlayerProfile,
                          $PlayerProfilesTable,
                          Achievement
                        >(
                          currentTable: table,
                          referencedTable: $$PlayerProfilesTableReferences
                              ._achievementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayerProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).achievementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (storeItemsRefs)
                        await $_getPrefetchedData<
                          PlayerProfile,
                          $PlayerProfilesTable,
                          StoreItem
                        >(
                          currentTable: table,
                          referencedTable: $$PlayerProfilesTableReferences
                              ._storeItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayerProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).storeItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlayerProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayerProfilesTable,
      PlayerProfile,
      $$PlayerProfilesTableFilterComposer,
      $$PlayerProfilesTableOrderingComposer,
      $$PlayerProfilesTableAnnotationComposer,
      $$PlayerProfilesTableCreateCompanionBuilder,
      $$PlayerProfilesTableUpdateCompanionBuilder,
      (PlayerProfile, $$PlayerProfilesTableReferences),
      PlayerProfile,
      PrefetchHooks Function({
        bool playerStatsRefs,
        bool gameHistoryRefs,
        bool achievementsRefs,
        bool storeItemsRefs,
      })
    >;
typedef $$PlayerStatsTableCreateCompanionBuilder =
    PlayerStatsCompanion Function({
      Value<int> id,
      required int profileId,
      Value<int> wins,
      Value<int> losses,
      Value<int> draws,
      Value<int> streak,
      Value<int> totalGames,
    });
typedef $$PlayerStatsTableUpdateCompanionBuilder =
    PlayerStatsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<int> wins,
      Value<int> losses,
      Value<int> draws,
      Value<int> streak,
      Value<int> totalGames,
    });

final class $$PlayerStatsTableReferences
    extends BaseReferences<_$AppDatabase, $PlayerStatsTable, PlayerStat> {
  $$PlayerStatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlayerProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.playerProfiles.createAlias(
        $_aliasNameGenerator(db.playerStats.profileId, db.playerProfiles.id),
      );

  $$PlayerProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$PlayerProfilesTableTableManager(
      $_db,
      $_db.playerProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlayerStatsTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerStatsTable> {
  $$PlayerStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wins => $composableBuilder(
    column: $table.wins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get losses => $composableBuilder(
    column: $table.losses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get draws => $composableBuilder(
    column: $table.draws,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalGames => $composableBuilder(
    column: $table.totalGames,
    builder: (column) => ColumnFilters(column),
  );

  $$PlayerProfilesTableFilterComposer get profileId {
    final $$PlayerProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.playerProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerProfilesTableFilterComposer(
            $db: $db,
            $table: $db.playerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayerStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerStatsTable> {
  $$PlayerStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wins => $composableBuilder(
    column: $table.wins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get losses => $composableBuilder(
    column: $table.losses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get draws => $composableBuilder(
    column: $table.draws,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalGames => $composableBuilder(
    column: $table.totalGames,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlayerProfilesTableOrderingComposer get profileId {
    final $$PlayerProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.playerProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.playerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayerStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerStatsTable> {
  $$PlayerStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get wins =>
      $composableBuilder(column: $table.wins, builder: (column) => column);

  GeneratedColumn<int> get losses =>
      $composableBuilder(column: $table.losses, builder: (column) => column);

  GeneratedColumn<int> get draws =>
      $composableBuilder(column: $table.draws, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<int> get totalGames => $composableBuilder(
    column: $table.totalGames,
    builder: (column) => column,
  );

  $$PlayerProfilesTableAnnotationComposer get profileId {
    final $$PlayerProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.playerProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.playerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayerStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayerStatsTable,
          PlayerStat,
          $$PlayerStatsTableFilterComposer,
          $$PlayerStatsTableOrderingComposer,
          $$PlayerStatsTableAnnotationComposer,
          $$PlayerStatsTableCreateCompanionBuilder,
          $$PlayerStatsTableUpdateCompanionBuilder,
          (PlayerStat, $$PlayerStatsTableReferences),
          PlayerStat,
          PrefetchHooks Function({bool profileId})
        > {
  $$PlayerStatsTableTableManager(_$AppDatabase db, $PlayerStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<int> wins = const Value.absent(),
                Value<int> losses = const Value.absent(),
                Value<int> draws = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<int> totalGames = const Value.absent(),
              }) => PlayerStatsCompanion(
                id: id,
                profileId: profileId,
                wins: wins,
                losses: losses,
                draws: draws,
                streak: streak,
                totalGames: totalGames,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                Value<int> wins = const Value.absent(),
                Value<int> losses = const Value.absent(),
                Value<int> draws = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<int> totalGames = const Value.absent(),
              }) => PlayerStatsCompanion.insert(
                id: id,
                profileId: profileId,
                wins: wins,
                losses: losses,
                draws: draws,
                streak: streak,
                totalGames: totalGames,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayerStatsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable: $$PlayerStatsTableReferences
                                    ._profileIdTable(db),
                                referencedColumn: $$PlayerStatsTableReferences
                                    ._profileIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlayerStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayerStatsTable,
      PlayerStat,
      $$PlayerStatsTableFilterComposer,
      $$PlayerStatsTableOrderingComposer,
      $$PlayerStatsTableAnnotationComposer,
      $$PlayerStatsTableCreateCompanionBuilder,
      $$PlayerStatsTableUpdateCompanionBuilder,
      (PlayerStat, $$PlayerStatsTableReferences),
      PlayerStat,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$GameHistoryTableCreateCompanionBuilder =
    GameHistoryCompanion Function({
      Value<int> id,
      required int profileId,
      required String opponent,
      required GameResult result,
      required String boardSize,
      required int durationSeconds,
      required String score,
      Value<DateTime> playedAt,
    });
typedef $$GameHistoryTableUpdateCompanionBuilder =
    GameHistoryCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> opponent,
      Value<GameResult> result,
      Value<String> boardSize,
      Value<int> durationSeconds,
      Value<String> score,
      Value<DateTime> playedAt,
    });

final class $$GameHistoryTableReferences
    extends BaseReferences<_$AppDatabase, $GameHistoryTable, GameHistoryData> {
  $$GameHistoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlayerProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.playerProfiles.createAlias(
        $_aliasNameGenerator(db.gameHistory.profileId, db.playerProfiles.id),
      );

  $$PlayerProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$PlayerProfilesTableTableManager(
      $_db,
      $_db.playerProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GameHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $GameHistoryTable> {
  $$GameHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opponent => $composableBuilder(
    column: $table.opponent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GameResult, GameResult, int> get result =>
      $composableBuilder(
        column: $table.result,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get boardSize => $composableBuilder(
    column: $table.boardSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get playedAt => $composableBuilder(
    column: $table.playedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlayerProfilesTableFilterComposer get profileId {
    final $$PlayerProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.playerProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerProfilesTableFilterComposer(
            $db: $db,
            $table: $db.playerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GameHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $GameHistoryTable> {
  $$GameHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opponent => $composableBuilder(
    column: $table.opponent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get boardSize => $composableBuilder(
    column: $table.boardSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get playedAt => $composableBuilder(
    column: $table.playedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlayerProfilesTableOrderingComposer get profileId {
    final $$PlayerProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.playerProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.playerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GameHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameHistoryTable> {
  $$GameHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get opponent =>
      $composableBuilder(column: $table.opponent, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GameResult, int> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get boardSize =>
      $composableBuilder(column: $table.boardSize, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<DateTime> get playedAt =>
      $composableBuilder(column: $table.playedAt, builder: (column) => column);

  $$PlayerProfilesTableAnnotationComposer get profileId {
    final $$PlayerProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.playerProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.playerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GameHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameHistoryTable,
          GameHistoryData,
          $$GameHistoryTableFilterComposer,
          $$GameHistoryTableOrderingComposer,
          $$GameHistoryTableAnnotationComposer,
          $$GameHistoryTableCreateCompanionBuilder,
          $$GameHistoryTableUpdateCompanionBuilder,
          (GameHistoryData, $$GameHistoryTableReferences),
          GameHistoryData,
          PrefetchHooks Function({bool profileId})
        > {
  $$GameHistoryTableTableManager(_$AppDatabase db, $GameHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> opponent = const Value.absent(),
                Value<GameResult> result = const Value.absent(),
                Value<String> boardSize = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<String> score = const Value.absent(),
                Value<DateTime> playedAt = const Value.absent(),
              }) => GameHistoryCompanion(
                id: id,
                profileId: profileId,
                opponent: opponent,
                result: result,
                boardSize: boardSize,
                durationSeconds: durationSeconds,
                score: score,
                playedAt: playedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String opponent,
                required GameResult result,
                required String boardSize,
                required int durationSeconds,
                required String score,
                Value<DateTime> playedAt = const Value.absent(),
              }) => GameHistoryCompanion.insert(
                id: id,
                profileId: profileId,
                opponent: opponent,
                result: result,
                boardSize: boardSize,
                durationSeconds: durationSeconds,
                score: score,
                playedAt: playedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GameHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable: $$GameHistoryTableReferences
                                    ._profileIdTable(db),
                                referencedColumn: $$GameHistoryTableReferences
                                    ._profileIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GameHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameHistoryTable,
      GameHistoryData,
      $$GameHistoryTableFilterComposer,
      $$GameHistoryTableOrderingComposer,
      $$GameHistoryTableAnnotationComposer,
      $$GameHistoryTableCreateCompanionBuilder,
      $$GameHistoryTableUpdateCompanionBuilder,
      (GameHistoryData, $$GameHistoryTableReferences),
      GameHistoryData,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$AchievementsTableCreateCompanionBuilder =
    AchievementsCompanion Function({
      Value<int> id,
      required int profileId,
      required String achievementId,
      Value<bool> isUnlocked,
      Value<int> progress,
      Value<DateTime?> unlockedDate,
    });
typedef $$AchievementsTableUpdateCompanionBuilder =
    AchievementsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> achievementId,
      Value<bool> isUnlocked,
      Value<int> progress,
      Value<DateTime?> unlockedDate,
    });

final class $$AchievementsTableReferences
    extends BaseReferences<_$AppDatabase, $AchievementsTable, Achievement> {
  $$AchievementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlayerProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.playerProfiles.createAlias(
        $_aliasNameGenerator(db.achievements.profileId, db.playerProfiles.id),
      );

  $$PlayerProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$PlayerProfilesTableTableManager(
      $_db,
      $_db.playerProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUnlocked => $composableBuilder(
    column: $table.isUnlocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedDate => $composableBuilder(
    column: $table.unlockedDate,
    builder: (column) => ColumnFilters(column),
  );

  $$PlayerProfilesTableFilterComposer get profileId {
    final $$PlayerProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.playerProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerProfilesTableFilterComposer(
            $db: $db,
            $table: $db.playerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUnlocked => $composableBuilder(
    column: $table.isUnlocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedDate => $composableBuilder(
    column: $table.unlockedDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlayerProfilesTableOrderingComposer get profileId {
    final $$PlayerProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.playerProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.playerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isUnlocked => $composableBuilder(
    column: $table.isUnlocked,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedDate => $composableBuilder(
    column: $table.unlockedDate,
    builder: (column) => column,
  );

  $$PlayerProfilesTableAnnotationComposer get profileId {
    final $$PlayerProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.playerProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.playerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AchievementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementsTable,
          Achievement,
          $$AchievementsTableFilterComposer,
          $$AchievementsTableOrderingComposer,
          $$AchievementsTableAnnotationComposer,
          $$AchievementsTableCreateCompanionBuilder,
          $$AchievementsTableUpdateCompanionBuilder,
          (Achievement, $$AchievementsTableReferences),
          Achievement,
          PrefetchHooks Function({bool profileId})
        > {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> achievementId = const Value.absent(),
                Value<bool> isUnlocked = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<DateTime?> unlockedDate = const Value.absent(),
              }) => AchievementsCompanion(
                id: id,
                profileId: profileId,
                achievementId: achievementId,
                isUnlocked: isUnlocked,
                progress: progress,
                unlockedDate: unlockedDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String achievementId,
                Value<bool> isUnlocked = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<DateTime?> unlockedDate = const Value.absent(),
              }) => AchievementsCompanion.insert(
                id: id,
                profileId: profileId,
                achievementId: achievementId,
                isUnlocked: isUnlocked,
                progress: progress,
                unlockedDate: unlockedDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AchievementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable: $$AchievementsTableReferences
                                    ._profileIdTable(db),
                                referencedColumn: $$AchievementsTableReferences
                                    ._profileIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementsTable,
      Achievement,
      $$AchievementsTableFilterComposer,
      $$AchievementsTableOrderingComposer,
      $$AchievementsTableAnnotationComposer,
      $$AchievementsTableCreateCompanionBuilder,
      $$AchievementsTableUpdateCompanionBuilder,
      (Achievement, $$AchievementsTableReferences),
      Achievement,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<bool> soundEnabled,
      Value<bool> musicEnabled,
      Value<bool> vibrationEnabled,
      Value<bool> hapticFeedbackEnabled,
      Value<bool> autoSaveEnabled,
      Value<bool> notificationsEnabled,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<bool> soundEnabled,
      Value<bool> musicEnabled,
      Value<bool> vibrationEnabled,
      Value<bool> hapticFeedbackEnabled,
      Value<bool> autoSaveEnabled,
      Value<bool> notificationsEnabled,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get musicEnabled => $composableBuilder(
    column: $table.musicEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hapticFeedbackEnabled => $composableBuilder(
    column: $table.hapticFeedbackEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoSaveEnabled => $composableBuilder(
    column: $table.autoSaveEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get musicEnabled => $composableBuilder(
    column: $table.musicEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hapticFeedbackEnabled => $composableBuilder(
    column: $table.hapticFeedbackEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoSaveEnabled => $composableBuilder(
    column: $table.autoSaveEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get musicEnabled => $composableBuilder(
    column: $table.musicEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hapticFeedbackEnabled => $composableBuilder(
    column: $table.hapticFeedbackEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoSaveEnabled => $composableBuilder(
    column: $table.autoSaveEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<bool> musicEnabled = const Value.absent(),
                Value<bool> vibrationEnabled = const Value.absent(),
                Value<bool> hapticFeedbackEnabled = const Value.absent(),
                Value<bool> autoSaveEnabled = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                soundEnabled: soundEnabled,
                musicEnabled: musicEnabled,
                vibrationEnabled: vibrationEnabled,
                hapticFeedbackEnabled: hapticFeedbackEnabled,
                autoSaveEnabled: autoSaveEnabled,
                notificationsEnabled: notificationsEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<bool> musicEnabled = const Value.absent(),
                Value<bool> vibrationEnabled = const Value.absent(),
                Value<bool> hapticFeedbackEnabled = const Value.absent(),
                Value<bool> autoSaveEnabled = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                soundEnabled: soundEnabled,
                musicEnabled: musicEnabled,
                vibrationEnabled: vibrationEnabled,
                hapticFeedbackEnabled: hapticFeedbackEnabled,
                autoSaveEnabled: autoSaveEnabled,
                notificationsEnabled: notificationsEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$ThemeSettingsTableCreateCompanionBuilder =
    ThemeSettingsCompanion Function({Value<int> id, Value<int> themeMode});
typedef $$ThemeSettingsTableUpdateCompanionBuilder =
    ThemeSettingsCompanion Function({Value<int> id, Value<int> themeMode});

class $$ThemeSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $ThemeSettingsTable> {
  $$ThemeSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ThemeSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ThemeSettingsTable> {
  $$ThemeSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ThemeSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThemeSettingsTable> {
  $$ThemeSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);
}

class $$ThemeSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ThemeSettingsTable,
          ThemeSetting,
          $$ThemeSettingsTableFilterComposer,
          $$ThemeSettingsTableOrderingComposer,
          $$ThemeSettingsTableAnnotationComposer,
          $$ThemeSettingsTableCreateCompanionBuilder,
          $$ThemeSettingsTableUpdateCompanionBuilder,
          (
            ThemeSetting,
            BaseReferences<_$AppDatabase, $ThemeSettingsTable, ThemeSetting>,
          ),
          ThemeSetting,
          PrefetchHooks Function()
        > {
  $$ThemeSettingsTableTableManager(_$AppDatabase db, $ThemeSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThemeSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThemeSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThemeSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> themeMode = const Value.absent(),
              }) => ThemeSettingsCompanion(id: id, themeMode: themeMode),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> themeMode = const Value.absent(),
              }) => ThemeSettingsCompanion.insert(id: id, themeMode: themeMode),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ThemeSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ThemeSettingsTable,
      ThemeSetting,
      $$ThemeSettingsTableFilterComposer,
      $$ThemeSettingsTableOrderingComposer,
      $$ThemeSettingsTableAnnotationComposer,
      $$ThemeSettingsTableCreateCompanionBuilder,
      $$ThemeSettingsTableUpdateCompanionBuilder,
      (
        ThemeSetting,
        BaseReferences<_$AppDatabase, $ThemeSettingsTable, ThemeSetting>,
      ),
      ThemeSetting,
      PrefetchHooks Function()
    >;
typedef $$StoreItemsTableCreateCompanionBuilder =
    StoreItemsCompanion Function({
      Value<int> id,
      required int profileId,
      required String itemId,
      Value<int> quantity,
      Value<DateTime> purchasedDate,
    });
typedef $$StoreItemsTableUpdateCompanionBuilder =
    StoreItemsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> itemId,
      Value<int> quantity,
      Value<DateTime> purchasedDate,
    });

final class $$StoreItemsTableReferences
    extends BaseReferences<_$AppDatabase, $StoreItemsTable, StoreItem> {
  $$StoreItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlayerProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.playerProfiles.createAlias(
        $_aliasNameGenerator(db.storeItems.profileId, db.playerProfiles.id),
      );

  $$PlayerProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$PlayerProfilesTableTableManager(
      $_db,
      $_db.playerProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoreItemsTableFilterComposer
    extends Composer<_$AppDatabase, $StoreItemsTable> {
  $$StoreItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedDate => $composableBuilder(
    column: $table.purchasedDate,
    builder: (column) => ColumnFilters(column),
  );

  $$PlayerProfilesTableFilterComposer get profileId {
    final $$PlayerProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.playerProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerProfilesTableFilterComposer(
            $db: $db,
            $table: $db.playerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoreItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoreItemsTable> {
  $$StoreItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedDate => $composableBuilder(
    column: $table.purchasedDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlayerProfilesTableOrderingComposer get profileId {
    final $$PlayerProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.playerProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.playerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoreItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoreItemsTable> {
  $$StoreItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedDate => $composableBuilder(
    column: $table.purchasedDate,
    builder: (column) => column,
  );

  $$PlayerProfilesTableAnnotationComposer get profileId {
    final $$PlayerProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.playerProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.playerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoreItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoreItemsTable,
          StoreItem,
          $$StoreItemsTableFilterComposer,
          $$StoreItemsTableOrderingComposer,
          $$StoreItemsTableAnnotationComposer,
          $$StoreItemsTableCreateCompanionBuilder,
          $$StoreItemsTableUpdateCompanionBuilder,
          (StoreItem, $$StoreItemsTableReferences),
          StoreItem,
          PrefetchHooks Function({bool profileId})
        > {
  $$StoreItemsTableTableManager(_$AppDatabase db, $StoreItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoreItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoreItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoreItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<DateTime> purchasedDate = const Value.absent(),
              }) => StoreItemsCompanion(
                id: id,
                profileId: profileId,
                itemId: itemId,
                quantity: quantity,
                purchasedDate: purchasedDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String itemId,
                Value<int> quantity = const Value.absent(),
                Value<DateTime> purchasedDate = const Value.absent(),
              }) => StoreItemsCompanion.insert(
                id: id,
                profileId: profileId,
                itemId: itemId,
                quantity: quantity,
                purchasedDate: purchasedDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StoreItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable: $$StoreItemsTableReferences
                                    ._profileIdTable(db),
                                referencedColumn: $$StoreItemsTableReferences
                                    ._profileIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoreItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoreItemsTable,
      StoreItem,
      $$StoreItemsTableFilterComposer,
      $$StoreItemsTableOrderingComposer,
      $$StoreItemsTableAnnotationComposer,
      $$StoreItemsTableCreateCompanionBuilder,
      $$StoreItemsTableUpdateCompanionBuilder,
      (StoreItem, $$StoreItemsTableReferences),
      StoreItem,
      PrefetchHooks Function({bool profileId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlayerProfilesTableTableManager get playerProfiles =>
      $$PlayerProfilesTableTableManager(_db, _db.playerProfiles);
  $$PlayerStatsTableTableManager get playerStats =>
      $$PlayerStatsTableTableManager(_db, _db.playerStats);
  $$GameHistoryTableTableManager get gameHistory =>
      $$GameHistoryTableTableManager(_db, _db.gameHistory);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$ThemeSettingsTableTableManager get themeSettings =>
      $$ThemeSettingsTableTableManager(_db, _db.themeSettings);
  $$StoreItemsTableTableManager get storeItems =>
      $$StoreItemsTableTableManager(_db, _db.storeItems);
}
