import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/view/addtextformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _Add();
}

class _Add extends State<Add> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  Future<void> addUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await categories.add({
        'name': name.text,
        'id': FirebaseAuth.instance.currentUser!.uid,
      });

      Get.back();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Get.offAllNamed("/home");

    } catch (error) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add category: $error'),
          backgroundColor: Colors.red,
        ),
      );
      print("Failed to add user: $error");
    }
  }
  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
        backgroundColor: Colors.grey[400],
        shadowColor: Colors.black,
      ),
      body: Form(
        key: formState,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: AddCustomTextFormField(
                hinttext: "Enter Category Name",
                myController: name,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Can't be empty";
                  }
                  return null;
                },
              ),
            ),
            MaterialButton(
              onPressed: () {
                if (formState.currentState!.validate()) {
                  addUser();
                }
              },
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: const Text(
                "Add",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}