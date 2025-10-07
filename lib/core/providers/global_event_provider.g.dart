// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_event_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GlobalEventNotifier)
const globalEventProvider = GlobalEventNotifierProvider._();

final class GlobalEventNotifierProvider
    extends $NotifierProvider<GlobalEventNotifier, void> {
  const GlobalEventNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'globalEventProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$globalEventNotifierHash();

  @$internal
  @override
  GlobalEventNotifier create() => GlobalEventNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$globalEventNotifierHash() =>
    r'f3d534416811addeb0d804495a146fba1e79edc6';

abstract class _$GlobalEventNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
