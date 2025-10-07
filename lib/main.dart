import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_xo_royale/app/app.dart';
import 'package:tictactoe_xo_royale/core/providers/global_event_provider.dart';
import 'package:tictactoe_xo_royale/core/database/database_providers.dart';
import 'package:tictactoe_xo_royale/core/database/app_database.dart';
import 'package:drift_flutter/drift_flutter.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Create the database instance using drift_flutter
  // This automatically handles platform-specific setup and paths
  final database = AppDatabase(driftDatabase(name: 'app_db'));

  // Run the app with database provider override
  runApp(
    ProviderScope(
      overrides: [
        globalEventProvider.overrideWith(() => GlobalEventNotifier()),
        appDatabaseProvider.overrideWithValue(database),
      ],
      child: const MainApp(),
    ),
  );
}
