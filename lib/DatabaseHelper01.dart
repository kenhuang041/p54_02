import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if(_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(),'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _create,
    );
  }

  Future<void> _create(Database db,int version) async {
    await db.execute("""
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        birthday TEXT,
        password TEXT
      )
    """);
  }

  Future<void> insertUser(User user) async {
    Database db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteUser(int id) async {
    Database db = await database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateUser(User user) async {
    Database db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<List<User>> getAllUser() async {
    Database db = await database;
    List<Map<String,dynamic>> lst = await db.query('users');

    return lst.map((mp) => User.fromMap(mp)).toList();
  }

  Future<User> getUser(User user) async {
    Database db = await database;
    User nofound = User(name: 'noFoundUser', email: 'noFoundUser', birthday: 'noFoundUser', password: 'noFoundUser');
    List<Map<String,dynamic>> lst = await db.query(
      'users',
      where: 'name = ? AND email = ? AND birthday = ? AND password = ?',
      whereArgs: [user.name,user.email,user.birthday,user.password],
    );

    return lst.isEmpty ? nofound : lst.map((mp) => User.fromMap(mp)).toList().first;
  }
}

class User {
  int? id;
  String name,email,birthday,password;
  User({this.id,required this.name, required this.email, required this.birthday, required this.password});

  Map<String,dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'birthday': birthday,
      'password': password,
    };
  }

  factory User.fromMap(Map<String,dynamic> mp) {
    return User(
      id: mp['id'],
      name: mp['name'],
      email: mp['email'],
      birthday: mp['birthday'],
      password: mp['password'],
    );
  }
}