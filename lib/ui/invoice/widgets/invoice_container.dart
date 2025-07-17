import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw; // Use alias for pdf
import 'package:pos_offline_desktop/core/database/app_database.dart'
    show AppDatabase, Invoice;
import 'package:pos_offline_desktop/l10n/l10n.dart';
import 'package:pos_offline_desktop/ui/invoice/widgets/export_invoice.dart';
import 'package:pos_offline_desktop/ui/widgets/search_widget.dart';
import 'package:pos_offline_desktop/ui/widgets/widgets.dart';

import 'widgets.dart';

class InvoiceContainer extends StatefulWidget {
  final AppDatabase db;

  const InvoiceContainer({super.key, required this.db});

  @override
  State<InvoiceContainer> createState() => _InvoiceContainerState();
}

class _InvoiceContainerState extends State<InvoiceContainer> {
  List<Invoice> invoices = [];
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _savedInvoices = {};

  // Edit invoice dialog
  // void _editInvoice(Invoice invoice) async {
  //   final updatedInvoice = await showDialog<Invoice>(
  //     context: context,
  //     builder: (context) => EditInvoiceDialog(invoice: invoice),
  //   );

  //   if (updatedInvoice != null) {
  //     await widget.db.invoiceDao.updateInvoice(updatedInvoice);
  //     setState(() {}); // Refresh the UI
  //   }
  // }

