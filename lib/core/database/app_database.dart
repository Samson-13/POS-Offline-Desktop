import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'dao/dao.dart';
import 'tables/tables.dart'; // Add this import

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Products, Customers, Invoices, InvoiceItems],
  daos: [ProductDao, CustomerDao, InvoiceDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    // onUpgrade: (Migrator m, int from, int to) async {
    //   if (from < 2) {
    //     await m.createTable(invoices);
    //   }
    //   if (from < 3) {
    //     await m.createTable(invoiceItems);
    //   }
    // },
    beforeOpen: (details) async {
      // Log the tables in the database
      final tables = await customSelect(
        "SELECT name FROM sqlite_master WHERE type = 'table';",
      ).get();

      for (final row in tables) {
        log('[DB Table] ${row.data['name']}');
      }

      // Log the database file location
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbPath = p.join(
        dbFolder.path,
        'pos_offline_desktop_database/pos_offline_desktop_database.sqlite',
      ); // Adjust filename if needed
      log('Database path: $dbPath'); // Logs the database path
    },
  );
}
