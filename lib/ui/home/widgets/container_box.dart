import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pos_offline_desktop/l10n/l10n.dart';

import 'custom_card.dart';

class ContainerBoxWidget extends StatefulWidget {
  final int totalProducts;
  final int totalCustomers;

  const ContainerBoxWidget({
    super.key,
    required this.totalProducts,
    required this.totalCustomers,
  });

  @override
  State<ContainerBoxWidget> createState() => _ContainerBoxWidgetState();
}

class _ContainerBoxWidgetState extends State<ContainerBoxWidget> {
  String _version = "";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.dashboard,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const Gap(30),
          Row(
            children: [
              buildStatCard(
                svgAssetPath: "assets/svg/product.svg",
                title: context.l10n.total_product,
                count: widget.totalProducts,
                color: Colors.teal,
                context: context,
              ),
              const Gap(40),
              buildStatCard(
                svgAssetPath: "assets/svg/customer.svg",
                title: context.l10n.total_customer,
                count: widget.totalCustomers,
                color: Colors.deepOrange,
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
