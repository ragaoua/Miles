import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:miles/core/failure.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import '../../../../domain/entities/block.dart';
import '../../../../domain/entities/day.dart';
import '../../../../domain/entities/exercise.dart';
import '../../../../domain/entities/movement.dart';
import '../../../../domain/entities/session.dart';
import '../../../../domain/entities/exercise_set.dart';

part '../dao/block_dao.dart';
part '../dao/day_dao.dart';
part '../dao/exercise_dao.dart';
part '../dao/movement_dao.dart';
part '../dao/session_dao.dart';
part '../dao/exercise_set_dao.dart';
part 'database.g.dart';

@DriftDatabase(
  tables: [
    BlockDAO,
    DayDAO,
    SessionDAO,
    ExerciseDAO,
    MovementDAO,
    ExerciseSetDAO,
  ],
)
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  /// Get all blocks with their sessions
  /// The block are sorted by latest session descending then by id descending.
  /// For each block, sessions are sorted by date then by id.
  Stream<List<BlockWithSessions>> getAllBlocks() {
    return customSelect(
      """
      SELECT
        block.id AS "block.id",
        block.name AS "block.name",
        session.id AS "session.id",
        session.day_id AS "session.day_id",
        session.date AS "session.date"
      FROM block
      LEFT JOIN day ON block.id = day.block_id
      LEFT JOIN session ON day.id = session.day_id
      ORDER BY
          max(session.date) OVER(PARTITION BY block.id) DESC,
          block.id DESC,
          session.date,
          session.id
      """,
      readsFrom: {blockDAO, dayDAO, sessionDAO},
    ).watch().map(_mapRowsToBlockWithSessionsList);
  }

  List<BlockWithSessions> _mapRowsToBlockWithSessionsList(
    List<QueryRow> rows,
  ) {
    final Map<Block, List<Session>> blockSessionsMap = {};
    for (final row in rows) {
      final block = blockDAO.map(row.data, tablePrefix: "block");

      final blockSessions = blockSessionsMap.putIfAbsent(block, () => []);
      if (row.data["session.id"] != null) {
        blockSessions.add(
          sessionDAO.map(row.data, tablePrefix: "session"),
        );
      }
    }

    return BlockWithSessions.fromMapToList(blockSessionsMap);
  }

  Future<Block?> getBlockByName(String name) =>
      (select(blockDAO)..where((block) => block.name.equals(name)))
          .getSingleOrNull();

  Future<BlockWithDays> insertBlockAndDays(String name, int nbDays) =>
      transaction(() async {
        int blockId = await into(blockDAO).insert(BlockDAOCompanion(
          name: Value(name),
        ));
        
        List<Day> days = [];
        for (var dayOrder = 1; dayOrder <= nbDays; dayOrder++) {
          int dayId = await into(dayDAO).insert(
            DayDAOCompanion(blockId: Value(blockId), order: Value(dayOrder)),
          );
          days.add(Day(id: dayId, blockId: blockId, order: dayOrder));
        }

        return BlockWithDays(id: blockId, name: name, days: days);
      });

  /// Retrieve a list of days for a given block
  /// Days are sorted by order.
  /// Each day's sessions are sorted by date then by id
  /// Each session's exercises are sorted by order then by supersetOrder
  /// Each exercise's sets are sorted by order
  Future<
          List<
              DayWithSessions<
                  SessionWithExercises<ExerciseWithMovementAndSets>>>>
      getDaysByBlockId(int blockId) {
    final query = select(dayDAO).join([
      leftOuterJoin(
        sessionDAO,
        sessionDAO.dayId.equalsExp(dayDAO.id),
      ),
      leftOuterJoin(
        exerciseDAO,
        exerciseDAO.sessionId.equalsExp(sessionDAO.id),
      ),
      leftOuterJoin(
        movementDAO,
        movementDAO.id.equalsExp(exerciseDAO.movementId),
      ),
      leftOuterJoin(
        exerciseSetDAO,
        exerciseSetDAO.exerciseId.equalsExp(exerciseDAO.id),
      ),
    ]);
    query.where(dayDAO.blockId.equals(blockId));
    query.orderBy([
      OrderingTerm(expression: dayDAO.order),
      OrderingTerm(expression: sessionDAO.date),
      OrderingTerm(expression: sessionDAO.id),
      OrderingTerm(expression: exerciseDAO.order),
      OrderingTerm(expression: exerciseDAO.supersetOrder),
      OrderingTerm(expression: exerciseSetDAO.order),
    ]);

    return query
        .get()
        .then(_mapRowsToDaysWithSessionsWithExercisesWithMovementAndSets);
  }

  List<DayWithSessions<SessionWithExercises<ExerciseWithMovementAndSets>>>
      _mapRowsToDaysWithSessionsWithExercisesWithMovementAndSets(rows) {
    final Map<
            Day,
            Map<Session,
                Map<Exercise, ({List<ExerciseSet> sets, Movement movement})>>>
        daySessionsMap = {};
    for (final row in rows) {
      final day = row.readTable(dayDAO) as Day;
      final dayMap = daySessionsMap.putIfAbsent(day, () => {});

      final session = row.readTableOrNull(sessionDAO) as Session?;
      if (session != null) {
        final sessionMap = dayMap.putIfAbsent(session, () => {});

        final exercise = row.readTableOrNull(exerciseDAO) as Exercise?;
        if (exercise != null) {
          final movement = row.readTable(movementDAO) as Movement;
          final exerciseMap = sessionMap.putIfAbsent(
            exercise,
            () => (sets: [], movement: movement),
          );

          final set = row.readTableOrNull(exerciseSetDAO) as ExerciseSet?;
          if (set != null) {
            exerciseMap.sets.add(set);
          }
        }
      }
    }

    return daySessionsMap.entries.map((entry) {
      final day = entry.key;
      return DayWithSessions(
        id: day.id,
        blockId: day.blockId,
        order: day.order,
        sessions: entry.value.entries.map((entry) {
          final session = entry.key;
          return SessionWithExercises(
            id: session.id,
            dayId: session.dayId,
            date: session.date,
            exercises: entry.value.entries.map((entry) {
              final exercise = entry.key;
              return ExerciseWithMovementAndSets(
                id: exercise.id,
                sessionId: exercise.sessionId,
                order: exercise.order,
                supersetOrder: exercise.supersetOrder,
                movement: entry.value.movement,
                sets: entry.value.sets,
              );
            }).toList(),
          );
        }).toList(),
      );
    }).toList();
  }
}

LazyDatabase openConnection() => LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, 'db.sqlite'));

      // Also work around limitations on old Android versions
      if (Platform.isAndroid) {
        await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      }

      // Make sqlite3 pick a more suitable location for temporary files - the
      // one from the system may be inaccessible due to sandboxing.
      // We can't access /tmp on Android, which sqlite3 would try by default.
      // Explicitly tell it about the correct temporary directory.
      sqlite3.tempDirectory = (await getTemporaryDirectory()).path;

      return NativeDatabase.createInBackground(file);
    });

class DatabaseFailure implements Failure {
  final String message;
  DatabaseFailure(this.message);
}
