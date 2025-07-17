import 'package:flutter/material.dart';
import 'package:pos_offline_desktop/l10n/l10n.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String name;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.name,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.are_you_sure_you_want_to_delete),

      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Dismiss dialog
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            onConfirm(); // Run delete action
            Navigator.of(context).pop(); // Close dialog
          },
          child: Text(context.l10n.delete, style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
