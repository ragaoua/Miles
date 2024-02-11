part of '../database/database.dart';

@UseRowClass(Block)
class BlockDAO extends Table {
  // Drift recognizes this column as the primary key
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1)();

  @override String get tableName => 'block';

  @override List<Set<Column>> get uniqueKeys => [ {name} ];
}