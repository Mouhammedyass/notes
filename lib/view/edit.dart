import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'addtextformfield.dart';

class EditPage extends StatefulWidget {

   final String docId;
   final String oldName;
  const EditPage({super.key, required this.docId, required this.oldName});

  @override
  State<EditPage> createState() => _EditPage();
}

class _EditPage extends State<EditPage> {

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  @override
  void initState() {
    super.initState();
    name.text = widget.oldName;
  }

  Future<void> editUser() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Update the document using the docId
      await categories.doc(widget.docId).update({
        'name': name.text,
      });

      // Close loading dialog
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to home
      Get.offAllNamed("/home");

    } catch (error) {
      // Close loading dialog if it's still showing
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update category: $error'),
          backgroundColor: Colors.red,
        ),
      );
      print("Failed to update category: $error");
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
        title: const Text("Edit Category"),
        backgroundColor: Colors.grey[400],
        shadowColor: Colors.black,
      ),
      body: Form(
        key: formState,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                  editUser();
                }
              },
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: const Text(
                "Save",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
