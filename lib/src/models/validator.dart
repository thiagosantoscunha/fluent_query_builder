import 'query_builder.dart';
import 'query_builder_options.dart';
import 'util.dart';
import 'expression.dart';

/// Validator & Sanitizer
class Validator {
  Validator();

  static String sanitizeFieldAlias(String value, QueryBuilderOptions options) {
    var result = options.autoQuoteAliasNames
        ? options.fieldAliasQuoteCharacter + value + options.fieldAliasQuoteCharacter
        : value;

    return result;
  }

  static String sanitizeFieldFromQueryBuilder(QueryBuilder value) {
    return '(${value.toString()})';
  }

  static String sanitizeField(String value, QueryBuilderOptions options) {
    var result = '';
    if (options.autoQuoteFieldNames) {
      final quoteChar = options.nameQuoteCharacter;
      if (options.ignorePeriodsForFieldNameQuotes) {
        // a.b.c -> `a.b.c`
        result = quoteChar + value + quoteChar;
      } else {
        // a.b.c -> `a`.`b`.`c`
        final parts = value.split('\\.');
        final newParts = [];
        for (var part in parts) {
          // treat '*' as special case
          if (part == '*') {
            newParts.add(part);
          } else {
            newParts.add(quoteChar + part + quoteChar);
          }
        }
        result = Util.join('.', newParts as List<String>);
      }
    }

    return result;
  }

  static String sanitizeTable(String name, QueryBuilderOptions options) {
    return options.autoQuoteTableNames ? options.nameQuoteCharacter + name + options.nameQuoteCharacter : name;
  }

  static String sanitizeTableAlias(String value, QueryBuilderOptions options) {
    return value != null
        ? (options.autoQuoteAliasNames
            ? options.tableAliasQuoteCharacter + value + options.tableAliasQuoteCharacter
            : value)
        : null;
  }

  static String formatValue(Object value, QueryBuilderOptions options) {
    if (value == null) {
      return formatNull();
    } else {
      if (value is num) {
        return formatNumber(value);
      } else if (value is String) {
        return formatString(value, options);
      } else if (value is bool) {
        return formatBoolean(value);
      } else if (value is QueryBuilder) {
        return formatQueryBuilder(value);
      } else if (value is Expression) {
        return formatExpression(value);
      } else if (value is List) {
        return formatArray(value, options);
      }
    }

    return value.toString();
  }

  static String escapeValue(String value, QueryBuilderOptions options) {
    return options.replaceSingleQuotes ? value.replaceAll("'", options.singleQuoteReplacement) : value;
  }

  static String formatNull() {
    return 'NULL';
  }

  static String formatBoolean(bool value) {
    return value ? 'TRUE' : 'FALSE';
  }

  static String formatNumber(num value) {
    return value.toString();
  }

  static String formatString(String value, QueryBuilderOptions options) {
    return options.dontQuote ? value : "'${escapeValue(value, options)}'";
  }

  static String formatQueryBuilder(QueryBuilder value) {
    return '(${value.toString()})';
  }

  static String formatExpression(Expression value) {
    return '(${value.toString()})';
  }

  static String formatIterable(List values, QueryBuilderOptions options) {
    final results = [];
    for (Object value in values) {
      results.add(formatValue(value, options));
    }
    return "(${Util.join(', ', results as List<String>)})";
  }

  static String formatArray(List<Object> values, QueryBuilderOptions options) {
    return formatIterable(values, options);
  }
}
