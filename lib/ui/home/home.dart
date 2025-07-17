// home_screen.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos_offline_desktop/core/database/app_database.dart';
import 'package:pos_offline_desktop/core/provider/app_database_provider.dart';
import 'package:pos_offline_desktop/l10n/l10n.dart';
import 'package:pos_offline_desktop/ui/customer/customer.dart';
import 'package:pos_offline_desktop/ui/invoice/invoice.dart';
import 'package:pos_offline_desktop/ui/pages/dashboard_page.dart';
import 'package:pos_offline_desktop/ui/widgets/side_bar.dart';

import '../product/widgets/widgets.dart';
import 'widgets/widgets.dart'; // Import the new file

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DashboardPage _selectedPage = DashboardPage.home;

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.blueGrey[900],
            child: Column(
              children: [
                const Gap(50),
                Text(
                  context.l10n.brand_name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(30),
                DashboardMenu(
                  selectedPage: _selectedPage,
                  onPageSelected: (page) {
                    setState(() {
                      _selectedPage = page;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: _buildPageContent(db),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(AppDatabase db) {
    switch (_selectedPage) {
      case DashboardPage.home:
        return DashboardPageContent(db: db); // Use the new widget
      case DashboardPage.products:
        return ProductScreen(db: db);
      case DashboardPage.customers:
        return CustomerScreen(db: db);
      case DashboardPage.invoice:
        return InvoiceScreen(db: db);
      // case DashboardPage.settings:
      //   return const SettingsScreen();
    }
  }
}
