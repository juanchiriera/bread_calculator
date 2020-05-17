import 'dart:convert';
import 'dart:io';

import 'package:calculadora_de_pan/model/Ingredient.dart';
import 'package:calculadora_de_pan/model/Recipee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final _dbName = "recipees.db";
  static final _dbVersion = 2;

  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    //TODO: Hacer el primer INSERT
    await db.execute('''
      CREATE TABLE recipees (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE ingredients (
        id INTEGER PRIMARY KEY,
        idRecipee INTEGER,
        name TEXT NOT NULL,
        quantity DOUBLE NOT NULL,
        FOREIGN KEY (idRecipee) REFERENCES recipees(id)
      )
    ''');
    //var dir = await rootBundle.loadString('assets/recipees.json');
    //List<Recipee> recipees = parseJson(dir);
    //for (var recipee in recipees) {
    //  insertReceta(recipee);
    //}
  }

  Future<int> updateReceta(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('recipees', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteReceta(int id) async {
    Database db = await instance.database;
    db.delete('ingredients', where: 'idRecipee = ?', whereArgs: [id]);
    return await db.delete('recipees', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertReceta(Recipee recipee) async {
    Map<String, dynamic> recipeeRow = {"name": recipee.name};
    Database db = await instance.database;
    int idRecipee = await db.insert('recipees', recipeeRow);
    for (var ingredient in recipee.ingredients) {
      Map<String, dynamic> ingredientRow = {
        "name": ingredient.name,
        "quantity": ingredient.quantity,
        "idRecipee": idRecipee
      };
      db.insert("ingredients", ingredientRow);
    }

    return idRecipee;
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Recipee>> getAllRecipees() async {
    Database db = await instance.database;
    var list = await db.query('recipees');
    List<Recipee> recipees = new List();
    for (var item in list) {
      List<Ingredient> ingredients = await getIngredientsForRecipee(item['id']);
      recipees.add(new Recipee.fromMap(item, ingredients));
    }
    return recipees;
  }

  List<Recipee> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final decoded = json.decode(response);
    return decoded.map<Recipee>((json) => Recipee.fromJson(json)).toList();
  }

  Future<List<Ingredient>> getIngredientsForRecipee(int recipeeId) async {
    Database db = await instance.database;
    var list = await db
        .query("ingredients", where: "idRecipee = ?", whereArgs: [recipeeId]);
    List<Ingredient> ingredients = new List();
    for (var item in list) {
      ingredients.add(new Ingredient.fromMap(item));
    }
    return ingredients;
  }
}
