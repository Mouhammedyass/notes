import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/controller/add.dart';
import 'package:first_app/view/HomeScreen.dart';
import 'package:first_app/view/Login.dart';
import 'package:first_app/view/Register.dart';
import 'package:first_app/view/edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Notes/addNote.dart';
import 'Notes/view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.grey,
          titleTextStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      debugShowCheckedModeBanner: false,

      initialRoute: (FirebaseAuth.instance.currentUser != null) ? '/home' : '/login',

      getPages: [
        GetPage(name: "/login", page: () => Login()),
        GetPage(name: "/register", page: () => Register()),
        GetPage(name: "/home", page: () => MyHomeScreen()),
        GetPage(name: "/add", page: () => Add()),
        GetPage(name: "/edit", page: () => EditPage(docId: '', oldName: '')),
        GetPage(name: "/view", page: () => ViewPage(categoryId: '')),
        GetPage(name: "/addnote", page: () => AddNote(docId: '')),
      ],
    );
  }
}