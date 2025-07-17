import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'invoice_dao.g.dart';

@DriftAccessor(tables: [Invoices, InvoiceItems])
class InvoiceDao extends DatabaseAccessor<AppDatabase> with _$InvoiceDaoMixin {
  InvoiceDao(super.db);

  // === Invoice CRUD ===
  Future<List<Invoice>> getAllInvoices() => select(invoices).get();

  Stream<List<Invoice>> watchAllInvoices() => select(invoices).watch();

  Future<int> insertInvoice(Insertable<Invoice> invoice) =>
      into(invoices).insert(invoice);

  Future updateInvoice(Insertable<Invoice> invoice) =>
      update(invoices).replace(invoice);

  Future deleteInvoice(Insertable<Invoice> invoice) =>
      delete(invoices).delete(invoice);

  // === Invoice Items ===
  Future<List<InvoiceItem>> getItemsByInvoiceId(int invoiceId) {
    return (select(
      invoiceItems,
    )..where((item) => item.invoiceId.equals(invoiceId))).get();
  }

  Future insertInvoiceItem(Insertable<InvoiceItem> item) =>
      into(invoiceItems).insert(item);

  Future deleteItemsByInvoiceId(int invoiceId) {
    return (delete(
      invoiceItems,
    )..where((item) => item.invoiceId.equals(invoiceId))).go();
  }

  // Query to get items for a specific invoice
  Future<List<InvoiceItem>> getInvoiceItems(int invoiceId) {
    return (select(
      invoiceItems,
    )..where((tbl) => tbl.invoiceId.equals(invoiceId))).get();
  }

  Future<List<(InvoiceItem, Product?)>> getItemsWithProductsByInvoice(
    int invoiceId,
  ) {
    final query = select(invoiceItems).join([
      leftOuterJoin(products, products.id.equalsExp(invoiceItems.productId)),
    ])..where(invoiceItems.invoiceId.equals(invoiceId));

    return query.map((row) {
      return (row.readTable(invoiceItems), row.readTableOrNull(products));
    }).get();
  }
}
