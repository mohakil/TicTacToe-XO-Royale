// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Simplified game provider without over-engineering (auto-generated)
/// Game notifier with clean, simple implementation

@ProviderFor(GameNotifier)
const gameProvider = GameNotifierProvider._();

/// Simplified game provider without over-engineering (auto-generated)
/// Game notifier with clean, simple implementation
final class GameNotifierProvider
    extends $NotifierProvider<GameNotifier, GameLogic> {
  /// Simplified game provider without over-engineering (auto-generated)
  /// Game notifier with clean, simple implementation
  const GameNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameNotifierHash();

  @$internal
  @override
  GameNotifier create() => GameNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameLogic value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameLogic>(value),
    );
  }
}

String _$gameNotifierHash() => r'9c80e67522067a38aee7e90cb5b0106dbf291385';

/// Simplified game provider without over-engineering (auto-generated)
/// Game notifier with clean, simple implementation

abstract class _$GameNotifier extends $Notifier<GameLogic> {
  GameLogic build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GameLogic, GameLogic>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameLogic, GameLogic>,
              GameLogic,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
