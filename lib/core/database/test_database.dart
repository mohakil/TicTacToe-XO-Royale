import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'test_database.g.dart';

// Test table for verification
class TestTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
}

// Test database class for initial setup verification
@DriftDatabase(tables: [TestTable])
class TestDatabase extends _$TestDatabase {
  TestDatabase() : super(driftDatabase(name: 'test_db'));

  @override
  int get schemaVersion => 1;
}
