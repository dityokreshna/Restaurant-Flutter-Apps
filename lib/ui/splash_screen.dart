import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submission_restaurant/style/color_style.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Tween<Color?> _colorTween =
      ColorTween(begin: primaryColor, end: secondaryColor);

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
        () => Navigator.pushReplacementNamed(context, '/restaurant_list'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            height: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TweenAnimationBuilder<Color?>(
                    tween: _colorTween,
                    duration: Duration(seconds: 3),
                    builder: (context, Color? value, child) {
                      return Image(
                        height: 50,
                        color: value,
                        fit: BoxFit.fitHeight,
                        image: AssetImage('assets/images/logo.png'),
                      );
                    },
                  ),
                ),
                Container(
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Re - List',
                        style: Theme.of(context).textTheme.headline3,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Easy to look the list of restaurant',
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
