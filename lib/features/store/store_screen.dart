import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Placeholder store screen
class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: const Center(child: Text('Store Screen - Coming Soon!')),
    );
  }
}
