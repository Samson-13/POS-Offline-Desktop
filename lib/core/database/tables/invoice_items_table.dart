import 'package:drift/drift.dart';
import 'tables.dart'; // or correct path to Products and Invoices

class InvoiceItems extends Table {
  IntColumn get id => integer().autoIncrement()(); // Primary key

  IntColumn get invoiceId =>
      integer().references(Invoices, #id)(); // FK to Invoices
  IntColumn get productId =>
      integer().references(Products, #id)(); // FK to Products

  IntColumn get quantity => integer().withDefault(const Constant(1))();
  IntColumn get ctn => integer().nullable()();
  RealColumn get price => real()();
}
