// database/dao/product_dao.dart
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [Products])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(super.db);

  Future<List<Product>> getAllProducts() => select(products).get();
  Stream<List<Product>> watchAllProducts() => select(products).watch();
  Future insertProduct(Insertable<Product> product) =>
      into(products).insert(product);
  Future updateProduct(Insertable<Product> product) =>
      update(products).replace(product);
  // Total products count
  Future<int> getTotalProductCount() async {
    final countExp = products.id.count(); // or any column
    final query = selectOnly(products)..addColumns([countExp]);

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future deleteProduct(Insertable<Product> product) =>
      delete(products).delete(product);
}
