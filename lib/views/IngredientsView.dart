import 'package:calculadora_de_pan/model/Ingredient.dart';
import 'package:flutter/material.dart';

class IngredientsView extends StatefulWidget {
  final List<Ingredient> ingredients;
  final double quantity;
  final Function(double) callback;

  IngredientsView({this.ingredients, this.quantity, this.callback});

  @override
  _IngredientsViewState createState() => _IngredientsViewState();
}

class _IngredientsViewState extends State<IngredientsView> {
  double totalSum;

  var _qtyController;

  double qty;

  @override
  void initState() {
    this.qty = 0;
    _qtyController = new TextEditingController(text: qty.toStringAsFixed(0));
    this.totalSum = 0;
    for (var ingredient in widget.ingredients) {
      this.totalSum += ingredient.quantity;
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: widget.ingredients == null ? 0 : widget.ingredients.length,
        itemBuilder: (BuildContext context, int index) {
          var qty =(widget.ingredients[index].quantity * widget.quantity) / totalSum;
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
                title: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.ingredients[index].quantity.toStringAsFixed(0) +
                              "%",
                          style: TextStyle(fontSize: 22),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Text(
                          widget.ingredients[index].name,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: TextField(
                          onSubmitted: (String value) {
                            double val = double.parse(value);
                            double newQuantity = (val * totalSum) /
                                widget.ingredients[index].quantity;
                            widget.callback(newQuantity);
                          },
                          controller: new TextEditingController(text: qty.toStringAsFixed(0)),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              suffix: Text("grs"),
                              labelStyle: TextStyle(color: Colors.black)),
                          //qty.toDouble().toStringAsFixed(0) + " grs",
                          style: TextStyle(fontSize: 22),
                          enabled: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
