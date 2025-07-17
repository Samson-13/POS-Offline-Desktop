import 'package:flutter/material.dart';

class DashboardMenu extends StatelessWidget {
  final DashboardPage selectedPage;
  final ValueChanged<DashboardPage> onPageSelected;

  const DashboardMenu({
    super.key,
    required this.selectedPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          icon: Icons.home_outlined,
          title: context.l10n.home,
          page: DashboardPage.home,
        ),
        _buildMenuItem(
          context,
          icon: Icons.shopping_cart_outlined,
          title: context.l10n.products,
          page: DashboardPage.products,
        ),
        _buildMenuItem(
          context,
          icon: Icons.person_outline,
          title: context.l10n.customer,
          page: DashboardPage.customers,
        ),
        _buildMenuItem(
          context,
          icon: Icons.receipt_outlined,
          title: context.l10n.invoice,
          page: DashboardPage.invoice,
        ),
        // _buildMenuItem(
        //   context,
        //   icon: Icons.settings,
        //   title: context.l10n.settings,
        //   page: DashboardPage.settings,
        // ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required DashboardPage page,
  }) {
    final isSelected = selectedPage == page;
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      selected: isSelected,
      selectedTileColor: Colors.blueGrey[800],
      onTap: () => onPageSelected(page),
    );
  }
}
