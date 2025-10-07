// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StoreNotifier)
const storeProvider = StoreNotifierProvider._();

final class StoreNotifierProvider
    extends $NotifierProvider<StoreNotifier, StoreState> {
  const StoreNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeNotifierHash();

  @$internal
  @override
  StoreNotifier create() => StoreNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoreState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoreState>(value),
    );
  }
}

String _$storeNotifierHash() => r'd8f1de8f7b12dc778c4e95890676097ffce5d48f';

abstract class _$StoreNotifier extends $Notifier<StoreState> {
  StoreState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<StoreState, StoreState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StoreState, StoreState>,
              StoreState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
