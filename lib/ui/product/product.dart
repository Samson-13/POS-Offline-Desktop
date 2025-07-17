import 'package:flutter/material.dart';
import 'package:pos_offline_desktop/database/app_database.dart';

import 'widgets/widgets.dart';

class ProductScreen extends StatefulWidget {
  final AppDatabase db;

  const ProductScreen({super.key, required this.db});

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
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
          child: ProductContainer(db: db),
        ),
      ),
    );
  }
}
