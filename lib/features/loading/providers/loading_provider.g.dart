// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loading_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoadingNotifier)
const loadingProvider = LoadingNotifierProvider._();

final class LoadingNotifierProvider
    extends $NotifierProvider<LoadingNotifier, LoadingState> {
  const LoadingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadingNotifierHash();

  @$internal
  @override
  LoadingNotifier create() => LoadingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadingState>(value),
    );
  }
}

String _$loadingNotifierHash() => r'e11a32fe98c8fc6d2965c89991dfbd82b106322b';

abstract class _$LoadingNotifier extends $Notifier<LoadingState> {
  LoadingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LoadingState, LoadingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LoadingState, LoadingState>,
              LoadingState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
