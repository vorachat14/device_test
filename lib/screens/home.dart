import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../service/local_notification_service.dart';
import 'second_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final LocalNotificationService service;

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        await service.showNotificationWithPayload(
          body: 'Hello',
          id: 1,
          title: 'titi',
          routes: "${message.data['_page1']}",
        );
      }
      FlutterAppBadger.updateBadgeCount(1);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        Navigator.pushNamed(context, '${message.data['_page2']}');
      }
      FlutterAppBadger.removeBadge();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Notification Demo'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SizedBox(
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'This is a demo of how to use local notifications in Flutter.',
                    style: TextStyle(fontSize: 20),
                  ),
                  ElevatedButton(
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
                        "data": {
                          "_data": "Row_id",
                          "_page1": "/second",
                          "_page2": "/three"
                        },
                        "notification": {
                          "body": "This is a new massage 1",
                          "title": "A new push notification 1"
                        }
                      };
                      //print(body);
                      var res = await dio.post(
                          "https://fcm.googleapis.com/fcm/send",
                          data: body);
                     },
                    child: const Text('Show Local Notification'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? routes) {
    if (routes != null && routes.isNotEmpty) {
      print('payload $routes');

      Navigator.pushNamed(context, '${routes}');
    }
  }
}
