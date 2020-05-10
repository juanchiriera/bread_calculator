import 'package:calculadora_de_pan/model/Ingredient.dart';
import 'package:calculadora_de_pan/model/Recipee.dart';
import 'package:calculadora_de_pan/utils/DecimalTextInputFormatter.dart';
import 'package:calculadora_de_pan/views/IngredientsView.dart';
import 'package:flutter/material.dart';

class RecipeeView extends StatefulWidget {
  final String name;
  final List<Ingredient> ingredients;

  const RecipeeView({Key key, this.ingredients, this.name}) : super(key: key);

  @override
  _RecipeeViewState createState() => _RecipeeViewState();
}

class _RecipeeViewState extends State<RecipeeView> {
  double _quantity = 1000;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextEditingController quantityController =
        new TextEditingController(text: _quantity.toStringAsFixed(0));
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("background.jpg"), fit: BoxFit.cover),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 30, bottom: 40),
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
                          child: Text(
                            "Cantidad: ",
                            style: TextStyle(fontSize: 32.0),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 10),
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  suffix: Text("grs"),
                                  labelStyle: TextStyle(color: Colors.black)),
                              style: TextStyle(fontSize: 32.0),
                              inputFormatters: [
                                DecimalTextInputFormatter()
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
                  return new IngredientsView(
                      ingredients: widget.ingredients, quantity: _quantity);
                }),
              ),
            ],
          ),
        ));
  }
}

class RecipeeList extends StatelessWidget {
  final List<Recipee> recipees;

  const RecipeeList({Key key, this.recipees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: recipees == null ? 0 : recipees.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3,
                        spreadRadius: 3,
                        offset: Offset(3, 3))
                  ],
                  color: Colors.white.withAlpha(215)),
              child: new ListTile(
                  title: Text(
                    recipees[index].name,
                    style: TextStyle(fontSize: 25),
                  ),
                  //trailing: new Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipeeView(
                                  name: recipees[index].name,
                                  ingredients: recipees[index].ingredients,
                                )));
                  }),
            ),
          );
        });
  }
}
