import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _Notifications();
}

class _Notifications extends State<Notifications> {

  getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();
      print("====================================");
      print(token);
      print("====================================");
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification"), backgroundColor: Colors.blue,),
      body: Container(
        padding: EdgeInsets.all(20),
      ),
    );
  }
}