import 'package:calculadora_de_pan/Ingredient.dart';
import 'package:calculadora_de_pan/utils/DecimalTextInputFormatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class RecipeeWidget extends StatefulWidget {
  final String name;
  final List<Ingredient> ingredients;

  const RecipeeWidget({Key key, this.ingredients, this.name}) : super(key: key);

  @override
  _RecipeeWidgetState createState() => _RecipeeWidgetState();
}

class _RecipeeWidgetState extends State<RecipeeWidget> {
  double _quantity = 1.0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextEditingController quantityController =
        new TextEditingController(text: "$_quantity");
    return Scaffold(
        appBar: null,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("background.jpg"), fit: BoxFit.cover),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                    bottom: 30.0,
                  ),
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      inherit: true,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 15),
                          child: Text("Cantidad: ",
                          style: TextStyle(fontSize: 32.0),),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right:10),
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  suffix: Text("Kg"),
                                  labelStyle: TextStyle(color: Colors.black)),
                              style: TextStyle(fontSize: 32.0),
                              inputFormatters: [
                                DecimalTextInputFormatter(decimalRange: 2)
                              ],
                              controller: quantityController,
                              onSubmitted: (String value) {
                                setState(() {
                                  _quantity = double.parse(value);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(builder: (context, snapshot) {
                  return new IngredientsList(
                      ingredients: widget.ingredients, quantity: _quantity);
                }),
              ),
            ],
          ),
          /*child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    /*children: <Widget>[
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
                                    ],*/
                                  ),
                                ),*/
        ));
  }
}

class IngredientsList extends StatelessWidget {
  final List<Ingredient> ingredients;
  final double quantity;

  IngredientsList({this.ingredients, this.quantity});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: ingredients == null ? 0 : ingredients.length,
        itemBuilder: (BuildContext context, int index) {
          var qty = ingredients[index].quantity * quantity;
//          if(_editing)
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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
//          else
//            return new IngrefientsBuilder();
        });
  }
}
