// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Simplified setup notifier without over-engineering

@ProviderFor(SetupNotifier)
const setupProvider = SetupNotifierProvider._();

/// Simplified setup notifier without over-engineering
final class SetupNotifierProvider
    extends $NotifierProvider<SetupNotifier, GameSetup> {
  /// Simplified setup notifier without over-engineering
  const SetupNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setupNotifierHash();

  @$internal
  @override
  SetupNotifier create() => SetupNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameSetup value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameSetup>(value),
    );
  }
}

String _$setupNotifierHash() => r'ef72b7e182ce78de9c9e43beaa5d539251353045';

/// Simplified setup notifier without over-engineering

abstract class _$SetupNotifier extends $Notifier<GameSetup> {
  GameSetup build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GameSetup, GameSetup>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameSetup, GameSetup>,
              GameSetup,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
