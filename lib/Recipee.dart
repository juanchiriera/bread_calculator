import 'package:calculadora_de_pan/Ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Recipee {
  final String name;
  final List<Ingredient> ingredients;

  Recipee({this.name, this.ingredients});


  factory Recipee.fromJson(Map<String, dynamic> json) {
    var ingList = json['ingredients'] as List;
    List<Ingredient> ingredients = ingList.map((i) => Ingredient.fromJson(i)).toList();
    return new Recipee(
        name: json['name'] as String,
        ingredients: ingredients
      );
  }
}

class RecipeeWidget extends StatelessWidget {
  final String name;
  final List<Ingredient> ingredients;

  const RecipeeWidget({Key key, this.ingredients, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: null,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("background.jpg"), fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Cantidad (grs)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Cantidad (grs)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
