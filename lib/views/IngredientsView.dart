
import 'package:calculadora_de_pan/model/Ingredient.dart';
import 'package:flutter/material.dart';

class IngredientsView extends StatelessWidget {
  final List<Ingredient> ingredients;
  final double quantity;

  IngredientsView({this.ingredients, this.quantity});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: ingredients == null ? 0 : ingredients.length,
        itemBuilder: (BuildContext context, int index) {
          var qty = (ingredients[index].quantity * quantity) / 100;
          return Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Colors.white.withAlpha(215),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                      spreadRadius: 3,
                      offset: Offset(3, 3))
                ],
              ),
              child: new ListTile(
                leading: Text(
                  ingredients[index].quantity.toStringAsFixed(0) + "%",
                  style: TextStyle(
                    fontSize: 22
                  ),
                ),
                title: Text(
                  ingredients[index].name,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                trailing: Text(
                  qty.toDouble().toStringAsFixed(0) + " grs",
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          );
        });
  }
}
