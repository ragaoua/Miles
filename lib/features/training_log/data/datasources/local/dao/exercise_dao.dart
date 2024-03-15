part of '../database/database.dart';

@UseRowClass(Exercise)
class ExerciseDAO extends Table {
  // Drift recognizes this column as the primary key
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(SessionDAO, #id)();
  IntColumn get order => integer()();
  IntColumn get supersetOrder => integer()();
  IntColumn get movementId => integer().references(MovementDAO, #id)();
  TextColumn get ratingType => textEnum<RatingType>()();

  @override
  String get tableName => 'exercise';

  @override
  List<Set<Column>> get uniqueKeys => [
        {sessionId, order, supersetOrder}
      ];
}
