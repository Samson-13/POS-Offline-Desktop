import 'dart:developer';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos_offline_desktop/core/database/app_database.dart';
import 'package:pos_offline_desktop/l10n/l10n.dart';

class AddInvoiceDialog extends StatefulHookConsumerWidget {
  final AppDatabase db;

  const AddInvoiceDialog({super.key, required this.db});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddInvoiceDialogState();
}

class _AddInvoiceDialogState extends ConsumerState<AddInvoiceDialog> {
  final _formKey = GlobalKey<FormState>();
  double _totalAmount = 0.0;

  List<Customer> _customers = [];
  List<Product> _products = [];

  Customer? _selectedCustomer;

  final List<_SelectedProductEntry> _selectedEntries = [];

  @override
  void initState() {
    super.initState();
    _loadCustomersAndProducts();
  }

  Future<void> _loadCustomersAndProducts() async {
    final db = widget.db;
    final customers = await db.customerDao.getAllCustomers();
    final products = await db.productDao.getAllProducts();

    setState(() {
      _customers = customers;
      _products = products;
    });
  }

  void _calculateTotalAmount() {
    double total = 0;
    for (final entry in _selectedEntries) {
      if (entry.product != null && entry.quantity > 0) {
        total += entry.product!.price * entry.quantity;
      }
    }
    setState(() => _totalAmount = total);
  }

  Future<void> _saveInvoice() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.select_customer)));
      return;
    }

    final db = widget.db;

    try {
      final invoiceId = await db.invoiceDao.insertInvoice(
        InvoicesCompanion(
          customerName: Value(_selectedCustomer!.name),
          customerContact: Value(_selectedCustomer!.phoneNumber),
          customerAddress: Value(_selectedCustomer!.address ?? ''),
          totalAmount: Value(_totalAmount),
          date: Value(DateTime.now()),
        ),
      );

      for (final entry in _selectedEntries) {
        if (entry.product == null || entry.quantity <= 0) continue;

        final updatedQuantity = entry.product!.quantity - entry.quantity;
        if (updatedQuantity < 0) {
          throw Exception("Insufficient stock for ${entry.product!.name}");
        }

        await db.productDao.updateProduct(
          entry.product!.copyWith(quantity: updatedQuantity),
        );

        await db.invoiceDao.insertInvoiceItem(
          InvoiceItemsCompanion(
            invoiceId: Value(invoiceId),
            productId: Value(entry.product!.id),
            quantity: Value(entry.quantity),
            ctn: Value(entry.ctn ?? 0),

            price: Value(entry.product!.price),
          ),
        );
      }

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      log('Error saving invoice: $e');
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showProductSelectionDialog() {
    // Copy current selection to a local mutable set
    final tempSelectedIds = _selectedEntries.map((e) => e.product!.id).toSet();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Select Products'),
              content: SizedBox(
                width: 400,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    final isSelected = tempSelectedIds.contains(product.id);

                    return CheckboxListTile(
                      title: Text('${product.name} (${product.quantity})'),
                      value: isSelected,
                      onChanged: (bool? checked) {
                        setStateDialog(() {
                          if (checked == true) {
                            tempSelectedIds.add(product.id);
                          } else {
                            tempSelectedIds.remove(product.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(context.l10n.cancel),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedEntries
                        ..clear()
                        ..addAll(
                          tempSelectedIds.map(
                            (id) => _SelectedProductEntry()
                              ..product = _products.firstWhere(
                                (p) => p.id == id,
                              )
                              ..quantity = 1,
                          ),
                        );
                      _calculateTotalAmount();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.add_invoice),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<Customer>(
                value: _selectedCustomer,
                items: _customers
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCustomer = val),
                decoration: InputDecoration(
                  hintText: context.l10n.select_customer,
                ),
              ),
              const Gap(20),

              ElevatedButton(
                onPressed: _showProductSelectionDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  context.l10n.select_products,
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const Gap(10),

              ..._selectedEntries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: entry.ctn?.toString() ?? '',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: context.l10n.ctn),
                      onChanged: (val) {
                        setState(() {
                          entry.ctn = int.tryParse(val);
                        });
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (val) {
                        final ctn = int.tryParse(val ?? '');
                        if (ctn == null || ctn < 0) return 'Enter a valid CTN';
                        return null;
                      },
                    ),
                    const Gap(6),

                    Text(
                      '${entry.product?.name ?? ''} (${entry.product?.quantity ?? 0})',
                    ),
                    TextFormField(
                      initialValue: entry.quantity.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        final qty = int.tryParse(val) ?? 0;
                        setState(() {
                          entry.quantity = qty;
                          _calculateTotalAmount();
                        });
                      },
                      validator: (val) {
                        final qty = int.tryParse(val ?? '') ?? -1;
                        if (qty <= 0) return context.l10n.enter_valid_quantity;
                        if (entry.product != null &&
                            qty > entry.product!.quantity) {
                          return context.l10n.exceeds_available_stock;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: context.l10n.enter_quantity,
                      ),
                    ),
                    const Gap(10),
                  ],
                );
              }),
              const Gap(10),

              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: _totalAmount.toStringAsFixed(2),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                decoration: InputDecoration(
                  hintText: context.l10n.total_amount,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _saveInvoice,
          child: Text(context.l10n.save_invoice),
        ),
      ],
    );
  }
}

class _SelectedProductEntry {
  Product? product;
  int quantity = 1;
  int? ctn;
}
