import 'package:flutter/material.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  String? validatorMessage,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
    validator:
        validatorMessage != null
            ? (value) {
              if (value == null || value.trim().isEmpty) {
                return validatorMessage;
              }
              return null;
            }
            : null,
  );
}
