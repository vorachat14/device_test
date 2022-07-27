import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String deviceName = '', deviceVersion = '', identifier = '';

  Future<void> _getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        print(androidInfo.id);
        print(androidInfo.brand);
        print(androidInfo.device);
        print(androidInfo.androidId);
       
      }
    } on PlatformException {
      print('Error');
    }
  }

  @override
  void initState() {
    super.initState();
    print('1232');
    // _getDeviceDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('device'),
        ),
        body: Column(
          children: [
            Text('deviceName'),
            Text(deviceName),
            Text(deviceVersion),
            Text(identifier),
          ],
        ),
      ),
    );
  }
}
