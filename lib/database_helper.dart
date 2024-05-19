import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/filme.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'filmes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE filmes(id INTEGER PRIMARY KEY, urlImagem TEXT, titulo TEXT, genero TEXT, faixaEtaria TEXT, duracao INTEGER, pontuacao REAL, descricao TEXT, ano INTEGER)',
        );
      },
    );
  }

  // Métodos CRUD
  Future<int> insertFilme(Filme filme) async {
    var dbClient = await db;
    return await dbClient.insert('filmes', filme.toMap());
  }

  Future<List<Filme>> getFilmes() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('filmes');

    return List.generate(maps.length, (i) {
      return Filme.fromMap(maps[i]);
    });
  }

  Future<int> updateFilme(Filme filme) async {
    var dbClient = await db;
    return await dbClient.update('filmes', filme.toMap(), where: 'id = ?', whereArgs: [filme.id]);
  }

  Future<int> deleteFilme(int id) async {
    var dbClient = await db;
    return await dbClient.delete('filmes', where: 'id = ?', whereArgs: [id]);
  }
}
