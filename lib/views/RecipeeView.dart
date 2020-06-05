import 'package:calculadora_de_pan/model/Ingredient.dart';
import 'package:calculadora_de_pan/model/Recipee.dart';
import 'package:calculadora_de_pan/utils/DbHelper.dart';
import 'package:calculadora_de_pan/utils/DecimalTextInputFormatter.dart';
import 'package:calculadora_de_pan/views/IngredientsView.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

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
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  share(context, widget.name, widget.ingredients, _quantity);
                },
                child: Icon(
                  Icons.share,
                ),
              ),
            )
          ],
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
                            "Peso Masa: ",
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
                                  border: InputBorder.none,
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: FutureBuilder(builder: (context, snapshot) {
                    return new IngredientsView(
                        ingredients: widget.ingredients,
                        quantity: _quantity,
                        callback: callback);
                  }),
                ),
              ),
            ],
          ),
        ));
  }

  share(BuildContext context, String name, List<Ingredient> ingredients,
      double quantity) {
    var text = "$name\n\n";

    var totalSum = 0;
    for (var ingredient in ingredients) {
      totalSum += ingredient.quantity.toInt();
    }
    for (var ingredient in ingredients) {
      var amount = (ingredient.quantity * quantity) / totalSum;
      text = text + "${ingredient.name}\t\t${amount.toStringAsFixed(0)} grs\n";
    }
    Share.share(text, subject: name);
  }
}

class RecipeeList extends StatefulWidget {
  final List<Recipee> recipees;

  RecipeeList({Key key, this.recipees}) : super(key: key);

  @override
  _RecipeeListState createState() => _RecipeeListState();
}

class _RecipeeListState extends State<RecipeeList> {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: widget.recipees == null ? 0 : widget.recipees.length,
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
                          widget.recipees[index].name,
                          style: TextStyle(fontSize: 25),
                        ),
                        //trailing: new Icon(Icons.edit),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecipeeView(
                                        name: widget.recipees[index].name,
                                        ingredients:
                                            widget.recipees[index].ingredients,
                                      )));
                        }),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: _navigateToEditPage(
                            context, widget.recipees[index])),
                  ),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Eliminar Receta"),
                                  content: Text(
                                      "Está seguro que desea eliminar la receta?"),
                                  actions: [
                                    FlatButton(
                                      child: Text("Cancelar"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Borrar"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        DbHelper.instance.deleteReceta(
                                            widget.recipees[index].id);
                                        widget.recipees
                                            .remove(widget.recipees[index]);
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          })
                      //_openDeletePrompt(context, recipees[index].id)),
                      )
                ],
              ),
            ),
          );
        });
  }

  Function _navigateToEditPage(BuildContext context, Recipee recipee) {
    return () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateRecetaView(receta: recipee)));
    };
  }
}
