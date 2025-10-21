// Database-specific exceptions for better error handling and debugging

/// Base class for all database-related exceptions
class DatabaseException implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  const DatabaseException({
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() =>
      'DatabaseException: $message${originalError != null ? ' (Original: $originalError)' : ''}';
}

/// Exception for database operation failures
class DatabaseOperationException extends DatabaseException {
  final String operation;

  const DatabaseOperationException({
    required this.operation,
    required super.message,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'DatabaseOperationException [$operation]: $message${originalError != null ? ' (Original: $originalError)' : ''}';
}

/// Exception for data validation failures
class DatabaseValidationException extends DatabaseException {
  final String field;
  final dynamic invalidValue;

  const DatabaseValidationException({
    required this.field,
    required this.invalidValue,
    required super.message,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'DatabaseValidationException [$field=$invalidValue]: $message${originalError != null ? ' (Original: $originalError)' : ''}';
}

/// Exception for constraint violations
class DatabaseConstraintException extends DatabaseException {
  final String constraint;

  const DatabaseConstraintException({
    required this.constraint,
    required super.message,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'DatabaseConstraintException [$constraint]: $message${originalError != null ? ' (Original: $originalError)' : ''}';
}

/// Exception for migration failures
class DatabaseMigrationException extends DatabaseException {
  final int fromVersion;
  final int toVersion;

  const DatabaseMigrationException({
    required this.fromVersion,
    required this.toVersion,
    required super.message,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'DatabaseMigrationException [v$fromVersion->v$toVersion]: $message${originalError != null ? ' (Original: $originalError)' : ''}';
}

/// Exception for connection issues
class DatabaseConnectionException extends DatabaseException {
  const DatabaseConnectionException({
    required super.message,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'DatabaseConnectionException: $message${originalError != null ? ' (Original: $originalError)' : ''}';
}

/// Exception for data corruption
class DatabaseCorruptionException extends DatabaseException {
  const DatabaseCorruptionException({
    required super.message,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'DatabaseCorruptionException: $message${originalError != null ? ' (Original: $originalError)' : ''}';
}
