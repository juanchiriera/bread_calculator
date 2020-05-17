import 'dart:js';

import 'package:calculadora_de_pan/model/Ingredient.dart';
import 'package:calculadora_de_pan/model/Recipee.dart';
import 'package:calculadora_de_pan/utils/DbHelper.dart';
import 'package:calculadora_de_pan/utils/DecimalTextInputFormatter.dart';
import 'package:calculadora_de_pan/views/IngredientsView.dart';
import 'package:flutter/material.dart';

import 'CreateRecipeeView.dart';

class RecipeeView extends StatefulWidget {
  final String name;
  final List<Ingredient> ingredients;

  const RecipeeView({Key key, this.ingredients, this.name}) : super(key: key);

  @override
  _RecipeeViewState createState() => _RecipeeViewState();
}

class _RecipeeViewState extends State<RecipeeView> {
  double _quantity = 1000;

  callback(newQuantity) {
    setState(() {
      _quantity = newQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                              inputFormatters: [DecimalTextInputFormatter()],
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
                      ingredients: widget.ingredients,
                      quantity: _quantity,
                      callback: callback);
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
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 14,
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
                                        ingredients:
                                            recipees[index].ingredients,
                                      )));
                        }),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                        icon: Icon(Icons.edit), onPressed: _navigateToEditPage),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                        icon: Icon(Icons.delete), onPressed: _openDeletePrompt(context, recipees[index].id)),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _navigateToEditPage() {}

  _openDeletePrompt(BuildContext context, int idRecipee) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Borrar"),
      onPressed: () {
        Navigator.of(context).pop();
        DbHelper.instance.deleteReceta(idRecipee);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar Receta"),
      content: Text("Está seguro que desea eliminar la receta?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
