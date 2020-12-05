import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  InitializationSettings initializationSettings;
  
  NotificationPlugin._() {
    init();
  }

  init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    initializePlatformSpecifics();

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  initializePlatformSpecifics() {
    const AndroidInitializationSettings initializationSettingsAndroid = 
      AndroidInitializationSettings('ic_stat_name');

    initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid
    );
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidChannelSpecifics = 
      AndroidNotificationDetails(
        'CHANNEL_ID',
        'CHANNEL_NAME',
        "CHANNEL_DESCRIPTION",
        playSound: true,
        timeoutAfter: 5000,
        styleInformation: DefaultStyleInformation(true, true),
      );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(
          android: androidChannelSpecifics
        );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Title',
      'Test Body',
      platformChannelSpecifics,
      payload: 'New Payload',
    );
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();