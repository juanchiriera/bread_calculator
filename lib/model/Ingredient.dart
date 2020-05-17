
class Ingredient {
  int idRecipee;
  String name;
  double quantity;
  int id;
  Ingredient({this.name, this.quantity, this.id, this.idRecipee});

  factory Ingredient.fromMap(Map<String, dynamic> json) {
    return new Ingredient(
        name: json['name'] as String,
        id: json['id'] as int,
        idRecipee: json['idRecipee'] as int, 
        quantity: json['quantity'] as double);
  }

  Map<String, dynamic> toMap() => {"name": name, "quantity": quantity};
}
