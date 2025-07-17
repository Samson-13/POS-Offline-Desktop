import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pos_offline_desktop/l10n/l10n.dart';

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
    return Padding(
      padding: const EdgeInsets.all(60.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildStatBox(
                context.l10n.total_product,
                widget.totalProducts,
                Colors.teal,
              ),
              const Gap(40),
              _buildStatBox(
                context.l10n.total_customer,
                widget.totalCustomers,
                Colors.deepOrange,
              ),
            ],
          ),
          const Gap(120),
          const Center(
            child: Text(
              'pos_offline_desktop INVOICE',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
          ),
          const Gap(20),
          Center(
            child: Text(
              "${context.l10n.version} $_version",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String title, int count, Color color) {
    return Container(
      width: 300,
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const Gap(10),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
