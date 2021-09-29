import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant2/ui/restaurant_detail.dart';
import 'package:submission_restaurant2/ui/restaurant_search.dart';
import 'data/api/request.dart';
import 'style/color_style.dart';
import 'ui/provider/list_notifier.dart';
import 'ui/restaurant_list.dart';
import 'ui/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(create:(context)=>ListNotifier(apiData: GetApiData()),),
         StreamProvider<ConnectivityResult>.value(value: Connectivity()., initialData: Connectivity)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Restaurant App',
        theme: ThemeData(
          primaryColor: primaryColor,
          accentColor: secondaryColor,
        ),
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => SplashScreen(),
          RestaurantUiList.routeName: (context) => RestaurantUiList(),
          RestaurantUiDetail.routeName: (context) => RestaurantUiDetail(restaurantDetailId: ModalRoute.of(context)?.settings.arguments as String),
          RestaurantUiSearch.routeName: (context) => RestaurantUiSearch(),
        },
      ),
    );
  }
}
