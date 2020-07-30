import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shree_ram/models/Category.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shree_ram/models/Product.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String product_table = 'product_table';
  String colId = 'id';
  String colName = 'name';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';
  String colBuyprice = 'buyprice';
  String colShellprice = 'shellprice';
  String colCategory = 'category';

  String categorytable = 'categorytable';
  String colCategoryName = 'categoryname';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'product.db';

    // await ((await openDatabase(path)).close());
    // await deleteDatabase(path);

    // Open/create the database at a given path

    var productDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return productDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $product_table($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, '
        '$colDescription TEXT, $colPriority INTEGER,$colDate TEXT,$colCategory TEXT, $colBuyprice TEXT, $colShellprice TEXT)');
    await db.execute(
        'CREATE TABLE $categorytable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colCategoryName TEXT )');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getProductMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(product_table, orderBy: '$colPriority ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getProductbycat(String cat) async {
    Database db = await this.database;
    var result = await db.query(product_table,
        orderBy: '$colPriority ASC',
        where: "$colCategory LIKE ?",
        whereArgs: ['%$cat']);

    return result;
  }

// get all categoryname object from category table
  Future<List<Map<String, dynamic>>> getCategoryMaplist() async {
    Database db = await this.database;
    var result = await db.query(categorytable);
    return result;
  }

  Future<List<Map<String, dynamic>>> categoryonly() async {
    Database db = await this.database;
    var result =
        await db.rawQuery('SELECT $colCategoryName FROM $categorytable');

    return result;
  }

// insert columnname into column table
  Future<int> insertCategory(Category category) async {
    Database db = await this.database;
    var result = await db.insert(categorytable, category.toMap());
    return result;
  }

// update column name into column table
  Future<int> updateCategory(Category category) async {
    Database db = await this.database;
    var result = await db.update(categorytable, category.toMap(),
        where: '$colId = ?', whereArgs: [category.id]);
    return result;
  }

// Delete category from category table
  Future deletecategory(int id, String catname) async {
    var db = await this.database;

    await db.delete(product_table,
        where: "$colCategory LIKE ?", whereArgs: ['%$catname']);
    await db.rawDelete('DELETE FROM $categorytable WHERE $colId = $id');
  }

// count no of category object in category table
  Future<int> getcategoryCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $categorytable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Category>> getCategorytList() async {
    var categoryMapList =
        await getCategoryMaplist(); // Get 'Map List' from database
    int count =
        categoryMapList.length; // Count the number of map entries in db table

    List<Category> categoryList = List<Category>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      categoryList.add(Category.fromMapObject(categoryMapList[i]));
    }

    return categoryList;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertProduct(Product product) async {
    Database db = await this.database;
    var result = await db.insert(product_table, product.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateProduct(Product product) async {
    var db = await this.database;
    var result = await db.update(product_table, product.toMap(),
        where: '$colId = ?', whereArgs: [product.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteProduct(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $product_table WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future getCount() async {
    List a = [];
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $product_table');
    List<Map<String, dynamic>> y = await db
        .rawQuery('SELECT COUNT (*) from $product_table where $colPriority=2');
    List<Map<String, dynamic>> z = await db
        .rawQuery('SELECT COUNT (*) from $product_table where $colPriority=1');
    List<Map<String, dynamic>> s =
        await db.rawQuery('SELECT COUNT (*) from $categorytable');
    String total = Sqflite.firstIntValue(x).toString();
    String high = Sqflite.firstIntValue(y).toString();
    String low = Sqflite.firstIntValue(z).toString();
    String cat = Sqflite.firstIntValue(s).toString();
    a.add([total, high, low, cat]);
    return a;
  }

  Future<List<Product>> getProductList() async {
    var productMapList =
        await getProductMapList(); // Get 'Map List' from database
    int count =
        productMapList.length; // Count the number of map entries in db table

    List<Product> productList = List<Product>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      productList.add(Product.fromMapObject(productMapList[i]));
    }

    return productList;
  }
}
