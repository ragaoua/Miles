part of '../database/database.dart';

@UseRowClass(Movement)
class MovementDAO extends Table {
  // Drift recognizes this column as the primary key
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1)();

  @override
  String get tableName => 'movement';

  @override
  List<Set<Column>> get uniqueKeys => [
        {name}
      ];
}
