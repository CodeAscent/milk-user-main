import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:water/model/product/product_item.dart';

import 'app_state.dart';

class LocalDataStorage {
  String dataBaseName = "dome.db";

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, dataBaseName),
      onCreate: (database, version) async {
        await database.execute(
          """CREATE TABLE cart(id INTEGER PRIMARY KEY,name TEXT,image TEXT, price INTEGER, discount_price INTEGER, stock INTEGER, description TEXT, status INTEGER, created_at TEXT,updated_at TEXT, cart_info TEXT, 
          quantity INTEGER, orderFrequency TEXT, days TEXT, selectedDates TEXT, start_date TEXT, end_date TEXT)""",
        );
      },
      version: 1,
    );
  }
  /*
         """CREATE TABLE cart(id INTEGER PRIMARY KEY,name TEXT,image TEXT, price TEXT, discount_price TEXT, stock INTEGER, description TEXT,
          capacity TEXT, package_items_count INTEGER, unit TEXT, featured INTEGER, top_deal INTEGER, most_popular INTEGER,deliverable INTEGER,
          market_id INTEGER, category TEXT, created_at TEXT,updated_at TEXT,cart_info TEXT,is_favourite INTEGER,
          has_media INTEGER, market TEXT,media TEXT)""",
  */

  Future<int> deleteDataBase() async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.delete("cart");
    return result;
  }

  Future<int> insertProduct(Product products) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('cart', products.toJson());
    return result;
  }

  Future<List<Product>> retrieveProduct() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('cart');
    appState.carts.value = queryResult.map((e) => Product.fromLocalJson(e)).toList();
    print("retrieveProduct cards $queryResult}");
    return appState.carts.value;
  }

  Future<void> deleteProduct(int id) async {
    final db = await initializeDB();
    await db.delete(
      'cart',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateProduct(Product products, int id) async {
    final db = await initializeDB();
    await db.update(
      'cart',
      products.toJson(),
      where: "id = ?",
      whereArgs: [id],
    );
  }
}