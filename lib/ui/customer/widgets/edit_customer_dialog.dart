import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:pos_offline_desktop/core/database/app_database.dart';
import 'package:pos_offline_desktop/l10n/l10n.dart';
import 'package:pos_offline_desktop/ui/home/widgets/text_formatter.dart';

class EditCustomerDialog extends StatefulWidget {
  final Customer customer;

  const EditCustomerDialog({super.key, required this.customer});

  @override
  State<EditCustomerDialog> createState() => _EditCustomerDialogState();
}

class _EditCustomerDialogState extends State<EditCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _gstinController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.customer.name);
    _phoneController = TextEditingController(text: widget.customer.phoneNumber);
    _addressController = TextEditingController(
      text: widget.customer.address ?? '',
    );
    _gstinController = TextEditingController(
      text: widget.customer.gstinNumber.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _gstinController.dispose();

    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedData = CustomersCompanion(
        id: Value(widget.customer.id),
        name: Value(_nameController.text.trim()),
        phoneNumber: Value(_phoneController.text.trim()),
        address: (_addressController.text.isNotEmpty)
            ? Value(_addressController.text.trim())
            : const Value.absent(),
        gstinNumber: Value(_gstinController.text.trim()),
      );
      Navigator.of(context).pop(updatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: context.l10n.customer_name,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? context.l10n.enter_valid_customer_name
                    : null,
              ),
              const Gap(16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: context.l10n.phone_number,
                  border: const OutlineInputBorder(),
                  counterText:
                      '', // Hides the default counter text below the field
                ),
                keyboardType: TextInputType.number,
                maxLength: 10, // Limit input length to 10
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only numbers
                  LengthLimitingTextInputFormatter(
                    10,
                  ), // Hard stop at 10 digits
                ],
                validator: (value) =>
                    (value == null || value.isEmpty || value.length < 10)
                    ? context.l10n.enter_valid_phone_number
                    : null,
              ),
              const Gap(16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: context.l10n.address,
                  border: const OutlineInputBorder(),
                ),
              ),
              const Gap(16),
              TextFormField(
                controller: _gstinController,
                decoration: InputDecoration(
                  labelText: context.l10n.gstin,
                  border: const OutlineInputBorder(),
                  counterText: '', // Hides the default counter text
                ),
                maxLength: 15,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                  LengthLimitingTextInputFormatter(15),
                ],
                textCapitalization: TextCapitalization.characters,
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(context.l10n.cancel),
                  ),
                  ElevatedButton(
                    onPressed: _saveChanges,

                    child: Text(context.l10n.save_customer),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
