import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matcher/matcher.dart' as matcher;
import 'package:tictactoe_xo_royale/core/database/app_database.dart';
import 'package:tictactoe_xo_royale/core/database/profile_dao.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;
  late ProfileDao dao;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    dao = container.read(profileDaoProvider);
  });

  tearDown(() async {
    await database.close();
    container.dispose();
  });

  group('ProfileDao Tests', () {
    // ===== PROFILE OPERATIONS =====

    group('getProfile()', () {
      test('should return profile when exists', () async {
        // Arrange
        final profile = PlayerProfilesCompanion.insert(
          nickname: 'TestUser',
          avatarUrlOrProvider: Value('avatar1'),
          gems: 100,
          hints: 5,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        final id = await dao.insertProfile(profile);

        // Act
        final result = await dao.getProfile(id.toString());

        // Assert
        expect(result, matcher.isNotNull);
        expect(result!.nickname, 'TestUser');
        expect(result.avatarUrlOrProvider, 'avatar1');
        expect(result.gems, 100);
        expect(result.hints, 5);
      });

      test('should return null when profile does not exist', () async {
        // Act
        final result = await dao.getProfile('999');

        // Assert
        expect(result, matcher.isNull);
      });
    });

    group('insertProfile()', () {
      test('should insert valid profile successfully', () async {
        // Arrange
        final profile = PlayerProfilesCompanion.insert(
          nickname: 'NewUser',
          avatarUrlOrProvider: Value('avatar2'),
          gems: 50,
          hints: 3,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        // Act
        final id = await dao.insertProfile(profile);

        // Assert
        expect(id, isA<int>());
        expect(id, greaterThan(0));

        // Verify insertion
        final retrieved = await dao.getProfile(id.toString());
        expect(retrieved, matcher.isNotNull);
        expect(retrieved!.nickname, 'NewUser');
      });

      test('should handle profile with minimum required data', () async {
        // Arrange - minimal valid profile
        final profile = PlayerProfilesCompanion.insert(
          nickname: 'MinUser',
          gems: 0,
          hints: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        // Act
        final id = await dao.insertProfile(profile);

        // Assert
        expect(id, greaterThan(0));

        final retrieved = await dao.getProfile(id.toString());
        expect(retrieved!.nickname, 'MinUser');
        expect(retrieved.avatarUrlOrProvider, matcher.isNull);
        expect(retrieved.gems, 0);
        expect(retrieved.hints, 0);
      });
    });

    group('updateProfile()', () {
      test('should update existing profile successfully', () async {
        // Arrange
        final originalProfile = PlayerProfilesCompanion.insert(
          nickname: 'OriginalUser',
          gems: 100,
          hints: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        final id = await dao.insertProfile(originalProfile);

        final updatedProfile = (await dao.getProfile(id.toString()))!.copyWith(
          nickname: 'UpdatedUser',
          gems: 200,
          updatedAt: DateTime(2024, 1, 1),
        );

        // Act
        final result = await dao.updateProfile(updatedProfile);

        // Assert
        expect(result, isTrue);

        final retrieved = await dao.getProfile(id.toString());
        expect(retrieved!.nickname, 'UpdatedUser');
        expect(retrieved.gems, 200);
      });

      test('should return false when updating non-existing profile', () async {
        // Arrange
        final nonExistingProfile = PlayerProfile(
          id: 999,
          nickname: 'NonExisting',
          gems: 100,
          hints: 5,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        // Act
        final result = await dao.updateProfile(nonExistingProfile);

        // Assert
        expect(result, isFalse);
      });
    });

    group('deleteProfile()', () {
      test('should delete existing profile successfully', () async {
        // Arrange
        final profile = PlayerProfilesCompanion.insert(
          nickname: 'ToDelete',
          gems: 0,
          hints: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        final id = await dao.insertProfile(profile);

        // Verify exists before deletion
        final beforeDelete = await dao.getProfile(id.toString());
        expect(beforeDelete, matcher.isNotNull);

        // Act
        final result = await dao.deleteProfile(id.toString());

        // Assert
        expect(result, 1); // One row deleted

        final afterDelete = await dao.getProfile(id.toString());
        expect(afterDelete, matcher.isNull);
      });

      test('should return 0 when deleting non-existing profile', () async {
        // Act
        final result = await dao.deleteProfile('999');

        // Assert
        expect(result, 0); // No rows deleted
      });
    });

    // ===== STATS OPERATIONS =====

    group('getStats() and updateStats()', () {
      test('should get stats for existing profile', () async {
        // Arrange
        final profile = PlayerProfilesCompanion.insert(
          nickname: 'StatsUser',
          gems: 0,
          hints: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        final profileId = await dao.insertProfile(profile);

        final stats = PlayerStatsCompanion(
          profileId: Value(profileId),
          wins: const Value(10),
          losses: const Value(5),
          draws: const Value(3),
          streak: const Value(2),
          totalGames: const Value(18),
        );
        await dao.insertStats(stats);

        // Act
        final result = await dao.getStats(profileId.toString());

        // Assert
        expect(result, matcher.isNotNull);
        expect(result!.wins, 10);
        expect(result.losses, 5);
        expect(result.draws, 3);
        expect(result.streak, 2);
        expect(result.totalGames, 18);
      });

      test('should return null when stats do not exist', () async {
        // Act
        final result = await dao.getStats('999');

        // Assert
        expect(result, matcher.isNull);
      });

      test('should update existing stats successfully', () async {
        // Arrange
        final profile = PlayerProfilesCompanion.insert(
          nickname: 'UpdateStatsUser',
          gems: 0,
          hints: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        final profileId = await dao.insertProfile(profile);

        final originalStats = PlayerStatsCompanion(
          profileId: Value(profileId),
          wins: const Value(5),
          losses: const Value(2),
          draws: const Value(1),
          streak: const Value(1),
          totalGames: const Value(8),
        );
        await dao.insertStats(originalStats);

        final updatedStats = PlayerStatsCompanion(
          wins: const Value(6),
          losses: const Value(3),
          draws: const Value(2),
          streak: const Value(3),
          totalGames: const Value(11),
        );

        // Act
        final result = await dao.updateStats(
          profileId.toString(),
          updatedStats,
        );

        // Assert
        expect(result, 1); // One row updated

        final retrieved = await dao.getStats(profileId.toString());
        expect(retrieved!.wins, 6);
        expect(retrieved.losses, 3);
        expect(retrieved.draws, 2);
        expect(retrieved.streak, 3);
        expect(retrieved.totalGames, 11);
      });

      test('should return 0 when updating non-existing stats', () async {
        // Arrange
        const stats = PlayerStatsCompanion(
          wins: Value(1),
          losses: Value(1),
          draws: Value(1),
          streak: Value(1),
          totalGames: Value(3),
        );

        // Act
        final result = await dao.updateStats('999', stats);

        // Assert
        expect(result, 0); // No rows updated
      });
    });

    // ===== COMBINED OPERATIONS =====

    group('getProfileWithStats()', () {
      test('should return profile with stats when both exist', () async {
        // Arrange
        final profile = PlayerProfilesCompanion.insert(
          nickname: 'CombinedUser',
          gems: 150,
          hints: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        final profileId = await dao.insertProfile(profile);

        final stats = PlayerStatsCompanion(
          profileId: Value(profileId),
          wins: const Value(8),
          losses: const Value(4),
          draws: const Value(2),
          streak: const Value(4),
          totalGames: const Value(14),
        );
        await dao.insertStats(stats);

        // Act
        final result = await dao.getProfileWithStats(profileId.toString());

        // Assert
        expect(result, matcher.isNotNull);
        expect(result!.profile.nickname, 'CombinedUser');
        expect(result.profile.gems, 150);
        expect(result.stats, matcher.isNotNull);
        expect(result.stats!.wins, 8);
        expect(result.stats!.losses, 4);
      });

      test(
        'should return profile with null stats when stats do not exist',
        () async {
          // Arrange
          final profile = PlayerProfilesCompanion.insert(
            nickname: 'NoStatsUser',
            gems: 0,
            hints: 0,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          );
          final profileId = await dao.insertProfile(profile);

          // Act
          final result = await dao.getProfileWithStats(profileId.toString());

          // Assert
          expect(result, matcher.isNotNull);
          expect(result!.profile.nickname, 'NoStatsUser');
          expect(result.stats, matcher.isNull);
        },
      );

      test('should return null when profile does not exist', () async {
        // Act
        final result = await dao.getProfileWithStats('999');

        // Assert
        expect(result, matcher.isNull);
      });
    });

    group('createProfileWithStats()', () {
      test('should create profile with default stats atomically', () async {
        // Arrange
        final profile = PlayerProfilesCompanion.insert(
          nickname: 'AtomicUser',
          gems: 75,
          hints: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        // Act
        final profileId = await dao.createProfileWithStats(profile);

        // Assert
        expect(profileId, greaterThan(0));

        // Verify profile was created
        final retrieved = await dao.getProfile(profileId.toString());
        expect(retrieved!.nickname, 'AtomicUser');
        expect(retrieved.gems, 75);

        // Verify default stats were created
        final stats = await dao.getStats(profileId.toString());
        expect(stats, matcher.isNotNull);
        expect(stats!.wins, 0);
        expect(stats.losses, 0);
        expect(stats.draws, 0);
        expect(stats.streak, 0);
        expect(stats.totalGames, 0);
      });
    });

    group('updateProfileAndStats()', () {
      test('should update profile and stats atomically', () async {
        // Arrange
        final profile = PlayerProfilesCompanion.insert(
          nickname: 'AtomicUpdateUser',
          gems: 100,
          hints: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        final profileId = await dao.insertProfile(profile);

        // Insert initial stats
        final initialStats = PlayerStatsCompanion(
          profileId: Value(profileId),
          wins: const Value(5),
          losses: const Value(2),
          draws: const Value(1),
          streak: const Value(3),
          totalGames: const Value(8),
        );
        await dao.insertStats(initialStats);

        // Prepare updates
        final updatedProfile = (await dao.getProfile(profileId.toString()))!
            .copyWith(
              nickname: 'UpdatedAtomicUser',
              gems: 150,
              updatedAt: DateTime(2024, 1, 1),
            );

        const updatedStats = PlayerStatsCompanion(
          wins: Value(6),
          losses: Value(3),
          draws: Value(2),
          streak: Value(4),
          totalGames: Value(11),
        );

        // Act
        await dao.updateProfileAndStats(updatedProfile, updatedStats);

        // Assert - Profile updated
        final retrievedProfile = await dao.getProfile(profileId.toString());
        expect(retrievedProfile!.nickname, 'UpdatedAtomicUser');
        expect(retrievedProfile.gems, 150);

        // Assert - Stats updated
        final retrievedStats = await dao.getStats(profileId.toString());
        expect(retrievedStats!.wins, 6);
        expect(retrievedStats.losses, 3);
        expect(retrievedStats.draws, 2);
        expect(retrievedStats.streak, 4);
        expect(retrievedStats.totalGames, 11);
      });
    });

    // ===== REACTIVE STREAMS =====

    group('Reactive Streams', () {
      test('watchProfile() should emit profile changes', () async {
        // Arrange
        final profile = PlayerProfilesCompanion.insert(
          nickname: 'WatchUser',
          gems: 0,
          hints: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        final profileId = await dao.insertProfile(profile);

        // Act & Assert
        expect(
          dao.watchProfile(profileId.toString()),
          emitsInOrder([
            // Initial emission
            isA<PlayerProfile>().having(
              (p) => p.nickname,
              'nickname',
              'WatchUser',
            ),
            // After update
            isA<PlayerProfile>().having(
              (p) => p.nickname,
              'nickname',
              'UpdatedWatchUser',
            ),
          ]),
        );

        // Update the profile to trigger stream emission
        final updatedProfile = (await dao.getProfile(profileId.toString()))!
            .copyWith(
              nickname: 'UpdatedWatchUser',
              updatedAt: DateTime(2024, 1, 1),
            );
        await dao.updateProfile(updatedProfile);
      });

      test('watchProfile() should emit null for non-existing profile', () {
        // Act & Assert
        expect(dao.watchProfile('999'), emits(null));
      });
    });

    // ===== EDGE CASES AND ERROR HANDLING =====

    group('Edge Cases and Error Handling', () {
      test('should handle empty nickname gracefully', () async {
        // Arrange
        final profile = PlayerProfilesCompanion.insert(
          nickname: '', // Empty nickname
          gems: 0,
          hints: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        // Act & Assert - Should not throw exception
        expect(() async => await dao.insertProfile(profile), returnsNormally);

        final id = await dao.insertProfile(profile);
        final retrieved = await dao.getProfile(id.toString());
        expect(retrieved!.nickname, '');
      });

      test('should handle large gem/hint values', () async {
        // Arrange
        final profile = PlayerProfilesCompanion.insert(
          nickname: 'RichUser',
          gems: 999999,
          hints: 999,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        // Act
        final id = await dao.insertProfile(profile);

        // Assert
        final retrieved = await dao.getProfile(id.toString());
        expect(retrieved!.gems, 999999);
        expect(retrieved.hints, 999);
      });

      test('should handle concurrent operations safely', () async {
        // Arrange
        final profile = PlayerProfilesCompanion.insert(
          nickname: 'ConcurrentUser',
          gems: 0,
          hints: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        final profileId = await dao.insertProfile(profile);

        // Act - Perform multiple operations concurrently
        final operations = await Future.wait([
          dao.getProfile(profileId.toString()),
          dao.getStats(profileId.toString()),
          dao.watchProfile(profileId.toString()).first,
        ]);

        // Assert
        expect(operations[0], matcher.isNotNull); // getProfile
        expect(operations[1], matcher.isNull); // getStats (no stats inserted)
        expect(operations[2], matcher.isNotNull); // watchProfile
      });
    });
  });
}
