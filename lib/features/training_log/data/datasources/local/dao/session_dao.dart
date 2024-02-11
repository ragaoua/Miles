part of '../database/database.dart';

@UseRowClass(Session)
class SessionDAO extends Table {
  // Drift recognizes this column as the primary key
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dayId => integer().references(DayDAO, #id)();
  DateTimeColumn get date => dateTime()();

  @override String get tableName => 'session';
}