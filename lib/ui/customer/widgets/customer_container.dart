import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pos_offline_desktop/database/app_database.dart';
import 'package:pos_offline_desktop/l10n/l10n.dart';
import 'package:pos_offline_desktop/ui/widgets/search_widget.dart';

import '../../widgets/widgets.dart';
import 'widgets.dart';

class CustomerContainer extends StatefulWidget {
  final AppDatabase db;

  const CustomerContainer({super.key, required this.db});

  @override
  State<CustomerContainer> createState() => _CustomerContainerState();
}

class _CustomerContainerState extends State<CustomerContainer> {
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.db.customerDao.watchAllCustomers().listen((event) {
      if (mounted) {
        setState(() {
          customers = event;
          filteredCustomers = event;
        });
      }
    });
  }

  void _searchCustomers(String query) {
    final lowerQuery = query.toLowerCase();
    final filtered = customers.where((customer) {
      return customer.name.toLowerCase().contains(lowerQuery) ||
          customer.phoneNumber.toLowerCase().contains(lowerQuery) ||
          (customer.address ?? '').toLowerCase().contains(lowerQuery);
    }).toList();

    if (mounted) {
      setState(() {
        filteredCustomers = filtered;
      });
    }
  }

  void _showDeleteConfirmation(Customer customer) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmationDialog(
          name: customer.name,
          onConfirm: () async {
            await widget.db.customerDao.deleteCustomer(customer);
          },
        );
      },
    );
  }

  void _editCustomer(Customer customer) async {
    // Pre-fill the form with the customer’s existing data
    final updatedCustomerData = await showDialog<CustomersCompanion>(
      context: context,
      builder: (context) => EditCustomerDialog(customer: customer),
    );

    if (updatedCustomerData != null) {
      await widget.db.customerDao.updateCustomer(updatedCustomerData);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Add Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.customer_list,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final newCustomerData = await showDialog<Map<String, String>>(
                  context: context,
                  builder: (context) => const AddCustomerDialog(),
                );

                if (newCustomerData != null) {
                  final newCustomer = CustomersCompanion(
                    name: Value(newCustomerData['name']!),
                    phoneNumber: Value(newCustomerData['phoneNumber']!),
                    address: (newCustomerData['address']?.isNotEmpty ?? false)
                        ? Value(newCustomerData['address']!)
                        : const Value.absent(),
                    gstinNumber: newCustomerData['gstinNumber'] != null
                        ? Value(newCustomerData['gstinNumber'])
                        : const Value.absent(),
                  );

                  await widget.db.customerDao.insertCustomer(newCustomer);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                backgroundColor: Colors.black,
              ),
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: Text(
                context.l10n.add_customer,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const Gap(12),
        ElevatedButton.icon(
          onPressed: () async {
            await exportCustomersToExcel(widget.db, context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            backgroundColor: const Color.fromARGB(255, 73, 8, 85),
          ),
          icon: const Icon(Icons.table_chart, color: Colors.white, size: 18),
          label: Text(
            context.l10n.export,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        const Gap(12),
        SearchWidget(
          controller: _searchController,
          onSearch: _searchCustomers,
          hintText: 'Search Customers',
        ),
        const Gap(12),
        Expanded(
          child: StreamBuilder<List<Customer>>(
            stream: widget.db.customerDao.watchAllCustomers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final customers = filteredCustomers;
              if (customers.isEmpty) {
                return const Center(
                  child: Text(
                    'No customers available.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 350,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      border: TableBorder.all(
                        color: Colors.grey.shade300,
                        width: 0.8,
                      ),
                      columnSpacing: 10,
                      headingRowColor: WidgetStateColor.resolveWith(
                        (states) => Colors.grey.shade100,
                      ),
                      headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      dataTextStyle: const TextStyle(fontSize: 13),
                      columns: const [
                        DataColumn(label: Text('SL')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Contact')),
                        DataColumn(label: Text('Address')),
                        DataColumn(label: Text('GSTIN')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: List.generate(customers.length, (index) {
                        final customer = customers[index];
                        return DataRow(
                          cells: [
                            DataCell(Text('${index + 1}')),
                            DataCell(Text(customer.name)),
                            DataCell(Text(customer.phoneNumber)),
                            DataCell(Text(customer.address ?? '')),
                            DataCell(Text(customer.gstinNumber ?? 'NIL')),

                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                    ),
                                    onPressed: () => _editCustomer(customer),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_sharp,
                                      size: 18,
                                    ),
                                    onPressed: () =>
                                        _showDeleteConfirmation(customer),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
