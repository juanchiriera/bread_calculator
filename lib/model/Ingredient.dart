import 'dart:ffi';

class Ingredient {
  final String name;
  final double quantity;

  Ingredient({this.name, this.quantity});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return new Ingredient(
      name: json['name'] as String,
      quantity: json['qty'] as double
      );
  }
}
