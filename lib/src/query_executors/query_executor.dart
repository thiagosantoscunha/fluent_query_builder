import 'dart:async';

/// An abstract interface that performs queries.
///
/// This class should be implemented.
abstract class QueryExecutor {
  const QueryExecutor();

  /// Executes a single query.
  Future<List<List>> query(
      String query, Map<String, dynamic> substitutionValues,
      [List<String> returningFields]);

  /// Enters a database transaction, performing the actions within,
  /// and returning the results of [f].
  ///
  /// If [f] fails, the transaction will be rolled back, and the
  /// responsible exception will be re-thrown.
  ///
  /// Whether nested transactions are supported depends on the
  /// underlying driver.
  Future<T> transaction<T>(FutureOr<T> Function(QueryExecutor) f);

  //Future transaction2(Function queryBlock);

  Future<List<Map<String, Map<String, dynamic>>>> getAsMapWithMeta(String query,
      {Map<String, dynamic> substitutionValues});

  Future<List<Map<String, dynamic>>> getAsMap(String query,
      {Map<String, dynamic> substitutionValues});

  Future close();
}
