import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Criar a tabela 'users'
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL,
        imagemPerfil TEXT,
        role TEXT NOT NULL DEFAULT 'buyer'
      )
    ''');

    // Criar a tabela 'products'
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        nome TEXT NOT NULL,
        preco REAL NOT NULL,
        descricao TEXT,
        imageUrl TEXT,
        categoria TEXT DEFAULT 'Outros',
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Criar a tabela 'cart_items'
    await db.execute('''
      CREATE TABLE cart_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        productId INTEGER NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE,
        UNIQUE(userId, productId)
      )
    ''');

    // Criar a tabela 'todos'
    await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY,
        userId INTEGER,
        title TEXT,
        completed INTEGER
      )
    ''');
  }

  Future<bool> _columnExists(Database db, String table, String column) async {
    final result = await db.rawQuery("PRAGMA table_info($table)");
    return result.any((row) => row['name'] == column);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Criar as novas tabelas na atualização
      await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          senha TEXT NOT NULL,
          imagemPerfil TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE products(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER NOT NULL,
          nome TEXT NOT NULL,
          preco REAL NOT NULL,
          descricao TEXT,
          imageUrl TEXT,
          FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');
    }

    if (oldVersion < 3) {
      // Criar a tabela cart_items na atualização para versão 3
      await db.execute('''
        CREATE TABLE cart_items(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER NOT NULL,
          productId INTEGER NOT NULL,
          quantity INTEGER NOT NULL DEFAULT 1,
          createdAt TEXT NOT NULL,
          FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
          FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE,
          UNIQUE(userId, productId)
        )
      ''');
    }

    if (oldVersion < 4) {
      // Adicionar coluna categoria na tabela products na atualização para versão 4
      if (!await _columnExists(db, 'products', 'categoria')) {
        await db.execute('''
          ALTER TABLE products ADD COLUMN categoria TEXT DEFAULT 'Outros'
        ''');
      }
    }

    if (oldVersion < 5) {
      // Adicionar coluna role na tabela users na atualização para versão 5
      if (!await _columnExists(db, 'users', 'role')) {
        await db.execute('''
          ALTER TABLE users ADD COLUMN role TEXT NOT NULL DEFAULT 'buyer'
        ''');
      }
    }
  }

  // CRUD para usuários
  Future<int> insertUser(Map<String, dynamic> user) async {
    return await _database!
        .insert('users', user, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null; // Retorne null se não encontrar
    }
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    return await _database!.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  Future<int> deleteUser(int id) async {
    return await _database!.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD para produtos
  Future<int> insertProduct(Map<String, dynamic> product) async {
    return await _database!.insert('products', product,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getProductsByUser(int userId) async {
    return await _database!
        .query('products', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    return await _database!.query('products');
  }

  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    return await _database!.query(
      'products',
      where: 'nome LIKE ?',
      whereArgs: ['%$query%'],
    );
  }

  Future<List<String>> getDistinctCategories() async {
    final db = await database;
    final result = await db
        .rawQuery('SELECT DISTINCT categoria FROM products ORDER BY categoria');
    return result.map((row) => row['categoria'] as String).toList();
  }

  Future<int> updateProduct(Map<String, dynamic> product) async {
    return await _database!.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [product['id']],
    );
  }

  Future<int> deleteProduct(int id) async {
    return await _database!.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD para cart_items
  Future<int> insertCartItem(Map<String, dynamic> cartItem) async {
    return await _database!.insert('cart_items', cartItem,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Map<String, dynamic>>> getCartItemsByUser(int userId) async {
    return await _database!
        .query('cart_items', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<int> updateCartItemQuantity(int id, int quantity) async {
    return await _database!.update(
      'cart_items',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCartItem(int id) async {
    return await _database!.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearUserCart(int userId) async {
    return await _database!.delete(
      'cart_items',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // CRUD para todo
  Future<List<Map<String, dynamic>>> getTodos() async {
    return await _database!.query('todos');
  }

  Future<int> insertTodo(Map<String, dynamic> todo) async {
    return await _database!
        .insert('todos', todo, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
