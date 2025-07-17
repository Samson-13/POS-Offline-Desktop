import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pos_offline_desktop/core/database/app_database.dart';
import 'package:pos_offline_desktop/l10n/l10n.dart';

class EditProductDialog extends StatefulWidget {
  final Product product;

  const EditProductDialog({super.key, required this.product});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _quantityController = TextEditingController(
      text: widget.product.quantity.toString(),
    );
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedData = ProductsCompanion(
        id: Value(widget.product.id),
        name: Value(_nameController.text.trim()),
        quantity: Value(int.parse(_quantityController.text.trim())),
        price: Value(double.parse(_priceController.text.trim())),
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
                  labelText: context.l10n.product_name,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? context.l10n.enter_valid_product_name
                    : null,
              ),
              const Gap(16),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: context.l10n.quantity,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    (value == null || int.tryParse(value) == null)
                    ? context.l10n.enter_valid_quantity
                    : null,
              ),
              const Gap(16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: context.l10n.price,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) =>
                    (value == null || double.tryParse(value) == null)
                    ? context.l10n.enter_valid_price
                    : null,
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[900],
                    ),
                    child: Text(context.l10n.save_product),
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
