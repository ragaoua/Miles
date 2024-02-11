part of '../database/database.dart';

@UseRowClass(Day)
class DayDAO extends Table {
  // Drift recognizes this column as the primary key
  IntColumn get id => integer().autoIncrement()();
  IntColumn get blockId => integer().references(BlockDAO, #id)();
  IntColumn get order => integer()();

  @override String get tableName => 'day';

  @override List<Set<Column>> get uniqueKeys => [ {blockId, order} ];
}