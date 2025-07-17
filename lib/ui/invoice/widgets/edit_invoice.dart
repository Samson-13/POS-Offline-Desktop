import 'package:flutter/material.dart';
import 'package:pos_offline_desktop/database/app_database.dart';

class EditInvoiceDialog extends StatefulWidget {
  final Invoice invoice;

  const EditInvoiceDialog({super.key, required this.invoice});

  @override
  State<EditInvoiceDialog> createState() => _EditInvoiceDialogState();
}

class _EditInvoiceDialogState extends State<EditInvoiceDialog> {
  late TextEditingController _customerController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _customerController = TextEditingController(
      text: widget.invoice.customerName,
    );
    _amountController = TextEditingController(
      text: widget.invoice.totalAmount.toString(),
    );
  }

  @override
  void dispose() {
    _customerController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Invoice'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _customerController,
            readOnly: true,
            decoration: const InputDecoration(labelText: 'Customer Name'),
          ),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Total Amount'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updated = widget.invoice.copyWith(
              customerName: _customerController.text,
              totalAmount: double.tryParse(_amountController.text) ?? 0,
            );
            Navigator.pop(context, updated);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
