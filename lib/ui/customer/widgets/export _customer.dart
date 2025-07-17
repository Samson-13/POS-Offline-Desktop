// ignore: file_names
import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pos_offline_desktop/core/database/app_database.dart'
    show AppDatabase;

Future<void> exportCustomersToExcel(
  AppDatabase db,
  BuildContext context,
) async {
  try {
    final customers = await db.customerDao.getAllCustomers();

    log('Customers fetched: ${customers.length}');
    log(
      'Customer details: ${customers.map((c) => "${c.id}: ${c.name}").join(", ")}',
    );

    if (customers.isEmpty) {
      // ignore: use_build_context_synchronously
      showSnack(context, 'No customers found to export.');
      return;
    }

    final outputDir = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select export folder',
    );
    if (outputDir == null) {
      // ignore: use_build_context_synchronously
      showSnack(context, 'Export cancelled.');
      return;
    }

    // ignore: use_build_context_synchronously
    final fileName = await askForFileName(context);
    if (fileName == null || fileName.trim().isEmpty) {
      // ignore: use_build_context_synchronously
      showSnack(context, 'Invalid filename.');
      return;
    }

    final fullPath = '$outputDir/${fileName.trim()}.xlsx';

    final excel = Excel.createExcel();
    const sheetName = 'Customers';
    excel.rename('Sheet1', sheetName);
    final sheet = excel.sheets[sheetName];

    final headers = ['Name', 'Phone', 'Address', 'GSTIN'];
    for (int col = 0; col < headers.length; col++) {
      sheet!.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
        ..value = TextCellValue(headers[col])
        ..cellStyle = CellStyle(
          bold: true,
          fontSize: 14,
          horizontalAlign: HorizontalAlign.Center,
        );
    }

    for (int i = 0; i < customers.length; i++) {
      final c = customers[i];
      final row = i + 1; // Start after header row

      sheet!
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = TextCellValue(
        c.name,
      );

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = TextCellValue(
        c.phoneNumber,
      );

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
          .value = TextCellValue(
        c.address ?? '',
      );

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
          .value = TextCellValue(
        c.gstinNumber ?? '',
      );

      log('Added customer row $row: ${c.name}');
    }

    final bytes = excel.encode();
    if (bytes != null) {
      final file = File(fullPath);
      await file.writeAsBytes(bytes, flush: true);
      log('Customers exported to: $fullPath');
      // ignore: use_build_context_synchronously
      showSnack(context, 'Customers exported to: $fullPath');
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

Future<String?> askForFileName(BuildContext context) async {
  final controller = TextEditingController(
    text: 'customers_pos_offline_desktop_',
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
