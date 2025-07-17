import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pos_offline_desktop/core/database/app_database.dart';
import 'package:pos_offline_desktop/l10n/l10n.dart';

import '../../widgets/widgets.dart';
import 'widgets.dart';

class ProductContainer extends StatefulWidget {
  final AppDatabase db;

  const ProductContainer({super.key, required this.db});

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  // Load products when the page loads
  @override
  void initState() {
    super.initState();
    widget.db.productDao.watchAllProducts().listen((event) {
      if (mounted) {
        setState(() {
          products = event;
          filteredProducts = event; // Initially, show all products
        });
      }
    });
  }

  void _showDeleteConfirmation(Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmationDialog(
          name: product.name,
          onConfirm: () async {
            await widget.db.productDao.deleteProduct(product);
          },
        );
      },
    );
  }

  // Search function to filter the products
  void _searchProducts(String query) {
    final filtered = products
        .where(
          (product) => product.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    if (mounted) {
      setState(() {
        filteredProducts = filtered;
      });
    }
  }

  void _editProduct(Product product) async {
    final updatedProductData = await showDialog<ProductsCompanion>(
      context: context,
      builder: (context) => EditProductDialog(product: product),
    );

    if (updatedProductData != null) {
      await widget.db.productDao.updateProduct(updatedProductData);
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed from the tree
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.product_list,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final newProductData =
                          await showDialog<Map<String, dynamic>>(
                            context: context,
                            builder: (context) => const AddProductDialog(),
                          );

                      if (newProductData != null) {
                        final newProduct = ProductsCompanion(
                          name: Value(newProductData['name']),
                          quantity: Value(newProductData['quantity']),
                          price: Value(newProductData['price']),
                        );

                        await widget.db.productDao.insertProduct(newProduct);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: Text(
                      context.l10n.add_product,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Gap(12),
                  ElevatedButton.icon(
                    onPressed: () => exportProductsToExcel(widget.db, context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 73, 8, 85),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(
                      Icons.table_chart,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      context.l10n.export,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap(16),
          SearchWidget(
            controller: _searchController,
            onSearch: _searchProducts,
            hintText: 'Search products',
          ),
          const Gap(20),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: widget.db.productDao.watchAllProducts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final products = filteredProducts;
                if (products.isEmpty) {
                  return const Center(child: Text('No products available.'));
                }

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width - 350,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columnSpacing: 20,
                            headingRowColor: WidgetStateProperty.all(
                              Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.05),
                            ),
                            headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            dataTextStyle: const TextStyle(fontSize: 13),
                            columns: const [
                              DataColumn(label: Text('SL')),
                              DataColumn(label: Text('Product')),
                              DataColumn(label: Text('Quantity')),
                              DataColumn(label: Text('Price')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: List.generate(products.length, (index) {
                              final product = products[index];
                              return DataRow(
                                cells: [
                                  DataCell(Text('${index + 1}')),
                                  DataCell(Text(product.name)),
                                  DataCell(Text('${product.quantity}')),
                                  DataCell(Text('₹ ${product.price}')),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined),
                                          onPressed: () =>
                                              _editProduct(product),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                          ),
                                          onPressed: () =>
                                              _showDeleteConfirmation(product),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
