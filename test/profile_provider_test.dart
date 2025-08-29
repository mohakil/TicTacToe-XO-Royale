import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe_xo_royale/core/models/player_profile.dart';
import 'package:tictactoe_xo_royale/core/providers/profile_provider.dart';

// Mock SharedPreferences for testing
class MockSharedPreferences implements SharedPreferences {
  final Map<String, dynamic> _data = {};

  @override
  Future<bool> setInt(String key, int value) async {
    _data[key] = value;
    return true;
  }

  @override
  int? getInt(String key) => _data[key] as int?;

  @override
  Future<bool> setBool(String key, bool value) async {
    _data[key] = value;
    return true;
  }

  @override
  bool? getBool(String key) => _data[key] as bool?;

  @override
  Future<bool> setString(String key, String value) async {
    _data[key] = value;
    return true;
  }

  @override
  String? getString(String key) => _data[key] as String?;

  @override
  Future<bool> setDouble(String key, double value) async {
    _data[key] = value;
    return true;
  }

  @override
  double? getDouble(String key) => _data[key] as double?;

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    _data[key] = value;
    return true;
  }

  @override
  List<String>? getStringList(String key) => _data[key] as List<String>?;

  @override
  Future<bool> remove(String key) async {
    _data.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _data.clear();
    return true;
  }

  @override
  Future<bool> commit() async => true;

  @override
  Future<void> reload() async {}

  @override
  bool containsKey(String key) => _data.containsKey(key);

  @override
  Set<String> getKeys() => _data.keys.toSet();

  @override
  Object? get(String key) => _data[key];

  Type getType(String key) => _data[key].runtimeType;

  bool get isEmpty => _data.isEmpty;

  int get length => _data.length;

  Iterable<String> get keys => _data.keys;

  Iterable<Object?> get values => _data.values;

  Map<String, Object?> asMap() => Map.unmodifiable(_data);

  void addListener(VoidCallback listener) {}

  void removeListener(VoidCallback listener) {}

  bool get hasListeners => false;

  void notifyListeners() {}

  void dispose() {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();

      // Override SharedPreferences.getInstance to return our mock
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() {
      container.dispose();
    });

    group('Profile Provider', () {
      test('should provide profile state', () {
        final profileState = container.read(profileProvider);
        expect(profileState, isA<ProfileState>());
        expect(profileState.profile, isNotNull);
        expect(profileState.profile!.nickname, equals('Player'));
        expect(profileState.profile!.gems, equals(100));
        expect(profileState.profile!.hints, equals(5));
      });
    });

    group('Individual Profile Providers', () {
      test('currentProfileProvider should provide profile', () {
        final profile = container.read(currentProfileProvider);
        expect(profile, isA<PlayerProfile>());
        expect(profile!.nickname, equals('Player'));
      });

      test('profileStatsProvider should provide stats', () {
        final stats = container.read(profileStatsProvider);
        expect(stats, isA<PlayerStats>());
        expect(stats!.wins, equals(0));
        expect(stats.losses, equals(0));
        expect(stats.draws, equals(0));
      });

      test('profileGemsProvider should provide gems', () {
        final gems = container.read(profileGemsProvider);
        expect(gems, equals(100));
      });

      test('profileHintsProvider should provide hints', () {
        final hints = container.read(profileHintsProvider);
        expect(hints, equals(5));
      });

      test('profileNicknameProvider should provide nickname', () {
        final nickname = container.read(profileNicknameProvider);
        expect(nickname, equals('Player'));
      });

      test('profileAvatarProvider should provide avatar', () {
        final avatar = container.read(profileAvatarProvider);
        expect(avatar, isA<String>());
      });

      test('profileIsLoadingProvider should provide loading state', () {
        final isLoading = container.read(profileIsLoadingProvider);
        expect(isLoading, isA<bool>());
      });

      test('profileErrorProvider should provide error state', () {
        final error = container.read(profileErrorProvider);
        expect(error, isNull);
      });

      test('profileIsEditingProvider should provide editing state', () {
        final isEditing = container.read(profileIsEditingProvider);
        expect(isEditing, isA<bool>());
      });
    });

    group('Computed Properties', () {
      test('profileWinRateProvider should provide win rate', () {
        final winRate = container.read(profileWinRateProvider);
        expect(winRate, isA<double>());
        expect(winRate, equals(0.0)); // No games played yet
      });

      test('profileTotalGamesProvider should provide total games', () {
        final totalGames = container.read(profileTotalGamesProvider);
        expect(totalGames, isA<int>());
        expect(totalGames, equals(0)); // No games played yet
      });

      test('profileIsProfileLoadedProvider should provide loaded state', () {
        final isLoaded = container.read(profileIsProfileLoadedProvider);
        expect(isLoaded, isA<bool>());
      });
    });

    group('Profile Extensions', () {
      test('should provide profile display name', () {
        container.read(profileProvider);
        final displayName = container.read(
          profileProvider.select((p) => p.profile?.nickname ?? 'Player'),
        );
        expect(displayName, equals('Player'));
      });

      test('should provide gems display', () {
        container.read(profileGemsProvider);
        final gemsDisplay = container.read(
          profileGemsProvider.select((g) => '$g 💎'),
        );
        expect(gemsDisplay, equals('100 💎'));
      });

      test('should provide hints display', () {
        container.read(profileHintsProvider);
        final hintsDisplay = container.read(
          profileHintsProvider.select((h) => '$h 💡'),
        );
        expect(hintsDisplay, equals('5 💡'));
      });
    });
  });
}
