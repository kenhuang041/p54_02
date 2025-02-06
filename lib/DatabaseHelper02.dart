import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper02 {
  static final DatabaseHelper02 _instance = DatabaseHelper02._internal();
  factory DatabaseHelper02() => _instance;
  static Database? _db;

  DatabaseHelper02._internal();

  Future<Database> get database async {
    if(_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(),'my_db02.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: createDatabase,
    );
  }

  Future<void> createDatabase(Database db,int version) async {
    await db.execute("""
      CREATE TABLE items(
        id INTEGER PRIMARY KEY,
        password TEXT,
        favorite INTEGER
      )
    """);
  }

  Future<void> insertItem(Item item) async {
    Database db = await database;
    await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteItem(int id) async {
    Database db = await database;
    await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateItem(Item item) async {
    Database db = await database;
    await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<List<Item>> getItem(String password) async {
    Database db = await database;
    List<Map<String,dynamic>> lst = await db.query(
        'items',
        where: 'password LIKE ?',
        whereArgs: ["%$password%"],
    );
    return lst.map((mp) => Item.fromMap(mp)).toList();
  }

  Future<List<Item>> getFavoriteItem() async {
    Database db = await database;
    List<Map<String,dynamic>> lst = await db.query(
      'items',
      where: 'favorite = ?',
      whereArgs: [1],
    );
    return lst.map((mp) => Item.fromMap(mp)).toList();
  }

  Future<List<Item>> getAllItem() async {
    Database db = await database;
    List<Map<String,dynamic>> lst = await db.query('items');
    return lst.map((mp) => Item.fromMap(mp)).toList();
  }
}

class Item {
  String password;
  int favorite = 0;
  int? id;

  Item({this.id, required this.password, required this.favorite});

  Map<String,dynamic> toMap() {
    return {
      if(id != null) 'id':id,
      'password':password,
      'favorite':favorite,
    };
  }

  factory Item.fromMap(Map<String,dynamic> mp) {
    return Item(
        id: mp['id'],
        password: mp['password'],
        favorite: mp['favorite'],
    );
  }
}