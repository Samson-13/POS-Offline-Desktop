import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pos_offline_desktop/core/database/app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase(_openConnection());
});

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbDir = Directory(
      p.join(dbFolder.path, 'pos_offline_desktop_database'),
    );

    // Ensure the directory exists
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }

    final file = File(
      p.join(dbDir.path, 'pos_offline_desktop_database.sqlite'),
    );
    return NativeDatabase(file);
  });
}
