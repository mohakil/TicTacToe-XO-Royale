import 'package:drift/drift.dart';

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
  TestDatabase(super.executor);

  @override
  int get schemaVersion => 1;
}
