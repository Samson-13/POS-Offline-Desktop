import 'package:flutter/material.dart';
import 'package:pos_offline_desktop/core/database/app_database.dart';

import 'widgets/widgets.dart';

class CustomerScreen extends StatefulWidget {
  final AppDatabase db;

  const CustomerScreen({super.key, required this.db});

  @override
  CustomerScreenState createState() => CustomerScreenState();
}

class CustomerScreenState extends State<CustomerScreen> {
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
          child: CustomerContainer(db: db),
        ),
      ),
    );
  }
}
