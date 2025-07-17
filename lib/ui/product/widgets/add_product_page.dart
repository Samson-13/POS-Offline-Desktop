import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos_offline_desktop/l10n/l10n.dart';
import 'package:pos_offline_desktop/ui/widgets/custom_button.dart';

class AddProductDialog extends StatefulHookConsumerWidget {
  const AddProductDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final productData = {
        'name': _nameController.text.trim(),
        'quantity': int.tryParse(_quantityController.text.trim()) ?? 0,
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
      };

      log('New Product: $productData');
      Navigator.of(context).pop(productData);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: 500,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true, // To prevent overflow
            children: [
              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: context.l10n.product_name,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.enter_valid_product_name;
                  }
                  return null;
                },
              ),
              const Gap(16),

              // Quantity
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only numbers
                ],
                decoration: InputDecoration(
                  labelText: context.l10n.quantity,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      int.tryParse(value.trim()) == null) {
                    return context.l10n.enter_valid_quantity;
                  }
                  return null;
                },
              ),
              const Gap(16),

              // Price
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only numbers
                ],
                decoration: InputDecoration(
                  labelText: context.l10n.price,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      double.tryParse(value.trim()) == null) {
                    return context.l10n.enter_valid_price;
                  }
                  return null;
                },
              ),
              const Gap(24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    onPressed: () => Navigator.of(context).pop(),
                    backgroundColor: Colors.red.shade400,

                    title: context.l10n.cancel,
                  ),
                  CustomButton(
                    title: context.l10n.save,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: _saveProduct,
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
