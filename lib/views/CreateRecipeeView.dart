import 'package:calculadora_de_pan/model/Ingredient.dart';
import 'package:calculadora_de_pan/model/Recipee.dart';
import 'package:calculadora_de_pan/utils/DbHelper.dart';
import 'package:flutter/material.dart';

class CreateRecetaView extends StatefulWidget {
  @override
  _CreateRecetaViewState createState() => _CreateRecetaViewState();
}

class _CreateRecetaViewState extends State<CreateRecetaView> {
  final _formKey = GlobalKey<FormState>();
  var ingredientsListView = <Widget>[];
  String nombreReceta = "";
  TextEditingController nameController;
  List<Ingredient> ingredientsList = new List();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    nameController = 
      new TextEditingController(text: nombreReceta);
    return Scaffold(
      appBar: AppBar(
        title: Text("Nueva Receta"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("background.jpg"), fit: BoxFit.fitWidth),
        ),
        child: buildNombreRecetaBox(),
      ),
      floatingActionButton: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'ADD_INGREDIENT',
              onPressed: addNewIngredient(ingredientsListView.length),
              backgroundColor: Colors.white,
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                saveRecipee();
                Navigator.pop(context);
              },
              heroTag: 'SAVE',
              backgroundColor: Colors.white,
              isExtended: true,
              tooltip: 'Increment',
              child: Icon(
                Icons.save,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildNombreRecetaBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
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
                      padding: const EdgeInsets.only(left: 15, right: 10),
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: "Nombre de tu receta",
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.black)),
                        style: TextStyle(fontSize: 32.0),
                        controller: nameController,
                        onChanged: (String value) {
                          nombreReceta = value;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildAddIngredient(),
      ],
    );
  }

  Widget _buildAddIngredient() {
    return Flexible(
      fit: FlexFit.tight,
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: ListView.builder(
                itemCount: ingredientsListView.length,
                itemBuilder: (context, index) {
                  return ingredientsListView[index];
                }),
          ),
        ),
      ),
    );
  }

  Function addNewIngredient(int index) {
    return (() {
      setState(() {
        ingredientsList.add(new Ingredient());
        ingredientsListView.add(Padding(
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
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 25, right: 25),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            labelText: 'Ingrediente',
                            labelStyle: TextStyle(color: Colors.deepOrange),
                            border: InputBorder.none,
                            hintText: "Ingrediente"),
                        controller: new TextEditingController(
                            text: ingredientsList.last.name),
                        onChanged: (value) {
                          ingredientsList[index].name = value;
                        },
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            labelText: 'Proporcion',
                            suffix: Text("%"),
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.deepOrange),
                            hintText: "proporcion"),
                        controller: new TextEditingController(
                            text: ingredientsList.last.quantity as String),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          ingredientsList[index].quantity = double.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
              )),
        ));
      });
    });
  }

  saveRecipee() async {
    Recipee recipee =
        new Recipee(name: nombreReceta, ingredients: ingredientsList);
    DbHelper.instance.insertReceta(recipee);
  }
}
