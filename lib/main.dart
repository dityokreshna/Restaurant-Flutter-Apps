import 'package:flutter/material.dart';
import 'data/models/restaurant.dart';
import 'data/models/restaurant_detail.dart';
import 'style/color_style.dart';
import 'ui/restaurant_detail.dart';
import 'ui/restaurant_list.dart';
import 'ui/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: secondaryColor,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        RestaurantList.routeName: (context) => RestaurantList(),
        RestaurantDetail.routeName: (context) => RestaurantDetail(
              restaurant: ModalRoute.of(context)?.settings.arguments as RestaurantDetailClass,
            ),
      },
    );
  }
}
