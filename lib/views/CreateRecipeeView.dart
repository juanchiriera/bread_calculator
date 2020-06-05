import 'package:calculadora_de_pan/model/Ingredient.dart';
import 'package:calculadora_de_pan/model/Recipee.dart';
import 'package:calculadora_de_pan/utils/DbHelper.dart';
import 'package:flutter/material.dart';

class CreateRecetaView extends StatefulWidget {
  final Recipee receta;

  const CreateRecetaView({Key key, this.receta}) : super(key: key);

  @override
  _CreateRecetaViewState createState() => _CreateRecetaViewState();
}

class _CreateRecetaViewState extends State<CreateRecetaView> {
  final _formKey = GlobalKey<FormState>();
  var ingredientsListView = <Widget>[];
  String nombreReceta = "";
  TextEditingController nameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var ingredient in widget.receta.ingredients) {
      ingredientsListView.add(
          ingredientEditBox(widget.receta.ingredients.indexOf(ingredient)));
    }
  }

  @override
  Widget build(BuildContext context) {
    nameController = new TextEditingController(text: widget.receta.name);
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget actionButtons(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Container(
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
                          widget.receta.name = value;
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
        actionButtons()
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
        var ingredients = widget.receta.ingredients;
        ingredients.add(new Ingredient(
            idRecipee: widget.receta.id, name: "", quantity: 0.0));
        widget.receta.ingredients = ingredients;
        ingredientsListView.add(ingredientEditBox(index));
      });
    });
  }

  Padding ingredientEditBox(int index) {
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
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 25, right: 25),
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
                        text: widget.receta.ingredients[index].name),
                    onChanged: (value) {
                      widget.receta.ingredients[index].name = value;
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Proporción',
                        suffix: Text("%"),
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.deepOrange),
                        hintText: "proporción"),
                    controller: doubleNumberController(widget.receta.ingredients[index].quantity),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      widget.receta.ingredients[index].quantity =
                          double.parse(value);
                    },
                  ),
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
                                title: Text("Eliminar Ingrediente"),
                                content: Text(
                                    "Está seguro que desea eliminar el ingrediente?"),
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
                                      //DbHelper.instance.deleteIngrediente(
                                      //    widget.receta.ingredients[index].id);
                                      setState(() {
                                        List ingredients =
                                            widget.receta.ingredients;
                                        ingredientsListView.remove(
                                            ingredientsListView
                                                .elementAt(index));
                                        ingredients.remove(ingredients[index]);
                                        widget.receta.ingredients = ingredients;
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }))
              ],
            ),
          )),
    );
  }

  saveRecipee() async {
    //Recipee recipee = new Recipee(name: nombreReceta, ingredients: ingredientsList);
    DbHelper.instance.insertOrUpdateReceta(widget.receta);
  }

  TextEditingController doubleNumberController(double value) {
    var text = "";
    if (value != 0)
      text = value.toStringAsFixed(0);
     return new TextEditingController(
                        text: text);
  }
}
