import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'utils/Constant.dart';
import 'views/Home.dart';

const String testDevice = 'MobileId';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Pan',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.white
      ),
      routes: <String, WidgetBuilder>{
        HOME_SCREEN: (BuildContext context) => new Home(
              title: "Calculadora de Pan",
            ),
        SPLASH_SCREEN: (BuildContext context) => new SplashScreen(),
      },
      //home: Home(title: 'Calculadora de Pan'),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Game', 'Mario'],
  );
  VideoPlayerController playerController;
  VoidCallback listener;

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
      //Change BannerAd adUnitId with Admob ID
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
      //Change Interstitial AdUnitId with Admob ID
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("IntersttialAd $event");
        });
  }


  @override
  void initState() {
    super.initState();
    listener = () {
      setState(() {});
    };
    initializeVideo();
    playerController.play();

    startTime();
    FirebaseAdMob.instance.initialize(appId: BannerAd.testAdUnitId);
    //Change appId With Admob Id
    
    super.initState();
  }

 

  void initializeVideo() {
    playerController =
        VideoPlayerController.asset('assets/anilogo.mp4')
          ..addListener(listener)
          ..setVolume(1.0)
          ..initialize()
          ..play();
  }

  void navigationPage() {
    playerController.setVolume(0.0);
    playerController.removeListener(listener);
    Navigator.of(context).pop(SPLASH_SCREEN);
    Navigator.of(context).pushReplacementNamed(HOME_SCREEN);
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  @override
  Widget build(BuildContext context) {
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
      new AspectRatio(
          aspectRatio: 9 / 16,
          child: Container(
            child: (playerController != null
                ? VideoPlayer(
                    playerController,
                  )
                : Container()),
          )),
    ]));
  }

  @override
  void deactivate() {
    if (playerController != null) {
      playerController.setVolume(0.0);
      playerController.removeListener(listener);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (playerController != null) playerController.dispose();
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }
}
