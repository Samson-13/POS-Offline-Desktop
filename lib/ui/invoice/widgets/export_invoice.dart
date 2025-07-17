import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pos_offline_desktop/core/database/app_database.dart';

Future<void> exportInvoicesToExcel(AppDatabase db, BuildContext context) async {
  try {
    final invoices = await db.invoiceDao.getAllInvoices();

    log('Invoices fetched: ${invoices.length}');
    if (invoices.isEmpty) {
      // ignore: use_build_context_synchronously
      showSnack(context, 'No invoices found to export.');
      return;
    }

    // Ask user to pick a directory
    final outputDir = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select export folder',
    );
    if (outputDir == null) {
      // ignore: use_build_context_synchronously
      showSnack(context, 'Export cancelled.');
      return;
    }

    // Ask user for a filename
    // ignore: use_build_context_synchronously
    final fileName = await _askForFileName(context);
    if (fileName == null || fileName.trim().isEmpty) {
      // ignore: use_build_context_synchronously
      showSnack(context, 'Invalid filename.');
      return;
    }

    final fullPath = '$outputDir/${fileName.trim()}.xlsx';

    final excel = Excel.createExcel();
    const sheetName = 'Invoices';
    excel.rename('Sheet1', sheetName);
    final sheet = excel.sheets[sheetName];

    final headers = ['Invoice No', 'Date', 'Customer', 'Total Amount'];
    for (int col = 0; col < headers.length; col++) {
      sheet!.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
        ..value = TextCellValue(headers[col])
        ..cellStyle = CellStyle(
          bold: true,
          fontSize: 14,
          horizontalAlign: HorizontalAlign.Center,
        );
    }

    for (int i = 0; i < invoices.length; i++) {
      final inv = invoices[i];
      sheet!
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
          .value = IntCellValue(
        inv.id,
      );
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
          .value = TextCellValue(
        inv.date.toIso8601String(),
      );
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1))
          .value = TextCellValue(
        inv.customerName,
      );
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1))
          .value = TextCellValue(
        '₹ ${inv.totalAmount.toString()}',
      );
    }

    final bytes = excel.encode();
    if (bytes != null) {
      final file = File(fullPath);
      await file.writeAsBytes(bytes, flush: true);
      log('Invoices exported to: $fullPath');
      // ignore: use_build_context_synchronously
      showSnack(context, 'Invoices exported to: $fullPath');
    } else {
      // ignore: use_build_context_synchronously
      showSnack(context, 'Failed to generate Excel bytes.');
    }
  } catch (e, stackTrace) {
    log('Export Error: $e');
    log('Stack trace: $stackTrace');
    // ignore: use_build_context_synchronously
    showSnack(context, 'Failed to export: $e');
  }
}

Future<String?> _askForFileName(BuildContext context) async {
  final controller = TextEditingController(
    text: 'invoices_pos_offline_desktop_',
  );
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Enter file name'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'File name (without extension)',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(controller.text),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
