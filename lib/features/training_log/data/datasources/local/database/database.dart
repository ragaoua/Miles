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
import '../../../../domain/entities/session.dart';

part '../dao/block_dao.dart';
part '../dao/day_dao.dart';
part '../dao/session_dao.dart';
part 'database.g.dart';

@DriftDatabase(
    tables: [
      BlockDAO,
      DayDAO,
      SessionDAO,
    ]
)
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}

LazyDatabase openConnection() =>
    LazyDatabase(() async {
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