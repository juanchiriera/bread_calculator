import 'Ingredient.dart';

class Recipee {
  final String name;
  final List<Ingredient> ingredients;

  Recipee({this.name, this.ingredients});

  factory Recipee.fromJson(Map<String, dynamic> json) {
    var ingList = json['ingredients'] as List;
    List<Ingredient> ingredients =
        ingList.map((i) => Ingredient.fromJson(i)).toList();
    return new Recipee(name: json['name'] as String, ingredients: ingredients);
  }
}


