import 'package:drift/drift.dart';

class ListItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get content => text().withLength(min: 1, max: 10000)();
  TextColumn get email => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
