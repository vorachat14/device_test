import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_chat/push_notification.dart';

import 'notfication_badge.dart';
import 'second_screen.dart';
import 'service/local_notification_service.dart';

int count = 0;
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  count = count + 1;
  print(count);
  print("Handling a background message: ${message.messageId}");
}

const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

final InitializationSettings initializationSettings = InitializationSettings(
  android: androidInitializationSettings,
);
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title// description
  importance: Importance.max,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyWidget());
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
} //_messaging = FirebaseMessaging.instance;

//String? token = await _messaging.getToken();
class _MyWidgetState extends State<MyWidget> {
  late final FirebaseMessaging _messaging;
  late final LocalNotificationService service;
//code https://www.desuvit.com/how-to-add-push-notifications-to-a-flutter-app-using-firebase-in-android/
  @override
  void initState() {
    super.initState();

    //flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      count = count + 1;
      print(count);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print(channel.id);
      print(notification);
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: "@mipmap/ic_launcher",
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {}
    });

    getToken();
  }

  String? token;
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: ElevatedButton(
              onPressed: () async {
                Dio dio = Dio(
                  BaseOptions(
                    connectTimeout: 5000,
                    receiveTimeout: 5000,
                    headers: {
                      "Content-Type": "application/json",
                      "Authorization":
                          "key=AAAA-IrmStU:APA91bFE7OV1Q8Iqac9hY53ji6B4hle0GJuGuwn0b6hunVgEI8_2Q-BbpNzsk7XZpkNKFe77--0PMN33shNbTJwxPXnF4n0jPNT6LC4A5Q7P4RyNSwD2FvOx3uLhCa4wR8gbEAkOoONA"
                    },
                  ),
                );
                var body = {
                  "to":
                      'fTQZlBhyTvu_roFhNqEdSW:APA91bFaAM1t0Ijra1bZOUKHJr2qsdlf5o-E6HhNtxD1kc1b-fPfbFXl8irmgiqCGl58Hhqyt6CnZtIAVRh8qdV0Ce2Oe_KSzDgFPuzCYpOF8cvIfOj5G6pB_RN3BSmTLza5MEbkRwiS',
                  "proiority": "high",
                  "notification": {
                    "body": "This is a new massage 1",
                    "title": "A new push notification 1"
                  }
                };
                //print(body);
                var res = await dio.post("https://fcm.googleapis.com/fcm/send",
                    data: body);
              },
              child: const Text('Show Notification With Payload'),
            ),
          ),
        ),
      ),
    );
  }
}
