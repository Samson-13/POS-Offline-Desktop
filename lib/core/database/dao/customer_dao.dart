// database/dao/customer_dao.dart
import 'package:drift/drift.dart';
import 'package:pos_offline_desktop/core/database/tables/customer_table.dart';

import '../app_database.dart';

part 'customer_dao.g.dart';

@DriftAccessor(tables: [Customers])
class CustomerDao extends DatabaseAccessor<AppDatabase>
    with _$CustomerDaoMixin {
  CustomerDao(super.db);

  // Fetch all customers
  Future<List<Customer>> getAllCustomers() => select(customers).get();

  Stream<List<Customer>> watchAllCustomers() => select(customers).watch();

  Future<int> insertCustomer(Insertable<Customer> customer) =>
      into(customers).insert(customer);

  Future<bool> updateCustomer(Insertable<Customer> customer) =>
      update(customers).replace(customer);

  Future<void> updateCustomerByCompanion(CustomersCompanion customer) {
    return (update(
      customers,
    )..where((tbl) => tbl.id.equals(customer.id.value))).write(customer);
  }

  // Total customer count
  Future<int> getTotalCustomerCount() async {
    final countExp = customers.id.count(); // or any column
    final query = selectOnly(customers)..addColumns([countExp]);

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<int> deleteCustomer(Insertable<Customer> customer) =>
      delete(customers).delete(customer);
}
