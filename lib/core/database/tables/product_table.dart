import 'package:drift/drift.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement().unique()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  RealColumn get price =>
      real().withDefault(const Constant(0))(); // Add this if missing
}
