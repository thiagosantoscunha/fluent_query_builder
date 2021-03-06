import 'block.dart';
import 'query_builder_options.dart';
import 'query_builder.dart';
import 'validator.dart';
import 'expression.dart';
import 'where_node.dart';

/// WHERE
class WhereBlock extends Block {
  WhereBlock(QueryBuilderOptions options) : super(options);
  List<WhereNode> mWheres;
  List<WhereRawNode> wheresRawSql;

  void setStartGroup() {
    mWheres ??= [];
    mWheres.add(WhereNode(null, null, groupDivider: '('));
  }

  void setEndGroup() {
    mWheres ??= [];
    mWheres.add(WhereNode(null, null, groupDivider: ')'));
  }

  /// Add a WHERE condition.
  /// @param condition Condition to add
  /// @param param Parameter to add to condition.
  /// @param <P> Type of the parameter to add.
  void setWhere(String condition, param, [String andOr = 'AND']) {
    assert(condition != null);
    doSetWhere(condition, param, andOr);
  }

  void setWhereRaw(String whereRawSql, [String andOr = 'AND']) {
    assert(whereRawSql != null);
    wheresRawSql ??= [];
    wheresRawSql.add(WhereRawNode(whereRawSql, andOr));
  }

  void setWhereSafe(String field, String operator, value) {
    assert(field != null);
    assert(operator != null);
    assert(value != null);
    mWheres ??= [];
    mWheres.add(WhereNode(field, value, operator: operator, andOr: 'AND'));
  }

  void setOrWhereSafe(String field, String operator, value) {
    assert(field != null);
    assert(operator != null);
    assert(value != null);
    mWheres ??= [];
    mWheres.add(WhereNode(field, value, operator: operator, andOr: 'OR'));
  }

  void setWhereWithExpression(Expression condition, param,
      [String andOr = 'AND']) {
    assert(condition != null);
    doSetWhere(condition.toString(), param, andOr);
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {
    final sb = StringBuffer();

    if (wheresRawSql != null) {
      for (var whereRaw in wheresRawSql) {
        if (sb.length > 0) {
          sb.write(' ${whereRaw.andOr} ');
        }

        sb.write(whereRaw.sqlString);
      }
      return 'WHERE $sb';
    }

    if (mWheres == null || mWheres.isEmpty) {
      return '';
    }

    var length = mWheres.length;
    for (var i = 0; i < length; i++) {
      var where = mWheres[i];

      if (where.groupDivider == null) {
        /*if (sb.length > 0) {
          //sb.write(') OR (');
          if (isDividerAdded) {
            if (sb.length > 1) {
              sb.write(' ${where.andOr} ');
            }
          } else {
            sb.write(' ${where.andOr} ');
          }
        }*/

        if (where.operator == null) {
          sb.write(where.text
              .replaceAll('?', Validator.formatValue(where.param, mOptions)));
        } else {
          sb.write('${where.text}');
          sb.write(' ${where.operator} ');
          sb.write('@${where.text}');
        }

        if (i < length - 1) {
          sb.write(' ${where.andOr} ');
        }
      } else {
        sb.write(' ${where.groupDivider} ');
        if (where.groupDivider == ')') {
          var str = sb.toString();
          //print('WhereBlock@buildStr $str');
          str = str.substring(0, str.lastIndexOf('OR'));
          sb.clear();
          sb.write(' ${str} ) ${where.andOr} ');
          //print('WhereBlock@buildStr $sb');
        }
      }
    }

    // return 'WHERE ($sb)';
    return 'WHERE $sb';
  }

  @override
  Map<String, dynamic> buildSubstitutionValues() {
    final result = <String, dynamic>{};
    if (mWheres == null || mWheres.isEmpty) {
      return result;
    }

    for (var item in mWheres) {
      if (item.operator != null) {
        var v = Validator.formatValue(item.param, mOptions);
        result.addAll({'${item.text}': v});
      }
    }

    return result;
  }

  /*List<String> buildFieldValuesForSubstitution(List<WhereNode> nodes) {
    final values = <String>[];
    for (var item in nodes) {
      if (item.operator != null) {
        values.add('@${item.text}');
      }
    }
    return values;
  }*/

  void doSetWhere(String condition, param, [String andOr = 'AND']) {
    mWheres ??= [];
    mWheres.add(WhereNode(condition, param, andOr: andOr));
  }
}
