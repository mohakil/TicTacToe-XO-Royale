import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:tictactoe_xo_royale/core/database/test_database.dart';

void main() {
  group('Drift Setup Verification', () {
    late TestDatabase db;

    setUp(() {
      // Use in-memory database for testing (drift_flutter compatible)
      db = TestDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('Database connection and basic operations work', () async {
      // Test basic insert operation
      final result = await db.customInsert(
        'INSERT INTO test_table (name, created_at) VALUES (?, ?)',
        variables: [
          Variable.withString('Test Record'),
          Variable.withDateTime(DateTime.now()),
        ],
      );

      // Verify the insert operation returned a valid result
      expect(result, isA<int>());

      // Test basic select operation
      final records = await db
          .customSelect(
            'SELECT * FROM test_table WHERE name = ?',
            variables: [Variable.withString('Test Record')],
          )
          .get();

      expect(records, hasLength(1));
      expect(records.first.data['name'], 'Test Record');

      // Test basic delete operation
      await db.customInsert(
        'DELETE FROM test_table WHERE name = ?',
        variables: [Variable.withString('Test Record')],
      );

      // Verify deletion
      final deletedRecords = await db
          .customSelect(
            'SELECT * FROM test_table WHERE name = ?',
            variables: [Variable.withString('Test Record')],
          )
          .get();

      expect(deletedRecords, isEmpty);
    });

    test('Database schema is correct', () async {
      // This test verifies that the table structure is correct
      // by checking that we can perform operations without errors

      // Insert a test record
      await db.customInsert(
        'INSERT INTO test_table (name, created_at) VALUES (?, ?)',
        variables: [
          Variable.withString('Schema Test'),
          Variable.withDateTime(DateTime.now()),
        ],
      );

      // Verify we can query it back
      final records = await db
          .customSelect(
            'SELECT * FROM test_table WHERE name = ?',
            variables: [Variable.withString('Schema Test')],
          )
          .get();

      expect(records, hasLength(1));
      expect(records.first.data['name'], 'Schema Test');
    });

    test('Database connection handles errors gracefully', () async {
      // Test that the database can handle invalid operations
      expect(
        () async =>
            await db.customSelect('SELECT * FROM non_existent_table').get(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
