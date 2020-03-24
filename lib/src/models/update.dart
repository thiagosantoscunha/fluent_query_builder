import 'sort_order.dart';

import 'expression.dart';
import 'query_builder_options.dart';

import 'query_builder.dart';
import 'string_block.dart';
import 'update_table_block.dart';
import 'set_field_block.dart';
import 'where_block.dart';
import 'order_by_block.dart';
import 'limit_block.dart';

/// UPDATE query builder.
class Update extends QueryBuilder {
  Update(
    QueryBuilderOptions options, {
    Future<List<List>> Function() execFunc,
    Future<Map<String, Map<String, dynamic>>> Function() firstAsMapFuncWithMeta,
    Future<List<Map<String, Map<String, dynamic>>>> Function() getAsMapFuncWithMeta,
    Future<List> Function() firstFunc,
    Future<Map<String, dynamic>> Function() firstAsMapFunc,
    Future<List<Map<String, dynamic>>> Function() getAsMapFunc,
  }) : super(
          options,
          [
            StringBlock(options, 'UPDATE'),
            UpdateTableBlock(options), // 1
            SetFieldBlock(options), // 2
            WhereBlock(options), // 3
            OrderByBlock(options), // 4
            LimitBlock(options) // 5
          ],
          execFunc: execFunc,
          firstAsMapFuncWithMeta: firstAsMapFuncWithMeta,
          getAsMapFuncWithMeta: getAsMapFuncWithMeta,
          firstFunc: firstFunc,
          firstAsMapFunc: firstAsMapFunc,
          getAsMapFunc: getAsMapFunc,
        );

  @override
  QueryBuilder table(String table, {String alias}) {
    final block = mBlocks[1] as UpdateTableBlock;
    block.setTable(table, alias);
    return this;
  }

  @override
  QueryBuilder set(String field, value) {
    final block = mBlocks[2] as SetFieldBlock;
    block.setFieldValue(field, value);
    return this;
  }

  @override
  QueryBuilder where(String condition, [Object param]) {
    final block = mBlocks[3] as WhereBlock;
    block.setWhere(condition, param);
    return this;
  }

  @override
  QueryBuilder whereExpr(Expression condition, [Object param]) {
    final block = mBlocks[3] as WhereBlock;
    block.setWhereWithExpression(condition, param);
    return this;
  }

  @override
  QueryBuilder order(String field, {SortOrder dir = SortOrder.ASC}) {
    final block = mBlocks[4] as OrderByBlock;
    block.setOrder(field, dir);
    return this;
  }

  @override
  QueryBuilder limit(int value) {
    final block = mBlocks[5] as LimitBlock;
    block.setLimit(value);
    return this;
  }
}
