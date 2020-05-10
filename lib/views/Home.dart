import 'dart:convert';
import 'dart:ffi';

import 'package:calculadora_de_pan/animations/HomeEnterAnimation.dart';
import 'package:calculadora_de_pan/model/Recipee.dart';
import 'package:flutter/material.dart';

import 'RecipeeView.dart';

class Home extends StatefulWidget {
  final String title;

  Home({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> with SingleTickerProviderStateMixin {
  List data;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MainMenuView(controller: _controller);
  }
}

class MainMenuView extends StatelessWidget {
  final HomeEnterAnimation animation;

  MainMenuView({@required AnimationController controller})
      : animation = new HomeEnterAnimation(controller);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Recetas"),
      ),
      body: new AnimatedBuilder(
          animation: animation.controller, builder: _buildMainMenu),
    );
  }

  Widget _buildMainMenu(BuildContext context, Widget child) {
    return new Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("background.jpg"), fit: BoxFit.fitWidth),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 10, left: 100, right: 100, top: 10),
              child: Container(
                width: 130.0,
                height: animation.imageWidth.value,
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
              child: Opacity(
                opacity: animation.listOpacity.value,
                              child: FutureBuilder(
                    future: DefaultAssetBundle.of(context)
                        .loadString('assets/recipees.json'),
                    builder: (context, snapshot) {
                      List<Recipee> recipees =
                          parseJson(snapshot.data.toString());
                      return recipees.isNotEmpty
                          ? new RecipeeList(recipees: recipees)
                          : new Center(child: new CircularProgressIndicator());
                    } // This trailing comma makes auto-formatting nicer for build methods.
                    ),
              ),
            ),
          ],
        ));
  }

  List<Recipee> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final decoded = json.decode(response);
    return decoded.map<Recipee>((json) => Recipee.fromJson(json)).toList();
  }
}

