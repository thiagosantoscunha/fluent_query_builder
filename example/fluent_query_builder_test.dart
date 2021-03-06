

import 'package:fluent_query_builder/fluent_query_builder.dart';
import 'package:test/test.dart';

void main() {
  //PostgreSQL connection information
  final pgsqlCom = DBConnectionInfo(
    host: 'localhost',
    database: 'banco_teste',
    driver: ConnectionDriver.pgsql,
    port: 5432,//32
    username: 'sisadmin',
    password: 's1sadm1n',
    charset: 'utf8',
    schemes: ['public'],
  );

  group('Connection test', () {
    DbLayer db;

    setUp(() {
      db = DbLayer();
    });

    tearDown(() async {
      await db?.close();
    });

    test('Connect with md5 auth required', () async {
      db = await db.connect(pgsqlCom);
      expect(
          await db.raw('select 1').exec(),
          equals([
            [1]
          ]));
    });
  });
  //end Connection test
  group('Successful queries over time', () {
    DbLayer db;

    setUp(() async {
      db = DbLayer();
      db = await db.connect(pgsqlCom);
    });

    tearDown(() async {
      await db?.close();
    });

    test(
        'Issuing multiple queries and awaiting between each one successfully returns the right value',
        () async {
      expect(
          await await db.select().from('pessoas').fieldRaw('1').limit(1).exec(),
          equals([
            [1]
          ]));
      expect(
          await await db.select().from('pessoas').fieldRaw('2').limit(1).exec(),
          equals([
            [2]
          ]));
      expect(
          await await db.select().from('pessoas').fieldRaw('3').limit(1).exec(),
          equals([
            [3]
          ]));
      expect(
          await await db.select().from('pessoas').fieldRaw('4').limit(1).exec(),
          equals([
            [4]
          ]));
      expect(
          await await db.select().from('pessoas').fieldRaw('5').limit(1).exec(),
          equals([
            [5]
          ]));
    });
  });
  //end queries over time test
}

