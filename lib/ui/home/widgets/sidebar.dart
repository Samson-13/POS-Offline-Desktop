// dashboard_page_content.dart
import 'package:flutter/material.dart';
import 'package:pos_offline_desktop/core/database/app_database.dart';

import 'widgets.dart';

class SideBarPageContent extends StatelessWidget {
  final AppDatabase db;

  const SideBarPageContent({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: db.productDao.getTotalProductCount(),
      builder: (context, productSnapshot) {
        if (productSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // While loading
        }
        if (productSnapshot.hasError) {
          return Center(
            child: Text('Error: ${productSnapshot.error}'),
          ); // In case of error
        }

        final totalProducts = productSnapshot.data ?? 0;

        return FutureBuilder<int>(
          future: db.customerDao.getTotalCustomerCount(),
          builder: (context, customerSnapshot) {
            if (customerSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              ); // While loading
            }
            if (customerSnapshot.hasError) {
              return Center(
                child: Text('Error: ${customerSnapshot.error}'),
              ); // In case of error
            }

            final totalCustomers = customerSnapshot.data ?? 0;

            return ContainerBoxWidget(
              totalProducts: totalProducts,
              totalCustomers: totalCustomers,
            );
          },
        );
      },
    );
  }
}
