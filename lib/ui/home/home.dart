import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos_offline_desktop/core/database/app_database.dart';
import 'package:pos_offline_desktop/core/provider/app_database_provider.dart';
import 'package:pos_offline_desktop/l10n/l10n.dart';
import 'package:pos_offline_desktop/ui/customer/customer.dart';
import 'package:pos_offline_desktop/ui/invoice/invoice.dart';
import 'package:pos_offline_desktop/ui/pages/sidebar_page.dart';
import 'package:pos_offline_desktop/ui/product/product.dart';
import 'package:pos_offline_desktop/ui/widgets/side_bar.dart';

import '../product/widgets/widgets.dart';
import 'widgets/widgets.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  SideBarPage _selectedPage = SideBarPage.home;

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.blueGrey[900],
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    context.l10n.brand_name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const Gap(30),
                Expanded(
                  child: SideBarMenu(
                    selectedPage: _selectedPage,
                    onPageSelected: (page) {
                      setState(() {
                        _selectedPage = page;
                      });
                    },
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'v1.0.0',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
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
      case SideBarPage.home:
        return SideBarPageContent(db: db);
      case SideBarPage.products:
        return ProductScreen(db: db);
      case SideBarPage.customers:
        return CustomerScreen(db: db);
      case SideBarPage.invoice:
        return InvoiceScreen(db: db);
    }
  }
}
