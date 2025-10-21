// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievements_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AchievementsNotifier)
const achievementsProvider = AchievementsNotifierProvider._();

final class AchievementsNotifierProvider
    extends $NotifierProvider<AchievementsNotifier, AchievementsState> {
  const AchievementsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'achievementsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$achievementsNotifierHash();

  @$internal
  @override
  AchievementsNotifier create() => AchievementsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AchievementsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AchievementsState>(value),
    );
  }
}

String _$achievementsNotifierHash() =>
    r'f338dece6e0e86eb0fc983eaae6b41e64de21629';

abstract class _$AchievementsNotifier extends $Notifier<AchievementsState> {
  AchievementsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AchievementsState, AchievementsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AchievementsState, AchievementsState>,
              AchievementsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
