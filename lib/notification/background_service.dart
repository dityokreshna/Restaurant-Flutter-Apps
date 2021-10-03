import 'dart:isolate';
import 'dart:math';

import 'dart:ui';

import 'package:submission_restaurant2/data/api/request.dart';

import '../main.dart';
import 'notification_helper.dart';

final ReceivePort port = ReceivePort();
 
class BackgroundService {
  static BackgroundService? _service;
  static String _isolateName = 'isolate';
  static SendPort? _uiSendPort;
  int nilaiRandom = Random().nextInt(restaurant.length);
  BackgroundService._createObject();
 
  factory BackgroundService() {
    if (_service == null) {
      _service = BackgroundService._createObject();
    }
    return _service!;
  }
 
  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }
 
  static Future<void> callback(int nilaiRandom) async {
    final NotificationHelper _notificationHelper = NotificationHelper();
    var result = await GetApiData().fetcList();
    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result, nilaiRandom);
 
    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
 
  Future<void> someTask() async {
    print('Execute some process');
  }
}