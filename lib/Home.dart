import 'dart:convert';
import 'dart:ffi';

import 'package:calculadora_de_pan/Recipee.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String title;

  Home({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  List data;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

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
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    left: 100,
                    right: 100,
                    top: 50
                  ),
                  child: Container(
                    width: 30.0,
                    height: 130.0,
                    decoration: new BoxDecoration(
                      image: DecorationImage(
                        image: new AssetImage('assets/appLogo.png'),
                        fit: BoxFit.fitHeight,
                      ),
                      //shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                      future: DefaultAssetBundle.of(context)
                          .loadString('assets/recipees.json'),
                      builder: (context, snapshot) {
                        List<Recipee> recipees =
                            parseJson(snapshot.data.toString());
                        return recipees.isNotEmpty
                            ? new RecipeeList(recipees: recipees)
                            : new Center(
                                child: new CircularProgressIndicator());
                      } // This trailing comma makes auto-formatting nicer for build methods.
                      ),
                ),
              ],
            )));
  }

  List<Recipee> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final decoded = json.decode(response);
    return decoded.map<Recipee>((json) => Recipee.fromJson(json)).toList();
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
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  spreadRadius: 3,
                  offset: Offset(3, 3)

                )],
                color: Colors.white.withAlpha(215)
              ),
              child: new ListTile(
                  title: Text(
                    recipees[index].name,
                    style: TextStyle(
                      fontSize: 25
                    ),),
                  //trailing: new Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipeeWidget(
                                  name: recipees[index].name,
                                  ingredients: recipees[index].ingredients,
                                )));
                  }),
            ),
          );
        });
  }
}
