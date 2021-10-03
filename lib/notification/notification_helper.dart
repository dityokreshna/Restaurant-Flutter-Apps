import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_list.dart';

import 'navigation.dart';

final selectNotificationSubject = BehaviorSubject<String>();
 
class NotificationHelper {
  static NotificationHelper? _instance;
 
  NotificationHelper._internal() {
    _instance = this;
  }
 
  factory NotificationHelper() => _instance ?? NotificationHelper._internal();
 
  Future<void> initNotifications(
     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
 
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
 
    var initializationSettings = InitializationSettings(
       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
 
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
       onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }
 
  Future<void> showNotification(
     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
     RestaurantDataList restaurant) async {
    var _channelId = "1";
    var _channelName = "channel_01";
    var _channelDescription = "dicoding news channel"; 
 
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName, _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: DefaultStyleInformation(true, true));
 
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
 
    var titleNotification = "<b>Headline News</b>";
    var titleNews = restaurant.restaurants[0].name;
 
    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleNews, platformChannelSpecifics,
        payload: json.encode(restaurant.toJson()));
  }
 
  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var data = RestaurantDataList.fromJson(json.decode(payload));
        var restaurantResult = data.restaurants[0];
        Navigation.intentWithData(route, restaurantResult);
      },
    );
  }
}