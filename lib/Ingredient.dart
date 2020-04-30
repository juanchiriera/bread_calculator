import 'dart:ffi';

class Ingredient {
  final String name;
  final Float quantity;

  Ingredient({this.name, this.quantity});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return new Ingredient(
      name: json['name'] as String,
      quantity: json['qt'] as Float
      );
  }
}