  // Save invoice as PDF
  Future<void> _saveInvoiceAsPdf(Invoice invoice) async {
    final items = await widget.db.invoiceDao.getItemsWithProductsByInvoice(
      invoice.id,
    );

    final double sgst = invoice.totalAmount * 0.09;
    final double cgst = invoice.totalAmount * 0.09;
    final double grandTotal = invoice.totalAmount + sgst + cgst;
    final rupees = grandTotal.floor();
    final paise = ((grandTotal - rupees) * 100).round();

    final rupeesInWords = NumberToWord()
        .convert('en-in', rupees)
        .replaceAll('-', ' ')
        .toUpperCase();

    final paiseInWords = paise > 0
        ? ' AND ${NumberToWord().convert('en-in', paise).replaceAll('-', ' ').toUpperCase()} PAISE'
        : '';

    final totalInWords = '$rupeesInWords RUPEES$paiseInWords ONLY';

    final font = await rootBundle.load(
      'assets/fonts/PlusJakartaSans-Regular.ttf',
    );
    final ttf = pw.Font.ttf(font);

    final pdf = pw.Document();

    String formatDate(DateTime date) {
      return DateFormat('dd-MM-yyyy h:mm a').format(invoice.date);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        build: (pw.Context context) => [
          // Header
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("RFL Importer"),
                  pw.Text("GSTIN"),
                  pw.Text("15AGKPL8229J2Z0"),
                ],
              ),
              pw.Spacer(),
              pw.Column(
                children: [
                  pw.Text(
                    "GIDEES",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    "(NextComm)",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    "(INVOICE pos_offline_desktop)",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("M 11/7, Block A Chaltlang,"),
                  pw.Text("Aizawl, Mizoram - 796001"),
                  pw.Text("Ph : 9862384076"),
                  pw.Text("Ph : 9436198740 (M)"),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Text("Invoice #: ${invoice.id}"),
          pw.Text("Date: ${formatDate(invoice.date)}"),
          pw.SizedBox(height: 8),
          pw.Divider(),
          pw.Text(
            "Customer Info",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text("Name: ${invoice.customerName}"),
          pw.Text("Contact: ${invoice.customerContact}"),
          pw.Text("Address: ${invoice.customerAddress ?? ''}"),
          pw.SizedBox(height: 8),
          pw.Text(
            "Items",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.TableHelper.fromTextArray(
            headers: [
              'Sl. No.',
              'Product',
              'Rate',
              'Quantity',
              'CTN',
              'Amount',
            ],
            data: List.generate(items.length, (index) {
              final item = items[index].$1;
              final product = items[index].$2;

              return [
                (index + 1).toString(),
                product?.name ?? 'Unknown',
                '₹ ${item.price.toStringAsFixed(2)}',
                item.quantity.toString(),
                item.ctn?.toString() ?? ' ', // Add CTN value safely

                '₹ ${(item.price * item.quantity).toStringAsFixed(2)}',
              ];
            }),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
              font: ttf,
            ),
            cellStyle: pw.TextStyle(fontSize: 9, font: ttf),
            headerAlignment: pw.Alignment.center,
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.centerLeft, // ✅ Product name left-aligned
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.center,
              5: pw.Alignment.center,
            },
            // Fake "headerAlignment" by inserting alignment manually:
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            columnWidths: {
              // Do not modify your existing widths if you're happy with them
            },
          ),
          pw.SizedBox(height: 3),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey, width: 0.5),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Total: ₹ ${invoice.totalAmount.toStringAsFixed(2)}',
                  style: pw.TextStyle(font: ttf, fontSize: 10),
                ),
                pw.Text(
                  'SGST (9%): ₹ ${sgst.toStringAsFixed(2)}',
                  style: pw.TextStyle(font: ttf, fontSize: 10),
                ),
                pw.Text(
                  'CGST (9%): ₹ ${cgst.toStringAsFixed(2)}',
                  style: pw.TextStyle(font: ttf, fontSize: 10),
                ),
                pw.Divider(),
                pw.Text(
                  'Grand Total:₹ ${grandTotal.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontSize: 10,
                    font: ttf,

                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  totalInWords,
                  style: pw.TextStyle(font: ttf, fontSize: 10),
                ),
                pw.SizedBox(height: 18),
                pw.Text(
                  'Authorized Signatory',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final outputPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Invoice As PDF',
      fileName: '${invoice.id} - ${invoice.customerName}.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (outputPath != null) {
      final file = File(outputPath);
      await file.writeAsBytes(await pdf.save());

      setState(() {
        _savedInvoices.add(invoice.id); // Track saved invoice
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice saved successfully!')),
      );
      await OpenFile.open(file.path);
    }
  }

  List<Invoice> _filteredInvoices = [];

  // Function to filter invoices based on the search query
  void _searchInvoices(String query) {
    final filtered = invoices.where((invoice) {
      return invoice.id.toString().contains(query) ||
          invoice.customerName.toLowerCase().contains(query.toLowerCase()) ||
          invoice.customerContact.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredInvoices = filtered;
    });
  }

  void _showDeleteConfirmation(Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmationDialog(
          name: invoice.customerName,
          onConfirm: () async {
            await widget.db.invoiceDao.deleteInvoice(invoice);
            setState(() {});
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() => _filteredInvoices = invoices);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),

            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title & Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.invoice_list,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final newInvoice = await showDialog<Invoice>(
                            context: context,
                            builder: (context) =>
                                AddInvoiceDialog(db: widget.db),
                          );

                          if (newInvoice != null) {
                            log('Invoice added: ${newInvoice.id}');
                            setState(
                              () {},
                            ); // Refresh the UI, no need to insert again
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          backgroundColor: Colors.black,
                        ),
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text(
                          context.l10n.add_invoice,
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
                    onPressed: () {
                      exportInvoicesToExcel(widget.db, context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      backgroundColor: const Color.fromARGB(255, 73, 8, 85),
                    ),
                    icon: const Icon(
                      Icons.table_chart,
                      color: Colors.white,
                      size: 18,
                    ),
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
                  // Search Widget for invoices
                  SearchWidget(
                    controller: _searchController,
                    onSearch: _searchInvoices,
                    hintText: 'Search Invoices', // Customize the hint text
                  ),
                  const Gap(12),

                  /// Invoice Table
                  Expanded(
                    child: StreamBuilder<List<Invoice>>(
                      stream: widget.db.invoiceDao.watchAllInvoices(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          log('No invoices found: ${snapshot.error}');
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        invoices = snapshot.data!;
                        invoices = invoices.reversed.toList();

                        if (_searchController.text.isEmpty) {
                          _filteredInvoices = invoices;
                        }

                        if (invoices.isEmpty) {
                          return const Center(
                            child: Text('No invoices available.'),
                          );
                        }

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 350,
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
                                DataColumn(label: Text('Invoice No')),
                                DataColumn(label: Text('Date')),
                                DataColumn(label: Text('Customer')),
                                DataColumn(label: Text('Total Amount')),
                                DataColumn(label: Text('')),
                              ],
                              rows: List.generate(_filteredInvoices.length, (
                                index,
                              ) {
                                final invoice = _filteredInvoices[index];

                                return DataRow(
                                  cells: [
                                    DataCell(Text('${invoice.id}')),
                                    DataCell(
                                      Text(
                                        DateFormat(
                                          'dd-MM-yyyy h:mm a',
                                        ).format(invoice.date),
                                      ),
                                    ),
                                    DataCell(Text(invoice.customerName)),
                                    DataCell(Text('₹${invoice.totalAmount}')),
                                    DataCell(
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // TextButton(
                                          //   onPressed:
                                          //       () => _editInvoice(invoice),
                                          //   style: TextButton.styleFrom(
                                          //     padding:
                                          //         const EdgeInsets.symmetric(
                                          //           horizontal: 8,
                                          //           vertical: 4,
                                          //         ),
                                          //     backgroundColor: Colors.black,
                                          //     foregroundColor: Colors.white,
                                          //   ),
                                          //   child: Text(context.l10n.print),
                                          // ),
                                          // Gap(8),
                                          TextButton(
                                            onPressed: () =>
                                                _saveInvoiceAsPdf(invoice),
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 4,
                                                  ),
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: Text(
                                              context.l10n.export_to_pdf,
                                            ),
                                          ),

                                          Gap(8),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline_sharp,
                                              size: 18,
                                            ),
                                            onPressed: () =>
                                                _showDeleteConfirmation(
                                                  invoice,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
