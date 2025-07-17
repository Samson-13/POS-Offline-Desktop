import 'package:flutter/material.dart';
import 'package:pos_offline_desktop/core/database/app_database.dart';
import 'package:pos_offline_desktop/ui/widgets/search_widget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> products = []; // Assuming Product is your product model

  // Your search function that filters the products
  void _searchProducts(String query) {
    final filteredProducts = products
        .where(
          (product) => product.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    setState(() {
      products = filteredProducts;
    });
  }

  @override
  void initState() {
    super.initState();
    // Load your initial list of products
    // products = await db.productDao.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Column(
        children: [
          // Use the SearchWidget
          SearchWidget(
            controller: _searchController,
            onSearch: _searchProducts,
            hintText: 'Search Products',
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('₹ ${product.price.toString()}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
