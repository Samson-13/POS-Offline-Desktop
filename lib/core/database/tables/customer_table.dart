import 'package:drift/drift.dart';

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()(); // Primary key
  IntColumn get invoiceNumber =>
      integer().nullable().customConstraint('UNIQUE')();
  TextColumn get gstinNumber => text().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get address => text().nullable()();
  TextColumn get phoneNumber => text()();
}
