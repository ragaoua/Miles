part of '../database/database.dart';

@UseRowClass(ExerciseSet)
class ExerciseSetDAO extends Table {
  // Drift recognizes this column as the primary key
  IntColumn get id => integer().autoIncrement()();
  IntColumn get exerciseId => integer().references(ExerciseDAO, #id)();
  IntColumn get order => integer()();
  IntColumn get reps => integer().nullable()();
  RealColumn get load => real().nullable()();
  RealColumn get rating => real().nullable()();

  @override
  String get tableName => 'exercise_set';

  @override
  List<Set<Column>> get uniqueKeys => [
        {exerciseId, order}
      ];
}
