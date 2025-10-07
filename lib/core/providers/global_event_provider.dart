import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_event_provider.g.dart';

@riverpod
class GlobalEventNotifier extends _$GlobalEventNotifier {
  late final WidgetsBindingObserver _observer;

  @override
  void build() {
    try {
      _observer = _GlobalEventObserver(this);
      WidgetsBinding.instance.addObserver(_observer);
      ref.onDispose(() {
        WidgetsBinding.instance.removeObserver(_observer);
      });
    } catch (error) {
      // GlobalEventNotifier initialization failed silently
    }
  }

  void onLifecycleStateChanged(AppLifecycleState state) {
    // Lifecycle state changed
  }

  void onOrientationChanged(Orientation orientation) {
    // Device orientation changed
  }

  void onMemoryPressure() {
    // Memory pressure detected
  }
}

class _GlobalEventObserver extends WidgetsBindingObserver {
  final GlobalEventNotifier notifier;

  _GlobalEventObserver(this.notifier);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    try {
      notifier.onLifecycleStateChanged(state);
    } catch (error) {
      // Error handled silently
    }
  }

  @override
  void didChangeMetrics() {
    try {
      final view = WidgetsBinding.instance.platformDispatcher.views.first;
      final orientation = view.physicalSize.width > view.physicalSize.height
          ? Orientation.landscape
          : Orientation.portrait;
      notifier.onOrientationChanged(orientation);
    } catch (error) {
      // Error handled silently
    }
  }

  @override
  void didHaveMemoryPressure() {
    try {
      notifier.onMemoryPressure();
    } catch (error) {
      // Error handled silently
    }
  }
}
