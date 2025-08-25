import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe_xo_royale/core/providers/theme_provider.dart';

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

  group('ThemeProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();

      // Override SharedPreferences.getInstance to return our mock
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() {
      container.dispose();
    });

    group('Theme Mode Provider', () {
      test('should initialize with system theme mode', () {
        final themeMode = container.read(themeModeProvider);
        expect(themeMode, isA<ThemeMode>());
      });

      test('should allow changing theme mode', () async {
        final notifier = container.read(themeModeProvider.notifier);

        await notifier.setThemeMode(ThemeMode.light);
        expect(notifier.state, equals(ThemeMode.light));

        await notifier.setThemeMode(ThemeMode.dark);
        expect(notifier.state, equals(ThemeMode.dark));
      });

      test('should persist theme mode changes', () async {
        final notifier = container.read(themeModeProvider.notifier);

        await notifier.setThemeMode(ThemeMode.light);
        expect(notifier.state, equals(ThemeMode.light));
      });
    });

    group('Theme Data Providers', () {
      test('should provide light theme data', () {
        final lightTheme = container.read(lightThemeProvider);
        expect(lightTheme, isA<ThemeData>());
        expect(lightTheme.brightness, equals(Brightness.light));
      });

      test('should provide dark theme data', () {
        final darkTheme = container.read(darkThemeProvider);
        expect(darkTheme, isA<ThemeData>());
        expect(darkTheme.brightness, equals(Brightness.dark));
      });
    });

    group('Theme Extensions', () {
      test('should provide theme name for display', () {
        final notifier = container.read(themeModeProvider.notifier);

        notifier.state = ThemeMode.light;
        final lightName = container.read(
          themeModeProvider.select((mode) {
            switch (mode) {
              case ThemeMode.light:
                return 'Light';
              case ThemeMode.dark:
                return 'Dark';
              case ThemeMode.system:
                return 'System';
            }
          }),
        );
        expect(lightName, equals('Light'));
      });

      test('should provide theme icon for display', () {
        final notifier = container.read(themeModeProvider.notifier);

        notifier.state = ThemeMode.dark;
        final darkIcon = container.read(
          themeModeProvider.select((mode) {
            switch (mode) {
              case ThemeMode.light:
                return Icons.light_mode;
              case ThemeMode.dark:
                return Icons.dark_mode;
              case ThemeMode.system:
                return Icons.brightness_auto;
            }
          }),
        );
        expect(darkIcon, equals(Icons.dark_mode));
      });
    });
  });
}
