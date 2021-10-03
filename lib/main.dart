import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_list.dart';
import 'package:submission_restaurant2/ui/restaurant_detail.dart';
import 'package:submission_restaurant2/ui/restaurant_search.dart';
import 'data/api/request.dart';
import 'notification/background_service.dart';
import 'notification/notification_helper.dart';
import 'style/color_style.dart';
import 'ui/provider/detail_notifier.dart';
import 'ui/provider/hive_notifier.dart';
import 'ui/provider/list_notifier.dart';
import 'ui/provider/scheduling_provider.dart';
import 'ui/restaurant_list.dart';
import 'ui/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

const restaurant = 'restaurant';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  await Hive.initFlutter();
  Hive.registerAdapter(RestaurantDataListElementAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ListNotifier(apiData: GetApiData()),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailNotifier(apiData: GetApiData()),
        ),
        StreamProvider<ConnectivityResult>.value(
            value: Connectivity().onConnectivityChanged,
            initialData: ConnectivityResult.none),
        ChangeNotifierProvider(
          create: (context) => HiveNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => SchedulingProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Restaurant App',
        theme: ThemeData(
          primaryColor: primaryColor, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondaryColor),
        ),
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => SplashScreen(),
          RestaurantUiList.routeName: (context) => RestaurantUiList(),
          RestaurantUiDetail.routeName: (context) => RestaurantUiDetail(
              restaurantDetailId:
                  ModalRoute.of(context)?.settings.arguments as String),
          RestaurantUiSearch.routeName: (context) => RestaurantUiSearch(),
        },
      ),
    );
  }
}
