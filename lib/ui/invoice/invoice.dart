import 'package:flutter/material.dart';
import 'package:pos_offline_desktop/database/app_database.dart';
import 'package:pos_offline_desktop/ui/invoice/widgets/invoice_container.dart';

class InvoiceScreen extends StatefulWidget {
  final AppDatabase db;

  const InvoiceScreen({super.key, required this.db});

  @override
  InvoiceScreenState createState() => InvoiceScreenState();
}

class InvoiceScreenState extends State<InvoiceScreen> {
  late final AppDatabase db;

  @override
  void initState() {
    super.initState();
    db = widget.db;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: InvoiceContainer(db: db),
        ),
      ),
    );
  }
}
