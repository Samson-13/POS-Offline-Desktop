import 'package:drift/drift.dart';

class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()(); // Primary key

  TextColumn get customerName => text().withLength(min: 1, max: 255)();
  TextColumn get customerContact => text().withLength(min: 1, max: 255)();
  TextColumn get customerAddress => text().nullable()();
  RealColumn get totalAmount => real().withDefault(const Constant(0))();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
}
