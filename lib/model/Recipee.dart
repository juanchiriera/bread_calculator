

import 'Ingredient.dart';

class Recipee {
  int id;
  String name;
  List<Ingredient> ingredients;

  Recipee({this.id, this.name, this.ingredients});

  factory Recipee.fromMap(Map<String, dynamic> recipeeMap, List<Ingredient> ingredients) {
    /*if (recipeeMap['ingredients']) {
      var ingList = recipeeMap['ingredients'] as List;
      ingredients = ingList.map((i) => Ingredient.fromMap(i)).toList();
    }*/
    return new Recipee(name: recipeeMap['name'] as String, ingredients: ingredients, id: recipeeMap['id']);
  }

  void addIngredient () => ingredients.add(new Ingredient());

  Map<String, dynamic> toMap() {
    List<Map> ingredients = this.ingredients.map((i) => i.toMap()).toList();
    return {"name": name, "ingredients": ingredients};
  }

  static fromJson(recipeeMap) {
    List<Ingredient> ingredients = new List();
     if (recipeeMap['ingredients']) {
      var ingList = recipeeMap['ingredients'] as List;
      ingredients = ingList.map((i) => Ingredient.fromMap(i)).toList();
    }
    return new Recipee(name: recipeeMap['name'] as String, ingredients: ingredients);
  }
}
